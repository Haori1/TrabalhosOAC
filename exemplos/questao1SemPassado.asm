.data

.text

main:

li t0, 0
fcvt.s.w ft2, t0
li a1, 10

li a7, 6  
ecall
fadd.s ft0, fa0, ft2

li a7, 6
ecall
fadd.s ft1, fa0, ft2

li a0, 0 #contador

jal raizes

li a7, 10
ecall

raizes:
addi sp, sp, -4
sw ra, 0(sp)

jal sen

li t5, 1
fcvt.s.w ft4, t5

fmul.s ft3, fa5, fa5
fsub.s ft3, ft5, ft3

fmul.s fa2, ft0, ft3
fmul.s fa3, ft0, fa5

lw ra, 0(sp)
addi sp, sp, 4
ret

sen:

addi sp, sp, -4
sw ra, 0(sp)

li t5, 0
fcvt.s.w fs5, t5

li t0, -1
fcvt.s.w fs4, t0
li t1, 2

loopSen: remu t3, a0, t1
beq t5, t3, positivo
jal fatorial
jal potenciaTeta
fdiv.s ft4, ft8, ft9
fmul.s ft4, fs4, ft4
fadd.s fa5, fa5, ft4

bne t5, t3, jump

positivo:
jal fatorial
jal potenciaTeta
fdiv.s ft4, ft8, ft9
fadd.s fa5, fa5, ft4
addi a0, a0, 1

beq a0, a1, retornaSen

jump: j loopSen

retornaSen: lw ra, 0(sp)
addi sp, sp, 4
ret

fatorial:
addi, sp, sp, -4
sw ra, 0(sp)

li t0, 0
fcvt.s.w ft5, t0
li t0, 1
fcvt.s.w ft6, t0
fcvt.s.w ft7, a0

fadd.s ft7, ft7, ft7
fadd.s ft7, ft7, ft6
fadd.s ft9, ft7, ft5

loop1:
fsub.s ft7, ft7, ft6
fmul.s ft9, ft9, ft7

feq.s t1, ft7, ft6
beq t0, t1, retorno1

j loop1

retorno1:
lw ra, 0(sp)
addi sp, sp, 4
ret

potenciaTeta:
addi sp, sp, -4
sw ra, 0(sp)

fcvt.s.w ft4, a0
li t0, 1
fcvt.s.w ft5, t0
li t0, 0
fcvt.s.w ft6, t0

fadd.s ft4, ft4, ft4
fadd.s ft4, ft4, ft4

fadd.s ft7, ft1, ft4

loop2:
fsub.s ft4, ft4, ft5
fmul.s ft8, ft8, ft7

feq.s t1, ft4, ft6

beq t1, t0, retorna2

j loop2

retorna2:
lw ra, 0(sp)
addi sp, sp, 4
ret






