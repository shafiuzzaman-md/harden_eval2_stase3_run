#ifndef _HEAP_ALLOC_H
#define _HEAP_ALLOC_H

#include <linux/types.h>

void *kheap_alloc(size_t size);
void kheap_free(void *ptr);

#endif
