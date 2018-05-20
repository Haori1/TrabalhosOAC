# PROGRAMA QUE SERVE APENAS PARA COMPILAR E VER COMO O RARS MONTA O CÓDIGO DE MÁQUINA NAS INSTRUÇÕES COM IMEDIATO

.eqv ADRR 0xFF100000



.data


palavra: .word 3

.text

#lui t2, 0x453FF

auipc t0, -1

addi t2, t2, -2047

#srli t2, t2, 12
#slli t2, t2, 12

lui t3, 0x7ffff
li t4, 1
slli t4, t4, 11
addi t4, t4, 0x7FF

add t3, t3, t4

andi t3, t3, 0xFF
jal testebranch

li t5, 0xff
slli t5, t5, 8
and t2, t2, t5

testebranch: addi t5, t5, 0xF
nop
nop
#j testebranch


li t6, ADRR
#bnez t5, testebranch

la t0, palavra
li t5, 8
sb t5, 0(t0)
sb t5, 1(t0)
sb t5, 3(t0)
sh t5, 0(t0)
sh t5, 2(t0)
sw t5, 0(t0)

li t1, 0x00400000
jalr ra, t1, 8
