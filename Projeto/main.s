.include "eqv.s"
.include "imagens.s"
.include "musicas.s"

.data

#Atencao: Adicionar campo para indicar se a peca eh uma dama ou nao, mesmo se por ventura nao formos iplementar
#nao adicionar este campo imposibilitaria-nos de implementar caso decidir-mos

# DADOS DAS PEDRAS ##################################################
# com as coordenadas iniciais no tabuleiro e cores que podem mudar antes do inicio das partidas
# player sempre na parte de baixo da tela
#			X	Y	cor	viva ou nao
pedra_pl_1: .byte	0,	5,	WHITE,	1
pedra_pl_2: .byte	2,	5,	WHITE,	1
pedra_pl_3: .byte	4,	5,	WHITE,	1
pedra_pl_4: .byte	6,	5,	WHITE,	1
pedra_pl_5: .byte	1,	6,	WHITE,	1
pedra_pl_6: .byte	3,	6,	WHITE,	1
pedra_pl_7: .byte	5,	6,	WHITE,	1
pedra_pl_8: .byte	7,	6,	WHITE,	1
pedra_pl_9: .byte	0,	7,	WHITE,	1
pedra_pl_10: .byte	2,	7,	WHITE, 	1
pedra_pl_11: .byte	4,	7,	WHITE, 	1
pedra_pl_12: .byte	6,	7,	WHITE,	1

pedra_cpu_1: .byte	1,	0,	BLACK,	1
pedra_cpu_2: .byte	3,	0,	BLACK,	1
pedra_cpu_3: .byte	5,	0,	BLACK,	1
pedra_cpu_4: .byte	7,	0,	BLACK,	1
pedra_cpu_5: .byte	0,	1,	BLACK,	1
pedra_cpu_6: .byte	2,	1,	BLACK,	1
pedra_cpu_7: .byte	4,	1,	BLACK,	1
pedra_cpu_8: .byte	6,	1,	BLACK,	1
pedra_cpu_9: .byte	1,	2,	BLACK,	1
pedra_cpu_10: .byte	3,	2,	BLACK,	1
pedra_cpu_11: .byte	5,	2,	BLACK,	1
pedra_cpu_12: .byte	7,	2,	BLACK,	1
#######################################################

# VETOR DE PEDRAS APAGADAS
# sempre atualizado apos a finalizaçao de uma jogada
# cada word é o endereco da pedra apagada
# serve para o desenhaTabuleiro saber quais pecas tem que apagar e para atribuir pontos
pedras_apagadas: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0		# 12 posicoes pois eh o maximo de pedras que podem ser apagadas de uma vez



.text

# USO DOS REGISTRADORES SALVOS
# s0: nível de dificuldade escolhido
# s1: pontos do player (pedras adversarias engolidas)
# s2: pontos da cpu
# s3: ultima coordenada x escolhida pra jogada do player
# s4: ultima coordenada y escolhida pra jogada do player


jal montaTabuleiro
jal jogadaPC

li a7, 10
ecall

#######################################################
# montaTabuleiro ######################################
# faz a distribuicao inicial das pecas no tabuleiro principal

montaTabuleiro: li t0, BOARD_ADDRESS	# endereco do tabuleiro
	la t1, pedra_cpu_1
	
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
	la t1, pedra_pl_1
	
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


#Este sera o loop principal em que o jogo ira ocorrer
loopPrincipal: addi sp, sp, -4
	sw ra, 0(sp)
	
	#argumentos de saida:
	#a0 = nivel selecionado
	#jal abertura		# por que isso ta no loop gabriel?
	
	#Talvez faca-se necessario salvar a0 antes de pular para as proximas funcoes
	
	mv a0, s1
	mv a1, s2
	# Argumentos:
	# a0: coordenada X escolhida no ultimo loop
	# a1: coordenada Y escolhida no ultimo loop
	# Retornos:
	# a0: endereco da pedra escolhida
	jal escolhePedraPL

	lb a1, 0(a0)
	lb a2, 1(a0)
	# Argumentos:
	# a1: coordenada X da ultima peca selecionada
	# a2: coordenada Y da ultima peca selecionada 
	
	# Retornos: (sera usado pelo desenhaTabuleiro)
	# a0: posicao antiga da pedra
	# a1: nova posicao da pedra
	# pecas_apagadas (memoria): vetor de pecas apagadas
	# a2: quantidade de pecas apagadas (pontos pro cpu ou pro player)  
	jal jogadaPL
	
	#Argumentos de entrada:
	#Estado atual do tabuleiro
	
	#Argumentos de saida:
	#a0 = coordenada X da ultima peca selecionada
	#a1 = coordenada Y da ultima peca selecionada 
	jal desenhaTabuleiro 
	
	#Argumentos de entrada:
	#a1 = nivel escolhido para jogar
	jal jogadaPC #Existe a possibilidade de criar uma funcao para cada nivel, mas ao momento, acredito que a melhor opcao
			#seja somente uma funcao.
	
	#Jah definido acima
	jal desenhaTabuleiro
	
	j loopPrincipal
	
	lw ra, 0(sp)
	addi sp, sp, 4
	ret 
	

#Aqui uma sugestao referente a aonde em codigo colocar a tela de abertura, esta funcao devera retornar o nivel da IA
abertura:

	ret

escolhePedraPL:
	
	ret
	
#Permite ao player transitar entre as pecas, escolher uma jogada viavel, ou parar o jogo (sair).
jogadaPL:

	ret

#refere-se totalmente a inteligencia artificial que determinara as jogadas do computador, com os dados niveis 
jogadaPC:
	#a1 = 1 ---> Nivel 1
	#a1 = 2 ---> Nivel 2
		
	li t0, BOARD_ADDRESS	# endereco do tabuleiro
	addi t0, t0, 4 
	li t6, 0   #Valor inicial do registrador com o peso da jogada
	li t5, 0   #Contador para determinar quando somar ou nao valores relativos a posicao no tabuleiro
	
	#as jogadas subsequentes estao nas casas 28 ou 36 a frente na memoria
	
	li t1, 1 
	bne a1, t1, nivel2 #checa se eh o nivel 1
	
	nivel1:
		#No tabuleiro acresce-se de 8 em 8 normalmente
		#em toda jogada multipla de 4, soma-se apenas 4
		#em toda jogada multipla de 8, soma-se 12
		
		li t1, 8
		rem t1, t5, t1
		beq t1, zero, somaDoze #sequencia que checa se estamos no caso de somar 12
					#Deve sempre ser anterior ao rem de 4, devido as propriedades da divisao
		
		li t1, 4
		rem t1, t5, t1
		beq t1, zero, somaQuatro #sequencia que checa se estamos no caso de somar 4
		
		lw t1, 0(t0) #loga a proxima posicao do tabuleiro
		addi t0, t0, 8 #posiciona o ponteiro para a proxima posicao do tabuleiro
		#lb t2, 0(t1) #carrega X
		#lb t3, 1(t1) #carrega Y
		
		somaQuatro:
			lw t1, 0(t0)
			addi t0, t0, 4  #posiciona o ponteiro para a proxima posicao do tabuleiro
			j saidaQuatro #jump necessario para nao passar por somaDoze
		
		somaDoze:
			lw t1, 0(t0) #loga a proxima posicao do tabuleiro
			addi t0, t0, 12  #posiciona o ponteiro para a proxima posicao do tabuleiro
	
		saidaQuatro:
		
		beq t1, zero, continue #Salta as comparacoes se nao tiver peca nesta posicao do tabuleiro
		
		lb t2, 3(t1) #loga a cor da peca
		li t3, WHITE
		
		beq t2, t3, continue #Salta as comparacoes se a peca existente for do jogador
		
		#lb t2, 0(t1) #carrega X
		#li t3, 0
		
		#beq t2, t3, jogadaEm0 #caso seja uma jogada em coordenada X 0, pula para seu tratamento especial
		
		addi t4, t0, 28 #carrega a posicao da diagonal esquerda
		lw s11, 0(t4) 
		
		bne s11, zero, diagonalEsqCheia
		
		li a7, 41
		li a0, 3
		ecall #gera numero aleatorio
	
		# li t4, 1, pontuacao exemplo para o caso nao aleatorio
		add t6, t6, a0 #FAZER A COMPARACAO JA AQUI, COM OS PESOS referente a se a jogada é mais pesada ou n, e guardar
		                #no registrador marcador de jogada.
	
		diagonalEsqCheia: #Aqui deve-se descobrir se pode-se comer a peca 
	
		addi t4, t0, 36 #carrega a posicao da diagonal direita
		lw s11, 0(t4) 
	
		bne s11, zero, diagonalDirCheia
	
		li a7, 41
		li a0, 3
		ecall #gera numero aleatorio
		
		add t6, t6, a0 
		
		diagonalDirCheia:
		
		continue:
		
		addi t5, t5, 1 #itera em um o contador
		
		li t2, 32 #loga o valor maximo possivel do contador (numero de espacos disponiveis no tabuleiro)
		beq t5, t2, saidaJogadaPC #caso todo o tabuleiro tenha sido percorrido, sai da funcao
		
		j nivel1 
	nivel2:
	
		li a7, 1
		add a0, zero, t6
		ecall
		
	saidaJogadaPC:
	
	ret

#Sera responsavel por desenhar o estado do tabuleiro no momento em que foi chamada
desenhaTabuleiro:

	ret
