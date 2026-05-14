#ifndef _STUB
#define _STUB
#include <linux/kernel.h>
#endif

#define THIS_MODULE ((void*)0)
struct cdev { void *owner; int dummy; };
static inline void cdev_init(struct cdev *c, const struct file_operations *f) { (void)c; (void)f; }
static inline int  cdev_add(struct cdev *c, unsigned long d, unsigned long n) { (void)c; (void)d; (void)n; return 0; }
static inline void cdev_del(struct cdev *c) { (void)c; }
typedef unsigned long stase3_dev_t_;
static inline int alloc_chrdev_region(dev_t *d, unsigned int f, unsigned int c, const char *n) { *d=0; return 0; }
static inline void unregister_chrdev_region(dev_t d, unsigned int c) {}
#define MKDEV(m, n) (0)
#define MAJOR(d) (0)
#define MINOR(d) (0)
struct class { int dummy; };
static inline struct class *class_create(const char *n) { static struct class c; return &c; }
static inline void class_destroy(struct class *c) {}
struct device;
static inline struct device *device_create(struct class *c, struct device *p, dev_t d, void *drv, const char *fmt, ...) { return (void*)0; }
static inline void device_destroy(struct class *c, dev_t d) {}
