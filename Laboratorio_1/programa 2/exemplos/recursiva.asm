.data
espaco: .ascii " "

.text

#quero fazer 5 + 4 + 3 + 2 + 1, recursivamente... Como???

#a0 = n
#a1 = retorno da função 
addi a0, zero, 3 # valor passado a funcao
jal ra, recursiva #chamada da funcao recursiva de somatório

addi a7, zero, 1 #indica ao ecall para imprimir
add a0, zero, a1 #guarda o valor a ser imprimido
ecall

addi a7, zero, 10  #finaliza o programa, retornando 0
ecall


recursiva:
addi sp, sp, -8 #inicia a funcao pilha, alocando espaço para duas palavras
sw ra, 4(sp) #salva o valor de ra, na primeira vez é a posição em que foi chamada a função
             #depois é a posição abaixo do jal de decresce, para desempilhar a pilha
sw a0, 0(sp) #salva o valor respectivo a etapa atual da função

slti t0, a0, 1 #testa se a0 é menor do que um
beq t0, zero, decresce #se a0 for diferente de zero, salta para decresce

add a1, zero, zero #o valor de retorno será zero, pois a0 já chegou em a0
addi sp, sp,8 #desempilha
jr ra, 0 #salta para abaixo do jal de decresce, para iniciar o desempilhamento

decresce:
addi a0,a0, -1 #decresce
jal ra, recursiva #empilha, e salva a psição de desempilhamento de cada 2 words da pilha
lw a0, 0(sp) #loga o valor empilhado na etapa
lw ra, 4(sp) #loga o valor de retorno(que será o jal de decresce, ou o ra do local aonde a função foi chamada

addi sp, sp, 8 #desempilha

add a1, a0, a1 #faz a soma de n com n-1
jr ra, 0 #retorna a posição de desempilhamento, ou a posição em que foi chamada a função





