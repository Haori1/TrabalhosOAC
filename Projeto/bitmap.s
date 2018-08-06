# ARQUIVO QUE CONTEM ROTINAS RELACIONADAS AO TRATAMENTO DE IMAGENS E DO BITMAP
# NAO COMPILA SOZINHO
# INCLUSO NA MAIN
###################################################################################

##############################################################################################
.macro _atualizaCursorEsq(%cor, %X, %Y)	# cor eh um registrador e outros sao imediatos
mv a0, %cor
li a1, 7
li a2, 3
mv a3, %X
mv a4, %Y
jal smallPaint			# apaga a posicao atual com branco ou verde

addi a0, %X, -1			
addi a1, %Y, 0
jal desenha.map			# mapeia 1 coordenada a esquerda da atual para imprimir 
mv a3, a0
mv a4, a1
li tp, Cor_cursor
li a0, 0(tp)
li a1, 7
li a2, 3
jal smallPaint			# imprime cursor
.end_macro
###############################################################################
.macro _atualizaCursorDir(%cor, %X, %Y)	# cor eh um registrador e outros sao imediatos
mv a0, %cor
li a1, 7
li a2, 3
mv a3, %X
mv a4, %Y
jal smallPaint			# apaga a posicao atual com branco ou verde

addi a0, %X, 1			
addi a1, %Y, 0
jal desenha.map			# mapeia 1 coordenada a direita da atual para imprimir 
mv a3, a0
mv a4, a1
li tp, Cor_cursor
li a0, 0(tp)
li a1, 7
li a2, 3
jal smallPaint			# imprime cursor
.end_macro
##############################################################################################
.macro _atualizaCursorCima(%cor, %X, %Y)	# cor eh um registrador e outros sao imediatos
mv a0, %cor
li a1, 7
li a2, 3
mv a3, %X
mv a4, %Y
jal smallPaint			# apaga a posicao atual com branco ou verde

addi a0, %X, 0			
addi a1, %Y, -1
jal desenha.map			# mapeia 1 coordenada acima da atual para imprimir 
mv a3, a0
mv a4, a1
li tp, Cor_cursor
li a0, 0(tp)
li a1, 7
li a2, 3
jal smallPaint			# imprime cursor
.end_macro
######################################################################################
.macro _atualizaCursorBaixo(%cor, %X, %Y)	# cor eh um registrador e outros sao imediatos
mv a0, %cor
li a1, 7
li a2, 3
mv a3, %X
mv a4, %Y
jal smallPaint			# apaga a posicao atual com branco ou verde

addi a0, %X, 0			
addi a1, %Y, 1
jal desenha.map			# mapeia 1 coordenada abaixo da atual para imprimir 
mv a3, a0
mv a4, a1
li tp, Cor_cursor
li a0, 0(tp)
li a1, 7
li a2, 3
jal smallPaint			# imprime cursor
.end_macro
######################################################################################

.text

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
	clearScreen.loop: beq t1,t2,clearScreen.fora	# Se for o �ltimo endere�o ent�o sai do loop
		sw a0,0(t1)				# escreve a word na mem�ria VGA
		addi t1,t1,4				# soma 4 ao endere�o
		j clearScreen.loop			# volta a verificar
	clearScreen.fora: ret
###########################################################################################################


# smallPaint
#	preenche uma parte pequena da tela com a cor desejada
# Argumentos: 
# 	a0: cor, em byte
# 	a1: largura (X)	ex: 320
# 	a2: altura (Y)	ex: 240
# 	a3: coordenada X desejada na tela
# 	a4: coordenada Y desejada na tela

smallPaint: li t6, BITMAP_ADDRESS	# carrega 0xFF000000
	mv t4, a4		# calculando endereco para preenchimento
	li t3, 320
	mul t4, t4, t3
	add t4, t4, a3
	add t4, t4, t6		# endereco para comecar o preenchimento = (Y*320) + X + BITMAP_ADDRESS
			
	mv t5, a2		# movendo argumentos para regs. temporarios
	sub t3, t3, a1		# quantidade a se pular para imprimir linha a linha corretamente
	
	smallPaint.antesloop1: mv t1, a1
	smallPaint.loop1: sb a0, 0(t4)		# transporta o dado de t0 (vetor da imagem) para t4 (bitmap)
		addi t4, t4, 1
		addi t1, t1, -1
		beqz t1, smallPaint.fora
		j smallPaint.loop1

	smallPaint.fora: add t4, t4, t3		# t4 vai para a proxima linha e comeca o loop1 novamente; t0 ja esta na proxima "linha" pois eh sequencial
		addi t5, t5, -1		# loop1 ira rodar Y vezes
		beqz t5, smallPaint.fim
		j smallPaint.antesloop1

	smallPaint.fim: ret
###########################################################################################################


# desenhaTela.ini
#	atualiza a posicao de todas as pedras no bitmap apos cada jogada

desenhaTela.ini: addi sp, sp, -12
	sw ra, 0(sp)
	sw s10, 4(sp)
	sw s11, 8(sp)
	
	li s10, 24							# s10: contador do loop
	la s11, Pedra_PL_1						# carrega primeira pedra
	desenhaTela.ini.loop: beq s10, zero, desenhaTela.ini.fora
		lb a0, 0(s11)
		lb a1, 1(s11)
		blt a0, zero, pecaMorta
		blt a1, zero, pecaMorta
		jal desenha.map
		mv a3, a0						# coloca coordenadas obtidas em a3 e a4
		mv a4, a1
		lb t0, 2(s11)						# carrega cor da pedra
		beq t0, zero, desenhaTela.ini.loop.preta		# se a cor for zero eh preta
		la a0, IMG_PEDRA_BRANCA					# se for branca, prepara pra imprimir pedra branca	
		j desenhaTela.ini.loop.pula					
		desenhaTela.ini.loop.preta: la a0, IMG_PEDRA_PRETA	# se for preta, prepara pra imprimir pedra preta
		desenhaTela.ini.loop.pula: li a1, 25
		li a2, 11
		
		jal imprimeImagem		# argumentos: a0 (imagem), a1 e a2 (dimensoes), a3 e a4 (coordenadas desejadas)
		
		pecaMorta:
		
		addi s11, s11, 4		# carrega proxima pedra
		addi s10, s10, -1		# decrementa contador
		
		
		j desenhaTela.ini.loop
	
	desenhaTela.ini.fora: lw ra, 0(sp)
	addi sp, sp, 12
	ret


# desenha.map
#	mapeia as coordenadas do tabuleiro em coordenadas no bitmap
# Argumentos:
#	a0 e a1: X e Y no tabuleiro da memoria
# Retornos:
#	a0 e a1: novos X e Y no tabuleiro representado na tela

desenha.map: li t0, 1
	li t1, 2
	li t2, 3
	li t3, 4
	li t4, 5
	li t5, 6
	li t6, 7			# carregando valores para comparacoes
	
	beq a1, zero, map.y0
	beq a1, t0, map.y1
	beq a1, t1, map.y2
	beq a1, t2, map.y3
	beq a1, t3, map.y4
	beq a1, t4, map.y5
	beq a1, t5, map.y6
	beq a1, t6, map.y7		# Y vale um desses

	map.y0:	li a1, 19		# o Y retornado sera 19
		beq a0, zero, map.0x0	# agora testamos os valores possiveis de X
		beq a0, t0, map.1x0
		beq a0, t1, map.2x0
		beq a0, t2, map.3x0
		beq a0, t3, map.4x0
		beq a0, t4, map.5x0
		beq a0, t5, map.6x0
		beq a0, t6, map.7x0
		map.0x0: li a0, 49
			j desenha.map.fim
		map.1x0: li a0, 77
			j desenha.map.fim
		map.2x0: li a0, 106
			j desenha.map.fim
		map.3x0: li a0, 134
			j desenha.map.fim
		map.4x0: li a0, 163
			j desenha.map.fim
		map.5x0: li a0, 192
			j desenha.map.fim
		map.6x0: li a0, 221
			j desenha.map.fim
		map.7x0: li a0, 249
			j desenha.map.fim
	
	map.y1:	li a1, 34
		beq a0, zero, map.0x1
		beq a0, t0, map.1x1
		beq a0, t1, map.2x1
		beq a0, t2, map.3x1
		beq a0, t3, map.4x1
		beq a0, t4, map.5x1
		beq a0, t5, map.6x1
		beq a0, t6, map.7x1
		map.0x1: li a0, 44
			j desenha.map.fim
		map.1x1: li a0, 74
			j desenha.map.fim
		map.2x1: li a0, 104
			j desenha.map.fim
		map.3x1: li a0, 134
			j desenha.map.fim
		map.4x1: li a0, 163
			j desenha.map.fim
		map.5x1: li a0, 194
			j desenha.map.fim
		map.6x1: li a0, 223
			j desenha.map.fim
		map.7x1: li a0, 253
			j desenha.map.fim
	
	map.y2:	li a1, 49
		beq a0, zero, map.0x2
		beq a0, t0, map.1x2
		beq a0, t1, map.2x2
		beq a0, t2, map.3x2
		beq a0, t3, map.4x2
		beq a0, t4, map.5x2
		beq a0, t5, map.6x2
		beq a0, t6, map.7x2
		map.0x2: li a0, 40
			j desenha.map.fim
		map.1x2: li a0, 71
			j desenha.map.fim
		map.2x2: li a0, 102
			j desenha.map.fim
		map.3x2: li a0, 133
			j desenha.map.fim
		map.4x2: li a0, 164
			j desenha.map.fim
		map.5x2: li a0, 195
			j desenha.map.fim
		map.6x2: li a0, 226
			j desenha.map.fim
		map.7x2: li a0, 257
			j desenha.map.fim

	map.y3:	li a1, 66
		beq a0, zero, map.0x3
		beq a0, t0, map.1x3
		beq a0, t1, map.2x3
		beq a0, t2, map.3x3
		beq a0, t3, map.4x3
		beq a0, t4, map.5x3
		beq a0, t5, map.6x3
		beq a0, t6, map.7x3
		map.0x3: li a0, 36
			j desenha.map.fim
		map.1x3: li a0, 68
			j desenha.map.fim
		map.2x3: li a0, 100
			j desenha.map.fim
		map.3x3: li a0, 133
			j desenha.map.fim
		map.4x3: li a0, 164
			j desenha.map.fim
		map.5x3: li a0, 197
			j desenha.map.fim
		map.6x3: li a0, 229
			j desenha.map.fim
		map.7x3: li a0, 261
			j desenha.map.fim

	map.y4:	li a1, 84
		beq a0, zero, map.0x4
		beq a0, t0, map.1x4
		beq a0, t1, map.2x4
		beq a0, t2, map.3x4
		beq a0, t3, map.4x4
		beq a0, t4, map.5x4
		beq a0, t5, map.6x4
		beq a0, t6, map.7x4
		map.0x4: li a0, 31
			j desenha.map.fim
		map.1x4: li a0, 65
			j desenha.map.fim
		map.2x4: li a0, 98
			j desenha.map.fim
		map.3x4: li a0, 132
			j desenha.map.fim
		map.4x4: li a0, 165
			j desenha.map.fim
		map.5x4: li a0, 199
			j desenha.map.fim
		map.6x4: li a0, 232
			j desenha.map.fim
		map.7x4: li a0, 266
			j desenha.map.fim

	map.y5:	li a1, 103
		beq a0, zero, map.0x5
		beq a0, t0, map.1x5
		beq a0, t1, map.2x5
		beq a0, t2, map.3x5
		beq a0, t3, map.4x5
		beq a0, t4, map.5x5
		beq a0, t5, map.6x5
		beq a0, t6, map.7x5
		map.0x5: li a0, 26
			j desenha.map.fim
		map.1x5: li a0, 61
			j desenha.map.fim
		map.2x5: li a0, 96
			j desenha.map.fim
		map.3x5: li a0, 131
			j desenha.map.fim
		map.4x5: li a0, 166
			j desenha.map.fim
		map.5x5: li a0, 201
			j desenha.map.fim
		map.6x5: li a0, 236
			j desenha.map.fim
		map.7x5: li a0, 271
			j desenha.map.fim
	
	map.y6: li a1, 125
		beq a0, zero, map.0x6
		beq a0, t0, map.1x6
		beq a0, t1, map.2x6
		beq a0, t2, map.3x6
		beq a0, t3, map.4x6
		beq a0, t4, map.5x6
		beq a0, t5, map.6x6
		beq a0, t6, map.7x6
		map.0x6: li a0, 20
			j desenha.map.fim
		map.1x6: li a0, 56
			j desenha.map.fim
		map.2x6: li a0, 93
			j desenha.map.fim
		map.3x6: li a0, 130
			j desenha.map.fim
		map.4x6: li a0, 167
			j desenha.map.fim
		map.5x6: li a0, 203
			j desenha.map.fim
		map.6x6: li a0, 240
			j desenha.map.fim
		map.7x6: li a0, 276
			j desenha.map.fim

	map.y7:	li a1, 149
		beq a0, zero, map.0x7
		beq a0, t0, map.1x7
		beq a0, t1, map.2x7
		beq a0, t2, map.3x7
		beq a0, t3, map.4x7
		beq a0, t4, map.5x7
		beq a0, t5, map.6x7
		beq a0, t6, map.7x7
		map.0x7: li a0, 12
			j desenha.map.fim
		map.1x7: li a0, 50
			j desenha.map.fim
		map.2x7: li a0, 90
			j desenha.map.fim
		map.3x7: li a0, 128
			j desenha.map.fim
		map.4x7: li a0, 168
			j desenha.map.fim
		map.5x7: li a0, 205
			j desenha.map.fim
		map.6x7: li a0, 245
			j desenha.map.fim
		map.7x7: li a0, 283
	
	desenha.map.fim: ret
	
