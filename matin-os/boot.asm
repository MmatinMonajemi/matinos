[BITS 16]
ORG 0x7C00

start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    mov [BOOT_DRIVE], dl

    mov si, msg
    call print

    ; بارگذاری 4 سکتور (از سکتور 2 تا 5) در آدرس 0x10000 (segment 0x1000)
    mov si, 0              ; شمارنده سکتورها
.load_loop:
    mov ah, 0x02           ; تابع خواندن سکتور BIOS
    mov al, 1              ; یک سکتور در هر بار خواندن
    mov ch, 0              ; سیلندر 0
    mov cl, 2              ; سکتور شروع (سکتور 2)
    add cl, si             ; افزودن شمارنده سکتور
    mov dh, 0              ; سر 0
    mov dl, [BOOT_DRIVE]   ; درایو بوت
    mov bx, 0x0000         ; آدرس افست 0x0000
    mov ax, 0x1000         ; segment = 0x1000 (0x10000 = 0x1000 << 4)
    mov es, ax
    int 0x13
    jc load_error          ; در صورت خطا پرش به بارگذاری خطا
    inc si
    cmp si, 4
    jl .load_loop

    ; تنظیم GDT
    lgdt [gdt_descriptor]

    call enable_a20

    ; سوئیچ به حالت محافظت شده
    cli

    ; سوئیچ به حالت 32 بیتی با jmp far
    jmp CODE_SEG:protected_mode_32

load_error:
    mov si, err_msg
    call print
    cli
    hlt
    jmp $

; تابع چاپ رشته با استفاده از int 0x10
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

; فعال سازی خط A20 برای دسترسی به بیش از 1 مگابایت حافظه
enable_a20:
    in al, 0x92
    or al, 2
    out 0x92, al
    ret

gdt_start:
    dq 0x0000000000000000        ; Null Descriptor
    dq 0x00CF9A000000FFFF        ; کد سگمنت، دسترسی خواندن و اجرا
    dq 0x00CF92000000FFFF        ; داده سگمنت، دسترسی خواندن و نوشتن
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

BOOT_DRIVE db 0

msg db "Booting Matin OS in Protected Mode...\r\n", 0
err_msg db "Error loading kernel!", 0

CODE_SEG equ 0x08
DATA_SEG equ 0x10

times 510 - ($-$$) db 0
dw 0xAA55

[BITS 32]
protected_mode_32:
    ; فعال سازی protected mode با تغییر CR0
    mov eax, cr0
    or eax, 1
    mov cr0, eax

    ; تنظیم سگمنت‌ها
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    mov esp, 0x9FC00      ; تنظیم استک

    ; پرش به آدرس کرنل بارگذاری شده (0x10000:0x0)
    jmp CODE_SEG:0x00010000

    jmp $
