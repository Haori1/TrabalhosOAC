..file	"sortc2.c"
	.option nopic #desativa a geração de "position-independet code"
	.text
	.align	2 #Alinha os dados ao limite de 16 bits(meia palavra)
	.globl	show #torna "show" global, ou seja, é visível em outros arquivos.
	.type	show, @function #torna show o tipo @function (nao suportado pelo rars)
show:
	blez	a1,.L6
	addi	sp,sp,-32
	sd	s1,8(sp)
	addiw	s1,a1,-1
	slli	s1,s1,32
	srli	s1,s1,30
	addi	a5,a0,4
	sd	s0,16(sp)
	sd	s2,0(sp)
	sd	ra,24(sp)
	mv	s0,a0
	add	s1,s1,a5
	lui	s2,%hi(.LC1)
.L3:
	lw	a1,0(s0)
	addi	a0,s2,%lo(.LC1)
	addi	s0,s0,4
	call	printf
	bne	s0,s1,.L3
	ld	s0,16(sp)
	ld	ra,24(sp)
	ld	s1,8(sp)
	ld	s2,0(sp)
	li	a0,10
	addi	sp,sp,32
	tail	putchar
.L6:
	li	a0,10
	tail	putchar
	.size	show, .-show  #determina um tamanho para show
	.align	2 #Alinha os dados ao limite de 16 bits(meia palavra)
	.globl	swap #torna swap global
	.type	swap, @function #torna swap o tipo @function (nao suportado pelo rars)
swap:
	slli	a1,a1,2
	addi	a5,a1,4
	add	a5,a0,a5
	lw	a3,0(a5)
	add	a0,a0,a1
	lw	a4,0(a0)
	sw	a3,0(a0)
	sw	a4,0(a5)
	ret
	.size	swap, .-swap #define um tamanho para swap
	.align	2 #Alinha os dados ao limite de 16 bits(meia palavra)
	.globl	sort #torna sort global (visivel em outros arquivos)
	.type	sort, @function #torna sort do tipo @function (nao suportado pelo rars)
sort:
	blez	a1,.L11
	addiw	t1,a1,-1
	slli	t1,t1,32
	srli	t1,t1,32
	slli	t1,t1,2
	mv	a4,a0
	add	t1,a0,t1
	li	a6,0
	beq	a4,t1,.L11
.L16:
	lw	a3,0(a4)
	lw	a2,4(a4)
	addi	a7,a4,4
	ble	a3,a2,.L14
	slli	a0,a6,2
	mv	a5,a4
	mv	a1,a7
	sub	a0,a4,a0
	j	.L15
.L20:
	lw	a3,-4(a4)
	lw	a2,0(a4)
	addi	a5,a5,-4
	addi	a4,a4,-4
	addi	a1,a1,-4
	ble	a3,a2,.L14
.L15:
	sw	a2,0(a5)
	sw	a3,0(a1)
	bne	a5,a0,.L20
.L14:
	mv	a4,a7
	addi	a6,a6,1
	bne	a4,t1,.L16
.L11:
	ret
	.size	sort, .-sort #define um tamanho para sort
	.section	.text.startup,"ax",@progbits #emite "seção" se a mesma nao estiver presente e a torna atual(faz o .text)
	.align	2 #Alinha os dados ao limite de 16 bits(meia palavra)
	.globl	main #torna main global (visivel em outros arquivos)
	.type	main, @function #torna main do tipo @function (nao suportado pelo rars)
main:
	lui	a5,%hi(.LANCHOR0)
	addi	a5,a5,%lo(.LANCHOR0)
	ld	a6,0(a5)
	ld	a2,8(a5)
	ld	a3,16(a5)
	ld	a4,24(a5)
	ld	a5,32(a5)
	addi	sp,sp,-64
	addi	a0,sp,8
	li	a1,10
	sd	ra,56(sp)
	sd	a6,8(sp)
	sd	a2,16(sp)
	sd	a3,24(sp)
	sd	a4,32(sp)
	sd	a5,40(sp)
	call	show
	addi	a0,sp,8
	li	a1,10
	call	sort
	addi	a0,sp,8
	li	a1,10
	call	show
	ld	ra,56(sp)
	addi	sp,sp,64x
	jr	ra
	.size	main, .-main #define um tamanho para main
	.section	.rodata #emite "seção" se a mesma nao estiver presente e a torna atual(faz o .text)
	.align	3
	.set	.LANCHOR0,. + 0 
.LC0:
	.word	5
	.word	8
	.word	3
	.word	4
	.word	7
	.word	6
	.word	8
	.word	0
	.word	1
	.word	9
	.section	.rodata.str1.8,"aMS",@progbits,1 #emite "seção" se a mesma nao estiver presente e a torna atual(faz o .text)
	.align	3
.LC1:
	.string	"%d\t"
	.ident	"GCC: (GNU) 7.2.0" 
	#ident define uma string