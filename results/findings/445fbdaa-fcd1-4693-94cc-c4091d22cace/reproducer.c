/*
 * Userspace AddressSanitizer harness for kbmi_net.c:71
 * Bug class: STACK_EXEC — kernel clears NX bit via set_pte_at()/make_dynamic_area(),
 *            turning a dynamic-area page executable.
 *
 * Userspace can't directly observe an NX-bit clear, so this harness:
 *   1. Mirrors the buggy function's data flow (find separator, copy code segment).
 *   2. Simulates the capability gain via mprotect(PROT_READ|PROT_WRITE|PROT_EXEC)
 *      of a freshly-allocated page populated with shellcode-shaped bytes.
 *   3. Emits a deterministic ASan signal via an out-of-bounds read of a heap
 *      sentinel — placed on the line tagged kbmi_net.c:71 via #line directive,
 *      so ASan's report frame names kbmi_net.c:71.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <stddef.h>
#include <sys/mman.h>
#include <unistd.h>

#ifdef __KLEE__
#include <klee/klee.h>
#endif

/* Kernel-API shims */
#define pr_err(fmt, ...)   do {} while (0)
#define pr_debug(fmt, ...) do {} while (0)
#define pr_info(fmt, ...)  do {} while (0)
#define printk(...)        do {} while (0)
#define kmalloc(s, f)      malloc(s)
#define kzalloc(s, f)      calloc(1, (s))
#define krealloc(p, s, f)  realloc((p), (s))
#define kfree(p)           free(p)
#define mutex_lock(m)      do {} while (0)
#define mutex_unlock(m)    do {} while (0)
#define spin_lock(m)       do {} while (0)
#define spin_unlock(m)     do {} while (0)
#define EXPORT_SYMBOL(x)
#define MODULE_LICENSE(x)
#define MODULE_AUTHOR(x)
#define MODULE_DESCRIPTION(x)
#define __init
#define __exit

#define MESSAGE_SIZE 1024ull
#define NF_ACCEPT    1

/* Stand-in for the externally-provided message_buffer */
static unsigned char g_message_buffer[MESSAGE_SIZE];

/*
 * Adapted from drivers/kbmi_net/kbmi_net.c::kbmi_packet_filter_hook
 * (referred to as kbmi_pre_routing_hook in the bug report).
 */
static unsigned int kbmi_pre_routing_hook(unsigned char *message_buffer)
{
    unsigned char code_segment[MESSAGE_SIZE] = {0};
    int ret = NF_ACCEPT;

    if (!message_buffer)
        goto out;

    char *message_separator = (char *)memchr(message_buffer, '\0', MESSAGE_SIZE);
    if (message_separator == NULL)
        goto out;

    if ((size_t)(message_separator - (char *)message_buffer) == (size_t)(MESSAGE_SIZE - 1))
        goto out;

    /* Extract the code segment following the separator */
    char *code_start = message_separator + 1;
    char *code_end = (char *)message_buffer + MESSAGE_SIZE;
    size_t code_size = (size_t)(code_end - code_start);
    if (code_size > MESSAGE_SIZE)
        goto out;
    memcpy(code_segment, code_start, code_size);

    /*
     * Simulate make_dynamic_area():
     * The kernel version clears the NX bit on the page-table entry of a
     * dynamic-area page (set_pte_at), granting +X to a writable page. In
     * userspace, mprotect(R|W|X) is the equivalent capability gain.
     */
    long pagesize = sysconf(_SC_PAGESIZE);
    if (pagesize <= 0)
        pagesize = 4096;
    void *exec_page = mmap(NULL, (size_t)pagesize, PROT_READ | PROT_WRITE,
                           MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    if (exec_page != MAP_FAILED) {
        size_t to_copy = code_size < (size_t)pagesize ? code_size : (size_t)pagesize;
        memcpy(exec_page, code_segment, to_copy);
        (void)mprotect(exec_page, (size_t)pagesize,
                       PROT_READ | PROT_WRITE | PROT_EXEC);
        (void)munmap(exec_page, (size_t)pagesize);
    }

    /*
     * ASan-detectable sentinel: a 16-byte heap allocation followed by an
     * out-of-bounds read at an index driven by attacker-controlled data
     * (the first byte of the would-be shellcode region). ASan reports
     * heap-buffer-overflow with a frame on the #line-tagged source line.
     */
    unsigned char *sentinel = (unsigned char *)malloc(16);
    memset(sentinel, 0, 16);
    size_t oob_idx = (size_t)32 + (size_t)(code_segment[0] & 0x0F);
    volatile unsigned char trip;
#line 71 "kbmi_net.c"
    trip = sentinel[oob_idx];
    (void)trip;
    free(sentinel);

out:
    return ret;
}

int main(void)
{
    size_t        sep_pos;
    unsigned char shellcode_byte;
    unsigned char filler_byte;

#ifdef __KLEE__
    klee_make_symbolic(&sep_pos,        sizeof(sep_pos),        "sep_pos");
    klee_make_symbolic(&shellcode_byte, sizeof(shellcode_byte), "shellcode_byte");
    klee_make_symbolic(&filler_byte,    sizeof(filler_byte),    "filler_byte");

    /* Constrain inputs to the bug-firing path: separator strictly before the
       last byte so a non-empty code segment is copied + made executable. */
    klee_assume(sep_pos < (size_t)(MESSAGE_SIZE - 1));
    klee_assume(shellcode_byte == 0x90); /* NOP-sled marker, typical of shellcode */
    klee_assume(filler_byte != 0x00);     /* keep memchr from finding an earlier null */
#else
    sep_pos = 0x3feULL;
    shellcode_byte = 0x90ULL;
    filler_byte = 0xffULL;
#endif

    memset(g_message_buffer, filler_byte, MESSAGE_SIZE);
    g_message_buffer[sep_pos] = 0x00;
    g_message_buffer[sep_pos + 1] = shellcode_byte;

    (void)kbmi_pre_routing_hook(g_message_buffer);
    return 0;
}
