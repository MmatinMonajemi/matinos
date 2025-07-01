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

    ; Load kernel (4 sectors) from disk to 0x1000:0
    mov ah, 0x02         ; BIOS read sectors
    mov al, 4            ; Number of sectors
    mov ch, 0            ; Cylinder
    mov cl, 2            ; Sector (starts from 1)
    mov dh, 0            ; Head
    mov dl, [BOOT_DRIVE] ; Drive
    mov bx, 0x1000       ; Buffer offset
    int 0x13
    jc load_error

    lgdt [gdt_descriptor]

    ; Enable A20 (اختیاری، بستگی به سخت‌افزار دارد)
    call enable_a20

    mov eax, cr0
    or eax, 1
    mov cr0, eax

    jmp CODE_SEG:protected_mode

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

; --- Optional: Enable A20 line ---
enable_a20:
    in   al, 0x92
    or   al, 2
    out  0x92, al
    ret

gdt_start:
    dq 0x0000000000000000
    dq 0x00CF9A000000FFFF ; Code segment
    dq 0x00CF92000000FFFF ; Data segment
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start -1
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

    ; پرش به کرنل در صورت وجود
    ; jmp 0x1000:0 ; اگر کرنل اینجاست

    jmp $
