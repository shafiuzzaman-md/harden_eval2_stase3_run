#ifndef _LINUX_UACCESS_H_STASE_STUB
#define _LINUX_UACCESS_H_STASE_STUB
#include <linux/kernel.h>
#endif
static inline unsigned long copy_from_user(void *to, const void *from, unsigned long n) {
    if(to && from) for(unsigned long i=0;i<n;i++) ((char*)to)[i]=((const char*)from)[i];
    return 0;
}
static inline unsigned long copy_to_user(void *to, const void *from, unsigned long n) {
    if(to && from) for(unsigned long i=0;i<n;i++) ((char*)to)[i]=((const char*)from)[i];
    return 0;
}
