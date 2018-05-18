.eqv ADRR 0xFF100000

.data


palavra: .word 3

.text

#lui t2, 0x453FF

auipc t0, 1

addi t2, t2, 2047

#srli t2, t2, 12
#slli t2, t2, 12

lui t3, 0x7ffff
li t4, 1
slli t4, t4, 11
addi t4, t4, 0x7FF

add t3, t3, t4

andi t3, t3, 0xFF

li t5, 0xff
slli t5, t5, 8
and t2, t2, t5

addi t5, t5, 0xF

#flw ft3, -7

li t6, ADRR
#bne t5, 0x122
