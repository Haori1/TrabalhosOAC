.include "eqv.s"
.include "imagens.s"
#.include "musicas.s"

.data

# DADOS DAS PEDRAS ##################################################
# com as coordenadas iniciais no tabuleiro e cores que podem mudar antes do inicio das partidas
# player sempre na parte de baixo da tela
#			X	Y	cor	viva ou não
pedra_pl_1: .byte	0,	5,	WHITE,	1
PEDRA_PL_2: .byte	2,	5,	WHITE,	1
PEDRA_PL_3: .byte	4,	5,	WHITE,	1
PEDRA_PL_4: .byte	6,	5,	WHITE,	1
PEDRA_PL_5: .byte	1,	6,	WHITE,	1
PEDRA_PL_6: .byte	3,	6,	WHITE,	1
PEDRA_PL_7: .byte	5,	6,	WHITE,	1
PEDRA_PL_8: .byte	7,	6,	WHITE,	1
PEDRA_PL_9: .byte	0,	7,	WHITE,	1
PEDRA_PL_10: .byte	2,	7,	WHITE, 	1
PEDRA_PL_11: .byte	4,	7,	WHITE, 	1
PEDRA_PL_12: .byte	6,	7,	WHITE,	1

PEDRA_CPU_1: .byte	1,	0,	BLACK,	1
PEDRA_CPU_2: .byte	3,	0,	BLACK,	1
PEDRA_CPU_3: .byte	5,	0,	BLACK,	1
PEDRA_CPU_4: .byte	7,	0,	BLACK,	1
PEDRA_CPU_5: .byte	0,	1,	BLACK,	1
PEDRA_CPU_6: .byte	2,	1,	BLACK,	1
PEDRA_CPU_7: .byte	4,	1,	BLACK,	1
PEDRA_CPU_8: .byte	6,	1,	BLACK,	1
PEDRA_CPU_9: .byte	1,	2,	BLACK,	1
PEDRA_CPU_10: .byte	3,	2,	BLACK,	1
PEDRA_CPU_11: .byte	5,	2,	BLACK,	1
PEDRA_CPU_12: .byte	7,	2,	BLACK,	1
#######################################################

.text

jal montaTabuleiro

li a7, 10
ecall

#######################################################
# montaTabuleiro ######################################
# distribui as pecas no tabuleiro principal

montaTabuleiro: li t0, BOARD_ADDRESS	# endereco do tabuleiro
	la t1, PEDRA_CPU_1
	
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