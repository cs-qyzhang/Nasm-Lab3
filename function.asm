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
rankPos:
%rep	GOODSNUM
	db 0
%endrep
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
	global	FindGoods, CalcuProfit, ChangeGoods, Ranking
	extern	strlen
	extern	printf
; -------------------------------------
; 函数名称：FindGoods
; 函数功能：查找商品在商店中的位置
; 入口参数：goodsName:dword, 商品名首地址
; 出口参数：eax, 商品下标，从0开始(如未找到则返回-1)
; 现场保护：ebp, ebx, ecx, edx, esi, edi, es
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
		mov	esi, ebx
		imul	esi, GOODSLENGTH
		add	esi, shop1
		push	esi
		call	strlen
		add	esp, 4

		mov	ecx, eax	;将商品名字符串长度赋值给ecx，即比较ecx次判断字符串是否相等
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
	ret
; -------------------------------------
; 函数名称：CalcuProfit
; 函数功能：计算商品在商店中的利润率
; 入口参数：无
; 出口参数：无
; 现场保护：ebx, ecx, edx, esi, edi, es
;--------------------------------------
CalcuProfit:
	push	ebx
	push	ecx
	push	edx
	push	esi			;保护现场
	push	edi
	push	es

	mov	eax, ds
	mov	es, eax
	mov	ebx, 0
	mov	ecx, GOODSNUM
	;更新shop1中商品的利润率
	.loop1:	mov	edi, ebx
		imul	edi, GOODSLENGTH

		cmp	byte [changeFlag1 + ebx], 0
		je	.N1
		mov	eax, [shop1 + edi + Goods.inPrice]		;将商品的进货价赋值给eax
		mov	edx, [shop1 + edi + Goods.quantity]		;将商品的进货总数赋值给edx
		mul	edx
		push	eax

		mov	eax, [shop1 + edi + Goods.outPrice]		;将商品的销售价赋值给eax
		mov	edx, [shop1 + edi + Goods.sold]		;将商品的已售数量赋值给edx
		mul	edx
		push	eax

		pop	eax				;取出销售价乘以已售数量
		pop	esi				;取出进货价乘以进货总数
		sub	eax, esi			;销售价乘以已售数量-进货价乘以进货总数->eax
		imul	eax, 100
		cdq
		idiv	esi
		mov	[shop1 + edi + Goods.profitRate], eax

	.N1:	inc	ebx
		dec	ecx
		jnz	.loop1

	mov	ebx, 0
	mov	ecx, GOODSNUM
	;更新shop2中商品的利润率
	.loop2:	mov	edi, ebx
		imul	edi, GOODSLENGTH
		

		cmp	byte [changeFlag2 + ebx], 0
		je	.N2
		mov	eax, [shop2 + edi + Goods.inPrice]		;将商品的进货价赋值给eax
		mov	edx, [shop2 + edi + Goods.quantity]		;将商品的进货总数赋值给edx
		mul	edx
		push	eax

		mov	eax, [shop2 + edi + Goods.outPrice]		;将商品的销售价赋值给eax
		mov	edx, [shop2 + edi + Goods.sold]		;将商品的已售数量赋值给edx
		mul	edx
		push	eax

		pop	eax				;取出销售价乘以已售数量
		pop	esi				;取出进货价乘以进货总数
		sub	eax, esi			;销售价乘以已售数量-进货价乘以进货总数->eax
		imul	eax, 100
		cdq
		idiv	esi
		mov	[shop2 + edi + Goods.profitRate], eax

	.N2:	inc	ebx
		dec	ecx
		jnz	.loop2

	pop	es
	pop	edi
	pop	esi
	pop	edx			;恢复现场
	pop	ecx
	pop	ebx
	ret
; -------------------------------------
; 函数名称：ChangeGoods
; 函数功能：修改商品的信息
; 入口参数：shop:dword, 存放修改哪一个商店的商品,pos:dword, 存放修改商店的第几个商品（从0开始）,goodsChange:dword, 存放修改后的商品信息结构的指针
; 出口参数：无
; 现场保护：ebp, ebx, ecx, edx, esi, edi, es
;--------------------------------------
ChangeGoods:
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
	mov	ebx, [ebp + 16]		;shop
	mov	ecx, [ebp + 12]		;pos
	mov	edx, [ebp + 8]		;goodsChange

	imul	ecx, GOODSLENGTH

	cmp	ebx, 1			;判断是修改shop1还是shop2里面的商品信息
	je	.N1
	cmp	ebx, 2
	je	.N2
	jmp	.N3
	
	.N1:	
		mov	esi, [edx + Goods.inPrice]
		mov	[shop1 + edi + Goods.inPrice], esi
		mov	esi, [edx + Goods.outPrice]
		mov	[shop1 + edi + Goods.outPrice], esi
		mov	esi, [edx + Goods.quantity]
		mov	[shop1 + edi + Goods.quantity], esi
		mov	esi, [edx + Goods.sold]
		mov	[shop1 + edi + Goods.sold], esi
		mov	esi, [edx + Goods.profitRate]
		mov	[shop1 + edi + Goods.profitRate], esi
		jmp	.N3

	.N2:	
		mov	esi, [edx + Goods.inPrice]
		mov	[shop2 + edi + Goods.inPrice], esi
		mov	esi, [edx + Goods.outPrice]
		mov	[shop2 + edi + Goods.outPrice], esi
		mov	esi, [edx + Goods.quantity]
		mov	[shop2 + edi + Goods.quantity], esi
		mov	esi, [edx + Goods.sold]
		mov	[shop2 + edi + Goods.sold], esi
		mov	esi, [edx + Goods.profitRate]
		mov	[shop2 + edi + Goods.profitRate], esi

	.N3:	pop	es
		pop	edi
		pop	esi
		pop	edx			;恢复现场
		pop	ecx
		pop	ebx
		pop	ebp
	ret
; -------------------------------------
; 函数名称：Ranking
; 函数功能：将SHOP2中的商品的利润率排序
; 入口参数：无
; 出口参数：无
; 现场保护：esp, ebx, ecx, edx, esi, edi, es
;--------------------------------------
Ranking:
	push	esp
	push	ebx
	push	ecx
	push	edx
	push	esi			;保护现场
	push	edi
	push	es

	mov	eax, ds
	mov	es, eax
	mov	ebx, 1				;ebx记录排序进行到第几个商品,从第1个开始
	mov	ecx, GOODSNUM			;将ecx设为shop2中商品的数量
	.loop1:	mov	edx, ebx		;edx记录商品正在与rankPos中利润率排第几的商品的利润率进行比较
		.loop2:	mov	esp, edx
			dec	esp
			imul	esp, GOODSLENGTH
			mov	esi, [rankPos + esp]	;获得在rankPos中已排序好的商品的位置信息
			mov	esp, esi
			imul	esp, GOODSLENGTH
			mov	edi, [shop2 + esp + Goods.profitRate]
			mov	esp, ebx
			imul	esp, GOODSLENGTH
			cmp	[shop2 + esp + Goods.profitRate], edi		;将商品的利润率与已排序好的商品的利润率进行比较
			jl	.N1						;被比较的商品的利润率小于已排序的商品的利润率，结束比较
			dec	edx
			jnz	.loop2					;结果是获得商品应在rankPos中放第几个
		;被比较的商品的位置信息ebx放入rankPos[edx]中，其它位置都往后移一个单位
		.N1	mov	esi, ebx
		.loop3:	mov	esp, esi
			dec	esp
			imul	esp, GOODSLENGTH
			mov	edi, [rankPos + esp]
			mov	[rankPos + esp - 32], edi
			dec	esi
			cmp	edx, esi
			jl	.loop3
		mov	[rankPos + esp - 32], ebx
		
		inc	ebx
		dec	ecx
		jnz	.loop1

	pop	esp
	pop	es
	pop	edi
	pop	esi
	pop	edx			;恢复现场
	pop	ecx
	pop	ebx
	ret