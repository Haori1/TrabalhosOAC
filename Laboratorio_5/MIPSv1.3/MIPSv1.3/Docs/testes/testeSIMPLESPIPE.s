# Teste para verificacao da simulacao por forma de onda e na DE1-SoC
.data
	WORD: .word 0xB0DEB0B0, 0xF0CAF0FA, 0x0040009C
.text
	lui $t0,0x1001
	ori $t0,$t0,0x0000
	add $t1,$zero,$t0
	lw $t0,0($t1)
	nop
	addi $t0,$t0,1
	beq $t0,$zero,PULA
	nop
	nop
	addi $t0,$t0,1
	addi $t0,$t0,1
PULA:	lw $t2,0($t1)
	nop
	bne $t0,$t2,PULA2
	nop
	nop
	addi $t0,$t1,-1
	addi $t0,$t0,-1
PULA2:  addi $t0,$t0,1
	jal PROC
	nop
	lw $t2,8($t1)
	nop
	nop
	nop
	jr $t2
	nop
	nop	#
VOLTA:	addi $t0,$t0,1
	j FIM1
	nop
	nop
	addi $t0,$t0,-1
	addi $t0,$t0,-1
PROC:	nop
	nop
	jr $ra
	nop
	addi $t0,$t0,-1
PROC1:	lw $t1,4($t1)
	nop
	div $t0,$t1
	mfhi $t1
	add $t0,$t0,$t1
	j VOLTA
	nop
	addi $t0,$t0,-1
FIM1: 	j FIM1
	nop
	addi $t0,$t0,-1
