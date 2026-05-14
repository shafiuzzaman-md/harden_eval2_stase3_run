#ifndef _STUB
#define _STUB
#include <linux/kernel.h>
#endif

struct scatterlist { void *page_link; unsigned int offset; unsigned int length; };
static inline void sg_init_one(struct scatterlist *sg, const void *buf, unsigned int len) { (void)sg; (void)buf; (void)len; }
static inline void sg_init_table(struct scatterlist *sg, unsigned int nents) { (void)sg; (void)nents; }
