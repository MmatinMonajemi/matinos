[BITS 32]
[ORG 0x1000]

global init_pm

init_pm:
    cli
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov esp, 0x9FC00

    sti

    mov edi, 0xb8000       ; آدرس VGA text mode
    mov eax, 0x07454c4c    ; 'ELL' با رنگ 7
    mov [edi], eax
    mov eax, 0x074f5720    ; 'OW ' با رنگ 7
    mov [edi+4], eax
    mov eax, 0x074c4421    ; 'LD!' با رنگ 7
    mov [edi+8], eax

.halt:
    hlt
    jmp .halt
