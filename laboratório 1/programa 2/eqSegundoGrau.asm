.data
quebraLinha: .ascii "\n"
imaginario: .ascii "i"
entreImaginario: .ascii " + "

.text

main:
#polinomio: ax² + bx + c
# equacao do delta: b² - 2(a)(c)
#O delta fornece a informacao de se a equacao possui raizes reais ou complexas
# calculo das raizes: (-b +- sqrt(delta))/2
#caso delta seja negativo, calcula-se a raiz do módulo do delta e desenha-se o i de acordo com esse valor.

# fa0 = a
# fa1 = b
# fa2 = c

li t0, 0
fcvt.s.w ft0, t0

li a7, 6
ecall

fadd.s fa4, fa0, ft0

li a7, 6
ecall

fadd.s fa1, fa0, ft0 # fa1 = b

li a7, 6
ecall

fadd.s fa2, fa0, ft0 # fa2 = c

fadd.s fa0, fa4, ft0 #fa0 = a


jal calculaDelta


#valores simulados de A
#li t0, 1 
#li t1, -6
#li t2, 10

#fcvt.s.w fa0, t0 # a = 1
#fcvt.s.w fa1, t1 # b = -6
#fcvt.s.w fa2, t2 # c = 10


li a7, 10
ecall


#*********************************************************************************************************************#
calculaDelta:

 addi sp, sp, -16 #Cria uma pilha com 4 palavras
 
 li t0, 2 
 
 fcvt.s.w ft3, t0 #loga o 2 que vai multiplicar ac

 fmul.s ft0, fs1, fs1 #t0 = b²
 fmul.s ft1, fs0, fs2 #t1 = ac
 fmul.s ft1, ft1 , ft3 #t1 = 2ac
 fsub.s ft2, ft0, ft1 #t2 = b² - 2ac
 
 li t0, 0 
 fcvt.s.w ft0, t0 
 
 li t0, 1
 fcvt.s.w ft3, t0
 
 flt.s t1, ft2, ft0 #se t2 <0 ft1 = 1, caso contrario ft1 = 0
 
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
 
 bne a0, t0, retornoCalcula
 
 raizes_negativas:
 
 #padrão na pilha: parte real em cima da parte imaginária
 li t0, -1
 fcvt.s.w ft0, t0 #salva -1 para inverter valores negativos
 
 fmul.s ft4, ft2, ft0 #-delta
 fsqrt.s ft4, ft4 #raiz do modulo do delta
 
 fmul.s ft5, fa1, ft0 #-b
 
 fsw ft4, 12(sp) #salva parte imaginária de x1 na pilha
 
 fsw ft5, 8(sp) #salva parte real de x1 na pilha

 fmul.s ft4, ft2, ft0 #-delta, da equação para achar x''
 
 fsw ft4, 4(sp) #salva parte imaginária de x2 na pilha
   
 fsw ft5, 0(sp) #salva parte real de x2 na pilha
 
 
 retornoCalcula:
 
 ret

#*********************************************************************************************************************#

imprimeRaizes:

 li t0, 2
 
 imprimeReais:
 beq a0, t0, imprimeComplexas
 
 flw fa0, 8(sp)
 
 li a7, 2
 ecall
 
 la a0, quebraLinha
 
 li a7, 4
 ecall
 
 
 flw fa0, 12(sp)
 
 li a7, 2
 ecall
 
 addi sp, sp, 16 #desaloca pilha 
    
 bne a0, t0, retornoImprime

 imprimeComplexas:
 
 flw fa0, 0(sp) #loga parte real de x2
 
 li a7, 2
 ecall
 
 la a0, entreImaginario #coloca o +
 
 li a7, 4
 ecall
 
 flw fa0, 4(sp) #loga parte imaginaria de x2
 
 li a7, 2
 ecall
 
 la a0, imaginario #coloca o i
 
 li a7, 4
 ecall
 
 la a0, quebraLinha 
 
 li a7, 4
 ecall
 
 flw fa0, 8(sp) #loga parte real de x1
 
 li a7, 2
 ecall
 
 la a0, entreImaginario #coloca o +
 
 li a7, 4
 ecall
 
 flw fa0, 12(sp) #loga parte imaginaria de x2
 
 li a7, 2
 ecall
 
 la a0, imaginario #coloca o i
 
 li a7, 4
 ecall
 
 addi sp, sp, 16 #desaloca pilha

 retornoImprime:
 
 ret