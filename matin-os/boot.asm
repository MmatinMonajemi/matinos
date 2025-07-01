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

    mov si, 0  ; sector index
.load_loop:
    mov ah, 0x02
    mov al, 1
    mov ch, 0
    mov cl, 2
    add cl, si
    mov dh, 0
    mov dl, [BOOT_DRIVE]
    mov bx, 0x0000
    ; محاسبه درست segment برای بارگذاری هر سکتور
    mov ax, 0x1000
    mov dx, si
    shl dx, 5      ; dx = si * 32 (هر سکتور 512 بایت = 32 * 16)
    add ax, dx
    mov es, ax
    int 0x13
    jc load_error
    inc si
    cmp si, 4
    jl .load_loop

    lgdt [gdt_descriptor]
    call enable_a20

    mov eax, cr0
    or eax, 1
    mov cr0, eax

    ; Far JMP با selector:offset برای Protected Mode
    jmp 0x08:protected_mode

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

enable_a20:
    in   al, 0x92
    or   al, 2
    out  0x92, al
    ret

gdt_start:
    dq 0x0000000000000000
    dq 0x00CF9A000000FFFF ; Code segment (base=0, limit=4GB, flags)
    dq 0x00CF92000000FFFF ; Data segment (base=0, limit=4GB, flags)
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
protected_mode:
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov esp, 0x9FC00

    ; پرش به آدرس خطی کرنل (در اینجا فرض شده کرنل در 0x10000 بارگذاری شده)
    jmp 0x10000

    jmp $
