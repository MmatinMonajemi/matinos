#ifndef STRING_H
#define STRING_H

#include <stddef.h>
#include <stdint.h>

int strcmp(const char* s1, const char* s2);
int strncmp(const char* s1, const char* s2, size_t n);
size_t strlen(const char* str);
void* memset(void* dest, int val, size_t len);
void* memcpy(void* dest, const void* src, size_t len);

#endif
