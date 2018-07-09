# ARQUIVO QUE CONTEM OUTRAS ROTINAS. MAIS UM MÓDULO PARA DIMINUIR O TAMANHO DO MAIN.S.
# NAO COMPILA SOZINHO
# INCLUSO NA MAIN
###################################################################################

.text

# esperaEntrada
#	mantem o codigo em loop ate o usuario digitar uma tecla
# Retornos:
#	a0: letra lida (ASCII)

esperaEntrada:  li t1,0xFF200000		# carrega o endereço de controle do KDMMIO
esperaEntrada.loop: lw t0,0(t1)			# Le bit de Controle Teclado
   	andi t0,t0,0x0001			# mascara o bit menos significativo
   	beq t0,zero,esperaEntrada.loop		# não tem tecla pressionada então volta ao loop
   	lw a0,4(t1)				# le o valor da tecla
	ret					# retorna
##########################################################################################################

#######################################################################################################


# selecionaNivel
# Retornos:
#	a0: nivel escolhido

selecionaNivel: addi sp, sp, -4
	sw ra, 0(sp)
	
selecionaNivel.loop: jal esperaEntrada		# a0 esta com a tecla digitada
	li t1, '1'
	li t2, '2'
	li t3, '3'
	beq a0, t1, selecionaNivel.1
	beq a0, t2, selecionaNivel.2
	beq a0, t3, selecionaNivel.3
	j selecionaNivel.loop			# se nao for nenhum dos tres, entrada invalida. Leia denovo
	
selecionaNivel.1: li a0, 1
	j selecionaNivel.pula

selecionaNivel.2: li a0, 2
 	j selecionaNivel.pula
 
selecionaNivel.3: li a0, 3 
selecionaNivel.pula: lw ra, 0(sp)
	addi sp, sp, 4
	ret
#############################################################################################################


# selecionaCores
# 	seleciona a cor das pedras do player, jogando a outra pra CPU
#	tambem escolhe a cor do cursor e atualiza a cor das pedras na memoria

selecionaCores: addi sp, sp, -4
	sw ra, 0(sp)
	
	selecionaCores.loop: jal esperaEntrada
		li t1, '1'
		li t2, '2'
		beq a0, t1, selecionaCores.1		# escolheu branco
		beq a0, t2, selecionaCores.2		# escolheu preto
		j selecionaCores.loop

	selecionaCores.1: li t1, WHITE			# t1: cor das pedras do player
		li t2, BLACK				# t2: cor das pedras da maquina
		li t3, RED				# t3: cor do cursor das jogadas
		
		la t4, Pedra_PL_1			# armazendo as cores das pedras em cada uma delas
		sb t1, 2(t4)				# as pedras estao distribuidas sequencialmente na memoria, logo basta incrementar o endereco
		sb t1, 6(t4)				# colocando a cor sempre no terceiro indice de cada vetor
		sb t1, 10(t4)
		sb t1, 14(t4)
		sb t1, 18(t4)
		sb t1, 22(t4)
		sb t1, 26(t4)
		sb t1, 30(t4)
		sb t1, 34(t4)
		sb t1, 38(t4)
		sb t1, 42(t4)
		sb t1, 46(t4)
		j selecionaCores.pula			# nao precisa colocar preto nas pedras da CPU, pois elas ja comecam em preto
		
	selecionaCores.2: li t1, BLACK			# escolheu preto
		li t2, WHITE				# nesse caso nao precisa colocar preto nas pedras do player
		li t3, YELLOW
		
		la t4, Pedra_CPU_1			# armazendo as cores das pedras em cada uma delas
		sb t2, 2(t4)				# as pedras estao distribuidas sequencialmente na memoria, logo basta incrementar o endereco
		sb t2, 6(t4)				# colocando a cor sempre no terceiro indice de cada vetor
		sb t2, 10(t4)
		sb t2, 14(t4)
		sb t2, 18(t4)
		sb t2, 22(t4)
		sb t2, 26(t4)
		sb t2, 30(t4)
		sb t2, 34(t4)
		sb t2, 38(t4)
		sb t2, 42(t4)
		sb t2, 46(t4)
	
	selecionaCores.pula: la t4, Cor_PL
		la t5, Cor_CPU
		la t6, Cor_cursor
		sb t1, 0(t4)
		sb t2, 0(t5)
		sb t3, 0(t6)
		
	lw ra, 0(sp)
	addi sp, sp, 4
	ret
###########################################################################################################


# efeito para tocar em cada ponto, ou seja, sempre que uma pedra for engolida
efeitoSonoro: li a0, 69
li a1, 600
li a2, 127
li a3, 128
li a7, 31
ecall

ret
###########################################################################################################

menuMusica: addi sp, sp, -8
	sw ra, 0(sp)
	sw s0, 4(sp)

INICIO:	la s0, NOTA_DURACAO_DELAY_WINX
	li a2, 0 			#intrumento piano 0	
	li a3, 64			#volume medio
	li t0, 0
	li t6, 48			#t6 = TAMANHO DO ARRAY DAS NOTAS
MUSICA:	jal VERIFY_KEY
RA:	lw a0, 0(s0)			#a0 = nota	
	lw a1, 4(s0)			#a1 = duracao	
	li a7, 31			#a2 = instrumento
	ecall				#a3 = volume
	
	li a7, 32
	lw a0, 8(s0)
	ecall
	
	addi t0, t0, 1
	addi s0, s0, 12
	bne t0, t6, MUSICA		
	j INICIO
	
VERIFY_KEY: li t1, 0xFF200000
	lw t2, 0(t1)
	andi t2, t2, 0x0001 
	beqz t2, JUMPR
	
	lw ra, 0(sp)
	lw s0, 4(sp)
	addi sp, sp, 8
	ret	
	
JUMPR:  j RA
	
