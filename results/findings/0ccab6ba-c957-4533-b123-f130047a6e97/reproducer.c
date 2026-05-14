/*
 * UBSan harness for kbmp.c:165 division-by-zero in rotate()
 * Reproducer: rotate("", any_size_t) -> strlen("") == 0 -> i % 0 traps.
 */

#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#ifdef __KLEE__
#include <klee/klee.h>
#endif

/* Kernel shims */
#define GFP_KERNEL 0
#define kmalloc(sz, flags) malloc(sz)
#define kzalloc(sz, flags) calloc(1, sz)
#define kfree(p) free(p)
#define copy_to_user(dst, src, n) (memcpy((dst), (src), (n)), 0UL)
#define copy_from_user(dst, src, n) (memcpy((dst), (src), (n)), 0UL)
#define get_user(x, p) ((x) = *(p), 0)
#define put_user(x, p) (*(p) = (x), 0)
#define pr_err(...) ((void)0)
#define pr_debug(...) ((void)0)
#define pr_info(...) ((void)0)
#define printk(...) ((void)0)
#define EXPORT_SYMBOL(x)
#define MODULE_LICENSE(x)
#define MODULE_AUTHOR(x)
#define MODULE_DESCRIPTION(x)

/* Adapted rotate() from the driver. The modulo line must land on line 165. */
#line 158 "kbmp.c"
char* rotate(char* s, size_t i) {
    size_t length = strlen(s);
    char* rotated = (char*)kmalloc(length + 1, GFP_KERNEL);
    if (!rotated) {
        return NULL;
    }

    size_t index = i % length;
    size_t remainder_length = length - index;

    memcpy(rotated, s + index, remainder_length);
    memcpy(rotated + remainder_length, s, index);

    rotated[length] = '\0';
    return rotated;
}

int main(void) {
    size_t i;

#ifdef __KLEE__
    klee_make_symbolic(&i, sizeof(i), "i");
    klee_assume(i < (size_t)(1ULL << 32));
#else
    i = 0x1;
#endif

    char empty[1] = {'\0'};
    char* r = rotate(empty, i);
    if (r) {
        free(r);
    }
    return 0;
}
