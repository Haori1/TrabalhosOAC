# Teste dos syscalls 1xx que usam o SYSTEMv1.s
# Conectar o BitMap Display e o KD MMIO para executar
# na DE1-SoC e no Rars deve ter o mesmo comportamento sem alterar nada!


.data
FLOAT: .float 3.14159265659
msg1: .string "Organizacao Arquitetura de Computadores 2018/1 !"
msg2: .string "Digite seu Nome:"
msg3: .string "Digite sua Idade:"
msg4: .string "Digite seu peso:"
msg5: .string "Numero Randomico:"
msg6: .string "Tempo do Sistema:"
buffer: .string "                                "

.text	
	#M_Setjal exceptionHandling(exceptionHandling)	# Macro de Setjal exceptionHandling
				
	jal CLS
	jal PRINTSTR1
	jal INPUTSTR
	jal INPUTINT
	jal INPUTFP
	jal RAND
	jal TIME
	jal TOCAR
	jal SLEEP

	li a7, 10
	jal exceptionHandling
			
# CLS Clear Screen
CLS:	li a0,0x07
	li a7,148
	addi sp, sp, -4
	sw ra, 0(sp)
	jal exceptionHandling
	lw ra, 0(sp)
	addi sp, sp, 4
	ret
				
# syscall print string
PRINTSTR1: li a7,104
	la a0,msg1
	li a1,0
	li a2,0
	li a3,0xFF00
	
	addi sp, sp, -4
	sw ra, 0(sp)
	jal exceptionHandling
	lw ra, 0(sp)
	addi sp, sp, 4
	ret		
	
INPUTSTR: li a7,104
	la a0,msg2
	li a1,0
	li a2,24
	li a3,0xFF00
	
	addi sp, sp, -4
	sw ra, 0(sp)
	jal exceptionHandling
	lw ra, 0(sp)
	addi sp, sp, 4
	
# syscall read string
	li a7,108
	la a0,buffer
	li a1,32
	
	addi sp, sp, -4
	sw ra, 0(sp)
	jal exceptionHandling
	lw ra, 0(sp)
	addi sp, sp, 4
	
# syscall print string	
	li a7,104
	la a0,buffer
	li a1,144
	li a2,24
	li a3,0xFF00
	
	addi sp, sp, -4
	sw ra, 0(sp)
	jal exceptionHandling
	lw ra, 0(sp)
	addi sp, sp, 4	
	ret
	
# syscall read int
	# syscall print string	
INPUTINT: li a7,104
	la a0,msg3
	li a1,0
	li a2,32
	li a3,0xFF00
	
	addi sp, sp, -4
	sw ra, 0(sp)
	jal exceptionHandling
	lw ra, 0(sp)
	addi sp, sp, 4

	# syscall read int
	li a7,105
	
	addi sp, sp, -4
	sw ra, 0(sp)
	jal exceptionHandling
	lw ra, 0(sp)
	addi sp, sp, 4
	
	mv t0,a0

#PI:	li $t0,-123456
	# syscall print int	
PRINTINT: li a7,101
	mv a0,t0
	li a1,152
	li a2,32
	li a3,0xFF00
	
	addi sp, sp, -4
	sw ra, 0(sp)
	jal exceptionHandling
	lw ra, 0(sp)
	addi sp, sp, 4
	ret
	
# syscall read float
	# syscall print string	
INPUTFP: li t0,0 
	la t1,FLOAT
	flw f0,0(t1)
	fmv.x.s t0,f0
	beq t0,zero,FORAFP  # testa para ver se tem a FPU
 
  	li a7,104
	la a0,msg4
	li a1,0
	li a2,40
	li a3,0xFF00
	
	addi sp, sp, -4
	sw ra, 0(sp)
	jal exceptionHandling
	lw ra, 0(sp)
	addi sp, sp, 4
	
	li a7,106
	
	addi sp, sp, -4
	sw ra, 0(sp)
	jal exceptionHandling
	lw ra, 0(sp)
	addi sp, sp, 4
	
	# syscall print float
	li a7,102
	li a1,144
	li a2,40
	li a3,0xFF00
	
	addi sp, sp, -4
	sw ra, 0(sp)
	jal exceptionHandling
	lw ra, 0(sp)
	addi sp, sp, 4
	
FORAFP:	ret
	
	# Contatos imediatos do terceiro grau
TOCAR:	li a0,62
	li a1,500
	li a2,16
	li a3,127
	li a7,133
	
	addi sp, sp, -4
	sw ra, 0(sp)
	jal exceptionHandling
	lw ra, 0(sp)
	addi sp, sp, 4
	
	li a0,64
	li a1,500
	li a2,16
	li a3,127
	li a7,133
	
	addi sp, sp, -4
	sw ra, 0(sp)
	jal exceptionHandling
	lw ra, 0(sp)
	addi sp, sp, 4
	
	li a0,61
	li a1,500
	li a2,16
	li a3,127
	li a7,133
	
	addi sp, sp, -4
	sw ra, 0(sp)
	jal exceptionHandling
	lw ra, 0(sp)
	addi sp, sp, 4
	
	li a0,50
	li a1,500
	li a2,16
	li a3,127
	li a7,133
	
	addi sp, sp, -4
	sw ra, 0(sp)
	jal exceptionHandling
	lw ra, 0(sp)
	addi sp, sp, 4
	
	
	li a0,55
	li a1,800
	li a2,16
	li a3,127
	li a7,131
	
	addi sp, sp, -4
	sw ra, 0(sp)
	jal exceptionHandling
	lw ra, 0(sp)
	addi sp, sp, 4
	
	ret
			
# syscall rand
	# syscall print string	
RAND:	li a7,104
	la a0,msg5
	li a1,0
	li a2,48
	li a3,0xFF00
	
	addi sp, sp, -4
	sw ra, 0(sp)
	jal exceptionHandling
	lw ra, 0(sp)
	addi sp, sp, 4

	# syscall Rand
	li a7,141
	
	addi sp, sp, -4
	sw ra, 0(sp)
	jal exceptionHandling
	lw ra, 0(sp)
	addi sp, sp, 4
	
	# print int em hex
	li a7,134  #134
	li a1,148
	li a2,48
	li a3,0xFF00
	
	addi sp, sp, -4
	sw ra, 0(sp)
	jal exceptionHandling
	lw ra, 0(sp)
	addi sp, sp, 4
	
	ret
	
		
# syscall time
	# syscall print string	
TIME:	li a7,104
	la a0,msg6
	li a1,0
	li a2,56
	li a3,0xFF00
	
	addi sp, sp, -4
	sw ra, 0(sp)
	jal exceptionHandling
	lw ra, 0(sp)
	addi sp, sp, 4

	li a7,130
	
	addi sp, sp, -4
	sw ra, 0(sp)
	jal exceptionHandling
	lw ra, 0(sp)
	addi sp, sp, 4
	
	mv t0,a0
	mv t1,a1
	
	#print int
	mv a0,t0
	li a7,101
	li a1,148
	li a2,56
	li a3,0xFF00
	
	addi sp, sp, -4
	sw ra, 0(sp)
	jal exceptionHandling
	lw ra, 0(sp)
	addi sp, sp, 4
	
	#print int
	mv a0,t1
	li a7,101
	li a1,244
	li a2,56
	li a3,0xFF00
	
	addi sp, sp, -4
	sw ra, 0(sp)
	jal exceptionHandling
	lw ra, 0(sp)
	addi sp, sp, 4
	
	ret
	
# syscall sleep
SLEEP:	li t0,5
LOOPHMS:li a0,1000   # 1 segundo
	li a7,132
	
	addi sp, sp, -4
	sw ra, 0(sp)
	jal exceptionHandling
	lw ra, 0(sp)
	addi sp, sp, 4
	
	addi t0,t0,-1
	#print seg
	mv a0,t0
	li a7,101
	li a1,120
	li a2,120
	li a3,0xFF00
	
	addi sp, sp, -4
	sw ra, 0(sp)
	jal exceptionHandling
	lw ra, 0(sp)
	addi sp, sp, 4
	
	bne t0,zero, LOOPHMS
		
	ret
	



.include "../SYSTEMv1.s"






