.PHONY: all run clean

all: matin-os.bin

boot.bin: boot.asm
	nasm -f bin boot.asm -o boot.bin

idt.o: idt.asm
	nasm -f elf idt.asm -o idt.o

kernel.o: kernel.c
	gcc -ffreestanding -m32 -c kernel.c -o kernel.o

idtc.o: idt.c
	gcc -ffreestanding -m32 -c idt.c -o idtc.o

keyboard.o: keyboard.c
	gcc -ffreestanding -m32 -c keyboard.c -o keyboard.o

kernel.bin: idt.o idtc.o keyboard.o kernel.o linker.ld
	ld -m elf_i386 -T linker.ld -o kernel.bin idt.o idtc.o keyboard.o kernel.o

matin-os.bin: boot.bin kernel.bin
	cat boot.bin kernel.bin > matin-os.bin

run: matin-os.bin
	qemu-system-i386 -drive format=raw,file=matin-os.bin

clean:
	rm -f *.o *.bin kernel.bin matin-os.bin
