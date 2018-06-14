# Teste para verificacao da simulacao por forma de onda e na DE1-SoC
.data
	WORD: .word 0xB0DEB0B0, 0xF0CAF0FA, 0x00400070
.text
	lui $t0,0x1001
	nop
	nop
	ori $t0,$t0,0x0000
	nop
	nop
	add $t1,$zero,$t0
	nop
	nop
	lw $t0,0($t1)
	addi $t0,$t0,1
	beq $t0,$zero,PULA
	addi $t0,$t0,1
	addi $t0,$t0,1
PULA:	lw $t2,0($t1)
	bne $t0,$t2,PULA2
	addi $t0,$t1,-1
	addi $t0,$t0,-1
PULA2:  addi $t0,$t0,1
	jal PROC
	lw $t2,8($t1)
	jr $t2
VOLTA:	addi $t0,$t0,1
	j FIM1
	addi $t0,$t0,-1
	addi $t0,$t0,-1
PROC:	jr $ra
	addi $t0,$t0,-1
PROC1:	lw $t1,4($t1)
	div $t0,$t1
	mfhi $t1
	add $t0,$t0,$t1
	j VOLTA
	addi $t0,$t0,-1
FIM1: 	j FIM1
	addi $t0,$t0,-1
