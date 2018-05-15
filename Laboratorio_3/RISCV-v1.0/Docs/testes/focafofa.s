.include "../SYSTEMv1.s"

.data
	DADO: .word 0x0A
	FLOAT: .float 16.0
.text
	li t0,0
	la s0,DADO
	lw t1,0(s0)
LOOP:	beq t0,t1,FIM
	addi t0,t0,1
	j LOOP
FIM:	li t0,0xf0caf0fa
	li t1,0x10
	remu t2,t0,t1
	divu t0,t0,t1
	flw f0,4(s0)
	fsqrt.s f8,f0

	li a7,10
	ecall
