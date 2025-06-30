void main() {
    char* video_memory = (char*) 0xb8000;
    video_memory[0] = 'H';
    video_memory[1] = 0x07;
}
void print(const char* str) {
    char* video_memory = (char*) 0xb8000;
    int i = 0;
    while (str[i]) {
        video_memory[i * 2] = str[i];
        video_memory[i * 2 + 1] = 0x07;
        i++;
    }
}

void main() {
    print("Matin OS Terminal\n>");
    while (1) {
        //  termianl !
    }
}
