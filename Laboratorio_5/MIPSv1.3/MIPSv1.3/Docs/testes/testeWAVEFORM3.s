# Teste para verificacao da simulacao por forma de onda no Quartus-II
# O programa verifica automaticamente se tem a FPU implementada
# testas as instrucoes criticas sqrt.s e div
# os registradores $t0 e $f8 são as saidas, total de 30 instrucoes

.data
NUM: .word 5
F1: .float 3.5

.text	
	la $t1,NUM		# $t1 = Endereco NUM
	lw $t0,0($t1)		# $t0 = numero 5
	sw $t0,8($t1)		# grava número em NUM+8 na memória
	lw $t0,8($t1)		# Le o numero gravado
	li $t1,5		# define $t1=5
	bne $t0,$t1,ERRO  	# caso o numero lido seja diferente de 5 é porque deu ruim em algum lugar
	l.s $f8,F1		# carrega $f8=3.5
	mfc1 $t0,$f8		# passa para $t0
	lui $t1,0x4060		#  define $t1=3.5 0x40600000
	bne $t0,$t1,SEMFPU	# parece que nao tem FPU
	mov.s $f0,$f8		# copia para $f0=3.5
	add.s $f8,$f8,$f0	# $f8=7.0
	mul.s $f8,$f8,$f8	# $f8=49.0
	sqrt.s $f8,$f8		# f8=7.0
	add.s $f0,$f0,$f0	# f0=7.0
	c.eq.s 4,$f8,$f0	# compara  7.0==7.0?
	cvt.w.s $f8,$f8		# converte para inteiro
	mfc1 $t0,$f8		# coloca em $t0
	bc1t 4,SEMFPU		# se for verdadeiro PULA
ERRO:	li $t0,0xEEEE		# sinaliza que houve EEEErro
FIM:	j FIM			# trava o processador
SEMFPU:	li $t1,0x958c96d5	# $t1
	li $t0,7
	jal PROC		# testa jal
	j FIM			# resultado esperado FocaFofa
PROC:	div $t1,$t0		# testa div
	mfhi $t0		# $t0=resto
	mflo $t0		# $t0=quociente
	jr $ra			# testa jr
