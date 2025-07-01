#include <stdint.h>
#include "port.h"

struct IDTEntry {
    uint16_t offset_low;
    uint16_t selector;
    uint8_t zero;
    uint8_t type_attr;
    uint16_t offset_high;
} __attribute__((packed));

struct IDTPointer {
    uint16_t limit;
    uint32_t base;
} __attribute__((packed));

extern void load_idt(struct IDTPointer* idt_ptr);
extern void irq1_handler(void);
extern void default_handler(void);

#define IDT_SIZE 256
struct IDTEntry idt[IDT_SIZE];

void remap_pic() {
    outb(0x20, 0x11);
    outb(0xA0, 0x11);
    outb(0x21, 0x20);
    outb(0xA1, 0x28);
    outb(0x21, 0x04);
    outb(0xA1, 0x02);
    outb(0x21, 0x01);
    outb(0xA1, 0x01);
    outb(0x21, 0x00);
    outb(0xA1, 0x00);
}

void set_idt_entry(int n, void (*handler)(void)) {
    uintptr_t addr = (uintptr_t)handler;
    idt[n].offset_low = addr & 0xFFFF;
    idt[n].selector = 0x08;
    idt[n].zero = 0;
    idt[n].type_attr = 0x8E;
    idt[n].offset_high = (addr >> 16) & 0xFFFF;
}

void init_idt() {
    remap_pic();

    for (int i = 0; i < IDT_SIZE; i++) {
        set_idt_entry(i, default_handler);
    }

    set_idt_entry(0x21, irq1_handler);

    struct IDTPointer idtp;
    idtp.limit = sizeof(struct IDTEntry) * IDT_SIZE - 1;
    idtp.base = (uint32_t)(uintptr_t)&idt;
    load_idt(&idtp);
}
