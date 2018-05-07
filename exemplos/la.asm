.data
teste: .word 1
flot:	.float	3.14159

.text
main: 
j main
la   t0, flot

lui  t0, 0x10010
addi t0, t0, 0x004
flw 	fa0, 0(t0)
li a7, 2
ecall
