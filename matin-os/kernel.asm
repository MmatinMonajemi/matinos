[BITS 32]
ORG 0x0000

start_kernel:
    ; تنظیم VGA متنی
    mov ax, 0xB800
    mov ds, ax

    ; پاک کردن صفحه
    mov edi, 0
    mov ecx, 80*25
    mov al, ' '
    mov ah, 0x07
.clear_loop:
    mov [edi*2], al
    mov [edi*2+1], ah
    inc edi
    loop .clear_loop

    ; نمایش پیام در خط اول (خانه اول)
    mov esi, msg
    mov edi, 0

.print_loop:
    lodsb
    cmp al, 0
    je .done
    mov [edi*2], al
    mov byte [edi*2+1], 0x0F   ; رنگ سفید روی پس‌زمینه سیاه
    inc edi
    jmp .print_loop

.done:
    ; ساده‌ترین ترمینال: فقط انتظار بی‌نهایت (loop)
    jmp $

msg db "Welcome to Matin OS", 0
