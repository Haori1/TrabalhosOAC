.text

.data
#polinomio: ax² + bx + c
# equacao do delta: b² - 2(a)(c)
#O delta fornece a informacao de se a equacao possui raizes reais ou complexas
# calculo das raizes: (-b +- sqrt(delta))/2
#caso delta seja negativo, calcula-se a raiz do módulo do delta e desenha-se o i de acordo com esse valor.

# s0 = a
# s1 = b
# s2 = c


#passar funcoes para o formato recursivo:
calculaDelta:

 mul t0, s1, s1 #t0 = b²
 mul t1, s0, s2 #t1 = ac
 sll t1, t1 , 1 #t1 = 2ac
 sub t2, t0, t1 #t2 = b² = 2ac
 
 slti t3, t2, 0 #se t2 <0 t3 = 1, caso contrario t3 = 0
 
 li t0, 1 #comparador
 
 beq t3, t0, negativo #se for negativo, retorna 2
 
 li a0, 1
 
 bne t3, t0, retorna #se for positivo, retorna 1
 
 negativo:
 
 li a0, 2
 
 retorna:
 
 ret