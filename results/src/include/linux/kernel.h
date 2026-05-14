/* stase2.1 minimal kernel-header stubs.
 *
 * The eval3 minimal corpus ships with these stubs so kheap.c and kchunk.c
 * compile in CodeQL's database-create step WITHOUT a real Linux kernel
 * source tree. None of these have semantic content — they're shapes only.
 * If you bring your own full kernel source, drop -I.../eval3_minimal/include
 * and use the real headers.
 */
#ifndef _LINUX_KERNEL_H_STASE_STUB
#define _LINUX_KERNEL_H_STASE_STUB

#include <stddef.h>
#include <stdint.h>

typedef int8_t   __s8;   typedef uint8_t  __u8;
typedef int16_t  __s16;  typedef uint16_t __u16;
typedef int32_t  __s32;  typedef uint32_t __u32;
typedef int64_t  __s64;  typedef uint64_t __u64;
typedef __u8 u8;  typedef __u16 u16;  typedef __u32 u32;  typedef __u64 u64;
typedef __s8 s8;  typedef __s16 s16;  typedef __s32 s32;  typedef __s64 s64;

typedef int bool;
#define true 1
#define false 0
typedef int gfp_t;

struct list_head { struct list_head *next, *prev; };
typedef struct { volatile unsigned int slock; } spinlock_t;
typedef struct { volatile unsigned int v; } atomic_t;

#define DEFINE_SPINLOCK(x) spinlock_t x = {0}
static inline void spin_lock_irqsave(spinlock_t *l, unsigned long f) {(void)l;(void)f;}
static inline void spin_unlock_irqrestore(spinlock_t *l, unsigned long f) {(void)l;(void)f;}
static inline void spin_lock(spinlock_t *l) {(void)l;}
static inline void spin_unlock(spinlock_t *l) {(void)l;}

#define EXPORT_SYMBOL(x)
#define EXPORT_SYMBOL_GPL(x)
#define module_init(x)
#define module_exit(x)
#define __init
#define __exit
#define __user
#define __kernel
#define MODULE_LICENSE(x)
#define MODULE_AUTHOR(x)
#define MODULE_DESCRIPTION(x)
#define pr_info(...)  do {} while (0)
#define pr_err(...)   do {} while (0)
#define pr_debug(...) do {} while (0)
#define pr_warn(...)  do {} while (0)
#define printk(...)   do {} while (0)
#define KERN_INFO  ""
#define KERN_ERR   ""

#define container_of(ptr, type, member) ((type *)((char *)(ptr) - offsetof(type, member)))
#define BIT(n) (1UL << (n))
#define ARRAY_SIZE(x) (sizeof(x)/sizeof((x)[0]))
#define max(a,b) ((a)>(b)?(a):(b))
#define min(a,b) ((a)<(b)?(a):(b))
#define BUG_ON(x) do { if(x); } while(0)
#define WARN_ON(x) do { if(x); } while(0)

#define PAGE_SIZE 4096
#define ENOMEM 12
#define EINVAL 22
#define ENOENT 2
#define EFAULT 14
#define EBUSY  16
#define GFP_KERNEL 0
#define GFP_ATOMIC 0

/* List head + iteration shims (enough for -fsyntax-only parsing). */
#define LIST_HEAD_INIT(name) { &(name), &(name) }
#define LIST_HEAD(name) struct list_head name = LIST_HEAD_INIT(name)
#define INIT_LIST_HEAD(ptr) do { (ptr)->next = (ptr); (ptr)->prev = (ptr); } while (0)
#define list_entry(ptr, type, member) container_of(ptr, type, member)
#define list_first_entry(ptr, type, member) list_entry((ptr)->next, type, member)
#define list_next_entry(pos, member) list_entry((pos)->member.next, typeof(*(pos)), member)
#define list_for_each_entry(pos, head, member)                                  \
    for (pos = list_first_entry(head, typeof(*pos), member);                    \
         &pos->member != (head);                                                \
         pos = list_next_entry(pos, member))
#define list_for_each_entry_safe(pos, n, head, member)                          \
    for (pos = list_first_entry(head, typeof(*pos), member),                    \
         n   = list_next_entry(pos, member);                                    \
         &pos->member != (head);                                                \
         pos = n, n = list_next_entry(n, member))
static inline void list_add_tail(struct list_head *new_, struct list_head *head) {
    (void)new_; (void)head;
}
static inline void list_del(struct list_head *entry) { (void)entry; }

/* Mutex shims. */
struct mutex { volatile unsigned int locked; };
#define DEFINE_MUTEX(name) struct mutex name = {0}
static inline void mutex_init(struct mutex *m) { (void)m; }
static inline void mutex_lock(struct mutex *m) { (void)m; }
static inline void mutex_unlock(struct mutex *m) { (void)m; }

/* Atomic shims. */
#define ATOMIC_INIT(i) { (i) }
static inline int atomic_inc_return(atomic_t *v) { return ++v->v; }

/* String / build helpers. */
#include <string.h>
#include <stdio.h>
static inline size_t strscpy(char *dst, const char *src, size_t n) {
    if (!n) return 0;
    size_t i = 0;
    for (; i + 1 < n && src[i]; i++) dst[i] = src[i];
    dst[i] = '\0';
    return src[i] ? (size_t)-1 : i;
}
#define BUILD_BUG_ON(cond) ((void)sizeof(char[1 - 2*!!(cond)]))
#define __packed __attribute__((packed))

#endif /* _LINUX_KERNEL_H_STASE_STUB */

#ifndef ESPIPE
#define ESPIPE 29
#endif
#ifndef EPERM
#define EPERM 1
#endif
