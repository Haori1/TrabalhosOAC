.data
	v:	.word	9,2,5,1,8,2,4,3,6,7
	
	
	.LC0:	.string	"%d\t"

.text
show:
	blez	a1,.L6
	addi	sp,sp,-32
	sw	s1,8(sp)
	addi	s1,a1,-1
	add	s1,zero,zero
	srli	s1,s1,30
	addi	a5,a0,4
	sw	s0,16(sp)
	sw	s2,0(sp)
	sw	ra,24(sp)
	mv	s0,a0
	add	s1,s1,a5
	lui	s2,%hi(.LC0)
.L3:
	lw	a1,0(s0)
	addi	a0,s2,%lo(.LC0)
	addi	s0,s0,4
	call	printf
	bne	s0,s1,.L3
	lw	s0,16(sp)
	lw	ra,24(sp)
	lw	s1,8(sp)
	lw	s2,0(sp)
	li	a0,10
	addi	sp,sp,32
	tail	putchar
.L6:
	li	a0,10
	tail	putchar

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

sort:
	blez	a1,.L11
	addi	t1,a1,-1
	add	t1,zero,zero
	add	t1,zero,zero
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

main:
	addi	sp,sp,-16
	sw	s0,0(sp)
	lui	s0,%hi(.LANCHOR0)
	addi	a0,s0,%lo(.LANCHOR0)
	li	a1,10
	sw	ra,8(sp)
	call	show
	addi	a0,s0,%lo(.LANCHOR0)
	li	a1,10
	call	sort
	addi	a0,s0,%lo(.LANCHOR0)
	lw	s0,0(sp)
	lw	ra,8(sp)
	li	a1,10
	addi	sp,sp,16
	tail	show
	
printf:
	
