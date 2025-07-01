[BITS 16]
ORG 0x7C00

start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    mov [boot_drive], dl

    ; پیام به صفحه
    mov si, msg
    call print

    ; بارگذاری 4 سکتور (سکتور 2 تا 5) در 0x1000:0x0000 (آدرس فیزیکی 0x10000)
    mov si, 0

load_loop:
    mov ah, 0x02        ; خواندن سکتور
    mov al, 1           ; تعداد سکتورها = 1
    mov ch, 0           ; سیلندر 0
    mov cl, 2
    add cl, si          ; سکتور 2 + si
    mov dh, 0           ; هد 0
    mov dl, [boot_drive]
    mov bx, 0x0000
    mov ax, 0x1000      ; segment 0x1000 = آدرس 0x10000
    mov es, ax
    int 0x13
    jc load_error

    inc si
    cmp si, 4
    jl load_loop

    ; آماده‌سازی GDT و ورود به حالت محافظت‌شده
    lgdt [gdt_descriptor]
    call enable_a20
    cli

    ; فعال کردن حالت محافظت‌شده
    mov eax, cr0
    or eax, 1
    mov cr0, eax

    ; پرش به کد 32 بیت
    jmp CODE_SEG:protected_mode

load_error:
    mov si, err_msg
    call print
    cli
    hlt
    jmp $

print:
    mov ah, 0x0E
.next_char:
    lodsb
    cmp al, 0
    je .done
    int 0x10
    jmp .next_char
.done:
    ret

enable_a20:
    in al, 0x92
    or al, 2
    out 0x92, al
    ret

gdt_start:
    dq 0x0000000000000000
    dq 0x00CF9A000000FFFF
    dq 0x00CF92000000FFFF
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

boot_drive db 0

msg db "Booting Matin OS...\r\n", 0
err_msg db "Error loading kernel!", 0

; پد کردن سکتور بوت تا 512 بایت
times 510 - ($ - $$) db 0
dw 0xAA55

[BITS 32]
protected_mode:
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov esp, 0x9FC00

    ; پرش به کرنل اصلی در 0x10000:0x0 (kernel.bin)
    jmp 0x08:0x00000000

    jmp $

CODE_SEG equ 0x08
DATA_SEG equ 0x10
