[BITS 32]

section .multiboot
    align 4
    dd 0x1BADB002         ; magic
    dd 0x00               ; flags
    dd -(0x1BADB002+0x00) ; checksum

section .text
    global init_pm

init_pm:
    cli
    mov     ax, 0x10
    mov     ds, ax
    mov     es, ax
    mov     fs, ax
    mov     gs, ax
    mov     ss, ax

    mov     esp, 0x9FC00

    sti

    mov     edi, 0xb8000
    mov     eax, 0x07454c4c  ; 'HELL'
    mov     [edi], eax
    mov     eax, 0x074f5720  ; 'O W '
    mov     [edi+4], eax
    mov     eax, 0x074c4421  ; 'LD!'
    mov     [edi+8], eax

.halt:
    hlt
    jmp .halt
