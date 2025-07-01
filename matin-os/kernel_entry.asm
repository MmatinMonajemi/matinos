[BITS 32]
global init_pm
extern main

init_pm:
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov esp, 0x90000

    call main

.hang:
    hlt
    jmp .hang
