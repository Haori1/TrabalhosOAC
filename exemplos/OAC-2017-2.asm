.data

msg1:	.string "Entre com o valor de rô: "
msg2:	.string "Entre com o valor de theta: "
out1:	.string "Valor de X = "
out2:	.string "Valor de Y = "
endl:	.string	"\n"
pi:		.float	3.141592654

.text

main:
	addi sp, sp, -8
	
	jal readvalues
	
	fsw	fa0, 0(sp)			# ro
	fsw fa1, 4(sp)			# theta
	
	fcvt.s.w ft0, zero
	feq.s t0, fa0, ft0		# fa0 == 0?
	bnez  t0, end
	
	jal P2R
	jal show
	
end:
	addi sp, sp, 8
	li a7, 10
	ecall
###################################################	

# Retorna: fa0 = ro 
#		   fa1 = theta
readvalues:
	addi sp, sp, -8
	
	li a7, 4
	la a0, msg1
	ecall
		li a7, 6
		ecall
		fsw fa0, 0(sp)
	li a7, 4
	la a0, msg2
	ecall
		li a7, 6
		ecall
		fsw fa0, 4(sp)
	
	flw fa0, 0(sp)
	flw fa1, 4(sp)
	
	addi sp, sp, 8
	ret
###################################################	

# parametros: fa0 = ro
#			  fa1 = theta
#
# retorna:	  fa0 = x
#			  fa1 = y
P2R:
	addi sp, sp, -16
	fsw	fa0, 0(sp)
	sw	ra, 8(sp)
	fcvt.s.w ft0, zero		
	jal seno				# retorno do seno em fa0
	lw	ra, 8(sp)
	fmv.s ft0, fa0			# ft0 = sen(theta)
	flw	 fa0, 0(sp)			# carrego em fa0 o valor de ro dnv 
y:	
	fmul.s fa1, fa0, ft0	# y = ro*sen(theta) 
cos:
	fmul.s ft0, ft0, ft0	# ft0 = sen^2(theta)
	li t1, 1
	fcvt.s.w	ft1 , t1
	fsub.s	ft0, ft1, ft0	# 1 - sen^2(theta)
	fsqrt.s ft0, ft0		# cos(theta)
xis:	
	fmul.s fa0, fa0, ft0		# x = ro * cos (theta)
	addi sp, sp, 16
fim:
	ret
###################################################	

# parametros: fa1 = theta
# retorno	: fa0 = seno(theta)
seno:
	addi 	sp, sp, -12
	fsw		fa0, 0(sp)
	sw		ra, 8(sp)
	jal 	ToRad		# fa1 em graus e retorna fa1 em rad
	lw		ra, 8(sp)
	fsw		fa1, 4(sp)
	
	li 		s0, 5		# qtd de iterações
	li 		s1, 0		# contador
	fcvt.s.w	ft0, zero
	fcvt.s.w	fa4, zero
	li 		s2, 2		# constante 2
	li 		s4, -1		# constante -1
	
loop:	beq s1, s0, endloop
	mul		s3, s2, s1	# s3 = 2*s1
	addi	s3, s3, 1	# s3 = (2*s1 + 1)
	
	#	(2*s1 + 1)!
	mv		a0, s3		# argumento pro fatorial
	sw 		ra, 8(sp)
	jal		fact		# valor de retorno no a2
	lw		ra, 8(sp)
	
	fcvt.s.w	fa2, a2		# fa2 = (2*s1 + 1)!
	
	#	theta ^ (2*s1 + 1)
	mv		a0, s3
	flw		fa1, 4(sp)
	sw		ra, 8(sp)
	jal		power_float		# valor de retorno no fa3
	lw		ra, 8(sp)
	
	fdiv.s		fa5, fa3, fa2	# x = fa3 / fa2
	
	#	(-1) ^ s1
	mv 		a0, s1
	mv 		a1, s4 
	sw		ra, 8(sp)
	jal		power			# valor de retorno no a3
	lw		ra, 8(sp)
	
	fcvt.s.w	fa3, a3		# fa3 = (-1) ^ (s1)
	
	fmul.s  fa3, fa5, fa3	# fa4 = (theta^(2n+1) / (2n + 1) ) * (-1)^n 
	fadd.s 	fa4, fa4, fa3	# fa4 = (fa3/fa2) + fa4
	addi 	s1, s1, 1		# i++
	j loop
	
endloop:
	addi sp, sp, 12
	fmv.s fa0, fa4
	ret
###################################################	

# Parametro: a0 = (s*s1 + 1)
# retorno: a2 = fat(a2)
fact:
	beqz , a0, return_1		# se o valor for 0 retorna 1
	
	li a2, 1
	mv t3, a0					# contador = fa0
	li t1, 1
	
lp:	beq 	a0, t1, return_1		# fa0 == ft1 ?
	beq 	t3, t1, exitfact		# se o contador == 1 entao sai
	mul 	a2, a2, t3				# fat * contador
	addi 	t3, t3, -1				# contador--
	b lp
return_1:
exitfact:
	ret	
###################################################	

# parametro: a0 = s1
#			 a1 = -1
#
# retorno:	 a3 = (-1)^s1
power:
	li a3, 1							# resultado = 1
	li t1, 1							# constante = 1
	beq 	a1, zero, exit0				# a1 == 0?
	beq	 	a1, t1, exit				# a1 == 1? 
lopo:
	beq 	a0, zero, exit				# a0 == 0? 
	
	mul 	a3, a3, a1					# a3 = a3 * base
	addi  	a0, a0, -1					# expoente--
	bgt 	a0, zero, lopo				# a0 > 0 ?
	j 		exit
exit0:
	mv a3, zero
exit:
	ret
###################################################	

# parametro: fa1 = theta
#			 a0  = (2*s1 + 1)
#
# retorno:	 fa3 = (theta)^(2*s1 + 1)
power_float:
	fcvt.s.w	ft0, a0
	li a3, 1
	fcvt.s.w	fa3, a3
	li t1, 1
	fcvt.s.w 	ft1, t1
	fcvt.s.w	ft0, zero
	
	feq.s	t0, fa1, ft0				# fa1 == 0?
	bnez	t0, exit0f
	feq.s	t0, fa1, ft1				# fa1 == 1?
	bnez	t0, exitf
lopof:
	beq 	a0, zero, exitf				# a0 == 0? 
	
	fmul.s 	fa3, fa3, fa1				# a3 = a3 * base
	addi  	a0, a0, -1					# expoente--
	bgt 	a0, zero, lopof				# a0 > 0 ?
	j 		exitf
exit0f:
	mv a3, zero
exitf:
	ret				
###################################################	
	
# parametro: fa1 = theta (graus)
# retorno:	 fa1 = theta (rad)
ToRad:
	la t0, pi
	flw ft0, 0(t0)
	fmul.s fa1, ft0, fa1
	li t0, 180
	fcvt.s.w ft0, t0
	fdiv.s fa1, fa1, ft0
	ret
###################################################	

# paramentro: fa0 = x
# parametro:  fa1 = y
show:
	li a7, 4
	la a0, out1
	ecall
		li a7, 2
		ecall
	
	li a7, 4
	la a0, endl
	ecall
	
	li a7, 4
	la a0, out2
	ecall
		li a7, 2
		fmv.s fa0, fa1
		ecall
	ret
###################################################	
