#################################################
#  Programa de exemplo de uso dos syscalls   	#
#  Versão Polling				#
#  ISC Maio 2018			      	#
#  Marcus Vinicius			      	#
#################################################
# Conecte o BitMap Display Tool E o Keyboard Display MMIO Tool


.data 
FILE: .string "display.bin"		# string do nome do arquivo
STR: .string "Placar do sapo:"		# string da mensagem

.text
	# seta o exception handler
 	la t0,exceptionHandling		# carrega em t0 o endere?o base das rotinas do sistema ECALL
 	csrrw zero,5,t0 		# seta utvec (reg 5) para o endere?o t0
 	csrrsi zero,0,1 		# seta o bit de habilitaçãoo de interrupçãoo em ustatus (reg 0)
 	
# Abre o arquivo
	la a0,FILE
	li a1,0
	li a2,0
	li a7,1024
	ecall
	mv s0,a0
	
# Le o arquivos para a memoria VGA
	mv a0,s0
	li a1,0xFF000000
	li a2,76800
	li a7,63
	ecall

#Fecha o arquivo
	mv a0,s0
	li a7,57
	ecall

# Escreve a string do endereço $a0, na posição ($a1,$a2) com as cores $a4		
	la a0,STR   	#Endereco da STR
	li a1,0		# coluna
	li a2,0		# linha
	li a3,0xFF00	# cores de frente(00) e fundo(FF) do texto
	li a7,104	# syscall de print string		
	ecall

MAINLOOP: jal KEYBOARD       	# Verifica se houve tecla pressionada

	mv a0,t2		# imprime o código ascii da tecla pressionada
	li a1,152		# coluna
	li a2,0			# linha
	li a3,0xFF00		# cores de frente(00) e fundo(FF) do texto
	li a7,101		# syscall de print int	
	ecall	  
	  
	mv a0,t2		# imprime a tecla lida no nariz do sapo
	li a1,220		# coluna
	li a2,100		# linha
	li a3,0x3807		# cores de frente(0x07) e fundo(0x38) do caracter ASCII do teclado
	li a7,111		# syscall de print char
	ecall 

  	j MAINLOOP		# volta ao loop principal

FIM:	li a7,10		# syscall de Exit
	ecall

KEYBOARD: 	li t1,0xFF200000	# carrega o endereço de controle do KDMMIO
		lw t0,0(t1)		# le a palavra de controle
		andi t0,t0,0x0001	# mascara o bit menos signifcativo
   		beq t0,zero,PULA   	# Se não há tecla pressionada então vá para PULA
  		lw t2,4(t1)  		# le a tecla pressionada
		sw t2,12(t1)  		# escreve a tecla do no display de texto
	
PULA:	jr ra,0



.include "SYSTEMv1.s"			# carrega as rotinas do sistema

