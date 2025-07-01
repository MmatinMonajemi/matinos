# matinos
Matin OS - Simple Operation Sysytem For Fun!  Created By M.Matin Monajemi With C &amp; Assembly &amp; Love!
# Matin OS

Matin OS is a simple, terminal-based operating system written in Assembly and C, designed for educational purposes and minimal hardware environments. It boots from a floppy image, prints text directly to video memory, and lays the foundation for building a basic CLI-based operating system.

## Features

- Bootloader written in x86 Assembly
- Minimal C-based kernel
- Custom text output to video memory (`0xB8000`)
- QEMU-compatible for testing and development
- Terminal-style shell interface (coming soon!)

## Getting Started

### 🔧 Requirements

- Ubuntu (or any Linux distro)
- `nasm`, `gcc`, `ld`, and `qemu`

### 🛠 Build & Run

```bash
git clone https://github.com/mmatinmonajemi/matinos
cd matin-os
make        # build the OS
make run    # launch in QEMU
boot.asm     # Bootloader (Assembly)
kernel.c     # Simple kernel (C)
linker.ld    # Linker script
Makefile     # Build automation
For Test Use This :
qemu-system-x86_64 -drive format=raw,file=boot.bin
