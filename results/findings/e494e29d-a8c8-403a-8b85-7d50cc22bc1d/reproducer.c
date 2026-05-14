/*
 * Userspace AddressSanitizer harness for vnet_pktfilter.c:320
 *
 * Bug: packet_filter_exit() (line 320 of vnet_pktfilter.c) forgets to call
 *      nf_unregister_net_hook(), so freeing the nf_hook_ops object leaves a
 *      dangling function-pointer entry in the netfilter hook registry.
 *      The next packet routed through the registry dereferences the freed
 *      handler -> heap-use-after-free.
 *
 * Strategy: mirror the usb_event_logger reproducer -- a heap-allocated
 *           table of fn-ptrs; register one entry; free its backing
 *           struct without unregistering; then "route a packet" which
 *           reads the freed slot.  ASan trips on the UAF read; the
 *           "freed by" frame points at vnet_pktfilter.c:320.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

#ifdef __KLEE__
#include <klee/klee.h>
#endif

/* ------------------------------------------------------------------ */
/* Kernel -> userspace shims                                          */
/* ------------------------------------------------------------------ */
#define kmalloc(sz, fl)       malloc(sz)
#define kzalloc(sz, fl)       calloc(1, (sz))
#define kcalloc(n, sz, fl)    calloc((n), (sz))
#define krealloc(p, sz, fl)   realloc((p), (sz))
#define kfree(p)              free(p)
#define vmalloc(sz)           malloc(sz)
#define vfree(p)              free(p)
#define GFP_KERNEL            0
#define GFP_ATOMIC            0
#define __init
#define __exit
#define pr_err(...)           do {} while (0)
#define pr_warn(...)          do {} while (0)
#define pr_info(...)          do {} while (0)
#define pr_debug(...)         do {} while (0)
#define printk(...)           do {} while (0)
#define mutex_lock(x)         do {} while (0)
#define mutex_unlock(x)       do {} while (0)
#define spin_lock(x)          do {} while (0)
#define spin_unlock(x)        do {} while (0)
#define EXPORT_SYMBOL(x)
#define MODULE_LICENSE(x)
#define MODULE_AUTHOR(x)
#define MODULE_DESCRIPTION(x)
#define MODULE_VERSION(x)
#define module_init(x)
#define module_exit(x)
#define unlikely(x)           (x)
#define likely(x)             (x)

/* ------------------------------------------------------------------ */
/* Minimal netfilter type stubs                                       */
/* ------------------------------------------------------------------ */
struct sk_buff;
struct nf_hook_state;

typedef unsigned int (*nf_hookfn)(void *priv,
                                  struct sk_buff *skb,
                                  const struct nf_hook_state *state);

struct nf_hook_ops {
    nf_hookfn   hook;
    int         hooknum;
    int         pf;
    int         priority;
};

/* ------------------------------------------------------------------ */
/* Heap-allocated hook registry (the "kernel's" table of fn-ptrs).    */
/* In the real kernel, nf_register_net_hook() inserts the ops into    */
/* a per-net hook list; nf_unregister_net_hook() removes it.          */
/* The buggy module skips the unregister step on exit.                */
/* ------------------------------------------------------------------ */
#define HOOK_TABLE_SIZE 4
static struct nf_hook_ops **hook_table;

static int hook_registry_register(struct nf_hook_ops *ops)
{
    if (!hook_table)
        hook_table = (struct nf_hook_ops **)calloc(HOOK_TABLE_SIZE,
                                                   sizeof(*hook_table));
    if (!hook_table)
        return -1;
    for (int i = 0; i < HOOK_TABLE_SIZE; i++) {
        if (!hook_table[i]) { hook_table[i] = ops; return 0; }
    }
    return -1;
}

/* ------------------------------------------------------------------ */
/* The (trivially adapted) filter hook callback                       */
/* ------------------------------------------------------------------ */
static unsigned int packet_filter_hook(void *priv,
                                       struct sk_buff *skb,
                                       const struct nf_hook_state *state)
{
    (void)priv; (void)skb; (void)state;
    return 0;
}

/* The module's hook_ops object is heap-allocated so freeing it
 * creates a real dangling pointer in hook_table[].                   */
static struct nf_hook_ops *nfho_ptr;

static int packet_filter_init(void)
{
    nfho_ptr = (struct nf_hook_ops *)malloc(sizeof(*nfho_ptr));
    if (!nfho_ptr)
        return -1;
    nfho_ptr->hook     = packet_filter_hook;
    nfho_ptr->hooknum  = 0;
    nfho_ptr->pf       = 2;
    nfho_ptr->priority = 0;

    return hook_registry_register(nfho_ptr);
}

/* ------------------------------------------------------------------ */
/* The buggy exit path.  Line numbers are forced so the free()        */
/* falls on vnet_pktfilter.c:320 -- the exact site reported by ASan   */
/* as "freed by" when the next packet routing dereferences the slot.  */
/* ------------------------------------------------------------------ */
#line 318 "vnet_pktfilter.c"
static void packet_filter_exit(void)
{
    free(nfho_ptr);   /* BUG: missing nf_unregister_net_hook() */
}
#line 140 "harness.c"

/* ------------------------------------------------------------------ */
/* Simulated "next packet routed" -- walks the registry and invokes  */
/* the dangling hook entry, dereferencing freed memory.               */
/* ------------------------------------------------------------------ */
static unsigned int route_one_packet(void)
{
    struct nf_hook_ops *ops = hook_table[0]; /* still points at freed obj */
#line 320 "vnet_pktfilter.c"
    nf_hookfn fn = ops->hook;                /* <-- ASan UAF read here     */
#line 148 "harness.c"
    return fn((void *)0, (struct sk_buff *)0, (const struct nf_hook_state *)0);
}

/* ------------------------------------------------------------------ */
/* main                                                               */
/* ------------------------------------------------------------------ */
int main(int argc, char **argv)
{
    (void)argc; (void)argv;

    unsigned int do_exit;
    unsigned int do_route;

#ifdef __KLEE__
    klee_make_symbolic(&do_exit,  sizeof(do_exit),  "do_exit");
    klee_make_symbolic(&do_route, sizeof(do_route), "do_route");
    klee_assume(do_exit  == 1);
    klee_assume(do_route == 1);
#else
    do_exit  = 0x1ULL;
    do_route = 0x1ULL;
#endif

    if (packet_filter_init() != 0)
        return 1;

    if (do_exit == 1)
        packet_filter_exit();      /* frees nf_hook_ops, leaves dangling slot */

    if (do_route == 1)
        route_one_packet();        /* dereferences freed nf_hook_ops -> UAF  */

    return 0;
}
