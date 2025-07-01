; kernel_entry.asm
[BITS 32]
global init_pm

section .text
init_pm:
    ; تنظیم سگمنت‌ها
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    ; تنظیم پشته
    mov esp, 0x90000

    ; نمایش پیام ساده
    mov esi, message
.print_loop:
    lodsb
    test al, al
    jz .done
    ; چاپ کاراکتر با اینترپت 0x10
    mov ah, 0x0E
    mov bh, 0
    mov bl, 7
    int 0x10
    jmp .print_loop

.done:
    ; توقف
    cli
.hlt_loop:
    hlt
    jmp .hlt_loop

section .data
message db "Protected mode kernel started!", 0
