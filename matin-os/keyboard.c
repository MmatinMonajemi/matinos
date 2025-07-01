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

char scancode_map[128] = {0};

void init_scancode_map() {
    char temp_map[60] = {
        0, 27, '1','2','3','4','5','6','7','8','9','0','-','=', '\b',
        '\t','q','w','e','r','t','y','u','i','o','p','[',']','\n', 0,
        'a','s','d','f','g','h','j','k','l',';','\'','`',   0, '\\',
        'z','x','c','v','b','n','m',',','.','/',   0, '*',  0, ' ', 0,
    };
    for(int i=0;i<60;i++) scancode_map[i]=temp_map[i];
    for(int i=60;i<128;i++) scancode_map[i]=0;
}

void clear_line(int line) {
    int start = line * COLS * 2;
    for(int i = 0; i < COLS; i++) {
        VIDEO_MEMORY[start + i*2] = ' ';
        VIDEO_MEMORY[start + i*2 + 1] = 0x07;
    }
}

void keyboard_handler() {
    uint8_t scancode = inb(0x60);

    if (scancode & 0x80 || scancode >= sizeof(scancode_map)) return;

    char c = scancode_map[scancode];
    if (!c) return;

    if (c == '\n') {
        if (buffer_index < INPUT_BUF_SIZE - 1)
            input_buffer[buffer_index++] = '\n';
        if (buffer_index < INPUT_BUF_SIZE)
            input_buffer[buffer_index] = 0;
        for(int i = buffer_index + 1; i < INPUT_BUF_SIZE; i++)
            input_buffer[i] = 0;
        buffer_index = 0;

        int line = cursor / (COLS * 2);
        line++;
        if (line >= ROWS) line = 0;
        cursor = line * COLS * 2;
        // clear_line(line); // در صورت نیاز فعال شود
    } else if (c == '\b') {
        if (buffer_index > 0 && cursor >= 2) {
            buffer_index--;
            cursor -= 2;
            if (cursor < VIDEO_SIZE - 1) {
                VIDEO_MEMORY[cursor] = ' ';
                VIDEO_MEMORY[cursor + 1] = 0x07;
            }
        }
    } else if (c >= 32 && c <= 126) { // فقط کاراکترهای قابل نمایش
        if (buffer_index < INPUT_BUF_SIZE - 1 && cursor < VIDEO_SIZE - 1) {
            input_buffer[buffer_index++] = c;
            VIDEO_MEMORY[cursor] = c;
            VIDEO_MEMORY[cursor + 1] = 0x07;
            cursor += 2;
        }
    }
    // جلوگیری از خروج cursor از محدوده
    if (cursor >= VIDEO_SIZE) {
        cursor = 0;
    }
    // اطمینان از اینکه بافر انتها ندارد
    if (buffer_index >= INPUT_BUF_SIZE) {
        buffer_index = INPUT_BUF_SIZE - 1;
    }
}
