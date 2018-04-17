.data

.text


funcao:
addi sp, sp, -12 #cria espaço para pilha
sw t1, 8(sp) 
sw t0, 4(sp)
sw s0, 0(sp)

add t0, a0, a1 # t0 = g + h
add t1, a2, a3 # t1 = i + j

sub s0, t0, t1 #s0 = (g + h) - (i + j)
add a0, s0, zero #valor de retorno

lw s0, 0(sp)
lw t0, 4(sp)
lw t1, 8(sp)

addi sp, sp, 12 #desempilha

j ra

