
.macro M_SetEcall(%label)
 	la t0,%label		# carrega em t0 o endere�o base das rotinas do sistema ECALL
 	csrrw zero,5,t0 	# seta utvec (reg 5) para o endere�o t0
 	csrrsi zero,0,1 	# seta o bit de habilita��o de interrup��o em ustatus (reg 0)
 .end_macro
 
.macro M_Exit
	li a7, 10
	ecall
.end_macro
