# Teste para verificacao da simulacao por forma de onda no Quartus-II
# A execução deve ser a mesma do Mars e na DE1-SoC
# Se for diferente deve ser devido a hazards não tratados no hardware
# Onde colocar nops de forma a corrigir os hazards?
.include "../SYSTEMv1.s"

.data
	NUM: .word 5
.text
INICIO: li 	$t0,100
	addi 	$sp,$sp,-4
	sw	$t0,0($sp)
	lw	$t0,0($sp)
	addi 	$sp,$sp,4
	ori 	$t0,$t0,1
	ori	$t0,$t0,4
	add 	$t0,$t0,$t0
    	mult    $t0, $t0	
    	mflo    $t0
    	add     $t0, $t0, $t0
    	addi    $t0, $t0, 7  
	addi 	$t0, $t0, -1
	bne 	$t0, 0x00013ece, ERRO
	la 	$t1,NUM
	lw 	$t0,0($t1)
	add	 $t0,$t0,$t0
	sw 	$t0,4($t1)	
	lw 	$t0,4($t1)	
	beq 	$t0,0xA,LABEL1
	j 	ERRO

LABEL1:	blt 	$t0,0x20,LABEL2
	j 	ERRO

LABEL2:	bgt 	$t0,1,LABEL3
	move	$t0,$zero

LABEL3:	jal LABEL4
	div 	$t1,$t0
	mflo 	$t0
	mfhi 	$t1
	addi 	$t1,$t1,1
	add 	$t0,$t1,$t0
	beq 	$t0,0x00ccd9a6, LABEL5
	j ERRO

LABEL4:	sll 	$t0,$t0,2
	srl 	$t0,$t0,1
	bne 	$t0,0x14,ERRO
	jr $ra

LABEL5:	la 	$t0, CERTO
	jr 	$t0
	lui 	$t0,0x0000
	j 	ERRO	

CERTO:	lui 	$t0,0xCCCC

FIM: 	li $v0,10
	syscall	
	
ERRO:	lui 	$t0,0xEEEE
	j 	FIM
	lui 	$t0,0x0000

	
