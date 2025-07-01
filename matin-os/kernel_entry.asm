[BITS 32]

global init_pm

init_pm:
    cli
    mov     ax, 0x10         ; Data segment selector (باید با GDT هماهنگ باشد)
    mov     ds, ax
    mov     es, ax
    mov     fs, ax
    mov     gs, ax
    mov     ss, ax

    mov     esp, 0x9FC00     ; Stack pointer (مطمئن شوید این آدرس آزاد است)

    sti

    mov     edi, 0xb8000
    mov     eax, 0x07454c4c  ; 'HELL'
    mov     [edi], eax
    mov     eax, 0x074f5720  ; 'O W '
    mov     [edi+4], eax
    mov     eax, 0x074c4421  ; 'LD!'
    mov     [edi+8], eax

.halt:
    hlt
    jmp .halt
