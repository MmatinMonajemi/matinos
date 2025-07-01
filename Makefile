.PHONY: all run clean

all: matin-os.bin

boot.bin: boot.asm
	nasm -f bin boot.asm -o boot.bin

kernel_entry.o: kernel_entry.asm
	nasm -f elf kernel_entry.asm -o kernel_entry.o

idt.o: idt.asm
	nasm -f elf idt.asm -o idt.o

idtc.o: idt.c
	gcc -ffreestanding -m32 -c idt.c -o idtc.o

keyboard.o: keyboard.c
	gcc -ffreestanding -m32 -c keyboard.c -o keyboard.o

string.o: string.c
	gcc -ffreestanding -m32 -c string.c -o string.o

kernel.o: kernel.c
	gcc -ffreestanding -m32 -c kernel.c -o kernel.o

kernel.bin: kernel_entry.o idt.o idtc.o keyboard.o string.o kernel.o linker.ld
	ld -m elf_i386 -T linker.ld -o kernel.bin kernel_entry.o idt.o idtc.o keyboard.o string.o kernel.o

matin-os.bin: boot.bin kernel.bin
	cat boot.bin kernel.bin > matin-os.bin

run: matin-os.bin
	qemu-system-i386 -drive format=raw,file=matin-os.bin

clean:
	rm -f *.o *.bin kernel.bin matin-os.bin
