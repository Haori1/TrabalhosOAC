.data
	
	digite: .string "DIGITE UM VALOR: "
	resultado: .string "FATORIAL: "

	.macro exit
	li a7, 10
	ecall
	.end_macro
	
	.macro printInt
	li a7, 1
	ecall
	.end_macro

.text
	la a0, digite
	li a7, 4
	ecall
	li a7, 5
	ecall
	
	jal fatorial
	
	la a0, resultado
	li a7, 4
	ecall
	mv a0, a1
	printInt
	
	exit
	
fatorial:
	addi sp, sp, -8
	sw ra, 4(sp)
	sw a0, 0(sp)
	
	slti t0, a0, 2
	beqz t0, rec
	li a1, 1
	
	addi sp, sp, 8
	ret
	
rec:
	addi a0, a0, -1
	jal fatorial
	
	lw a0, 0(sp)
	lw ra, 4(sp)
	addi sp, sp, 8
	
	mul a1, a0, a1
	ret
	
	
	