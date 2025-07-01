#include <stdint.h>
#include "port.h"

#define VIDEO_MEMORY ((char*)0xb8000)
#define ROWS 25
#define COLS 80
#define VIDEO_SIZE (ROWS * COLS * 2)
#define INPUT_BUF_SIZE 128

volatile char input_buffer[INPUT_BUF_SIZE] = {0};
volatile int buffer_index = 0;
volatile int cursor = 0;

char scancode_map[128] = {
    0, 27, '1','2','3','4','5','6','7','8','9','0','-','=', '\b',
    '\t','q','w','e','r','t','y','u','i','o','p','[',']','\n', 0,
    'a','s','d','f','g','h','j','k','l',';','\'','`',   0, '\\',
    'z','x','c','v','b','n','m',',','.','/',   0, '*',  0, ' ', 0,
};

void init_scancode_map() {
    for(int i = 58; i < 128; i++) {
        scancode_map[i] = 0;
    }
}

void keyboard_handler() {
    uint8_t scancode = inb(0x60);

    if (scancode & 0x80 || scancode >= sizeof(scancode_map)) return;

    char c = scancode_map[scancode];
    if (!c) return;

    if (c == '\n') {
        if (buffer_index < INPUT_BUF_SIZE)
            input_buffer[buffer_index] = 0;
        for(int i = buffer_index + 1; i < INPUT_BUF_SIZE; i++)
            input_buffer[i] = 0;
        buffer_index = 0;

        // رفتن به ابتدای خط بعدی
        int line = cursor / (COLS * 2);
        line++;
        if (line >= ROWS) line = 0; // اگر به آخر صفحه رسیدیم، به اول برگردیم
        cursor = line * COLS * 2;
    } else if (c == '\b') {
        if (buffer_index > 0 && cursor >= 2) {
            buffer_index--;
            cursor -= 2;
            VIDEO_MEMORY[cursor] = ' ';
            VIDEO_MEMORY[cursor + 1] = 0x07;
        }
    } else if (c >= 32 && c <= 126) { // فقط کاراکترهای قابل نمایش
        if (buffer_index < INPUT_BUF_SIZE - 1 && cursor < VIDEO_SIZE - 2) {
            input_buffer[buffer_index++] = c;
            VIDEO_MEMORY[cursor++] = c;
            VIDEO_MEMORY[cursor++] = 0x07;
        }
    }
}

// در جایی از کد اصلی، قبل از استفاده از کیبورد، حتما این تابع را یک بار صدا بزنید
// init_scancode_map();
