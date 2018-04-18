.text

.data

main:
#polinomio: ax² + bx + c
# equacao do delta: b² - 2(a)(c)
#O delta fornece a informacao de se a equacao possui raizes reais ou complexas
# calculo das raizes: (-b +- sqrt(delta))/2
#caso delta seja negativo, calcula-se a raiz do módulo do delta e desenha-se o i de acordo com esse valor.

# fa0 = a
# fa1 = b
# fa2 = c

#Não como dar load immediate em um float?

#valores simulados de A
li t0, 1
li t1, -6
li t2, 10

fcvt.s.w fa0, t0
fcvt.s.w fa1, t1
fcvt.s.w fa2, t2


li a7, 10
ecall



#passar funcoes para o formato recursivo:
calculaDelta:

 addi sp, sp, -16
 
 li t0, 2
 
 fcvt.s.w ft3, t0

 fmul.s ft0, fs1, fs1 #t0 = b²
 fmul.s ft1, fs0, fs2 #t1 = ac
 fmul.s ft1, ft1 , ft3 #t1 = 2ac
 fsub.s ft2, ft0, ft1 #t2 = b² - 2ac
 
 li t0, 0
 fcvt.s.w ft0, t0
 
 li t0, 1
 fcvt.s.w ft3, t0
 
 flt.s ft1, ft2, ft0 #se t2 <0 ft1 = 1, caso contrario ft1 = 0
 
 feq.s ft1, ft3, negativo #se for negativo, retorna 2
 
 li a0, 1
 
 feq.s ft1, ft0, raizes #se for positivo, retorna 1
 
 negativo:
 
 li a0, 2
 
 raizes:
 
 li t0, 2
 beq a0, t0, raizes_negativas
  
 
 positivas:
 
 li t0, -1
 fcvt.s.w ft0, t0
 
 fmul.s ft5, fa1, ft0 #-b
 
 fsqrt.s ft4, ft4 #raiz do modulo do delta
 
 fadd.s ft6, ft4, ft5 #soma de -b com raiz de delta
 
 li t0, 2
 fcvt.s.w ft0, t0
 
 fdiv.s ft6, ft6, ft0 #divisão da soma por dois
 
 fsw ft6, 12(sp) #salva x1 na pilha
 
 fsub.s ft6, ft4, ft5 #soma de -b com raiz de delta
 fdiv.s ft6, ft6, ft0 #divisão da soma por dois 
 
 fsw ft6, 8(sp) #salva x2 na pilha
 
 bne a0, t0, retorno
 
 raizes_negativas:
 
 fmul.s ft4, ft2, ft0 #-delta
 
 retorno:
 
 ret
