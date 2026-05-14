#ifndef _LINUX_SLAB_H_STASE_STUB
#define _LINUX_SLAB_H_STASE_STUB
#include <linux/kernel.h>
#endif
#include <stdlib.h>
#define kmalloc(s, g) malloc(s)
#define kzalloc(s, g) calloc(1, s)
#define kfree(p) free((void*)(p))
