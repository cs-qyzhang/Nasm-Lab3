Nasm-Lab3	:	Nasm-Lab3.o function.o
	gcc -m32 -gdwarf -o Nasm-Lab3 Nasm-Lab3.o function.o

function.o	:	function.c
	gcc -m32 -o function.o function.c

Nasm-Lab3.o	:	main.asm
	nasm -f elf32 -g -F dwarf -l Nasm-Lab3.lst -o Nasm-Lab3.o main.asm