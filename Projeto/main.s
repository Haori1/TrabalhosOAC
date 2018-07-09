.include "eqv.s"

.data

#Atencao: Adicionar campo para indicar se a peca eh uma dama ou nao, mesmo se por ventura nao formos iplementar
#nao adicionar este campo imposibilitaria-nos de implementar caso decidir-mos

# DADOS DAS PEDRAS
# com as coordenadas iniciais no tabuleiro e cores que podem mudar antes do inicio das partidas
# player sempre na parte de baixo da tela
#			X	Y	cor	viva ou nao
Pedra_PL_1: .byte	0,	5,	WHITE,	1
Pedra_PL_2: .byte	2,	5,	WHITE,	1
Pedra_PL_3: .byte	4,	5,	WHITE,	1
Pedra_PL_4: .byte	6,	5,	WHITE,	1
Pedra_PL_5: .byte	1,	6,	WHITE,	1
Pedra_PL_6: .byte	3,	6,	WHITE,	1
Pedra_PL_7: .byte	5,	6,	WHITE,	1
Pedra_PL_8: .byte	7,	6,	WHITE,	1
Pedra_PL_9: .byte	0,	7,	WHITE,	1
Pedra_PL_10: .byte	2,	7,	WHITE, 	1
Pedra_PL_11: .byte	4,	7,	WHITE, 	1
Pedra_PL_12: .byte	6,	7,	WHITE,	1

Pedra_CPU_1: .byte	1,	0,	BLACK,	1
Pedra_CPU_2: .byte	3,	0,	BLACK,	1
Pedra_CPU_3: .byte	5,	0,	BLACK,	1
Pedra_CPU_4: .byte	7,	0,	BLACK,	1
Pedra_CPU_5: .byte	0,	1,	BLACK,	1
Pedra_CPU_6: .byte	2,	1,	BLACK,	1
Pedra_CPU_7: .byte	4,	1,	BLACK,	1
Pedra_CPU_8: .byte	6,	1,	BLACK,	1
Pedra_CPU_9: .byte	1,	2,	BLACK,	1
Pedra_CPU_10: .byte	3,	2,	BLACK,	1
Pedra_CPU_11: .byte	5,	2,	BLACK,	1
Pedra_CPU_12: .byte	7,	2,	BLACK,	1

# CORES ARMAZENADAS
Cor_PL:		.byte 0
Cor_CPU:	.byte 0
Cor_cursor:	.byte 0x07
#######################################################

# VETOR DE PEDRAS APAGADAS
# sempre atualizado apos a finalizaçao de uma jogada
# cada word é o endereco da pedra apagada
# serve para o desenhaTabuleiro saber quais pecas tem que apagar e para atribuir pontos
Pedras_apagadas: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0		# 12 posicoes pois eh o maximo de pedras que podem ser apagadas de uma vez

.include "imagens.s"
.include "musicas.s"

.text

# USO DOS REGISTRADORES SALVOS
# s0: nível de dificuldade escolhido
# s1: pontos do player (pedras adversarias engolidas)
# s2: pontos da cpu
# s3: ultima coordenada x escolhida pra jogada do player
# s4: ultima coordenada y escolhida pra jogada do player
li s0, 0
li s1, 0
li s2, 0
li s3, 0
li s4, 0				# zerando-se todos eles

la a0, IMG_MENU
li a1, 320
li a2, 240
li a3, 0
li a4, 0
jal imprimeImagem			# imprime o menu
jal menuMusica			# pressione qualquer tecla

li a0, WHITE_WORD
jal clearScreen				# limpa a tela com branco

# IMPRIME TELA SELECAO DE NIVEL
jal selecionaNivel
mv s0, a0				# a0: nivel escolhido
# IMPRIME TELA SELECAO DE CORES
#jal selecionaCores

jal montaTabuleiro

la a0, IMG_TABULEIRO
li a1, 320
li a2, 160
li a3, 0
li a4, 15
jal imprimeImagem			# imprime tabuleiro
jal desenhaTela.ini			# imprime todas as pedras

jal loopPrincipal

li a7, 10
ecall
##################################################################################################################


#Este sera o loop principal em que o jogo ira ocorrer
loopPrincipal: addi sp, sp, -4
	sw ra, 0(sp)
	
	#argumentos de saida:
	#a0 = nivel selecionado
	#jal abertura		# por que isso ta no loop gabriel?
	
	#Talvez faca-se necessario salvar a0 antes de pular para as proximas funcoe


	# Argumentos:
	# a0: endereco da pedra escolhida
	# Retornos: (sera usado pelo desenhaTabuleiro)
	# a0: endereco da pedra, ja com X e Y atualizados
	# a1: antigo X da pedra
	# a2: antigo Y da pedra - X e Y como casas do tabuleiro
	# Pedras_apagadas: vetor com os endereco das pedras apagadas
	jal jogadaPL
	
	
	# Argumentos: retornos do jogadaPL
	#la a0, Pedra_CPU_2
	#li a1, 0
	#li a2, 1
	#li t3, 1
	#li t4, 2
	#sb t3, 0(a0)
	#sb t4, 1(a0)
	#jal desenhaTela
	
	#Argumentos de entrada:
	#a1 = nivel escolhido para jogar
	mv a1, s0
	la t1, Pedra_PL_1
	li t3, BOARD_ADDRESS
	li t0, 4
	sb t0, 0(t1)
	li t0, 3
	sb t0, 1(t1)
	sw t1, 112(t3)
	jal jogadaPC 
	
	#ebreak
	la a0, IMG_TABULEIRO
	li a1, 320
	li a2, 160
	li a3, 0
	li a4, 15
	jal imprimeImagem			# imprime tabuleiro	
	jal desenhaTela.ini 	# argumentos: retornos do jogadaPC
	
	ebreak
	
	j loopPrincipal
	
	lw ra, 0(sp)
	addi sp, sp, 4
	ret
######################################################################################################


# montaTabuleiro ######################################
# faz a distribuicao inicial das pecas no tabuleiro principal

montaTabuleiro: li t0, BOARD_ADDRESS	# endereco do tabuleiro
	la t1, Pedra_CPU_1
	
	# offsets em relacao ao endereco base (t0), ou seja, a coordenada (0, 0)
	# t1 percorre de 4 em 4 pois as words estao proximas umas das outras na memoria
	
	sw t1, 4(t0)		# pedra_cpu_1 nas coordenadas (1, 0)
	addi t1, t1, 4		
	sw t1, 12(t0)		# pedra_cpu_2 nas coordenadas (3, 0)
	addi t1, t1, 4		
	sw t1, 20(t0)		# pedra_cpu_3 nas coordenadas (5, 0)
	addi t1, t1, 4	
	sw t1, 28(t0)		# pedra_cpu_4 nas coordenadas (7, 0)
	addi t1, t1, 4		
	sw t1, 32(t0)		# pedra_cpu_5 nas coordenadas (0, 1)
	addi t1, t1, 4
	sw t1, 40(t0)		# pedra_cpu_6 nas coordenadas (2, 1)
	addi t1, t1, 4
	sw t1, 48(t0)		# pedra_cpu_7 nas coordenadas (4, 1)
	addi t1, t1, 4
	sw t1, 56(t0)		# pedra_cpu_8 nas coordenadas (6, 1)
	addi t1, t1, 4
	sw t1, 68(t0)		# pedra_cpu_9 nas coordenadas (1, 2)
	addi t1, t1, 4
	sw t1, 76(t0)		# pedra_cpu_10 nas coordenadas (3, 2)
	addi t1, t1, 4
	sw t1, 84(t0)		# pedra_cpu_11 nas coordenadas (5, 2)
	addi t1, t1, 4
	sw t1, 92(t0)		# pedra_cpu_12 nas coordenadas (7, 2)
	
	addi t0, t0, 160
	la t1, Pedra_PL_1
	
	# offsets em relacao ao ponto (0, 5)
	sw t1, 0(t0)		# pedra_pl_1 nas coordenadas (0, 5)
	addi t1, t1, 4
	sw t1, 8(t0)		# pedra_pl_2 nas coordenadas (2, 5)
	addi t1, t1, 4
	sw t1, 16(t0)		# pedra_pl_3 nas coordenadas (4, 5)
	addi t1, t1, 4
	sw t1, 24(t0)		# pedra_pl_4 nas coordenadas (6, 5)
	addi t1, t1, 4
	sw t1, 36(t0)		# pedra_pl_5 nas coordenadas (1, 6)
	addi t1, t1, 4
	sw t1, 44(t0)		# pedra_pl_6 nas coordenadas (3, 6)
	addi t1, t1, 4
	sw t1, 52(t0)
	addi t1, t1, 4
	sw t1, 60(t0)
	addi t1, t1, 4
	sw t1, 64(t0)
	addi t1, t1, 4
	sw t1, 72(t0)
	addi t1, t1, 4
	sw t1, 80(t0)
	addi t1, t1, 4
	sw t1, 88(t0)
	
	ret
#####################################################################################################

	
#Permite ao player transitar entre as pecas, escolher uma jogada viavel, ou parar o jogo (sair).
jogadaPL:

	ret

#refere-se totalmente a inteligencia artificial que determinara as jogadas do computador, com os dados niveis 
jogadaPC: addi sp, sp, -36
	sw ra, 0(sp)
	sw s4, 4(sp)
	sw s5, 8(sp)
	sw s6, 12(sp)
	sw s7, 16(sp)
	sw s8, 20(sp)
	sw s9, 24(sp)
	sw s10, 28(sp)
	sw s11, 32(sp)
	#a1 = 1 ---> Nivel 1
	#a1 = 2 ---> Nivel 2
		
	li t0, BOARD_ADDRESS	# endereco do tabuleiro
	addi t0, t0, 4
	li s10, 0  #Valor inicial do registrador com o endereco de origem da melhor jogada 
	li s9, 0   #Valor inicial do registrador com o peso da jogada
	li s8, 0   #Valor inicial do registrador com o endereço de destino da melhor joagada
	li s7, 0   #Valor inicial do registrador que indica a diagonal para a qual a jogada será realizada
	li s6, 0   #Valor booleano que indica se peca inimiga foi ou nao apagada
	li s5, 0   #Valor inicial do registrador com o peso da ultima jogada em que uma peca foi comida
	li s4, 0   #Valor inicial do registrador com o endereco da pedra que foi apagada ---> talvez seja melhor fazer no loop
	li t5, 0   #Contador para determinar quando somar ou nao valores relativos a posicao no tabuleiro
	
	#as jogadas subsequentes estao nas casas 28(diagonal esquerda) ou 36 (diagonal direita) a frente na memoria
	
	li t1, 1 
	bne a1, t1, nivel2 #checa se eh o nivel 1
	
	nivel1:
		#No tabuleiro acresce-se de 8 em 8 normalmente
		#em toda jogada multipla de 4, soma-se apenas 4
		#em toda jogada multipla de 8, soma-se 12
		
		lw t1, 0(t0) #loga a posicao atual do tabuleiro
		
		beq t1, zero, continue #Salta as comparacoes se nao tiver peca nesta posicao do tabuleiro
		
		lbu t2, 2(t1) #loga a cor da peca
		li t3, WHITE
		
		beq t2, t3, continue #Salta as comparacoes se a peca existente for do jogador
		
		lb t2, 0(t1) #carrega X
		li t3, 0
		
		beq t2, t3, jogadaEm0 #caso seja uma jogada em coordenada X 0, pula para realizar somente a verificacao a direita
		
		addi t4, t0, 28 #carrega a posicao da diagonal esquerda
		lw s11, 0(t4) 
		
		bne s11, zero, diagonalEsqCheia #indica que ha peca na diagonal esquerda (pode ser possivel come-la)
		
		li a7, 41
		li a0, 3
		ecall #gera numero aleatorio
	
		add t6, zero, a0 #Salva o numero aleatorio no registrador marcador da jogada
		
		bltu t6, s9, jogadaNaoMelhorEsq #Compara a pontuacao entre as jogadas
		
		mv s10, t0  #Salva a posicao de origem da melhor jogada atual
		mv s9, t6   #Salva a pontuacao da melhor jogada atual
		mv s8, t4   #Salva o endereco da diagonal destino
		addi s7, zero, 28 #salva de qual diagonal se trata 
		
		j jogadaNaoMelhorEsq
					
		diagonalEsqCheia: #Aqui deve-se descobrir se pode-se comer a peca
			
			lbu t2, 2(s11) #carrega a cor da peca 
			li t3, BLACK
			 
			beq t2, t3, diagonalComAliadoEsq #checa se a peca presente na diagonal eh aliada ou nao
							  #pois caso for nao eh uma jogada valida
			
			lb t2, 0(s11)
			li t3, 0
			beq t2, t3, diagonalLimiteEsq
			
			li a7, 41
			li a0, 3
			ecall #gera numero aleatorio
			
			bltu a0, s5, comeEsqDescartada 
			
			addi t4, t4, 28 #itera para a posicao destino da peca da cpu, caso ocorra o movimento
			
			lw t3, 0(t4) #carrega do tabuleiro as informacoes acerca de pecas na posicao destino
			
			bne t3, zero, naoVazioEsq #Caso nao esteja vazio, o movimento nao pode ser realizado
			
			li t6, COME_PECA #loga o valor maximo de 32 bits para determinar que uma peca deve ser comida
			mv s10, t0  #Salva a origem da jogada atual
			mv s9, t6   #Salva a pontuacao da jogada atual
			mv s8, t4   #Salva o destino da jogada atual
			addi s7, zero, 28 #Salva a diagonal da jogada atual 
			addi s6, zero, 1 #Registra se alguma peca foi ou nao comida 
			mv s5, a0 #Salva peso da jogada
			mv s4, s11 #Salva endereco da peca apagada
			li t3, -1
			sb t1, 0(s11)
			sb t1, 1(s11)
			
			diagonalComAliadoEsq:
			
			diagonalLimiteEsq:
			
			comeEsqDescartada:
			
			naoVazioEsq: 				  
		
		jogadaNaoMelhorEsq:	 
		
		jogadaEm0:
		
		lb t2, 0(t1) #carrega X
		li t3, 7
		
		beq t2, t3, jogadaEm7 #caso seja uma jogada em coordenada X 7, pula a comparacao a esquerda, pois nao existe
		
		addi t4, t0, 36 #carrega a posicao da diagonal direita
		lw s11, 0(t4) 
	
		bne s11, zero, diagonalDirCheia
	
		li a7, 41
		li a0, 3
		ecall #gera numero aleatorio
		
		add t6, zero, a0 #Salva o numero aleatorio no registrador marcador da jogada
		
		bltu t6, s9, jogadaNaoMelhorDir  #Compara a pontuacao entre as jogadas
		
		mv s10, t0  #Salva a posicao de origem da melhor jogada atual
		mv s9, t6   #Salva a pontuacao da melhor jogada atual
		mv s8, t4   #Salva o endereco da diagonal destino
		addi s7, zero, 36 #salva de qual diagonal se trata 
		
		j jogadaNaoMelhorDir
		
		diagonalDirCheia:
		
			lbu t2, 2(s11) #carrega a cor da peca 
			li t3, BLACK
			 
			beq t2, t3, diagonalComAliadoDir #checa se a peca presente na diagonal eh aliada ou nao
			
			lb t2, 0(s11)
			li t3, 7
			beq t2, t3, diagonalLimiteDir
			
			li a7, 41
			li a0, 3
			ecall #gera numero aleatorio
			
			bltu a0, s5, comeDirDescartada 
			
			addi t4, t4, 36 #itera para a posicao destino da peca da cpu, caso ocorra o movimento
			
			lw t3, 0(t4) #carrega do tabuleiro as informacoes acerca de pecas na posicao destino
			
			bne t3, zero, naoVazioDir #Caso nao esteja vazio, o movimento nao pode ser realizado
			
			li t6, COME_PECA #loga o valor maximo em 32 bits para determinar que uma peca deve ser comida
			mv s10, t0  #Salva a origem da jogada atual
			mv s9, t6   #Salva a pontuacao da jogada atual
			mv s8, t4   #Salva o destino da jogada atual
			addi s7, zero, 36 #Salva a diagonal da jogada atual 
			addi s6, zero, 1 #Registra que uma peca foi comida 
			mv s5, a0   #Salva peso da jogada em que a peca foi comida
			mv s4, s11 #Salva endereco da peca apagada
			li t3, -1
			sb t1, 0(s11)
			sb t1, 1(s11)
			
			diagonalComAliadoDir:
			
			diagonalLimiteDir:
			
			comeDirDescartada:
			
			naoVazioDir: 
			
			
		jogadaNaoMelhorDir:
		
		jogadaEm7:
		
		continue:
				
		addi t5, t5, 1 #itera em um o contador
		
		li t2, 32 #loga o valor maximo possivel do contador (numero de espacos disponiveis no tabuleiro)
		beq t5, t2, saidaLoopNivel1 #caso todo o tabuleiro tenha sido percorrido, sai da funcao
		
		li t2, 1
		beq t5, zero, primeiraIteracao 
		
		li t1, 8
		rem t1, t5, t1
		
		beq t1, zero, somaDoze #sequencia que checa se estamos no caso de somar 12
					#Deve sempre ser anterior ao rem de 4, devido as propriedades da divisao
		
		li t1, 4
		rem t1, t5, t1
		beq t1, zero, somaQuatro #sequencia que checa se estamos no caso de somar 4
		
		primeiraIteracao:
		
		addi t0, t0, 8 #posiciona o ponteiro para a proxima posicao do tabuleiro
		j saidaIterador
		#lb t2, 0(t1) #carrega X
		#lb t3, 1(t1) #carrega Y
		
		somaQuatro:
			addi t0, t0, 4  #posiciona o ponteiro para a proxima posicao do tabuleiro
			j saidaIterador #jump necessario para nao passar por somaDoze
		
		somaDoze:
			addi t0, t0, 12  #posiciona o ponteiro para a proxima posicao do tabuleiro
	
		saidaIterador:

		j nivel1 
		
		saidaLoopNivel1:
		#ebreak
		
		#Retorna os parametros para a funcao
		# a0: endereco da pedra, ja com X e Y atualizados
    		# a1: antigo X da pedra
    		# a2: antigo Y da pedra - X e Y como casas do tabuleiro
    		# Pedras_apagadas: vetor com os endereco das pedras apagadas
    		
		li t2, 28
		bne t2, s7, jogadaParaDireita #Checa se a jogada sera para a direita 
		
		li t2, 0
		bne s6, t2, pecaComidaEsq #Checa se na jogada para a esquerda, uma peca foi comida
		
		lw t2, 0(s10) #Carrega o ponteiro para os dados em memoria
		
		li t3, 0
		sw t3, 0(s10)
		sw t2, 0(s8)
		
		lb t3, 0(t2) #carrega a coordenada X
		
		mv a1, t3 #salva valor do antigo X no registrador de retorno
		
		addi t3, t3, -1 #Atualiza a coordenada X um a esquerda
		sb t3, 0(t2) #salva o novo valor na memória
		
		lb t3, 1(t2) #carrega a coordenada Y
		
		mv a2, t3 #salva valor do antigo Y no registrador de retorno
		
		addi t3, t3, 1 #atualiza a coordenada Y um abaixo
		sb t3, 1(t2) #salva o novo valor na memoria
		
		mv a0, t2 #salva o endereco da peca na memoria
		
		j fimJogadaParaEsq
		
		pecaComidaEsq:
			
			lw t2, 0(s10) #Carrega o ponteiro para os dados em memoria
			
			li t3, 0
			sw t3, 0(s10)
			sw t2, 0(s8)
		
			lb t3, 0(t2) #carrega a coordenada X
		
			mv a1, t3 #salva valor do antigo X no registrador de retorno
			
			addi t3, t3, -2 #Atualiza a coordenada X dois a esquerda
			sb t3, 0(t2) #salva o novo valor na memória
		
			lb t3, 1(t2) #carrega a coordenada Y
		
			mv a2, t3 #salva valor do antigo Y no registrador de retorno
		
			addi t3, t3, 2 #atualiza a coordenada Y dois abaixo
			sb t3, 1(t2) #salva o novo valor na memória
		
			mv a0, t2 #salva o endereco da peca na memoria
			
			la t4, Pedras_apagadas #carrega o endereco do vetor de pedras apagadas
			
			posPedraApagadaNaoVaziaEsq:
			
			lw t3, 0(t4) #loga o valor na posicao do vetor de pedras apagas guardada em t4
			addi t4, t4, 4 #itera para a proxima posicao
			
			bne t3, zero, posPedraApagadaNaoVaziaEsq #caso nao seja zero, salta buscando a proxima posicao vazia
			
			sw s4, 0(t4) #salva o valor da pedra apagada em posicao vazia do vetor
			
			j fimJogadaParaEsq
			
		
		jogadaParaDireita:
		
		li t2, 0
		bne s6, t2, pecaComidaDir #Checa se na jogada para a direita, uma peca foi comida
		
		lw t2, 0(s10) #Carrega o ponteiro para os dados em memoria
		
		li t3, 0
		sw t3, 0(s10)
		sw t2, 0(s8)
		
		lb t3, 0(t2) #carrega a coordenada X
		
		#ebreak
		
		mv a1, t3 #salva valor do antigo X no registrador de retorno
		
		addi t3, t3, 1 #Atualiza a coordenada X um a direita
		sb t3, 0(t2) #salva o novo valor na memória
		
		lb t3, 1(t2) #carrega a coordenada Y
		
		mv a2, t3 #salva valor do antigo Y no registrador de retorno
		
		addi t3, t3, 1 #atualiza a coordenada Y um abaixo
		sb t3, 1(t2) #salva o novo valor na memória
		
		mv a0, t2
		
		j fimJogadaParaDir
		
		pecaComidaDir:
		
			lw t2, 0(s10) #Carrega o ponteiro para os dados em memoria		
		
			li t3, 0
			sw t3, 0(s10)
			sw t2, 0(s8)
		
			lb t3, 0(t2) #carrega a coordenada X
		
			mv a1, t3 #salva valor do antigo X no registrador de retorno
			
			addi t3, t3, 2 #Atualiza a coordenada X dois a direita
			sb t3, 0(t2) #salva o novo valor na memória
		
			lb t3, 1(t2) #carrega a coordenada Y
		
			mv a2, t3 #salva valor do antigo Y no registrador de retorno
		
			addi t3, t3, 2 #atualiza a coordenada Y dois abaixo
			sb t3, 1(t2) #salva o novo valor na memória
		
			mv a0, t2 #salva o endereco da peca na memoria
			
			la t4, Pedras_apagadas #carrega o endereco do vetor de pedras apagadas
			
			posPedraApagadaNaoVaziaDir:
			
			lw t3, 0(t4) #loga o valor na posicao do vetor de pedras apagas guardada em t4
			addi t4, t4, 4 #itera para a proxima posicao
			
			bne t3, zero, posPedraApagadaNaoVaziaDir #caso nao seja zero, salta buscando a proxima posicao vazia
			
			sw s4, 0(t4) #salva o valor da pedra apagada em posicao vazia do vetor
		
		fimJogadaParaEsq:
		
		fimJogadaParaDir:
		
			j saidaJogadaPC
		
	nivel2:
		
	saidaJogadaPC:
	
	#ebreak
	
	lw ra, 0(sp)
	lw s4, 4(sp)
	lw s5, 8(sp)
	lw s6, 12(sp)
	lw s7, 16(sp)
	lw s8, 20(sp)
	lw s9, 24(sp)
	lw s10, 28(sp)
	lw s11, 32(sp)
	addi sp, sp, 36

	ret

#Sera responsavel por desenhar o estado do tabuleiro no momento em que foi chamada
desenhaTabuleiro:

	ret
	
.include "bitmap.s"
.include "outros.s"
