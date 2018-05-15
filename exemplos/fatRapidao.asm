.data

.text

li a0, 3
mv a1, a0
li a2, 1

loop: fsub.s a0, a0, -1
mul a1, a1, a0
beq a0, a2, fim
j loop
fim: 

li a7, 1
mv a0, a1
ecall

