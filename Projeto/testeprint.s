.include "eqv.s"
.include "imagens.s"

.macro _limpaPedra(%X, %Y)
li a0, BOARD_BACKGROUND
li a1, 25
li a2, 11
li a3, %X
li a4, %Y
jal smallClear
.end_macro

.text

li a0, WHITE_WORD
jal clearScreen

la a0, IMG_TABULEIRO
li a1, 320
li a2, 160
li a3, 0
li a4, 15
jal imprimeImagem

la a0, IMG_PEDRA_PRETA
li a1, 25
li a2, 11
li a3, 250
li a4, 19
jal imprimeImagem

_limpaPedra(250, 19)

li a7, 10
ecall

#########################################################################################################
# imprimeImagem
# Argumentos: 
# 	a0: endereco da imagem, cujo conteu do eh um vetor de bytes correspondendo a cor de cada pixel
# 	a1: largura (X)	ex: 320
# 	a2: altura (Y)	ex: 240
# 	a3: coordenada X desejada na tela
# 	a4: coordenada Y desejada na tela
imprimeImagem: li t6, BITMAP_ADDRESS	# carrega 0xFF000000
	mv t4, a4		# calculando endereco para impressao
	li t3, 320
	mul t4, t4, t3
	add t4, t4, a3
	add t4, t4, t6		# endereco para comecar a impressao = (Y*320) + X + BITMAP_ADDRESS
	
	mv t0, a0		# movendo argumentos para regs. temporarios
	mv t5, a2
	
	sub t3, t3, a1		# quantidade a se pular para imprimir linha a linha corretamente

	li t1, 4
	rem t1, a1, t1		# se X % 4 for diferente de zero, X nao esta alinhado em words
	bnez t1, imprimeimagem.byte	# nesse caso, pula pro caso byte a byte (4x mais lento)

	# CASO ENDERECO ALINHADO
	imprimeimagem.antesloop1: srli t1, a1, 2	# divide o contador por 4, afinal o loop percorre de 4 em 4 bytes (words)
	imprimeimagem.loop1: lw t2, 0(t0)
		sw t2, 0(t4)				# transporta o dado de t0 (vetor da imagem) para t4 (bitmap)
		addi t0, t0, 4
		addi t4, t4, 4
		addi t1, t1, -1
		beqz t1, imprimeimagem.fora
		j imprimeimagem.loop1

	imprimeimagem.fora: add t4, t4, t3		# t4 vai para a proxima linha e comeca o loop1 novamente; t0 ja esta na proxima "linha" pois eh sequencial
		addi t5, t5, -1				# loop1 ira rodar Y vezes
		beqz t5, imprimeimagem.fim
		j imprimeimagem.antesloop1

	# CASO ENDERECO DESALINHADO
	imprimeimagem.byte: mv t1, a1
	imprimeimagem.byte.loop1: lb t2, 0(t0)
		sb t2, 0(t4)				# transporta o dado de t0 (vetor da imagem) para t4 (bitmap)
		addi t0, t0, 1
		addi t4, t4, 1
		addi t1, t1, -1
		beqz t1, imprimeimagem.byte.fora
		j imprimeimagem.byte.loop1

	imprimeimagem.byte.fora: add t4, t4, t3		# t4 vai para a proxima linha e comeca o loop1 novamente; t0 ja esta na proxima "linha" pois eh sequencial
		addi t5, t5, -1				# loop1 ira rodar Y vezes
		beqz t5, imprimeimagem.fim
		j imprimeimagem.byte

	imprimeimagem.fim: ret
	
	
############################################################################################################
# clearScreen
# 	preenche toda a tela com a cor desejada
# Argumentos: 
# 	a0: cor, em word

clearScreen: li t1, BITMAP_ADDRESS			# endereco inicial da Memoria VGA
	li t2,0xFF012C00				# endereco final 
	clearScreen.loop: beq t1,t2,clearScreen.fora	# Se for o último endereço então sai do loop
		sw a0,0(t1)				# escreve a word na memória VGA
		addi t1,t1,4				# soma 4 ao endereço
		j clearScreen.loop			# volta a verificar
	clearScreen.fora: ret
	
	
###########################################################################################################
# smallClear
#	preenche uma parte pequena da tela com a cor desejada
# Argumentos: 
# 	a0: cor, em byte
# 	a1: largura (X)	ex: 320
# 	a2: altura (Y)	ex: 240
# 	a3: coordenada X desejada na tela
# 	a4: coordenada Y desejada na tela

smallClear: 
	li t6, BITMAP_ADDRESS	# carrega 0xFF000000
	mv t4, a4		# calculando endereco para preenchimento
	li t3, 320
	mul t4, t4, t3
	add t4, t4, a3
	add t4, t4, t6		# endereco para comecar o preenchimento = (Y*320) + X + BITMAP_ADDRESS
			
	mv t5, a2		# movendo argumentos para regs. temporarios
	sub t3, t3, a1		# quantidade a se pular para imprimir linha a linha corretamente
	
	smallClear.antesloop1: mv t1, a1
	smallClear.loop1: sb a0, 0(t4)		# transporta o dado de t0 (vetor da imagem) para t4 (bitmap)
		addi t4, t4, 1
		addi t1, t1, -1
		beqz t1, smallClear.fora
		j smallClear.loop1

	smallClear.fora: add t4, t4, t3		# t4 vai para a proxima linha e comeca o loop1 novamente; t0 ja esta na proxima "linha" pois eh sequencial
		addi t5, t5, -1		# loop1 ira rodar Y vezes
		beqz t5, smallClear.fim
		j smallClear.antesloop1

	smallClear.fim: ret
	
	
###########################################################################################################