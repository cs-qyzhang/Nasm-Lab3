; ===================================
; main.asm
; 主函数所在源文件
; Created by qiuyang.Zhang at 5/2/2018
; ===================================
section .data

section .bss

section .text
	global	main

main:

	mov	eax, 0x01
	mov	ebx, 0
	int	0x80
	ret