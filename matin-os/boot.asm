BITS 16
ORG 0x7C00

mov [BOOT_DRIVE], dl
mov bp, 0x9000
mov sp, bp

mov si, msg
call print

call load_kernel
jmp 0x1000

print:
    mov ah, 0x0E
.next:
    lodsb
    cmp al, 0
    je .done
    int 0x10
    jmp .next
.done:
    ret

load_kernel:
    mov ah, 0x02
    mov al, 1
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov dl, [BOOT_DRIVE]
    mov bx, 0x1000
    int 0x13
    ret

msg db "Booting Matin OS...", 0
BOOT_DRIVE db 0

times 510 - ($ - $$) db 0
dw 0xAA55
sti ; faal sazi vaghfeha
jmp $

