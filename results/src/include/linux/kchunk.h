/* SPDX-License-Identifier: GPL-2.0 */
/*
 * kchunk - Kernel chunk allocator interface
 *
 * Provides a fixed-size chunk allocator with handle-based access and internal
 * free list management. This allocator is intended for use by kernel code that
 * requires memory chunks of bounded size classes, with dynamic expansion and
 * tracking.
 */
 
#ifndef _KCHUNK_H
#define _KCHUNK_H

#include <linux/types.h>
#include <linux/spinlock.h>

#define MAX_PAGES 4
#define INITIAL_ITEMS 10

#define BLOCK_080 0x80
#define BLOCK_100 0x100
#define BLOCK_200 0x200
#define BLOCK_400 0x400

#define B_080 0
#define B_100 1
#define B_200 2
#define B_400 3

extern spinlock_t kchunk_lock;

/**
 * block_sizes - array of supported chunk sizes in bytes
 * 
 * Indexes correspond to size class constants: B_080, B_100, etc.
 * Use get_block_size() to translate a byte request into an index.
 */
extern const size_t block_sizes[MAX_PAGES];

/**
 * struct chunk - basic linked-list chunk structure
 * @next: pointer to next chunk in free list
 */
typedef struct chunk {
    struct chunk *next;
} chunk_t;

/**
 * struct handle_entry_t - metadata for handle-based allocation
 * @chunk_ptr: pointer to allocated chunk
 * @chunk_size: index of size class
 * @in_use: set to 1 if this handle is currently active
 */
typedef struct {
    chunk_t *chunk_ptr;
    unsigned int chunk_size;
    int in_use;
} handle_entry_t;

/**
 * struct heap_t - main heap state and tracking
 * @free_list: list heads for each chunk size class
 * @allocations: dynamically grown list of allocated regions per class
 * @alloc_counts: number of active regions per size class
 * @alloc_capacity: capacity of allocations array
 */
typedef struct {
    chunk_t *free_list[MAX_PAGES];
    void **allocations[MAX_PAGES];  // Array of memory blocks per size
    int alloc_counts[MAX_PAGES];    // Number of malloc'd regions per block size
    int alloc_capacity[MAX_PAGES];  // Capacity of allocations array
} heap_t;

/**
 * struct heap_metadata_t - metadata for handle-based allocation system
 * @handle_table: dynamically allocated handle table
 * @handle_capacity: number of total slots in handle_table
 * @free_handle_top: stack index for next available handle
 */
typedef struct {
    handle_entry_t *handle_table;
    int handle_capacity;
    int free_handle_top;
} heap_metadata_t;

/**
 * allocate_chunk - allocate a chunk from the heap
 * @chunk_size: index into block_sizes[] (not byte size)
 * @return: pointer to chunk, or NULL on failure
 */
void *allocate_chunk(unsigned int chunk_size);

/**
 * free_chunk - free chunk by raw pointer
 * @ptr: pointer to allocated chunk
 */
void free_chunk(void *ptr);

/**
 * get_block_size - get size class index for requested size
 * @size: requested size in bytes
 * @return: block index or -1 if no class fits
 */
int get_block_size(size_t size);

/**
 * heap_get_handle_table - returns pointer to internal handle table
 * @return: pointer to handle table
 */
const handle_entry_t *heap_get_handle_table(void);

/**
 * heap_get_free_handle_top - returns index of top of free handle stack
 * @return: stack index
 */
int heap_get_free_handle_top(void);

/**
 * heap_get_free_list - get free list for given chunk class
 * @index: index into block_sizes
 * @return: pointer to head of free list
 */
chunk_t *heap_get_free_list(int index);

#endif /* _KCHUNK_H */
