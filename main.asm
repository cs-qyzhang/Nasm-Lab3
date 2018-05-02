; ===================================
; main.asm
; 主函数所在源文件
; Created by qiuyang.Zhang at 5/2/2018
; ===================================
struc   Goods
		.goodsName:     resb 12
		.inPrice:       resd 1
		.outPrice:      resd 1
		.quantity:      resd 1
		.sold:          resd 1
		.profitRate:    resd 1
endstruc
;----------------------------
%define	GOODSNUM	30
%define	GOODSLENGTH	32
;==========================================================================================
section .data
welcomeMsg	db "Welcome to Shop Manage System!", 0x0a, 0x00

changeFlag1:
%rep	GOODSNUM
	db  1
%endrep

changeFlag2:
%rep	GOODSNUM
	db 1
%endrep
;==========================================================================================
section .bss
shop1:
%rep GOODSNUM
istruc  Goods
		at Goods.goodsName,     resb 12
		at Goods.inPrice,       resd 1
		at Goods.outPrice,      resd 1
		at Goods.quantity,      resd 1
		at Goods.sold,          resd 1
		at Goods.profitRate,    resd 1
iend
%endrep
;--------------------------------
shop2:
%rep GOODSNUM
istruc  Goods
		at Goods.goodsName,     resb 12
		at Goods.inPrice,       resd 1
		at Goods.outPrice,      resd 1
		at Goods.quantity,      resd 1
		at Goods.sold,          resd 1
		at Goods.profitRate,    resd 1
iend
%endrep
;==========================================================================================
section .text
	global	main
	extern	strlen
	extern	printf
	extern	ReadData
main:
	mov	eax, ds
	mov	es, eax

	push	welcomeMsg
	call	printf

	mov	eax, 0x01
	mov	ebx, 0
	int	0x80
	ret
;==========================================================================================
; -------------------------------------
; 函数名称：FindGoods
; 函数功能：查找商品在商店中的位置
; 入口参数：goodsName:dword, 商品名首地址
; 出口参数：eax, 商品下标，从0开始(如未找到则返回-1)
; 现场保护：ebx, ecx, edx, esi, edi, es
;--------------------------------------
FindGoods:
	push	ebp
	mov	ebp, esp
	push	ebx
	push	ecx
	push	edx
	push	esi			;保护现场
	push	edi
	push	es
	
	mov	eax, ds
	mov	es, eax
	mov	ebx, 0			;初始化位置信息
	mov	edx, GOODSNUM
	.LOOPA:	mov	edi, [ebp + 8]	;将商品名的首地址赋值给edi
		lea	esi, [shop1 + ebx + Goods.goodsName]	;将shop1商品名称的首地址赋值给esi
		push	esi
		call	strlen
		mov	ecx, eax	;将商品名字符串长度赋值给ecx，即比较ecx次判断字符串长度是否相等
		repz	cmpsb
		jne	.N1		;不相等，跳到N1继续循环
		jmp	.N2		;字符串相等，跳到N2返回位置信息eax并返回主函数

	.N1:	inc	ebx		;位置信息加一
		dec	edx
		jnz	.LOOPA
		mov	ebx, -1
.N2:	mov	eax, ebx

	pop	es
	pop	edi
	pop	esi
	pop	edx			;恢复现场
	pop	ecx
	pop	ebx
	pop	ebp
	ret	4