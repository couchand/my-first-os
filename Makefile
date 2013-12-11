all: kernel iso

kernel: kernel.bin
iso: boot.iso

kernel.bin: obj/boot.o obj/kernel.o src/linker.ld
	i586-elf-gcc -T src/linker.ld -o kernel.bin -ffreestanding -O2 -nostdlib obj/boot.o obj/kernel.o -lgcc

obj/boot.o: src/boot.s
	i586-elf-as src/boot.s -o obj/boot.o

obj/kernel.o: src/kernel.c
	i586-elf-gcc -c src/kernel.c -o obj/kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra

boot.iso: kernel.bin grub.cfg
	mkdir -p iso/boot/grub
	cp kernel.bin iso/boot/
	cp grub.cfg iso/boot/grub/
	grub-mkrescue -o boot.iso iso

clean:
	rm -f obj/boot.o obj/kernel.o
