// kernel.c
#include <stdint.h>
#include <string.h>

#define VIDEO_MEMORY ((char*)0xb8000)
#define MAX_INPUT 80

extern void init_idt();
extern char input_buffer[80];

void print(const char* str);
void clear_screen();
void read_input(char* buffer);

void main() {
    char input[MAX_INPUT];

    clear_screen();
    init_idt();
    __asm__ __volatile__("sti");

    print("Matin OS Terminal\nType 'help' for commands.\n\n> ");

    while (1) {
        read_input(input);

        if (input[0] == 0) continue;

        if (strcmp(input, "help") == 0) {
            print("Available commands:\nhelp\nclear\necho [text]\n\n> ");
        } else if (strcmp(input, "clear") == 0) {
            clear_screen();
            print("> ");
        } else if (strncmp(input, "echo ", 5) == 0) {
            print(input + 5);
            print("\n> ");
        } else {
            print("Unknown command\n> ");
        }
    }
}

void print(const char* str) {
    static int row = 0, col = 0;
    char* video = VIDEO_MEMORY;

    while (*str) {
        if (*str == '\n') {
            row++;
            col = 0;
        } else {
            int pos = (row * 80 + col) * 2;
            video[pos] = *str;
            video[pos + 1] = 0x07;
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
}

void read_input(char* buffer) {
    while (input_buffer[0] == 0);
    for (int i = 0; i < MAX_INPUT; i++) {
        buffer[i] = input_buffer[i];
        if (input_buffer[i] == 0) break;
    }
    input_buffer[0] = 0;
}
