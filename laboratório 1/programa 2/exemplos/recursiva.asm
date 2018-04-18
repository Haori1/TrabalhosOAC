.data
espaco: .ascii " "

.text

#quero fazer 5 + 4 + 3 + 2 + 1, recursivamente... Como???

#a0 = n
#a1 = retorno da fun��o 
addi a0, zero, 3 # valor passado a funcao
jal ra, recursiva #chamada da funcao recursiva de somat�rio

addi a7, zero, 1 #indica ao ecall para imprimir
add a0, zero, a1 #guarda o valor a ser imprimido
ecall

addi a7, zero, 10  #finaliza o programa, retornando 0
ecall


recursiva:
addi sp, sp, -8 #inicia a funcao pilha, alocando espa�o para duas palavras
sw ra, 4(sp) #salva o valor de ra, na primeira vez � a posi��o em que foi chamada a fun��o
             #depois � a posi��o abaixo do jal de decresce, para desempilhar a pilha
sw a0, 0(sp) #salva o valor respectivo a etapa atual da fun��o

slti t0, a0, 1 #testa se a0 � menor do que um
beq t0, zero, decresce #se a0 for diferente de zero, salta para decresce

add a1, zero, zero #o valor de retorno ser� zero, pois a0 j� chegou em a0
addi sp, sp,8 #desempilha
jr ra, 0 #salta para abaixo do jal de decresce, para iniciar o desempilhamento

decresce:
addi a0,a0, -1 #decresce
jal ra, recursiva #empilha, e salva a psi��o de desempilhamento de cada 2 words da pilha
lw a0, 0(sp) #loga o valor empilhado na etapa
lw ra, 4(sp) #loga o valor de retorno(que ser� o jal de decresce, ou o ra do local aonde a fun��o foi chamada

addi sp, sp, 8 #desempilha

add a1, a0, a1 #faz a soma de n com n-1
jr ra, 0 #retorna a posi��o de desempilhamento, ou a posi��o em que foi chamada a fun��o





