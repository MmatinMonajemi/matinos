[BITS 32]

global load_idt
load_idt:
    mov eax, [esp + 4]
    lidt [eax]
    ret

extern keyboard_handler
global irq1_handler
irq1_handler:
    pusha
    call keyboard_handler
    popa
    iretd
