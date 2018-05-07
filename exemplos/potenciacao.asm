.data

.text
li a0, 4 #expoente
li a1, 0 #contador
li a2, 20 #base

loop: addi a0, a0, -1
      mul a2, a2, a2
      beq a0, zero, fim
      j loop
      fim: ret
      
li a7, 1
mv a0, a2
ecall