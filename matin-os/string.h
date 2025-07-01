#ifndef MATIN_STRING_H
#define MATIN_STRING_H

#include <stddef.h>
#include <stdint.h>

// توابع با prefix matin_ برای جلوگیری از تداخل
int matin_strcmp(const char* s1, const char* s2);
int matin_strncmp(const char* s1, const char* s2, size_t n);
size_t matin_strlen(const char* str);
void* matin_memset(void* dest, int val, size_t len);
void* matin_memcpy(void* dest, const void* src, size_t len);

#endif
