#ifndef _LINUX_PROC_FS_STUB
#define _LINUX_PROC_FS_STUB
#include <linux/kernel.h>
#include <linux/fs.h>

typedef long long loff_t;
typedef long ssize_t;

struct proc_ops {
    int (*proc_open)(void *, void *);
    ssize_t (*proc_read)(struct file *, char *, size_t, loff_t *);
    ssize_t (*proc_write)(struct file *, const char *, size_t, loff_t *);
    int (*proc_release)(void *, void *);
};

struct proc_dir_entry;

static inline struct proc_dir_entry *
proc_create(const char *name, int mode, struct proc_dir_entry *parent,
            const struct proc_ops *ops) {
    (void)name; (void)mode; (void)parent; (void)ops;
    return (struct proc_dir_entry *)1;
}

static inline void proc_remove(struct proc_dir_entry *p) { (void)p; }

#endif
