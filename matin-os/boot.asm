; boot.asm
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

    mov bx, 0x1000
    mov dh, 0
    mov ch, 0
    mov cl, 2
    mov al, 1
    mov dl, [BOOT_DRIVE]
    mov ah, 0x02
    int 0x13
    jc load_error

    lgdt [gdt_descriptor]

    mov eax, cr0
    or eax, 1
    mov cr0, eax

    jmp CODE_SEG:init_pm

load_error:
    mov si, err_msg
    call print
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

[BITS 32]
init_pm:
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov esp, 0x90000

    call 0x1000

.hang:
    jmp .hang

gdt_start:
    dq 0x0000000000000000
    dq 0x00CF9A000000FFFF
    dq 0x00CF92000000FFFF
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start -1
    dd gdt_start

BOOT_DRIVE db 0

msg db "Booting Matin OS in Protected Mode...", 0
err_msg db "Error loading kernel!", 0

CODE_SEG equ 0x08
DATA_SEG equ 0x10

times 510-($-$$) db 0
dw 0xAA55
