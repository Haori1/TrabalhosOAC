.include "eqv.s"
.include "imagens.s"

.text

li a0, WHITE_WORD
jal cls

la a0, IMG_TABULEIRO
li a1, 320
li a2, 160
li a3, 0
li a4, 15
jal imprimeimagem

la a0, IMG_PEDRA_BRANCA
li a1, 25
li a2, 11
li a3, 77
li a4, 19
jal imprimeimagem

li a7, 10
ecall

cls:
	li t1,0xFF000000	# endereco inicial da Memoria VGA
	li t2,0xFF012C00	# endereco final 
cls.loop: 	beq t1,t2,cls.fora		# Se for o último endereço então sai do loop
	sw a0,0(t1)		# escreve a word na memória VGA
	addi t1,t1,4		# soma 4 ao endereço
	j cls.loop			# volta a verificar
cls.fora: ret

imprimeimagem:		# FALTA O CASO PARA IMPRIMIR IMAGENS DESALINHADAS, COMO A DAS PEDRAS
#a0 = endereco da imagem, cujo conteu do eh um vetor de bytes correspondendo a cor de cada pixel
#a1 = largura (X)	ex: 320
#a2 = altura (Y)	ex: 240
#a3 = coordenada X desejada na tela
#a4 = coordenada Y desejada na tela
li t6, BITMAP_ADDRESS	# carrega 0xFF000000
mv t0, a0

mv t4, a4
li t3, 320
mul t4, t4, t3
add t4, t4, a3
add t4, t4, t6		# endereco para comecar a impressao = (Y*320) + X + BITMAP_ADDRESS

sub t3, t3, a1		# quantidade a se pular para imprimir linha a linha corretamente
mv t5, a2

li t1, 4
rem t1, a1, t1		# se X % 4 for diferente de zero, X nao esta alinhado em words
bnez t1, imprimeimagem.byte	# nesse caso, pula pro caso byte a byte (4x mais lento)

# CASO ENDERECO ALINHADO
imprimeimagem.antesloop1:
srli t1, a1, 2		# divide o contador por 4, afinal o loop percorre de 4 em 4 bytes (words)
imprimeimagem.loop1:
lw t2, 0(t0)
sw t2, 0(t4)		# transporta o dado de t0 (vetor da imagem) para t4 (bitmap)
addi t0, t0, 4
addi t4, t4, 4
addi t1, t1, -1
beqz t1, imprimeimagem.out
j imprimeimagem.loop1

imprimeimagem.out:
add t4, t4, t3		# t4 vai para a proxima linha e comeca o loop1 novamente; t0 ja esta na proxima "linha" pois eh sequencial
addi t5, t5, -1		# loop1 ira rodar Y vezes
beqz t5, imprimeimagem.out2
j imprimeimagem.antesloop1

# CASO ENDERECO DESALINHADO
imprimeimagem.byte:
mv t1, a1
imprimeimagem.byte.loop1:
lb t2, 0(t0)
sb t2, 0(t4)		# transporta o dado de t0 (vetor da imagem) para t4 (bitmap)
addi t0, t0, 1
addi t4, t4, 1
addi t1, t1, -1
beqz t1, imprimeimagem.byte.out
j imprimeimagem.byte.loop1

imprimeimagem.byte.out:
add t4, t4, t3		# t4 vai para a proxima linha e comeca o loop1 novamente; t0 ja esta na proxima "linha" pois eh sequencial
addi t5, t5, -1		# loop1 ira rodar Y vezes
beqz t5, imprimeimagem.out2
j imprimeimagem.byte

imprimeimagem.out2: ret
