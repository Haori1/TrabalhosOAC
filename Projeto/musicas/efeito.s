.data

.text

addi sp, sp, -20

sw a0, 0(sp)
sw a1, 4(sp)
sw a2, 8(sp)
sw a3, 12(sp)
sw a7, 16(sp)

li a0, 69
li a1, 600
li a2, 127
li a3, 128
li a7, 31

ecall

lw a0, 0(sp)
lw a1, 4(sp)
lw a2, 8(sp)
lw a3, 12(sp)
lw a7, 16(sp)

addi sp, sp, 20
