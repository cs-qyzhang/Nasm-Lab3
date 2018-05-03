Nasm-Lab3  : main.c function.o
	gcc -m32 -gdwarf -o Nasm-Lab3 main.c function.o

function.o : function.asm
	nasm -f elf32 -g -F dwarf -l Nasm-Lab3.lst -o function.o function.asm