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

    ; بارگذاری 4 سکتور (از سکتور 2 تا 5) در 0x10000
    mov si, 0              ; sector index
.load_loop:
    mov ah, 0x02           ; read sectors
    mov al, 1              ; sectors to read
    mov ch, 0
    mov cl, 2
    add cl, si
    mov dh, 0
    mov dl, [BOOT_DRIVE]
    mov bx, 0x0000
    mov ax, 0x1000         ; segment = 0x1000  (0x10000 = 0x1000 << 4)
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
    dq 0x00CF9A000000FFFF
    dq 0x00CF92000000FFFF
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

    ; پرش صحیح به آدرس کرنل (0x10000:0x0)
    jmp dword 0x10000

    jmp $
