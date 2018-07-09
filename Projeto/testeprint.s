.include "eqv.s"

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

#_limpaPedra(250, 19)

la a0, IMG_PEDRA_BRANCA
li a1, 25
li a2, 11
li a3, 77
li a4, 19
jal imprimeImagem

_imprimeCursor(78, 19)

li a7, 10
ecall

.include "bitmap.s"
