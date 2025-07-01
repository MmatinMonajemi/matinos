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

    ; بارگذاری 1 سکتور کرنل از سکتور 2 به آدرس 0x1000:0x0000
    mov ah, 0x02
    mov al, 1
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov dl, [boot_drive]
    mov bx, 0x0000
    mov ax, 0x1000
    mov es, ax
    int 0x13
    jc load_error

    lgdt [gdt_descriptor]
    call enable_a20
    cli

    mov eax, cr0
    or eax, 1
    mov cr0, eax

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

err_msg db "Error loading kernel!", 0

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

    jmp 0x08:start_kernel

CODE_SEG equ 0x08
DATA_SEG equ 0x10
