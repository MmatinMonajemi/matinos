#include "string.h"

int strcmp(const char* s1, const char* s2) {
    while (*s1 && (*s1 == *s2)) {
        s1++; s2++;
    }
    return *(const unsigned char*)s1 - *(const unsigned char*)s2;
}

int strncmp(const char* s1, const char* s2, size_t n) {
    while (n && *s1 && (*s1 == *s2)) {
        s1++; s2++; n--;
    }
    if (n == 0) return 0;
    return *(const unsigned char*)s1 - *(const unsigned char*)s2;
}

size_t strlen(const char* str) {
    size_t len = 0;
    while (*str++) len++;
    return len;
}

void* memset(void* dest, int val, size_t len) {
    unsigned char* ptr = dest;
    while (len--) *ptr++ = (unsigned char)val;
    return dest;
}

void* memcpy(void* dest, const void* src, size_t len) {
    char* d = dest;
    const char* s = src;
    while (len--) *d++ = *s++;
    return dest;
}
