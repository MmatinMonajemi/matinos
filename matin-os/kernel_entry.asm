[BITS 32]
global init_pm
extern main

init_pm:
    mov ax, 0x10       ; دیتا سگمنت
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov esp, 0x90000   ; استک

    call main

.halt:
    hlt
    jmp .halt
