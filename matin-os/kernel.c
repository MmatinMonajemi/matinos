#include <stdio.h>
#include <string.h>

#define MAX_INPUT 128

void print(const char* str) {
    printf("%s", str);
    fflush(stdout);
}

void clear_screen() {
    // این تابع ترمینال را پاک می‌کند
    printf("\033[2J\033[H");
    fflush(stdout);
}

void read_input(char* buffer) {
    if (fgets(buffer, MAX_INPUT, stdin) != NULL) {
        // حذف '\n' انتهای خط
        buffer[strcspn(buffer, "\n")] = 0;
    } else {
        buffer[0] = 0;
    }
}

int main() {
    char input[MAX_INPUT] = {0};

    clear_screen();
    print("Matin OS Terminal\nType 'help' for commands.\n\n> ");

    while (1) {
        read_input(input);
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
            break;
        } else {
            print("Unknown command\n> ");
        }
        memset(input, 0, MAX_INPUT);
    }
    return 0;
}
