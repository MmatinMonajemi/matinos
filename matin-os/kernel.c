#include <stdint.h>
#include <string.h>

#define VIDEO_MEMORY ((char*)0xb8000)
#define MAX_INPUT 128

extern void init_idt();
extern char input_buffer[];

void print(const char* str);
void clear_screen();
void read_input(char* buffer);

static int row = 0, col = 0;

void main() {
    char input[MAX_INPUT] = {0}; // مقداردهی اولیه برای اطمینان

    clear_screen();
    init_idt();
    __asm__ __volatile__("sti");

    print("Matin OS Terminal\nType 'help' for commands.\n\n> ");

    while (1) {
        read_input(input);

        // اطمینان از بسته بودن رشته
        input[MAX_INPUT - 1] = 0;

        if (input[0] == 0) continue;

        if (strcmp(input, "help") == 0) {
            print("Commands:\nhelp\nclear\necho [text]\nexit\n\n> ");
        } else if (strcmp(input, "clear") == 0) {
            clear_screen();
            print("> ");
        } else if (strncmp(input, "echo ", 5) == 0) {
            print(input + 5);
            print("\n> ");
        } else if (strcmp(input, "exit") == 0) {
            print("Bye!\n");
            for (;;) __asm__("hlt");
        } else {
            print("Unknown command\n> ");
        }
        // پاک‌سازی input برای جلوگیری از تکرار دستورات قبلی
        memset(input, 0, MAX_INPUT);
    }
}

void print(const char* str) {
    char* video = VIDEO_MEMORY;
    while (*str) {
        if (*str == '\n') {
            row++;
            col = 0;
        } else {
            if (row >= 25) {
                clear_screen();
            }
            int pos = (row * 80 + col) * 2;
            if (pos < 80 * 25 * 2) { // جلوگیری از دسترسی خارج از محدوده
                video[pos] = *str;
                video[pos + 1] = 0x07;
            }
            col++;
            if (col >= 80) {
                col = 0;
                row++;
            }
        }
        str++;
    }
}

void clear_screen() {
    char* video = VIDEO_MEMORY;
    for (int i = 0; i < 80 * 25 * 2; i += 2) {
        video[i] = ' ';
        video[i + 1] = 0x07;
    }
    row = 0;
    col = 0;
}

void read_input(char* buffer) {
    // جلوگیری از گیرکردن در حلقه بی‌نهایت و مصرف زیاد CPU
    while (input_buffer[0] == 0) {
        __asm__ __volatile__("hlt"); // صرفه‌جویی در مصرف CPU
    }

    int i;
    for (i = 0; i < MAX_INPUT - 1; i++) {
        buffer[i] = input_buffer[i];
        if (input_buffer[i] == 0) {
            break;
        }
    }
    buffer[i] = 0; // تضمین تهی بودن انتها
    // پاک‌سازی input_buffer برای جلوگیری از دستور تکراری
    memset(input_buffer, 0, MAX_INPUT);
}
