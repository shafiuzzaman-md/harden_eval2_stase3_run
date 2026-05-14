/* ASan harness for evt_notifier.c:162
 * Bug: integer/sign mishandling in dr_w_dev_read.
 *   bytes_to_read = min(len, (size_t)(message_size - *offset));
 * When *offset > message_size, (message_size - *offset) is a negative
 * signed value; the cast to size_t makes it huge, so min(len, huge) = len.
 * Then `message + *offset` walks far past the buffer and copy_to_user
 * (memcpy in userspace) performs an OOB read that AddressSanitizer traps.
 *
 * NOTE: do NOT typedef loff_t / ssize_t here — glibc's <sys/types.h>
 * already provides them; redefining caused the previous build failure.
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <sys/types.h>

#ifdef __KLEE__
#include <klee/klee.h>
#endif

/* ---------- kernel-ish shims ---------- */
#define BUFFER_SIZE 256
#define DEVICE_NAME "dr_w_device"
#define KERN_INFO  ""
#define KERN_ERR   ""
#define KERN_ALERT ""

#define printk(...)              ((void)0)
#define pr_info(...)             ((void)0)
#define pr_err(...)              ((void)0)
#define pr_debug(...)            ((void)0)

#define copy_to_user(dst, src, n)   (memcpy((dst), (src), (n)), 0)
#define copy_from_user(dst, src, n) (memcpy((dst), (src), (n)), 0)
#define get_user(x, ptr)            ((x) = *(ptr), 0)
#define put_user(x, ptr)            (*(ptr) = (x), 0)

#define kmalloc(sz, fl)  malloc(sz)
#define kzalloc(sz, fl)  calloc(1, (sz))
#define krealloc(p, sz, fl) realloc((p), (sz))
#define kfree(p)         free(p)

#define mutex_lock(l)    ((void)0)
#define mutex_unlock(l)  ((void)0)
#define spin_lock(l)     ((void)0)
#define spin_unlock(l)   ((void)0)

#define EXPORT_SYMBOL(x)
#define EXPORT_SYMBOL_GPL(x)
#define MODULE_LICENSE(x)
#define MODULE_AUTHOR(x)
#define MODULE_DESCRIPTION(x)
#define MODULE_ALIAS(x)

#define __user
#define __init
#define __exit

#ifndef min
#define min(a, b) (((a) < (b)) ? (a) : (b))
#endif

struct file;
struct inode;

/* ---------- module state (mirrors the driver) ---------- */
static char  *message = NULL;          /* heap-backed so ASan reliably traps */
static short  message_size = 0;

/* ---------- adapted buggy function ----------
 * Faithful copy of dr_w_dev_read; only kernel calls are macro-rewritten.
 * The `#line` directive below makes the crashing memcpy report as
 *     evt_notifier.c:162
 * regardless of where it actually lives in this harness file.
 */
static ssize_t dr_w_dev_read(struct file *filep, char __user *buffer,
                             size_t len, loff_t *offset)
{
    int ret;
    int bytes_to_read = min(len, (size_t)(message_size - *offset));

    if (bytes_to_read <= 0) {
        printk(KERN_INFO "%s: End of message\n", DEVICE_NAME);
        return 0;
    }

#line 162 "evt_notifier.c"
    ret = copy_to_user(buffer, message + *offset, bytes_to_read);
    if (ret == 0) {
        *offset += bytes_to_read;
        return bytes_to_read;
    } else {
        return -1;
    }
}

/* ---------- driver ---------- */
int main(void)
{
    char    user_buf[BUFFER_SIZE];
    size_t  len;
    loff_t  off;

    /* Backing buffer: allocated small on the heap so any read past it
     * is a clean ASan heap-buffer-overflow. */
    message_size = 100;
    message = (char *)malloc((size_t)message_size);
    if (!message) return 1;
    memset(message, 'A', (size_t)message_size);

#ifdef __KLEE__
    klee_make_symbolic(&len, sizeof(len), "len");
    klee_make_symbolic(&off, sizeof(off), "off");

    /* Keep len in a sensible range (fits in user_buf, non-zero). */
    klee_assume(len > 0);
    klee_assume(len <= (size_t)BUFFER_SIZE);

    /* Bug-firing path: *offset must exceed message_size so that
     * (message_size - *offset) goes negative, the size_t cast
     * makes min() pick `len`, and message+*offset is far OOB.
     * Bound it to keep KLEE focused. */
    klee_assume(off > (loff_t)message_size);
    klee_assume(off < (loff_t)(1LL << 16));
#else
    /* Concrete witness satisfying the same constraints. */
    len = 0x40;
    off = 0x500;
#endif

    (void)dr_w_dev_read((struct file *)0, user_buf, len, &off);

    free(message);
    return 0;
}
