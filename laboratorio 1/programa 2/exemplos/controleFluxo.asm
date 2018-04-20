.data

.text

#variáveis
addi t0, zero, 120
addi t1, zero, 120

beq t1, t0, continua1 #if diferentes, faça (beq = iguais)
addi a7, zero, 1
addi a0, zero, 1
ecall

continua1:

bne t0, t1, continua2 #if iguais, faça (bne = diferentes)

addi a7, zero, 1
addi a0, zero, 2
ecall

continua2:
addi t0, zero, 200

bge t0, t1, continua3 #if menor, faça (bge = maior ou igual)
addi a7, zero, 1
addi a0, zero, 3
ecall

continua3:

blt t0, t1, continua4 #if maior ou igual, faça (blt = menor que)
addi a7, zero, 1
addi a0, zero, 4
ecall

continua4: 




