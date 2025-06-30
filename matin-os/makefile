all:
    nasm -f bin boot.asm -o boot.bin
    nasm -f elf idt.asm -o idt.o
    gcc -ffreestanding -m32 -c kernel.c -o kernel.o
    gcc -ffreestanding -m32 -c idt.c -o idtc.o
    gcc -ffreestanding -m32 -c keyboard.c -o keyboard.o
    ld -m elf_i386 -T linker.ld -o kernel.bin idt.o idtc.o keyboard.o kernel.o
    cat boot.bin kernel.bin > matin-os.bin

run:
    qemu-system-i386 -drive format=raw,file=matin-os.bin
