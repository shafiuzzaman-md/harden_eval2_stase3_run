#ifndef _LINUX_FS_H_STASE_STUB
#define _LINUX_FS_H_STASE_STUB
#include <linux/kernel.h>
#endif
struct file { void *private_data; long long f_pos; };
struct inode { void *i_private; };

/* Minimal file_operations so kcrypt.c / knotes.c can compile under
 * gcc -fsyntax-only for the CodeQL DB build. Members are unused. */
struct file_operations {
    void *owner;
    long (*unlocked_ioctl)(struct file *, unsigned int, unsigned long);
    int  (*open)(struct inode *, struct file *);
    int  (*release)(struct inode *, struct file *);
    long (*write)(struct file *, const char *, unsigned long, long *);
    long (*read)(struct file *, char *, unsigned long, long *);
    long long (*llseek)(struct file *, long long, int);
};

struct miscdevice {
    int minor;
    const char *name;
    const struct file_operations *fops;
};

static inline int misc_register(struct miscdevice *m) { (void)m; return 0; }
static inline void misc_deregister(struct miscdevice *m) { (void)m; }
