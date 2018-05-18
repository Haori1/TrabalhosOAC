.include "../SYSTEMv1.s"

.data
	DADO: .word 0x0A
	FLOAT: .float 16.0
.text
	li $t0,0
	la $s0,DADO
	lw $t1,0($s0)
LOOP:	beq $t0,$t1,FIM
	addi $t0,$t0,1
	j LOOP
FIM:	la $t0,0xf0caf0fa
	li $t1,0x10
	divu $t0,$t1
	mfhi $t0
	mflo $t0
	l.s $f0,FLOAT
	sqrt.s $f8,$f0

	li $v0,10
	syscall
