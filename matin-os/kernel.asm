[BITS 32]
section .text
global _start

_start:
    mov si, kernel_msg
print_char:
    lodsb
    cmp al, 0
    je halt
    mov ah, 0x0E
    int 0x10
    jmp print_char

halt:
    cli
    hlt
    jmp halt

section .data
kernel_msg db "Hello from kernel!", 0
