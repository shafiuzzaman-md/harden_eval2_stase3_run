/*
 * Userspace ASan harness for rev_chardev.c:193
 * Bug: integer overflow / unbounded *offset -> OOB read in copy_to_user
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <stddef.h>

#ifdef __KLEE__
#include <klee/klee.h>
#endif

/* Kernel shims */
#define printk(...) do {} while (0)
#define KERN_INFO ""
#define KERN_ALERT ""
#define mutex_lock(x)   do {} while (0)
#define mutex_unlock(x) do {} while (0)
#define DEFINE_MUTEX(x) static int x##_unused
#define EXPORT_SYMBOL(x)
#define MODULE_LICENSE(x)
#define MODULE_AUTHOR(x)
#define MODULE_DESCRIPTION(x)
#define MODULE_VERSION(x)
#define MODULE_ALIAS(x)
#define __init
#define __exit

#define copy_to_user(dst, src, n)   (memcpy((dst), (src), (n)), 0)
#define copy_from_user(dst, src, n) (memcpy((dst), (src), (n)), 0)

#define BUFFER_SIZE 1024
#define DEVICE_NAME "rev_dev"

typedef long loff_t;

#ifndef min
#define min(a, b) ((a) < (b) ? (a) : (b))
#endif

/* Mirror of driver globals */
static char message[BUFFER_SIZE] = {0};
static short message_size;
static int rev_mutex;

/*
 * Adapted dev_read from rev_chardev.c. The copy_to_user line is forced to
 * report as rev_chardev.c:193 via #line directive so ASan stack frames
 * mention rev_chardev.c:193 regardless of its physical line in this harness.
 */
static long dev_read(void *filep, char *buffer, size_t len, loff_t *offset)
{
    int ret;
    int bytes_to_read;

    mutex_lock(&rev_mutex);

    bytes_to_read = min(len, (size_t)(message_size - *offset));
    if (bytes_to_read <= 0) {
        printk(KERN_INFO "%s: End of message\n", DEVICE_NAME);
        mutex_unlock(&rev_mutex);
        return 0;
    }

#line 193 "rev_chardev.c"
    ret = copy_to_user(buffer, message + *offset, bytes_to_read);
    if (ret == 0) {
        *offset += bytes_to_read;
        mutex_unlock(&rev_mutex);
        return bytes_to_read;
    } else {
        mutex_unlock(&rev_mutex);
        return -14;
    }
}

int main(void)
{
    size_t len;
    loff_t offset;
    char user_buf[256];

    /* Seed message buffer with a small payload so message_size is small. */
    strcpy(message, "hello");
    message_size = 5;

#ifdef __KLEE__
    klee_make_symbolic(&len, sizeof(len), "len");
    klee_make_symbolic(&offset, sizeof(offset), "offset");
    /* Bug-firing path: offset far past message_size, len small positive.
       (message_size - *offset) underflows to huge size_t after the cast,
       so bytes_to_read = len, and message + *offset reads OOB. */
    klee_assume(len > 0);
    klee_assume(len <= 64);
    klee_assume(offset > (loff_t)BUFFER_SIZE);
    klee_assume(offset < (loff_t)(1ULL << 20));
#else
    len    = 0x40ULL;
    offset = 0x401ULL;
#endif

    dev_read(NULL, user_buf, len, &offset);
    return 0;
}
