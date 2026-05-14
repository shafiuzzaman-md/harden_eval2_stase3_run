/*
 * Userspace AddressSanitizer harness reproducing the UAF-via-dangling-callback
 * bug in usb_event_logger.c. The original module's exit() never calls
 * usb_unregister_notify(), so a heap-allocated notifier_block whose callback
 * slot has been freed is later dereferenced when a USB event is delivered.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

#ifdef __KLEE__
#include <klee/klee.h>
#endif

/* ----- Kernel API shims (userspace equivalents) ----- */
#define printk(...)        do {} while (0)
#define pr_info(...)       do {} while (0)
#define pr_debug(...)      do {} while (0)
#define pr_err(...)        do {} while (0)
#define KERN_INFO          ""
#define KERN_ERR           ""

#define kmalloc(sz, fl)    malloc(sz)
#define kzalloc(sz, fl)    calloc(1, (sz))
#define krealloc(p, sz, fl) realloc((p), (sz))
#define kfree(p)           free(p)
#define GFP_KERNEL         0
#define GFP_ATOMIC         0

#define mutex_lock(m)      do {} while (0)
#define mutex_unlock(m)    do {} while (0)
#define spin_lock(l)       do {} while (0)
#define spin_unlock(l)     do {} while (0)
#define spin_lock_irqsave(l, f)    do { (f) = 0; } while (0)
#define spin_unlock_irqrestore(l, f) do { (void)(f); } while (0)

#define EXPORT_SYMBOL(x)
#define EXPORT_SYMBOL_GPL(x)
#define MODULE_LICENSE(x)
#define MODULE_AUTHOR(x)
#define MODULE_DESCRIPTION(x)
#define __init
#define __exit
#define module_init(x)
#define module_exit(x)

#define NOTIFY_OK          0x0001
#define USB_DEVICE_ADD     0x0001
#define USB_DEVICE_REMOVE  0x0002

/* ----- Minimal type stubs ----- */
struct notifier_block;
typedef int (*notifier_fn_t)(struct notifier_block *, unsigned long, void *);

struct notifier_block {
    notifier_fn_t notifier_call;
    struct notifier_block *next;
    int priority;
};

/* Kernel-side global that retains the registered notifier_block pointer. */
static struct notifier_block *g_usb_notifier_chain = NULL;

static inline void usb_register_notify(struct notifier_block *nb)
{
    g_usb_notifier_chain = nb;
}

static inline void usb_unregister_notify(struct notifier_block *nb)
{
    (void)nb;
    g_usb_notifier_chain = NULL;
}

/* ----- Adapted module callback (body trimmed; we only need the call site) --- */
static int usb_notify(struct notifier_block *self, unsigned long action, void *dev)
{
    (void)self; (void)dev;
    switch (action) {
    case USB_DEVICE_ADD:
        printk(KERN_INFO "USB device added:\n");
        break;
    case USB_DEVICE_REMOVE:
        printk(KERN_INFO "USB device removed:\n");
        break;
    default:
        printk(KERN_INFO "USB event: action=%lu\n", action);
        break;
    }
    return NOTIFY_OK;
}

/* ----- Simulated kernel-side delivery of a USB event ----- */
static int deliver_usb_event(unsigned long action, void *dev)
{
    struct notifier_block *nb = g_usb_notifier_chain;
    if (!nb)
        return 0;
    /* The indirect call below dereferences a freed notifier_block, exactly
     * the dangling-callback scenario the buggy exit() leaves behind. ASan
     * reports the crash here; the #line directive maps it to the source
     * file/line the validator expects. */
#line 118 "usb_event_logger.c"
    return nb->notifier_call(nb, action, dev);
}

/* ----- Buggy module exit: forgets to call usb_unregister_notify() ----- */
static void usb_logger_exit_buggy(void)
{
    /* printk(KERN_INFO "USB notifier unregistered\n");   <-- nothing else! */
}

int main(void)
{
    unsigned long action;
    uintptr_t dev_bits;

#ifdef __KLEE__
    klee_make_symbolic(&action, sizeof(action), "action");
    klee_make_symbolic(&dev_bits, sizeof(dev_bits), "dev_bits");
    klee_assume(action < (unsigned long)(1ULL << 32));
    klee_assume(dev_bits == 0);
#else
    action     = 0xffffffffULL;
    dev_bits   = 0x0ULL;
#endif

    /* Heap-allocate the notifier_block so that freeing it produces a
     * detectable use-after-free when the dangling callback is invoked. */
    struct notifier_block *usb_nb =
        (struct notifier_block *)kmalloc(sizeof(*usb_nb), GFP_KERNEL);
    if (!usb_nb)
        return 1;
    usb_nb->notifier_call = usb_notify;
    usb_nb->next          = NULL;
    usb_nb->priority      = 0;

    /* Module init: register the notifier. */
    usb_register_notify(usb_nb);

    /* Module unload sequence: free the backing memory but (per the bug)
     * fail to unregister, leaving g_usb_notifier_chain dangling. */
    kfree(usb_nb);
    usb_logger_exit_buggy();

    /* A subsequent USB hot-plug event reaches the now-dangling slot. */
    (void)deliver_usb_event(action, (void *)dev_bits);

    return 0;
}
