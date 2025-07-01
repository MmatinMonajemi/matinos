#include <stdint.h>
#include "port.h"

#define VIDEO_MEMORY ((char*)0xb8000)
#define ROWS 25
#define COLS 80
#define VIDEO_SIZE (ROWS * COLS * 2)

#define INPUT_BUF_SIZE 128

char input_buffer[INPUT_BUF_SIZE];
int buffer_index = 0;
int cursor = 0;

char scancode_map[128] = {
    0, 27, '1','2','3','4','5','6','7','8','9','0','-','=', '\b',
    '\t','q','w','e','r','t','y','u','i','o','p','[',']','\n', 0,
    'a','s','d','f','g','h','j','k','l',';','\'','`',   0, '\\',
    'z','x','c','v','b','n','m',',','.','/',   0, '*',  0, ' ', 0,
    // بقیه مقدارها صفر بماند
};

void keyboard_handler() {
    uint8_t scancode = inb(0x60);

    // چک کردن بازه اسکن‌کد و کلید رها شده
    if (scancode & 0x80 || scancode >= sizeof(scancode_map)) return;

    char c = scancode_map[scancode];
    if (!c) return;

    if (c == '\n') {
        input_buffer[buffer_index] = 0;
        buffer_index = 0;
        cursor = 0;
    } else if (c == '\b') {
        if (buffer_index > 0 && cursor >= 2) {
            buffer_index--;
            cursor -= 2;
            VIDEO_MEMORY[cursor] = ' ';
            VIDEO_MEMORY[cursor + 1] = 0x07;
        }
    } else {
        if (buffer_index < INPUT_BUF_SIZE - 1 && cursor < VIDEO_SIZE - 2) {
            input_buffer[buffer_index++] = c;
            VIDEO_MEMORY[cursor++] = c;
            VIDEO_MEMORY[cursor++] = 0x07;
        }
    }
}
