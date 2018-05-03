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

shop1:
%rep GOODSNUM
istruc  Goods
		at Goods.goodsName,     times 12 db 0
		at Goods.inPrice,       dd 0
		at Goods.outPrice,      dd 0
		at Goods.quantity,      dd 0
		at Goods.sold,          dd 0
		at Goods.profitRate,    dd 0
iend
%endrep
;--------------------------------
shop2:
%rep GOODSNUM
istruc  Goods
		at Goods.goodsName,     times 12 db 0
		at Goods.inPrice,       dd 0
		at Goods.outPrice,      dd 0
		at Goods.quantity,      dd 0
		at Goods.sold,          dd 0
		at Goods.profitRate,    dd 0
iend
%endrep
global	ptrShop1, ptrShop2

ptrShop1	dd shop1
ptrShop2	dd shop2

fileName	db "data.dat", 0
;==========================================================================================
section .bss

;==========================================================================================
section .text
	global	FindGoods
	extern	strlen
	extern	printf
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
	push	esi			;保护现场
	push	edi
	push	es
	
	mov	eax, ds
	mov	es, eax
	mov	ebx, 0			;初始化位置信息
	mov	edi, [ebp + 8]		;将商品名的首地址赋值给edi
	.LOOPA:
		mov	esi, ebx	;将shop1商品名称的首地址赋值给esi
		imul	esi, GOODSLENGTH
		add	esi, shop1
		push	esi
		call	strlen
		add	esp, 4

		mov	ecx, eax	;将商品名字符串长度赋值给ecx，即比较ecx次判断字符串长度是否相等
		inc	ecx
		mov	eax, esi
		push	edi
		repz	cmpsb
		pop	edi
		jne	.N1		;不相等，跳到N1继续循环
		jmp	.N2		;字符串相等，跳到N2返回位置信息eax并返回主函数

	.N1:	inc	ebx		;位置信息加一
		cmp	ebx, GOODSNUM
		jnz	.LOOPA
		mov	ebx, -1
.N2:	mov	eax, ebx

	pop	es
	pop	edi
	pop	esi			;恢复现场
	pop	ecx
	pop	ebx
	pop	ebp
	retn