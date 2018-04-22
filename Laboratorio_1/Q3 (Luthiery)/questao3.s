.macro _loadImmFP(%register, %integer)
	li t6, %integer
	fcvt.s.w %register, t6
.end_macro

.macro _printNewLine
	la a0, newline
	li a7, 4
	ecall
.end_macro

.data

	newline:	.string "\n"
	print_read_a:	.string "Digite o coeficiente a: "
	print_read_b:	.string "Digite o coeficiente b: "
	print_read_c:	.string "Digite o coeficiente c: "
	print_roots:	.string "Raizes:"
	print_x1:	.string "R(1): "
	print_x2:	.string "R(2): "
	print_i:	.string "i"
	print_plus:	.string " + "
	print_minus:	.string " - "

.text

main:
	la a0, print_read_a
	li a7, 4
	ecall
	li a7, 6
	ecall
	fmv.s fa1, fa0		# lendo o coeficiente a e colocando-o em fa1
	
	la a0, print_read_b
	li a7, 4
	ecall
	li a7, 6
	ecall
	fmv.s fa2, fa0		# lendo o coeficiente a e colocando-o em fa2
	
	la a0, print_read_c
	li a7, 4
	ecall
	li a7, 6
	ecall
	fmv.s fa3, fa0		# lendo o coeficiente a e colocando-o em fa3
	
	jal bhaskara
	jal show

	li a7, 10		# fecha programa
	ecall

######################################################################
bhaskara:
# FUNCAO QUE CALCULA AS RAIZES DE UMA EQUACAO DE 2 GRAU: ax^2 + bx +c,
# COLOCANDO OS RESULTADOS NA PILHA
#
# ARGUMENTOS:
#	fa1, coeficiente a;
#	fa2, coeficiente b;
#	fa3, coeficiente c.
# RETORNO (a0):
#	1, se as raizes forem reais;
#	2, se as raizes forem complexas.

	fmul.s ft0, fa2, fa2	# ft0 = b^2
	_loadImmFP(ft2, 4)	# ft2 = 4
	fmul.s ft1, ft2, fa1 	# ft1 = 4*a
	fmul.s ft1, ft1, fa3	# ft1 = 4*a*c
	fsub.s ft3, ft0, ft1	# ft3 = b^2 - 4*a*c
	
	_loadImmFP(ft10, 0)		# ft10 = constante 0
	feq.s t0, ft3, ft10		# testa se ft3 = 0
	bnez t0, delta.caso_zero	
	flt.s t1, ft3, ft10		# testa se ft3 < 0
	bnez t1, delta.caso_negativo	

delta.caso_positivo:	
	fneg.s ft0, fa2		# ft0 = -b
	fsqrt.s ft1, ft3	# ft1 = srqt(delta)
	_loadImmFP(ft2, 2)
	fmul.s ft2, ft2, fa1	# ft2 = 2a
	
	fadd.s ft4, ft0, ft1
	fdiv.s ft5, ft4, ft2	# ft5 = (-b + sqrt(delta)) / 2a
	fsub.s ft4, ft0, ft1
	fdiv.s ft6, ft4, ft2	# ft6 = (-b - sqrt(delta)) / 2a
	
	addi sp, sp, -8
	fsw ft5, 0(sp)
	fsw ft6, 4(sp)		# insere-as na pilha
	li a0, 1		# retorno = 1 (raizes reais)
	ret
	
delta.caso_zero:
	fneg.s ft0, fa2		# ft0 = -b
	_loadImmFP(ft2, 2)
	fmul.s ft2, ft2, fa1	# ft2 = 2a
	
	fdiv.s ft5, ft0, ft2	# ft5 = -b / 2a
	
	addi sp, sp, -8
	fsw ft5, 0(sp)		# insere raiz dupla na pilha
	fsw ft5, 4(sp)
	li a0, 1		# retorno = 1 (raizes reais)
	ret
	
delta.caso_negativo:
# nesse caso, as raizes da equacao estao na forma (x + yi) e (x - yi) respectivamente
# onde x = -b/2a e y = sqrt(abs(delta))/2a

	fneg.s ft0, fa2		# ft0 = -b
	_loadImmFP(ft2, 2)
	fmul.s ft2, ft2, fa1	# ft2 = 2a
	fdiv.s ft5, ft0, ft2	# ft5 = -b / 2a = x
	
	fabs.s ft4, ft3		# ft4 = abs(delta)
	fsqrt.s ft1, ft4	# ft1 = sqrt(abs(delta))
	fdiv.s ft6, ft1, ft2	# ft6 = sqrt(abs(delta)) / 2a = y
	
	addi sp, sp, -8
	fsw ft5, 0(sp)		# coloca x na pilha
	fsw ft6, 4(sp)		# coloca y na pilha
	li a0, 2		# retorno = 2 (raizes complexas)
	ret
	

####################################################################################
show:
# FUNCAO QUE RECUPERA RAIZES DE EQUACOES DE 2 GRAU NA PILHA E AS IMPRIME NA TELA
# ARGUMENTOS:
#	a0 = 1 para imprimir raizes reais, 2 para raizes complexas
	
	mv t0, a0		# salva o argumento em outro registrador
	flw ft0, 0(sp)		# carrega os valores da pilha
	flw ft1, 4(sp)
	addi sp, sp, 8
	
	_printNewLine
	la a0, print_roots
	li a7, 4
	ecall
	_printNewLine
	
	li t1, 2
	beq t0, t1, show.caso_complexo	# se t0 = 2, pula pro caso de complexo
	
	la a0, print_x1
	li a7, 4
	ecall				# preguica de comentar os syscalls
	fmv.s fa0, ft0
	li a7, 2
	ecall
	_printNewLine
	
	la a0, print_x2
	li a7, 4
	ecall
	fmv.s fa0, ft1
	li a7, 2
	ecall
	_printNewLine
	
	ret	
	
show.caso_complexo:
	la a0, print_x1
	li a7, 4
	ecall
	fmv.s fa0, ft0
	li a7, 2
	ecall
	la a0, print_plus
	li a7, 4
	ecall
	fmv.s fa0, ft1
	li a7, 2
	ecall
	la a0, print_i
	li a7, 4
	ecall
	_printNewLine
	
	la a0, print_x2
	li a7, 4
	ecall
	fmv.s fa0, ft0
	li a7, 2
	ecall
	la a0, print_minus
	li a7, 4
	ecall
	fmv.s fa0, ft1
	li a7, 2
	ecall
	la a0, print_i
	li a7, 4
	ecall
	_printNewLine

	ret
