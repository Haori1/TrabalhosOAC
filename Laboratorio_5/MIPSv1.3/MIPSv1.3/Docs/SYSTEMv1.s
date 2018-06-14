#########################################################################
# Rotina de tratamento de excecao e interrupcao		v1.0		#
# Lembre-se: Os sycalls originais do Mars possuem precedencia sobre	#
# 	     estes definidos aqui					#
# Os syscalls 1XX usam o BitMap Display e Keyboard Display MMIO Tools	#
#									#
# Marcus Vinicius Lamar							#
# 2018/1								#
#########################################################################

#definicao do mapa de enderecamento de MMIO
.eqv VGAADDRESSINI      0xFF000000
.eqv VGAADDRESSFIM      0xFF012C00
.eqv NUMLINHAS          240
.eqv NUMCOLUNAS         320

.eqv KDMMIO_Ctrl	0xFF200000
.eqv KDMMIO_Data	0xFF200004

.eqv Buffer0Teclado     0xFF200100
.eqv Buffer1Teclado     0xFF200104

.eqv TecladoxMouse      0xFF200110
.eqv BufferMouse        0xFF200114

.eqv AudioBase		0xFF200160
.eqv AudioINL           0xFF200160
.eqv AudioINR           0xFF200164
.eqv AudioOUTL          0xFF200168
.eqv AudioOUTR          0xFF20016C
.eqv AudioCTRL1         0xFF200170
.eqv AudioCTRL2         0xFF200174

# Sintetizador - 2015/1
.eqv NoteData           0xFF200178
.eqv NoteClock          0xFF20017C
.eqv NoteMelody         0xFF200180
.eqv MusicTempo         0xFF200184
.eqv MusicAddress       0xFF200188


.eqv IrDA_CTRL 		0xFF20 0500	
.eqv IrDA_RX 		0xFF20 0504
.eqv IrDA_TX		0xFF20 0508

.eqv STOPWATCH		0xFF200510

.eqv LFSR		0xFF200514

.eqv KeyMap0		0xFF200520
.eqv KeyMap1		0xFF200524
.eqv KeyMap2		0xFF200528
.eqv KeyMap3		0xFF20052C

######### Macro que verifica se eh a DE2 ###############
.macro DE2(%salto)
	bne $gp,0x10008000,%salto
.end_macro

.kdata   # endereço 0x9000 0000

# Tabela de caracteres desenhados segundo a fonte do ZX-Spectrum
LabelTabChar:
.word 	0x00000000, 0x00000000, 0x10101010, 0x00100010, 0x00002828, 0x00000000, 0x28FE2828, 0x002828FE, 
	0x38503C10, 0x00107814, 0x10686400, 0x00004C2C, 0x28102818, 0x003A4446, 0x00001010, 0x00000000, 
	0x20201008, 0x00081020, 0x08081020, 0x00201008, 0x38549210, 0x00109254, 0xFE101010, 0x00101010, 
	0x00000000, 0x10081818, 0xFE000000, 0x00000000, 0x00000000, 0x18180000, 0x10080402, 0x00804020, 
	0x54444438, 0x00384444, 0x10103010, 0x00381010, 0x08044438, 0x007C2010, 0x18044438, 0x00384404, 
	0x7C482818, 0x001C0808, 0x7840407C, 0x00384404, 0x78404438, 0x00384444, 0x1008047C, 0x00202020, 
	0x38444438, 0x00384444, 0x3C444438, 0x00384404, 0x00181800, 0x00001818, 0x00181800, 0x10081818, 
	0x20100804, 0x00040810, 0x00FE0000, 0x000000FE, 0x04081020, 0x00201008, 0x08044438, 0x00100010, 
	0x545C4438, 0x0038405C, 0x7C444438, 0x00444444, 0x78444478, 0x00784444, 0x40404438, 0x00384440,
	0x44444478, 0x00784444, 0x7840407C, 0x007C4040, 0x7C40407C, 0x00404040, 0x5C404438, 0x00384444, 
	0x7C444444, 0x00444444, 0x10101038, 0x00381010, 0x0808081C, 0x00304848, 0x70484444, 0x00444448, 
	0x20202020, 0x003C2020, 0x92AAC682, 0x00828282, 0x54546444, 0x0044444C, 0x44444438, 0x00384444, 
	0x38242438, 0x00202020, 0x44444438, 0x0C384444, 0x78444478, 0x00444850, 0x38404438, 0x00384404, 
	0x1010107C, 0x00101010, 0x44444444, 0x00384444, 0x28444444, 0x00101028, 0x54828282, 0x00282854, 
	0x10284444, 0x00444428, 0x10284444, 0x00101010, 0x1008047C, 0x007C4020, 0x20202038, 0x00382020, 
	0x10204080, 0x00020408, 0x08080838, 0x00380808, 0x00442810, 0x00000000, 0x00000000, 0xFE000000, 
	0x00000810, 0x00000000, 0x3C043800, 0x003A4444, 0x24382020, 0x00582424, 0x201C0000, 0x001C2020, 
	0x48380808, 0x00344848, 0x44380000, 0x0038407C, 0x70202418, 0x00202020, 0x443A0000, 0x38043C44, 
	0x64584040, 0x00444444, 0x10001000, 0x00101010, 0x10001000, 0x60101010, 0x28242020, 0x00242830, 
	0x08080818, 0x00080808, 0x49B60000, 0x00414149, 0x24580000, 0x00242424, 0x44380000, 0x00384444, 
	0x24580000, 0x20203824, 0x48340000, 0x08083848, 0x302C0000, 0x00202020, 0x201C0000, 0x00380418, 
	0x10381000, 0x00101010, 0x48480000, 0x00344848, 0x44440000, 0x00102844, 0x82820000, 0x0044AA92, 
	0x28440000, 0x00442810, 0x24240000, 0x38041C24, 0x043C0000, 0x003C1008, 0x2010100C, 0x000C1010, 
	0x10101010, 0x00101010, 0x04080830, 0x00300808, 0x92600000, 0x0000000C, 0x243C1818, 0xA55A7E3C, 
	0x99FF5A81, 0x99663CFF, 0x10280000, 0x00000028, 0x10081020, 0x00081020

# scancode -> ascii
LabelScanCode:
#  	0     1     2     3     4     5     6     7     8     9     A     B     C     D     E     F
.byte 	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, # 00 a 0F
	0x00, 0x00, 0x00, 0x00, 0x00, 0x71, 0x31, 0x00, 0x00, 0x00, 0x7a, 0x73, 0x61, 0x77, 0x32, 0x00, # 10 a 1F 
	0x00, 0x63, 0x78, 0x64, 0x65, 0x34, 0x33, 0x00, 0x00, 0x20, 0x76, 0x66, 0x74, 0x72, 0x35, 0x00, # 20 a 2F  29 espaco => 20
	0x00, 0x6e, 0x62, 0x68, 0x67, 0x79, 0x36, 0x00, 0x00, 0x00, 0x6d, 0x6a, 0x75, 0x37, 0x38, 0x00, # 30 a 3F 
	0x00, 0x2c, 0x6b, 0x69, 0x6f, 0x30, 0x39, 0x00, 0x00, 0x2e, 0x2f, 0x6c, 0x3b, 0x70, 0x2d, 0x00, # 40 a 4F 
	0x00, 0x00, 0x27, 0x00, 0x00, 0x3d, 0x00, 0x00, 0x00, 0x00, 0x0A, 0x5b, 0x00, 0x5d, 0x00, 0x00, # 50 a 5F   5A enter => 0A (= ao Mars)
	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x31, 0x00, 0x34, 0x37, 0x00, 0x00, 0x00, # 60 a 6F 
	0x30, 0x2e, 0x32, 0x35, 0x36, 0x38, 0x00, 0x00,	0x00, 0x2b, 0x33, 0x2d, 0x2a, 0x39, 0x00, 0x00, # 70 a 7F 
	0x00, 0x00, 0x00, 0x00, 0x00, 0x00						   		# 80 a 85
# scancode -> ascii (com shift)
LabelScanCodeShift:
.byte   0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
	0x00, 0x00, 0x00, 0x00, 0x00, 0x51, 0x21, 0x00, 0x00, 0x00, 0x5a, 0x53, 0x41, 0x57, 0x40, 0x00, 
	0x00, 0x43, 0x58, 0x44, 0x45, 0x24, 0x23, 0x00, 0x00, 0x00, 0x56, 0x46, 0x54, 0x52, 0x25, 0x00, 
	0x00, 0x4e, 0x42, 0x48, 0x47, 0x59, 0x5e, 0x00, 0x00, 0x00, 0x4d, 0x4a, 0x55, 0x26, 0x2a, 0x00, 
	0x00, 0x3c, 0x4b, 0x49, 0x4f, 0x29, 0x28, 0x00, 0x00, 0x3e, 0x3f, 0x4c, 0x3a, 0x50, 0x5f, 0x00, 
	0x00, 0x00, 0x22, 0x00, 0x00, 0x2b, 0x00, 0x00, 0x00, 0x00, 0x00, 0x7b, 0x00, 0x7d, 0x00, 0x00, 
	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
	0x00, 0x00, 0x00, 0x00, 0x00, 0x00

instructionMessage:     .ascii  "   Instrucao    "
                        .asciiz "   Invalida!    "
#lixoBuffer:	.asciiz "  "
.align 2
#buffer do ReadString, ReadFloat, SDread, etc. 512 caracteres/bytes
TempBuffer:	.ascii  "                                                                                                                              "
		.ascii  "                                                                                                                              "
		.ascii  "                                                                                                                              "
		.asciiz "                                                                                                                              "
# Nome do arquivo que simula o cartao SD
#SDFile:		.asciiz "SDcard.bin"

# tabela de conversao hexa para ascii
TabelaHexASCII:		.asciiz "0123456789ABCDEF  "
NumDesnormP:		.asciiz "+desnorm"
NumDesnormN:		.asciiz "-desnorm"
NumZero:		.asciiz "0.00000000"
NumInfP:		.asciiz "+Infinity"
NumInfN:		.asciiz "-Infinity"
NumNaN:			.asciiz "NaN"

.align 2
# variaveis para implementar a fila de eventos de input
eventQueueBeginAddr:    .word 0x90000E00
eventQueueEndAddr:      .word 0x90001000
eventQueueBeginPtr:     .word 0x90000E00
eventQueueEndPtr:       .word 0x90000E00


##MOUSE
#DATA_X:         .word 0
#DATA_Y:         .word 0
#DATA_CLICKS:    .word 0

##### Preparado para considerar syscall similar a jal ktext  para o pipeline

### Obs.: a forma 'LABEL: instrução' embora fique feio facilita o debug no Mars, por favor não reformatar

.ktext
#	mfc0 $t0,$12
#	mfc0 $t0,$13
#	mfc0 $t0,$14
#	addi $t0,$t0,4
#	mtc0 $t0,$14
#	eret
	
# inicio do exception handler
exceptionHandling:  addi    $sp, $sp, -8 # aloca espaco 
    sw      $at, 0($sp)			# salva $at
    sw      $ra, 4($sp)			# salva $ra

    addi    $k0, $zero, 32              # default syscall exception=8*4
    mfc0    $k0, $13                    # nao esta implementada no pipeline, então usa o default 32
    nop                                 # nao retirar!
    andi    $k0, $k0, 0x007C		# mascarar 0000000001111100
    srl     $k0, $k0, 2			# retira os 2 bits iniciais

    addi    $k1, $zero, 8               # excecao de syscall
    beq     $k1, $k0, syscallException

    addi    $k1, $zero, 0               # interrupcoes
    beq     $k1, $k0, interruptException

    addi    $k1, $zero, 10              # excecao instrucao reservada ou invalida
    beq     $k1, $k0, instructionException

    addi    $k1, $zero, 12              # excecao overflow na ULA
    beq     $k1, $k0, ALUOverflowException

    addi    $k1, $zero, 15              # excecao de ponto flutuante
    beq     $k1, $k0, FPALUException
	
endException: 	lw    	$ra, 4($sp)		# recupera $ra
    		lw      $at, 0($sp)		# recupera $at
    		addi    $sp, $sp, 8		# libera espaco

    		mfc0    $k0, $14                # le EPC     //NOTE: nao esta implementada no pipe
    		addi    $k0, $k0, 4		# EPC+4
    		mtc0    $k0, $14                # move para EPC     // nao esta implementada no pipeline
    		eret                            # Retorna ao EPC - fim exception handler
    		nop

ALUOverflowException:   j endException  # escolhi nao fazer nada, ja que ate hoje nunca vi um SO tratar esse tipo de excecao...  by Matheus Pimenta

FPALUException:         j endException  # escolhi nao fazer nada, ja que ate hoje nunca vi um SO tratar esse tipo de excecao... by Matheus Pimenta

interruptException:     mfc0    $k0, $13  		# le o codigo da interrupcao
    			andi    $k0, $k0, 0xFF00	# mascara 1111111100000000
    			srl     $k0, $k0, 8		# desloca 8 bits

    		andi    $k1, $k0, 0x0001		# interrupcao 1 : Teclado - implementada mas desabilitada
    		bne     $k1, $zero, keyboardInterrupt

    		andi    $k1, $k0, 0x0002		# interrupcao 2 : Audio	- nao implementada
    		bne     $k1, $zero, audioInterrupt

    		andi    $k1, $k0, 0x0004		# interruopcao 4: Mouse	- nao implementada
    		bne     $k1, $zero, mouseInterrupt

    		andi    $k1, $k0, 0x0008            	# interrupcao 8: Watchdog - nao implementada
    		bne     $k1, $zero, counterInterrupt

    		andi $k1, $k0, 0x0010              	# interrupcao 16: do Keyboard and Display Interrupt Tool
    		bne $k1, $zero, KDMMIOInterrupt
	
    		j       endException	# se nao for nenhuma dessas finaliza o tratamento de excecao

KDMMIOInterrupt:  la $k1, KDMMIO_Ctrl		# carrega endereco de controle do buffer teclado
		lw $k0,4($k1)	            	# codigo ascii da tecla lida

		sw $k0,12($k1)	            	# imprime no Display <<<<<<<<<<<<<< Colocar aqui o que deve ser feito com a tecla lida		

		mfc0 $k0,$14  	            	# O Mars ja soma 4! Le o EPC
		addi $k0,$k0,-4	            	# Entao precisa tirar 4 do EPC pois vai somar 4 novamente no endException
		mtc0 $k0,$14 			# Coloca endereco no EPC
		j endException
	
counterInterrupt:   j endException      # nenhum tratamento para a interrupcao de contagem eh necessario ate agora

audioInterrupt:     j endException      # TODO: Implementar interrupcao de audio.

###########  Interrupcao do Mouse ################  Retirado e Comentado em 2017/2
mouseInterrupt:	    j endException   
#mouseInterrupt:     la      $k0, BufferMouse            # endereco do buffer_mouse
#    lw      $k0, 0($k0)                 # carrega o buffer em k0
#    andi    $k1, $k0, 0xFF
#
#    addi    $sp, $sp, -8
#    sw      $t0, 0($sp)
#    sw      $t1, 4($sp)
#
#    #default (supoe-se que seja o movimento do mouse)
#
#    ###atualiza os clicks
#    li      $k1, 0x00ff0000
#    and     $k1, $k0, $k1
#    srl     $k1, $k1, 16                # k1 tem o byte com info dos clicks e sinais de X/Y
#    andi    $t0, $k1, 1                 # $t0=botao esquerdo
#    li      $t1, 0
#    beq     $t0, $zero, MOUSEPULAESQ
#    li      $t1, 0xF
#
#MOUSEPULAESQ:     andi    $t0, $k1, 2
#    srl     $t0, $t0, 1                 # $t0=botao direito
#    beq     $t0, $zero, MOUSEPULADIR
#    ori     $t1, $t1, 0xF0
#
#MOUSEPULADIR:     andi    $t0, $k1, 4
#    srl     $t0, $t0, 2                 #$t0=botao do meio
#    beq     $t0, $zero, MOUSEPULAMEIO
#    ori     $t1, $t1, 0xF00
#MOUSEPULAMEIO:     sw      $t1, DATA_CLICKS($zero)     # FIXME: ENDERECO ERRADO!!!!!!!
#
#    ###atualiza o x
#    andi    $t0, $k1, 0x10
#    srl     $t0, $t0, 4                 #t0=(sinal)
#    la      $t1, 0x0000ff00
#    and     $t1, $t1, $k0
#    srl     $t1, $t1, 8
#    beq     $t0, $zero, pulasinalmousex
#    la      $t0, 0xffffff00
#    or      $t1, $t1, $t0
#
#pulasinalmousex:     lw      $t0, DATA_X($zero)          # FIXME: ENDERECO ERRADO
#    add     $t0, $t0, $t1
#    li      $t1, 320
#    slt     $t1, $t0, $t1
#    bne     $t1, $zero, mouseliberax320
#    li      $t0, 320
#
#mouseliberax320:     li      $t1, 0
#    slt     $t1, $t0, $t1
#    beq     $t1, $zero, mouseliberax0
#    li      $t0, 0
#
#mouseliberax0:     sw      $t0, DATA_X($zero)          # FIXME: ENDERECO ERRADO
#
#    ###atualiza o Y
#    andi    $t0, $k1, 0x20
#    srl     $t0, $t0, 5                 #t0=(sinal)
#    la      $t1, 0x000000ff
#    and     $t1, $t1, $k0
#    beq     $t0, $zero, pulasinalmousey
#    la      $t0, 0xffffff00
#    or      $t1, $t1, $t0
#
#    #t1=-delta y
#pulasinalmousey:     nor     $t1, $t1, $t1
#    addi    $t1, $t1, 1                 #t1=delta y
#    lw      $t0, DATA_Y($zero)          # FIXME: ENDERECO ERRADO
#    add     $t0, $t0, $t1
#    li      $t1, 240
#    slt     $t1, $t0, $t1
#    bne     $t1, $zero, mouseliberay240
#    li      $t0, 240
#
#mouseliberay240:     li      $t1, 0
#    slt     $t1, $t0, $t1
#    beq     $t1, $zero, mouseliberay0
#    li      $t0, 0
#
#mouseliberay0:     sw      $t0, DATA_Y($zero)          # FIXME: END ERRADO
#    lw      $t0, 0($sp)
#    lw      $t1, 4($sp)
#    addi    $sp, $sp, 8
#
#    j endException
#
#


################ Interrupcao do teclado da DE2 ##################
keyboardInterrupt: 	addi    $sp, $sp, -8  		# aloca espaco
    			sw      $a0, 0($sp)        	# salva $a0
    			sw      $v0, 4($sp)		# salva $v0
  	
    # verifica se ha espaco na fila comparando o incremento do ponteiro do fim da fila com o ponteiro do inicio
    	la      $a0, eventQueueEndPtr		# ponteiro da fila de eventos
    	lw      $a0, 0($a0)			# le o endereco da fila de eventos
    	jal     eventQueueIncrementPointer	#
    	la      $k0, eventQueueBeginPtr		#
    	lw      $k0, 0($k0)			#
    	beq     $k0, $v0, keyboardInterruptEnd	#

    	# FIXME: preparar o evento de teclado no registrador $k0
    	la      $k0, Buffer0Teclado			# carrega o endereco do Buffer0Teclado
    	lw      $k0, 0($k0)				# carrega o Buffer0
    	move    $t9, $k0				#

    	# poe o evento de teclado na fila
    	sw      $k0, 0($a0)
    	la      $k0, eventQueueEndPtr
	sw      $v0, 0($k0)

keyboardInterruptEnd:   lw      $a0, 0($sp)	# recupera $a0
    			lw      $v0, 4($sp)	# rercupera $v0
    			addi    $sp, $sp, 8 	# libera espaco
    			j       endException	# retorna

# $a0 = endereco (ou ponteiro) a ser incrementado. $v0 = valor incrementado
eventQueueIncrementPointer:     addi    $v0, $a0, 4
    				la      $t0, eventQueueEndAddr
    				lw      $t0, 0($t0)
    				beq     $t0, $v0, eventQueueIncrementPointerIf
    				jr      $ra

eventQueueIncrementPointerIf:   la      $v0, eventQueueBeginAddr
    				lw      $v0, 0($v0)
    				jr      $ra


########  Interrupcao de Instrucao Invalida  ###########
# mostra mensagem de erro no display LCD
#instructionException:   la      $t0, instructionMessage		# endereco da mensagem
#    			la      $t9, LCD_LINHA1			# endereco da 1 linha do LCD
#    			sw      $zero, 0x20($t9)		# Limpa o LCD
#    			lb      $t1, 0($t0)                 	# le primeiro caractere
#    			
#instructionExceptionLoop:	beq     $t1, $zero, instructionExceptionVGA     # se leu zero é o fim da string
#    				sb      $t1, 0($t9)				# mostra o caractere no LCD
#    				addi    $t0, $t0, 1				# endereco do proximo caractere a ser lido
#    				addi    $t9, $t9, 1				# endereco do proximo caractere a ser escrito
#    				lb      $t1, 0($t0)				# le o caractere
#    				j       instructionExceptionLoop		# proximo caracter
    				
 # mostra mensagem de erro no monitor VGA
instructionException: 	la 	$a0, instructionMessage		# endereco da mensagem
				li 	$a1, 0				# posicao X
  				li 	$a2, 0				# posicao Y
  				li 	$a3, 0x0F			# cor vermelho sobre preto
  				jal 	printString			# chama o printString
  				
  				mfc0 	$a0, $14			# recupera o EPC: Endereco onde ocorreu o erro
  				li 	$a1, 232			# posicao X
  				li 	$a2,0				# posicao Y
  				li 	$a3,0x0F			# cor vermelho sobre preto
  				jal 	printHex			# chama printHex
  				
  				j goToExit


############# interrupcao de SYSCALL ###################
syscallException:     addi    $sp, $sp, -264              # Salva todos os registradores na pilha
    sw      $1,     0($sp)
    sw      $2,     4($sp)
    sw      $3,     8($sp)
    sw      $4,    12($sp)
    sw      $5,    16($sp)
    sw      $6,    20($sp)
    sw      $7,    24($sp)
    sw      $8,    28($sp)
    sw      $9,    32($sp)
    sw      $10,   36($sp)
    sw      $11,   40($sp)
    sw      $12,   44($sp)
    sw      $13,   48($sp)
    sw      $14,   52($sp)
    sw      $15,   56($sp)
    sw      $16,   60($sp)
    sw      $17,   64($sp)
    sw      $18,   68($sp)
    sw      $19,   72($sp)
    sw      $20,   76($sp)
    sw      $21,   80($sp)
    sw      $22,   84($sp)
    sw      $23,   88($sp)
    sw      $24,   92($sp)
    sw      $25,   96($sp)
    sw      $26,  100($sp)
    sw      $27,  104($sp)
    sw      $28,  108($sp)
    sw      $29,  112($sp)
    sw      $30,  116($sp)
    sw      $31,  120($sp)
    swc1    $f0,  124($sp)
    swc1    $f1,  128($sp)
    swc1    $f2,  132($sp)
    swc1    $f3,  136($sp)
    swc1    $f4,  140($sp)
    swc1    $f5,  144($sp)
    swc1    $f6,  148($sp)
    swc1    $f7,  152($sp)
    swc1    $f8,  156($sp)
    swc1    $f9,  160($sp)
    swc1    $f10, 164($sp)
    swc1    $f11, 168($sp)
    swc1    $f12, 172($sp)
    swc1    $f13, 176($sp)
    swc1    $f14, 180($sp)
    swc1    $f15, 184($sp)
    swc1    $f16, 188($sp)
    swc1    $f17, 192($sp)
    swc1    $f18, 196($sp)
    swc1    $f19, 200($sp)
    swc1    $f20, 204($sp)
    swc1    $f21, 208($sp)
    swc1    $f22, 212($sp)
    swc1    $f23, 216($sp)
    swc1    $f24, 220($sp)
    swc1    $f25, 224($sp)
    swc1    $f26, 228($sp)
    swc1    $f27, 232($sp)
    swc1    $f28, 236($sp)
    swc1    $f29, 240($sp)
    swc1    $f30, 244($sp)
    swc1    $f31, 248($sp)
    # mthi, mtlo - 2015/1 (Salva os registradores HI e LO)
    mfhi    $k0
    sw      $k0, 252($sp)
    mflo    $k0
    sw      $k0, 256($sp)
    
    # Zera os valores dos registradores temporarios - 2015/1
    add     $t0, $zero, $zero
    add     $t1, $zero, $zero
    add     $t2, $zero, $zero
    add     $t3, $zero, $zero
    add     $t4, $zero, $zero
    add     $t5, $zero, $zero
    add     $t6, $zero, $zero
    add     $t7, $zero, $zero
    add     $t8, $zero, $zero
    add     $t9, $zero, $zero

# Verifica o o numero da chamada do sistema
    addi    $t0, $zero, 10
    beq     $t0, $v0, goToExit          # syscall exit
    addi    $t0, $zero, 110
    beq     $t0, $v0, goToExit          # syscall exit
    
    addi    $t0, $zero, 1               # sycall 1 = print int
    beq     $t0, $v0, goToPrintInt
    addi    $t0, $zero, 101             # sycall 1 = print int
    beq     $t0, $v0, goToPrintInt

    addi    $t0, $zero, 2               # syscall 2 = print float
    beq     $t0, $v0, goToPrintFloat
    addi    $t0, $zero, 102             # syscall 2 = print float
    beq     $t0, $v0, goToPrintFloat

    addi    $t0, $zero, 4               # syscall 4 = print string
    beq     $t0, $v0, goToPrintString
    addi    $t0, $zero, 104             # syscall 4 = print string
    beq     $t0, $v0, goToPrintString

    addi    $t0, $zero, 5               # syscall 5 = read int
    beq     $t0, $v0, goToReadInt
    addi    $t0, $zero, 105             # syscall 5 = read int
    beq     $t0, $v0, goToReadInt

    addi    $t0, $zero, 6               # syscall 6 = read float
    beq     $t0, $v0, goToReadFloat
    addi    $t0, $zero, 106             # syscall 6 = read float
    beq     $t0, $v0, goToReadFloat

    addi    $t0, $zero, 8               # syscall 8 = read string
    beq     $t0, $v0, goToReadString
    addi    $t0, $zero, 108             # syscall 8 = read string
    beq     $t0, $v0, goToReadString

    addi    $t0, $zero, 11              # syscall 11 = print char
    beq     $t0, $v0, goToPrintChar
    addi    $t0, $zero, 111             # syscall 11 = print char
    beq     $t0, $v0, goToPrintChar

    addi    $t0, $zero, 12              # syscall 12 = read char
    beq     $t0, $v0, goToReadChar
    addi    $t0, $zero, 112             # syscall 12 = read char
    beq     $t0, $v0, goToReadChar

    addi    $t0, $zero, 30              # syscall 30 = time
    beq     $t0, $v0, goToTime
    addi    $t0, $zero, 130             # syscall 30 = time
    beq     $t0, $v0, goToTime
    
    addi    $t0, $zero, 32              # syscall 32 = sleep
    beq     $t0, $v0, goToSleep
    addi    $t0, $zero, 132             # syscall 32 = sleep
    beq     $t0, $v0, goToSleep

    addi    $t0, $zero, 41              # syscall 41 = random
    beq     $t0, $v0, goToRandom
    addi    $t0, $zero, 141             # syscall 41 = random
    beq     $t0, $v0, goToRandom

    addi    $t0, $zero, 34       	# syscall 34 = print hex
    beq     $t0, $v0, goToPrintHex
    addi    $t0, $zero, 134		# syscall 41 = print hex
    beq     $t0, $v0, goToPrintHex
    
    addi    $t0, $zero, 31              # syscall 31 = MIDI out
    beq     $t0, $v0, goToMidiOut       # Generate tone and return immediately
    addi    $t0, $zero, 131             # syscall 31 = MIDI out
    beq     $t0, $v0, goToMidiOut

    addi    $t0, $zero, 33              # syscall 33 = MIDI out synchronous
    beq     $t0, $v0, goToMidiOutSync   # Generate tone and return upon tone completion
    addi    $t0, $zero, 133             # syscall 33 = MIDI out synchronous
    beq     $t0, $v0, goToMidiOutSync

#    addi    $t0, $zero, 49              # syscall 49 = SD Card read
#    beq     $t0, $v0, goToSDread
#    addi    $t0, $zero, 149              # syscall 49 = SD Card read
#    beq     $t0, $v0, goToSDread

    addi    $t0, $zero, 48              # syscall 48 = CLS
    beq     $t0, $v0, goToCLS
    addi    $t0, $zero, 148              # syscall 48 = CLS
    beq     $t0, $v0, goToCLS
    
    addi    $t0, $zero, 150             # syscall 150 = pop event
    beq     $t0, $v0, goToPopEvent


endSyscall:	lw	$1, 0($sp)  # recupera QUASE todos os registradores na pilha
#   lw	    $2,   4($sp)	# $v0 retorno de valor
#   lw 	    $3,   8($sp)	# $v1 retorno de valor
#   lw	    $4,  12($sp)      	# $a0 as vezes usado como retorno de valor
#   lw	    $5,  16($sp)      	# $a1 
    lw	    $6,  20($sp)	
    lw      $7,  24($sp)
    lw 	    $8,  28($sp)
    lw      $9,    32($sp)
    lw      $10,   36($sp)
    lw      $11,   40($sp)
    lw      $12,   44($sp)
    lw      $13,   48($sp)
    lw      $14,   52($sp)
    lw      $15,   56($sp)
    lw      $16,   60($sp)
    lw      $17,   64($sp)
    lw      $18,   68($sp)
    lw      $19,   72($sp)
    lw      $20,   76($sp)
    lw      $21,   80($sp)
    lw      $22,   84($sp)
    lw      $23,   88($sp)
    lw      $24,   92($sp)
    lw      $25,   96($sp)
    lw      $26,  100($sp)
    lw      $27,  104($sp)
    lw      $28,  108($sp)
    lw      $29,  112($sp)
    lw      $30,  116($sp)
    lw      $31,  120($sp)
#   lwc1    $0,   124($sp) 	# $f0 retorno de valor
    lwc1    $f1,  128($sp)
    lwc1    $f2,  132($sp)
    lwc1    $f3,  136($sp)
    lwc1    $f4,  140($sp)
    lwc1    $f5,  144($sp)
    lwc1    $f6,  148($sp)
    lwc1    $f7,  152($sp)
    lwc1    $f8,  156($sp)
    lwc1    $f9,  160($sp)
    lwc1    $f10, 164($sp)
    lwc1    $f11, 168($sp)
    lwc1    $f12, 172($sp)
    lwc1    $f13, 176($sp)
    lwc1    $f14, 180($sp)
    lwc1    $f15, 184($sp)
    lwc1    $f16, 188($sp)
    lwc1    $f17, 192($sp)
    lwc1    $f18, 196($sp)
    lwc1    $f19, 200($sp)
    lwc1    $f20, 204($sp)
    lwc1    $f21, 208($sp)
    lwc1    $f22, 212($sp)
    lwc1    $f23, 216($sp)
    lwc1    $f24, 220($sp)
    lwc1    $f25, 224($sp)
    lwc1    $f26, 228($sp)
    lwc1    $f27, 232($sp)
    lwc1    $f28, 236($sp)
    lwc1    $f29, 240($sp)
    lwc1    $f30, 244($sp)
    lwc1    $f31, 248($sp)
    # mthi, mtlo - 2015/1 (Recupera os registradores HI e LO)
    lw      $k0,  252($sp)
    mthi    $k0
    lw      $k0,  256($sp)
    mtlo    $k0			# $k0 fica com lixo mesmo
    
    addi    $sp, $sp, 264
    j endException


goToExit:   	DE2(goToExitDE2)	# se for a DE2
  		li 	$v0, 10		# chama o syscal normal do Mars
  		syscall			# exit syscall
  		
goToExitDE2:	j       goToExitDE2     ########### syscall 10 ou 110

goToPrintInt:	jal     printInt               	# chama printInt
		j       endSyscall

goToPrintString: jal     printString           	# chama printString
    		j       endSyscall

goToPrintChar:	jal     printChar		# chama printChar
    		j       endSyscall

goToPrintFloat:	jal     printFloat		# chama printFloat
    		j       endSyscall

goToReadChar:	jal     readChar              	# chama readChar
    		j       endSyscall

goToReadInt:   	jal     readInt                 # chama readInt
    		j       endSyscall

goToReadString:	jal     readString              # chama readString
    		j       endSyscall

goToReadFloat:	jal     readFloat               # chama readFloat
		j       endSyscall

goToPrintHex:	jal     printHex                # chama printHex
		j       endSyscall
	
goToMidiOut:	jal     midiOut                 # chama MIDIout
    		j       endSyscall

goToMidiOutSync:     	jal     midiOutSync   	# chama MIDIoutSync
    			j       endSyscall

#goToSDread:     jal     sdRead                  # Chama sdRead
#    		j       endSyscall

goToPopEvent:	jal     popEvent                # chama popEvent
    		j       endSyscall

goToTime:	jal     time                    # chama time
    		j       endSyscall

goToSleep:	jal     sleep                  	# chama sleep
		j       endSyscall

goToRandom:	jal     random                 	# chama random
    		j       endSyscall

goToCLS:	jal     clsCLS                 	# chama CLS
    		j       endSyscall
    		
####################################################################################################

#############################################
#  PrintInt                                 #
#  $a0    =    valor inteiro                #
#  $a1    =    x                            #
#  $a2    =    y  			    #
#  $a3    =    cor                          #
#############################################

printInt:	addi 	$sp, $sp, -4			# Aloca espaco
		sw 	$ra, 0($sp)			# salva $ra
		la 	$t0, TempBuffer			# carrega o Endereco do Buffer da String
		
		bge 	$a0, $zero, ehposprintInt	# Se eh positvo
		li 	$t1, '-'			# carrega o sinal -
		sb 	$t1, 0($t0)			# coloca no buffer
		addi 	$t0, $t0, 1			# incrementa endereco do buffer
		sub 	$a0, $zero, $a0			# torna o numero positivo
		
ehposprintInt:  li 	$t2, 10				# carrega numero 10
		li 	$t1, 0				# carrega numero de digitos com 0
		
loop1printInt:	div 	$a0, $t2			# divide por 10
		mfhi 	$t3				# resto
		mflo 	$t4				# quociente
		addi 	$sp, $sp, -4			# aloca espaco na pilha
		sw 	$t3, 0($sp)			# coloca resto na pilha
		move 	$a0, $t4			# atualiza o numero com o quociente
		addi 	$t1, $t1, 1			# incrementa o contador de digitos
		bne 	$a0, $zero, loop1printInt	# verifica se o numero eh zero
				
loop2printInt:	lw 	$t2, 0($sp)			# le digito da pilha
		addi 	$sp, $sp, 4			# libera espaco
		addi 	$t2, $t2, 48			# converte o digito para ascii
		sb 	$t2, 0($t0)			# coloca caractere no buffer
		addi 	$t0, $t0, 1			# incrementa endereco do buffer
		addi 	$t1, $t1, -1			# decrementa contador de digitos
		bne 	$t1, $zero, loop2printInt	# eh o ultimo?
		sb 	$zero, 0($t0)			# insere \NULL na string
		
		la 	$a0, TempBuffer			# Endereco do buffer da srting
		jal 	printString			# chama o print string
				
		lw 	$ra, 0($sp)			# recupera $a
		addi 	$sp, $sp, 4			# libera espaco
fimprintInt:	jr 	$ra				# retorna
		


#############################################
#  PrintHex                                 #
#  $a0    =    valor inteiro                #
#  $a1    =    x                            #
#  $a2    =    y                            #
#  $a3    =    cor			    #
#############################################

printHex:	addi    $sp, $sp, -4    		# aloca espaco
    		sw      $ra, 0($sp)			# salva $ra
		move 	$t0, $a0			# Inteiro de 32 bits a ser impresso em Hexa
		la 	$t1, TabelaHexASCII		# endereco da tabela HEX->ASCII
		la 	$t2, TempBuffer			# onde a string sera montada

		li 	$t3,'0'			# Caractere '0'
		sb 	$t3,0($t2)		# Escreve '0' no Buffer da String
		li 	$t3,'x'			# Caractere 'x'
		sb 	$t3,1($t2)		# Escreve 'x' no Buffer da String
		addi 	$t2,$t2,2		# novo endereco inicial da string

		li 	$t3, 28			# contador de nibble   inicio = 28
loopprintHex:	blt 	$t3, $zero, fimloopprintHex	# terminou? $t3<0?
		srlv 	$t4, $t0, $t3		# desloca o nibble para direita
		andi 	$t4, $t4, 0x000F	# mascara o nibble	
		add 	$t4, $t1, $t4		# endereco do ascii do nibble
		lb 	$t4, 0($t4)		# le ascii do nibble
		sb 	$t4, 0($t2)		# armazena o ascii do nibble no buffer da string
		addi 	$t2, $t2, 1		# incrementa o endereco do buffer
		addi 	$t3, $t3, -4		# decrementa o numero do nibble
		j 	loopprintHex
		
fimloopprintHex: sb 	$zero,0($t2)		# grava \null na string
		la 	$a0, TempBuffer		# Argumento do print String
    		jal	printString		# Chama o print string
    			
		lw 	$ra, 0($sp)		# recupera $ra
		addi 	$sp, $sp, 4		# libera espaco
fimprintHex:	jr 	$ra			# retorna


#####################################
#  PrintSring                       #
#  $a0    =  endereco da string     #
#  $a1    =  x                      #
#  $a2    =  y                      #
#  $a3    =  cor		    #
#####################################

printString:	addi	$sp, $sp, -8			# aloca espaco
    		sw	$ra, 0($sp)			# salva $ra
    		sw	$s0, 4($sp)			# salva $s0
    		move	$s0, $a0              		# $s0 = endereco do caractere na string

loopprintString: lb	$a0, 0($s0)                 	# le em $a0 o caracter a ser impresso
    		beq     $a0, $zero, fimloopprintString   # string ASCIIZ termina com NULL

    		jal     printChar       		# imprime char
    		
		addi    $a1, $a1, 8                 	# incrementa a coluna		
		blt	$a1, 313, NaoPulaLinha	    	# se ainda tiver lugar na linha
    		addi    $a2, $a2, 8                 	# incrementa a linha
    		move    $a1, $zero			# volta a coluna zero

NaoPulaLinha:	addi    $s0, $s0, 1			# proximo caractere
    		j       loopprintString       		# volta ao loop

fimloopprintString:	lw      $ra, 0($sp)    		# recupera $ra
			lw 	$s0, 0($sp)		# recupera $s0
    			addi    $sp, $sp, 8		# libera espaco
fimprintString:		jr      $ra             	# retorna


#########################################################
#  PrintChar                                            #
#  $a0 = char(ASCII)                                    #
#  $a1 = x                                              #
#  $a2 = y                                              #
#########################################################
#   $t0 = i                                             #
#   $t1 = j                                             #
#   $t2 = endereco do char na memoria                   #
#   $t3 = metade do char (2a e depois 1a)               #
#   $t4 = endereco para impressao                       #
#   $t5 = background color                              #
#   $t6 = foreground color                              #
#   $t7 = 2                                             #
#########################################################


printChar:     andi    $t5, $a3, 0xFF00         # cor fundo
    	andi    $t6, $a3, 0x00FF             	# cor frente
    	srl     $t5, $t5, 8			# numero da cor de fundo

	blt 	$a0, ' ', NAOIMPRIMIVEL		# ascii menor que 32 nao eh imprimivel
	bgt	$a0, '~', NAOIMPRIMIVEL		# ascii Maior que 126  nao eh imprimivel
    	j       IMPRIMIVEL
    
NAOIMPRIMIVEL:     li      $a0, 32		# Imprime espaco

IMPRIMIVEL:	li	$at, NUMCOLUNAS		# Num colunas 320
    	mult    $at, $a2			# multiplica $a2x320
    	mflo    $t4				# $t4 = coordenada y
    	add     $t4, $t4, $a1               	# $t4 = 320*y + x
    	addi    $t4, $t4, 7                 	# t4 = 320*y + (x+7)
    	la      $t8, VGAADDRESSINI          	# Endereco de inicio da memoria VGA
    	add     $t4, $t4, $t8               	# t4 = endereco de impressao do ultimo pixel da primeira linha do char
    	addi    $t2, $a0, -32               	# indice do char na memoria
    	sll     $t2, $t2, 3                 	# offset em bytes em relacao ao endereco inicial
	la      $t3, LabelTabChar		# endereco dos caracteres na memoria
    	add     $t2, $t2, $t3               	# endereco do caractere na memoria
	lw      $t3, 0($t2)                 	# carrega a primeira word do char
	li 	$t0, 4				# i=4

forChar1I:	beq     $t0, $zero, endForChar1I	# if(i == 0) end for i
    		addi    $t1, $zero, 8               	# j = 8

	forChar1J:      beq     $t1, $zero, endForChar1J    	# if(j == 0) end for j
        		andi    $t9, $t3, 0x0001		# primeiro bit do caracter
        		srl     $t3, $t3, 1             	# retira o primeiro bit
        		beq     $t9, $zero, printCharPixelbg1	# pixel eh fundo?
        		sb      $t6, 0($t4)             	# imprime pixel com cor de frente
        		j       endCharPixel1
printCharPixelbg1:     	sb      $t5, 0($t4)                 	# imprime pixel com cor de fundo
endCharPixel1:     	addi    $t1, $t1, -1                	# j--
    			addi    $t4, $t4, -1                	# t4 aponta um pixel para a esquerda
    			j       forChar1J			# vollta novo pixel

endForChar1J: 	addi    $t0, $t0, -1 		# i--
    		addi    $t4, $t4, 328           # 2**12 + 8
    		j       forChar1I		# volta ao loop

endForChar1I:	lw      $t3, 4($t2)           	# carrega a segunda word do char
		li 	$t0, 4			# i = 4
forChar2I:     	beq     $t0, $zero, endForChar2I    	# if(i == 0) end for i
    		addi    $t1, $zero, 8               # j = 8

	forChar2J:	beq	$t1, $zero, endForChar2J    	# if(j == 0) end for j
        		andi    $t9, $t3, 0x0001	    	# pixel a ser impresso
        		srl     $t3, $t3, 1                 	# desloca para o proximo
        		beq     $t9, $zero, printCharPixelbg2	# pixel eh fundo?
        		sb      $t6, 0($t4)			# imprime cor frente
        		j       endCharPixel2			# volta ao loop

printCharPixelbg2:     	sb      $t5, 0($t4)			# imprime cor de fundo

endCharPixel2:     	addi    $t1, $t1, -1			# j--
    			addi    $t4, $t4, -1                	# t4 aponta um pixel para a esquerda
    			j       forChar2J

endForChar2J:	addi	$t0, $t0, -1 		# i--
    		addi    $t4, $t4, 328		#
    		j       forChar2I		# volta ao loop

endForChar2I:	jr $ra				# retorna


#########################################
# ReadChar           			#
# $v0 = valor ascii da tecla   		#
# 2017/2  				#
######################################### 

readChar:	DE2(readCharKDMMIODE2)

##### Tratamento para uso com o Keyboard Display MMIO Tool do Mars
readCharKDMMIO:		la 	$t0, KDMMIO_Ctrl			# Execucao com Polling do KD MMIO

loopReadCharKDMMIO:  	lw     	$v0, 0($t0)   			# le o bit de flag do teclado
			andi 	$v0, $v0, 0x0001		# masacara bit 0
			beq     $v0, $zero, loopReadCharKDMMIO  # testa se uma tecla foi pressionada
    			lw 	$v0, 4($t0)			# le o ascii da tecla pressionada
			j fimreadChar				# fim Read Char


##### Tratamento para uso com o Keyboard Display MMIO Tool na DE2 usando o KDMMIO
readCharKDMMIODE2:	la 	$t0, KDMMIO_Ctrl			# Execucao com Polling do KD MMIO

loopReadCharKDMMIODE2: 	lw     	$v0, 0($t0)   			# le o bit de flag do teclado
			andi 	$v0, $v0, 0x0001		# masacara bit 0
			beq     $v0, $zero, loopReadCharKDMMIODE2  # testa se uma tecla foi pressionada
    			lw 	$v0, 4($t0)			# le o ascii da tecla pressionada
			j fimreadChar				# fim Read Char

						
												
##### Tratamento para uso com o teclado PS2 da DE2 usando Buffer0 teclado
#### muda $v0, $t0,$t1,$t2,$t3 e $fp
#### Cuidar: ao entrar $fp ja deve conter o endereco la $fp,LabelScanCode  #####
readCharDE2:  	la      $t0, Buffer0Teclado 			# Endereco buffer0
    		lw     	$t1, 0($t0)				# conteudo inicial do buffer
	
loopReadChar:  	lw     	$t2, 0($t0)   				# le buffer teclado
		bne     $t2, $t1, buffermodificadoChar    	# testa se o buffer foi modificado

atualizaBufferChar:  move $t1, $t2			# atualiza o buffer com o novo valor
    	j       loopReadChar				# loop de printicpal de leitura 

buffermodificadoChar:    andi    $t3, $t2, 0xFF00 	# mascara o 2o scancode
	beq     $t3, 0XF000, teclasoltaChar		# eh 0xF0 no 2o scancode? tecla foi solta
	andi	$t3, $t2, 0xFF				# mascara 1o scancode
    	bne 	$t3, 0x12, atualizaBufferChar		# nao eh o SHIFT que esta pressionado ? volta a ler 
	la      $fp, LabelScanCodeShift			# se for SHIFT que esta pressionado atualiza o endereco da tabel
    	j       atualizaBufferChar			# volta a ler

teclasoltaChar:		andi $t3, $t2, 0x00FF		# mascara o 1o scancode
  	bgt	$t3, 0x80, atualizaBufferChar		# se o scancode for > 0x80 entao nao eh imprimivel!
	bne 	$t3, 0x12, naoehshiftChar		# nao foi o shift que foi solto? entao processa
	la 	$fp, LabelScanCode			# shift foi solto atualiza o endereco da tabela
	j 	atualizaBufferChar			# volta a ler
	
naoehshiftChar:	   	add     $t3, $fp, $t3                   	# endereco na tabela de scancode da tecla com ou sem shift
    	lb      $v0, 0($t3)				# le o ascii do caracter para $v0
    	beq     $v0, $zero, atualizaBufferChar		# se for caractere nao imprimivel volta a ler
    	
fimreadChar: 	jr   $ra				# retorna
	
#########################################
#    ReadString         	 	#
# $a0 = end Inicio      	 	#
# $a1 = tam Max String 		 	#
# $v0 = end do ultimo caractere	 	#
# $v1 = num de caracteres digitados	#
# 2017/2                		#
#########################################
# muda $v0, $v1, $a0 e $fp  

readString: 	addi 	$sp, $sp, -4			# reserva espaco na pilha
		sw 	$ra, 0($sp)			# salva $ra
		li 	$v1, 0				# zera o contador de caracteres digitados
    		la      $fp, LabelScanCode      	# Endereco da tabela de scancode inicial para readChar
    		
loopreadString: beq 	$a1, $v1, fimreadString   	# buffer cheio fim
		move 	$t9, $ra			# salva $ra
		jal 	readChar			# le um caracter do teclado (retorno em $v0)
		move 	$ra, $t9			# recupera $ra
		beq 	$v0, 0x0A, fimreadString	# se for tecla ENTER fim
		sb 	$v0, 0($a0)			# grava no buffer
		addi 	$v1, $v1, 1			# incrementa contador
		addi 	$a0, $a0, 1			# incrementa endereco no buffer
		j loopreadString			# volta a ler outro caractere
	
fimreadString: 	sb 	$zero, 0($a0)			# grava NULL no buffer
		addi 	$v0, $a0, -1			# Para que $v0 tenha o endereco do ultimo caractere digitado
		lw 	$ra, 0($sp)			# recupera $ra
		addi 	$sp, $sp, 4			# libera espaco
		jr 	$ra				# retorna
	
	
###########################
#    ReadInt              #
# $v0 = valor do inteiro  #
#                         #
###########################

readInt: 	addi 	$sp,$sp,-4		# reserva espaco na pilha
	sw 	$ra, 0($sp)			# salva $ra
	la 	$a0, TempBuffer			# Endereco do buffer de string
	li 	$a1, 10				# numero maximo de digitos
	jal 	readString			# le uma string de ate 10 digitos, $v1 numero de digitos
	move 	$t0, $v0			# copia endereco do ultimo digito
	li 	$t2, 10				# dez
	li 	$t3, 1				# dezenas, centenas, etc
	move 	$v0, $zero			# zera o numero
	
loopReadInt: 	beq	$v1,$zero, fimReadInt	# Leu todos os digitos
	lbu 	$t1, ($t0)			# le um digito
	beq 	$t1, 0x2d, ehnegReadInt		# = '-'
	beq 	$t1, 0x2b, ehposReadInt		# = '+'
	blt 	$t1, 0x30, naoehReadInt		# <'0'
	bgt 	$t1, 0x39, naoehReadInt		# >'9'
	addi 	$t1, $t1, -48			# transforma ascii em numero
	mult 	$t1, $t3			# multiplica por dezenas/centenas
	mflo 	$t1				# resultado LO da mult
	add 	$v0, $v0, $t1			# soma no numero
	mult 	$t3, $t2			# proxima dezena/centena
	mflo 	$t3				# resultado LO da mult
	addi 	$t0, $t0, -1			# busca o digito anterior
	addi	$v1, $v1, -1			# reduz o contador de digitos 
	j loopReadInt				# volta para buscar proximo digito

naoehReadInt:	j instructionException		# gera erro "instruçao" invalida

ehnegReadInt:	sub $v0,$zero,$v0		# se for negativo

ehposReadInt:					# se for positivo só retorna

fimReadInt:	lw 	$ra, 0($sp)		# recupera $ra
	addi 	$sp, $sp, 4			# libera espaco
	jr 	$ra				# fim ReadInt


###########################################
#        MidiOut 31 (2015/1)              #
#  $a0 = pitch (0-127)                    #
#  $a1 = duration in milliseconds         #
#  $a2 = instrument (0-15)                #
#  $a3 = volume (0-127)                   #
###########################################


#################################################################################################
#
# Note Data           = 32 bits     |   1'b - Melody   |   4'b - Instrument   |   7'b - Volume   |   7'b - Pitch   |   1'b - End   |   1'b - Repeat   |   11'b - Duration   |
#
# Note Data (Syscall) = 32 bits     |   1'b - Melody   |   4'b - Instrument   |   7'b - Volume   |   7'b - Pitch   |   13'b - Duration   |
#
#################################################################################################
midiOut: DE2(midiOutDE2)
	li $v0,31		# Chama o syscall normal
	syscall
	j fimmidiOut

midiOutDE2:	la      $t0, NoteData
    		add     $t1, $zero, $zero

    		# Melody = 0

    		# Definicao do Instrumento
   	 	andi    $t2, $a2, 0x0000000F
    		sll     $t2, $t2, 27
    		or      $t1, $t1, $t2

    		# Definicao do Volume
    		andi    $t2, $a3, 0x0000007F
    		sll     $t2, $t2, 20
    		or      $t1, $t1, $t2

    		# Definicao do Pitch
    		andi    $t2, $a0, 0x0000007F
    		sll     $t2, $t2, 13
    		or      $t1, $t1, $t2

    		# Definicao da Duracao
    		andi    $t2, $a1, 0x00001FFF
    		or      $t1, $t1, $t2

    		# Guarda a definicao da duracao da nota na Word 1
    		j       SintMidOut

SintMidOut:	sw	$t1, 0($t0)

	    		# Verifica a subida do clock AUD_DACLRCK para o sintetizador receber as definicoes
	    		la      $t2, NoteClock
Check_AUD_DACLRCK:     	lw      $t3, 0($t2)
    			beq     $t3, $zero, Check_AUD_DACLRCK

fimmidiOut:    		jr      $ra

###########################################
#        MidiOut 33 (2015/1)              #
#  $a0 = pitch (0-127)                    #
#  $a1 = duration in milliseconds         #
#  $a2 = instrument (0-127)               #
#  $a3 = volume (0-127)                   #
###########################################

#################################################################################################
#
# Note Data             = 32 bits     |   1'b - Melody   |   4'b - Instrument   |   7'b - Volume   |   7'b - Pitch   |   1'b - End   |   1'b - Repeat   |   8'b - Duration   |
#
# Note Data (Syscall)   = 32 bits     |   1'b - Melody   |   4'b - Instrument   |   7'b - Volume   |   7'b - Pitch   |   13'b - Duration   |
#
#################################################################################################
midiOutSync: DE2(midiOutSyncDE2)
	li $v0,33		# Chama o syscall normal
	syscall
	j fimmidiOutSync
	
midiOutSyncDE2:	la      $t0, NoteData
    		add     $t1, $zero, $zero

    		# Melody = 1
    		ori     $t1, $t1, 0x80000000

    		# Definicao do Instrumento
    		andi    $t2, $a2, 0x0000000F
    		sll     $t2, $t2, 27
    		or      $t1, $t1, $t2

    		# Definicao do Volume
    		andi    $t2, $a3, 0x0000007F
    		sll     $t2, $t2, 20
    		or      $t1, $t1, $t2

    		# Definicao do Pitch
    		andi    $t2, $a0, 0x0000007F
    		sll     $t2, $t2, 13
    		or      $t1, $t1, $t2

    		# Definicao da Duracao
    		andi    $t2, $a1, 0x00001FFF
    		or      $t1, $t1, $t2

    		# Guarda a definicao da duracao da nota na Word 1
    		j       SintMidOutSync

SintMidOutSync:	sw	$t1, 0($t0)

    		# Verifica a subida do clock AUD_DACLRCK para o sintetizador receber as definicoes
    		la      $t2, NoteClock
    		la      $t4, NoteMelody

Check_AUD_DACLRCKSync:	lw      $t3, 0($t2)
    			beq     $t3, $zero, Check_AUD_DACLRCKSync

Melody:     	lw      $t5, 0($t4)
    		bne     $t5, $zero, Melody

fimmidiOutSync:	jr      $ra


#################################
#    Pop event                  #
#  $v0 = sucesso ? 1 : 0        #
#  $v1 = evento                 #
#################################

popEvent:     addi    $sp, $sp, -12
    sw      $a0, 0($sp)
    sw      $s0, 4($sp)
    sw      $ra, 8($sp)

    # verifica se ha eventos na fila comparando os ponteiros de inicio e fim
    la      $s0, eventQueueBeginPtr
    lw      $k0, 0($s0)
    la      $k1, eventQueueEndPtr
    lw      $k1, 0($k1)
    li      $v0, 0
    beq     $k0, $k1, popEventEnd

    # tira o evento da fila e coloca em $v1
    move    $a0, $k0
    jal     eventQueueIncrementPointer
    sw      $v0, 0($s0)
    li      $v0, 1
    lw      $v1, 0($k0)

popEventEnd:     lw      $ra, 8($sp)
    lw      $s0, 4($sp)
    lw      $a0, 0($sp)
    addi    $sp, $sp, 12
    jr      $ra




#################################
# printFloat                    #
# imprime Float em $f12         #
# na posicao ($a1,$a2)	cor $a3 #
#################################


printFloat:	addi 	$sp, $sp, -4
		sw 	$ra, 0($sp)
		la 	$s0, TempBuffer

		# Encontra o sinal do número e coloca no Buffer
		li 	$t0, '+'			# define sinal '+'
		mfc1 	$s1, $f12			# recupera o numero float
		andi 	$s1, $s1, 0x80000000		# mascara com 1000
		beq 	$s1, $zero, ehposprintFloat	# eh positivo $s0=0
		li 	$s1, 1				# numero eh negativo $s0=1
		li 	$t0, '-'			# define sinal '-'
ehposprintFloat: sb 	$t0, 0($s0)			# coloca sinal no buffer
		addi 	$s0, $s0,1			# incrementa o endereco do buffer

		# Encontra o expoente em $t0
		 mfc1 	$t0, $f12			# recupera o numero float
		 andi 	$t0, $t0, 0x7F800000   		# mascara com 0111 1111 1000 0000 0000 0000...
		 sll 	$t0, $t0, 1			# tira o sinal do numero
		 srl 	$t0, $t0, 24			# recupera o expoente

		# Encontra a fracao em $t1
		mfc1 	$t1, $f12			# recupera o numero float 
		andi 	$t1, $t1, 0x007FFFFF		# mascara com 0000 0000 0111 1111 1111... 		 
			 
		beq 	$t0, $zero, ehExp0printFloat	# Expoente = 0
		beq 	$t0, 255, ehExp255printFloat	# Expoente = 255
		
		# Eh um numero float normal  $t0 eh o expoente e $t1 eh a mantissa
		# Encontra o E tal que 10^E <= x <10^(E+1)
		abs.s 	$f0, $f12		# $f0 recebe o módulo  de x
		lui 	$t0, 0x3F80
		mtc1 	$t0, $f1		# $f1 recebe o numero 1.0
		lui 	$t0, 0x4120
		mtc1 	$t0, $f10		# $f10 recebe o numero 10.0
		
		c.lt.s 	1, $f0, $f1		# $f0 < 1.0 ? Flag 1 indica se $f0<1 ou seja E deve ser negativo
		bc1t 	1, menor1printFloat
		mov.s 	$f2, $f10		# $f2  fator de multiplicaçao = 10
		j 	cont2printFloat		# vai para expoente positivo
menor1printFloat: div.s $f2,$f1,$f10		# $f2 fator multiplicativo = 0.1

			# calcula o expoente negativo de 10
cont1printFloat: 	mov.s 	$f4, $f0			# inicia com o numero x 
		 	mov.s 	$f3, $f1			# contador começa em 1
loop1printFloat: 	div.s 	$f4, $f4, $f2			# divide o numero pelo fator multiplicativo
		 	c.le.s 	0, $f4, $f1			# o numero eh > que 1? entao fim
		 	bc1f 	0, fimloop1printFloat
		 	add.s 	$f3, $f3, $f1			# incrementa o contador
		 	j 	loop1printFloat			# volta ao loop
fimloop1printFloat: 	div.s 	$f4, $f4, $f2			# ajusta o numero
		 	j 	intprintFloat			# vai para imprimir a parte inteira

			# calcula o expoente positivo de 10
cont2printFloat:	mov.s 	$f4, $f0			# inicia com o numero x 
		 	mtc1 	$zero, $f3			# contador começa em 0
loop2printFloat:  	c.lt.s 	0, $f4, $f10			# resultado eh < que 10? entao fim
		 	div.s 	$f4, $f4, $f2			# divide o numero pelo fator multiplicativo
		 	bc1t 	0 ,intprintFloat
		 	add.s 	$f3, $f3, $f1			# incrementa o contador
		 	j 	loop2printFloat

		# Neste ponto tem-se no flag 1 se $f0<1, em $f3 o expoente de 10 e $f0 0 módulo do numero e $s1 o sinal
		# e em $f4 um número entre 1 e 10 que multiplicado por E$f3 deve voltar ao numero		
		
	  		# imprime parte inteira (o sinal já está no buffer)
intprintFloat:		mul.s 		$f4, $f4, $f2		# ajusta o numero
		  	floor.w.s 	$f5, $f4		# menor inteiro
		  	mfc1 		$t0, $f5		# passa para $t5
		  	addi 		$t0, $t0, 48		# converte para ascii
		  	sb 		$t0, 0($s0)		# coloca no buffer
		  	addi 		$s0, $s0, 1		# incrementta o buffer
		  
		  	# imprime parte fracionaria
		  	li 	$t0, '.'			# carrega o '.'
		  	sb 	$t0, 0($s0)			# coloca no buffer
		  	addi 	$s0, $s0, 1			# incrementa o buffer
		  
		  	# $f4 contem a mantissa com 1 casa não decimal
		  	li 		$t1, 8				# contador de digitos  -  8 casas decimais
loopfracprintFloat:  	beq 		$t1, $zero, fimfracprintFloat	# fim dos digitos?
		  	floor.w.s 	$f5, $f4			# menor inteiro
		  	cvt.s.w 	$f5, $f5			# parte inteira		
		  	sub.s 		$f5, $f4, $f5			# parte fracionaria
		  	mul.s 		$f5, $f5, $f10			# mult x 10
		  	floor.w.s 	$f6, $f5			# converte para inteiro
		  	mfc1 		$t0, $f6			# passa para $t0
		  	addi 		$t0, $t0, 48			# converte para ascii
		  	sb 		$t0, 0($s0)			# coloca no buffer
		  	addi 		$s0, $s0, 1			# incrementa endereco
		  	addi 		$t1, $t1, -1			# decrementa contador
		  	mov.s 		$f4, $f5			# coloca o numero em $f4
		  	j 		loopfracprintFloat		# volta ao loop
		  
		  	# imprime 'E'		  
fimfracprintFloat: 	li 	$t0,'E'			# carrega 'E'
			sb 	$t0, 0($s0)		# coloca no buffer
			addi 	$s0, $s0, 1		# incrementa endereco
			
		  	# imprime sinal do expoente
		  	li 	$t0, '+'				# carrega '+'
		  	bc1f 	1, expposprintFloat			# nao eh negativo?
		  	li 	$t0, '-'				# carrega '-'
expposprintFloat: 	sb 	$t0, 0($s0)				# coloca no buffer
		  	addi 	$s0, $s0, 1				#incrementa endereco
				    
		  	# imprimeo expoente com 2 digitos (maximo E+38)
			li 	$t1, 10				# carrega 10
			cvt.w.s $f3, $f3			# converte $f3 em inteiro	
			mfc1 	$t0, $f3			# passa $f3 para $t0
			div 	$t0, $t1			# divide por 10
			mflo 	$t0				# quociente (dezena)
			addi 	$t0, $t0, 48			# converte para ascii
			sb 	$t0, 0($s0)			# coloca no buffer
			mfhi 	$t0				# resto (unidade)
			addi 	$t0, $t0, 48			# converte para ascii
			sb 	$t0, 1($s0)			# coloca no buffer
			sb 	$zero, 2($s0)			# insere \NULL da string
			la 	$a0, TempBuffer			# endereco do Buffer										
	  		j 	fimprintFloat			# imprime a string
								
ehExp0printFloat: 	beq 	$t1, $zero, eh0printFloat	# Verifica se eh zero
		
ehDesnormprintFloat: 	la 	$a0, NumDesnormP		# string numero desnormalizado positivo
			beq 	$s1, $zero, fimprintFloat	# o sinal eh 1? entao é negativo
		 	la 	$a0, NumDesnormN		# string numero desnormalizado negativo
			j 	fimprintFloat			# imprime a string

eh0printFloat:		la 	$a0, NumZero			# string do zero
			j 	fimprintFloat 	 		# imprime a string
		 		 		 		 
ehExp255printFloat: 	beq 	$t1, $zero, ehInfprintFloat	# se mantissa eh zero entao eh Infinito

ehNaNprintfFloat:	la 	$a0, NumNaN			# string do NaN
			j 	fimprintFloat			# imprime string

ehInfprintFloat:	la 	$a0, NumInfP			# string do infinito positivo
			beq 	$s1, $zero, fimprintFloat	# o sinal eh 1? entao eh negativo
			la 	$a0, NumInfN			# string do infinito negativo
								# imprime string
		
fimprintFloat:		jal 	printString			# imprime a string em $a0
			lw 	$ra, 0($sp)			# recupera $ra
			addi 	$sp, $sp, 4			# libera sepaco
			jr 	$ra				# retorna


#################################
# readFloat       	 	#
# $f0 = float digitado        	#
# 2017/2			#
#################################

readFloat: addi $sp, $sp, -4			# aloca espaco
	sw 	$ra, 0($sp)			# salva $ra
	la 	$a0, TempBuffer			# endereco do FloatBuffer
	li 	$a1, 32				# numero maximo de caracteres
	jal	readString			# le string, retorna $v0 ultimo endereco e $v1 numero de caracteres
	move 	$s0, $v0			# ultimo endereco da string (antes do \0)
	move 	$s1, $v1			# numero de caracteres digitados
	la	$s7, TempBuffer			# Endereco do primeiro caractere
	
lePrimeiroreadFloat:	move 	$t0, $s7		# Endereco de Inicio
	lb 	$t1, 0($t0)				# le primeiro caractere
	beq 	$t1, 'e', insere0AreadFloat		# insere '0' antes
	beq 	$t1, 'E', insere0AreadFloat		# insere '0' antes
	beq 	$t1, '.', insere0AreadFloat		#  insere '0' antes
	beq 	$t1, '+', pulaPrimreadChar		# pula o primeiro caractere
	beq 	$t1, '-', pulaPrimreadChar
	j leUltimoreadFloat

pulaPrimreadChar: addi $s7,$s7,1		# incrementa o endereco inicial
		  j lePrimeiroreadFloat		# volta a testar o novo primeiro caractere
		  
insere0AreadFloat: move $t0, $s0		# endereco do ultimo caractere
		   addi $s0, $s0, 1		# desloca o ultimo endereco para o proximo
	   	   addi $s1, $s1, 1		# incrementa o num. caracteres
	   	   sb 	$zero, 1($s0)		# \NULL do final de string
	   	   move $t8, $s7		# primeiro caractere
insere0Aloop:	   beq 	$t0, $t8, saiinsere0AreadFloat	# chegou no inicio entao fim
		   lb 	$t1, 0($t0)		# le caractere
		   sb 	$t1, 1($t0)		# escreve no proximo
		   addi $t0, $t0, -1		# decrementa endereco
		   j insere0Aloop		# volta ao loop
saiinsere0AreadFloat: li $t1, '0'		# ascii '0'
		   sb $t1, 0($t0)		# escreve '0' no primeiro caractere

leUltimoreadFloat: lb  	$t1,0($s0)			# le ultimo caractere
		beq 	$t1,'e', insere0PreadFloat	# insere '0' depois
		beq 	$t1,'E', insere0PreadFloat	# insere '0' depois
		beq 	$t1,'.', insere0PreadFloat	# insere '0' depois
		j 	inicioreadFloat
	
insere0PreadFloat: addi	$s0, $s0, 1		# desloca o ultimo endereco para o proximo
	   	   addi	$s1, $s1, 1		# incrementa o num. caracteres
		   li 	$t1,'0'			# ascii '0'
		   sb 	$t1,0($s0)		# escreve '0' no ultimo
		   sb 	$zero,1($s0)		# \null do final de string

inicioreadFloat:  mtc1 	$zero,$f0		# $f0 Resultado inicialmente zero
		li 	$t0, 10			# inteiro 10	
		mtc1 	$t0, $f10		# passa para o C1
		cvt.s.w $f10, $f10		# $f10 contem sempre o numero cte 10.0000
		li 	$t0, 1			# inteiro 1
		mtc1 	$t0, $f1		# passa para o C1
		cvt.s.w $f1, $f1		# $f1 contem sempre o numero cte 1.0000
	
##### Verifica se tem 'e' ou 'E' na string  resultado em $s3			
procuraEreadFloat:	add 	$s3, $s0, 1			# inicialmente nao tem 'e' ou 'E' na string (fora da string)
			move 	$t0, $s7			# endereco inicial
loopEreadFloat: 	beq 	$t0, $s0, naotemEreadFloat	# sai se nao encontrou 'e'
			lb 	$t1, 0($t0)			# le o caractere
			beq 	$t1, 'e', ehEreadFloat		# tem 'e'
			beq	$t1, 'E', ehEreadFloat		# tem 'E'
			addi 	$t0, $t0, 1			# incrementa endereco
			j 	loopEreadFloat			# volta ao loop
ehEreadFloat: 		move 	$s3, $t0			# endereco do 'e' ou 'E' na string
naotemEreadFloat:						# nao tem 'e' ou 'E' $s3 eh o endereco do \0 da string

##### Verifica se tem '.' na string resultado em $s2 espera-se que nao exista ponto no expoente
procuraPontoreadFloat:	move 	$s2, $s3			# local inicial do ponto na string (='e' se existir) ou fora da string	
			move 	$t0, $s7			# endereco inicial
loopPontoreadFloat: 	beq 	$t0, $s0, naotemPontoreadFloat	# sai se nao encontrou '.'
			lb 	$t1, 0($t0)			# le o caractere
			beq 	$t1, '.', ehPontoreadFloat	# tem '.'
			addi 	$t0, $t0, 1			# incrementa endereco
			j 	loopPontoreadFloat		# volta ao loop
ehPontoreadFloat: 	move 	$s2, $t0			# endereco do '.' na string
naotemPontoreadFloat:						# nao tem '.' $s2 = local do 'e' ou \0 da string

### Encontra a parte inteira em $f0
intreadFloat:		mtc1 	$zero, $f2			# zera parte inteira
			addi 	$t0, $s2, -1			# endereco do caractere antes do ponto
			mov.s 	$f3, $f1			# $f3 contem unidade/dezenas/centenas		
			move 	$t8, $s7			# Primeiro Endereco
loopintreadFloat: 	blt 	$t0, $t8, fimintreadFloat	# sai se o enderefo for < inicio da string
			lb 	$t1, 0($t0)			# le o caracter
			blt 	$t1, '0', erroreadFloat		# nao eh caractere valido para numero
			bgt 	$t1, '9', erroreadFloat		# nao eh caractere valido para numero
			addi 	$t1, $t1, -48			# converte ascii para decimal
			mtc1 	$t1, $f2			# passa para 0 C1
			cvt.s.w $f2, $f2			# digito lido em float

			mul.s 	$f2,$f2,$f3			# multiplcica por un/dezena/centena
			add.s 	$f0,$f0,$f2			# soma no resultado
			mul.s 	$f3,$f3,$f10			# proxima dezena/centena

			add $t0,$t0,-1				# endereco anterior
			j loopintreadFloat			# volta ao loop
fimintreadFloat:

### Encontra a parte fracionaria  ja em $f0							
fracreadFloat:		mtc1 	$zero, $f2			# zera parte fracionaria
			addi 	$t0, $s2, 1			# endereco depois do ponto
			div.s 	$f3, $f1, $f10			# $f3 inicial 0.1
	
loopfracreadFloat: 	bge 	$t0, $s3, fimfracreadFloat	# endereco eh 'e' 'E' ou >ultimo
			lb 	$t1, 0($t0)			# le o caracter
			blt 	$t1, '0', erroreadFloat		# nao eh valido
			bgt 	$t1, '9', erroreadFloat		# nao eh valido
			addi 	$t1, $t1, -48			# converte ascii para decimal
			mtc1 	$t1, $f2			# passa para C1				
			cvt.s.w $f2, $f2			# digito lido em float

			mul.s 	$f2, $f2, $f3			# multiplica por ezena/centena
			add.s 	$f0, $f0, $f2			# soma no resultado
			div.s 	$f3, $f3, $f10			# proxima frac un/dezena/centena
	
			addi 	$t0, $t0, 1			# proximo endereco
			j 	loopfracreadFloat		# volta ao loop		
fimfracreadFloat:

### Encontra a potencia em $f2																																																																																																																																																							
potreadFloat:		mtc1 	$zero, $f2			# zera potencia
			addi 	$t0, $s3, 1			# endereco seguinte ao 'e'
			li 	$s4, 0				# sinal do expoente positivo
			lb 	$t1, 0($t0)			# le o caractere seguinte ao 'e'
			beq	$t1, '-', potsinalnegreadFloat	# sinal do expoente esta escrito e eh positivo
			beq 	$t1, '+', potsinalposreadFloat	# sinal do expoente eh negativo
			j 	pulapotsinalreadFloat		# nao esta escrito o sinal do expoente
potsinalnegreadFloat:	li 	$s4, 1				# $s4=1 expoente negativo
potsinalposreadFloat:	addi 	$t0, $t0, 1			# se tiver '-' ou '+' avanca para o proximo endereco
pulapotsinalreadFloat:	move 	$s5, $t0 			# Neste ponto $s5 contem o endereco do primeiro digito da pot e $s4 o sinal do expoente		

			mov.s 	$f3, $f1		# $f3 un/dez/cen = 1
	
### Encontra o expoente inteiro em $t2
expreadFloat:		li 	$t2, 0			# zera expoente
			move 	$t0, $s0		# endereco do ultimo caractere da string
			li 	$t3, 10			# numero dez
			li 	$t4, 1			# und/dez/cent
				
loopexpreadFloat:	blt 	$t0, $s5, fimexpreadFloat	# ainda nao eh o endereco do primeiro digito?
			lb 	$t1, 0($t0)			# le o caracter
			addi 	$t1, $t1, -48			# converte ascii para decimal
			mult 	$t1, $t4			# mul digito
			mflo 	$t1
			add 	$t2, $t2, $t1			# soma ao exp
			mult 	$t4, $t3			# proxima casa decimal
			mflo 	$t4
			add 	$t0, $t0, -1			# endereco anterior
			j loopexpreadFloat			# volta ao loop
fimexpreadFloat:
																																																								
# calcula o numero em $f2 o numero 10^exp
			mov.s 	$f2, $f1			# numero 10^exp  inicial=1
			mov.s 	$f3, $f10			# se o sinal for + $f3 eh 10
			beq 	$s4, 0, sinalexpPosreadFloat	# se sinal exp positivo
			div.s 	$f3, $f1, $f10			# se o final for - $f3 eh 0.1
sinalexpPosreadFloat:	li 	$t0, 0				# contador 
sinalexpreadFloat: 	beq 	$t0, $t2, fimsinalexpreadFloat	# se chegou ao fim
			mul.s 	$f2, $f2, $f3			# multiplica pelo fator 10 ou 0.1
			addi 	$t0, $t0, 1			# incrementa o contador
			j 	sinalexpreadFloat
fimsinalexpreadFloat:

		mul.s 	$f0, $f0, $f2		# multiplicacao final!
	
		la 	$t0, TempBuffer		# ajuste final do sinal do numero
		lb 	$t1, 0($t0)		# le primeiro caractere
		bne 	$t1, '-', fimreadFloat	# nao eh '-' entao fim
		neg.s 	$f0, $f0		# nega o numero float

erroreadFloat:		
fimreadFloat: 	lw 	$ra, 0($sp)		# recupera $ra
		addi 	$sp, $sp, 4		# libera espaco
		jr 	$ra			# retorna
																														


############################################
#  SD Card Read                            #
#  $a0    =    Origem Addr                 #           //TODO: Implementar identificacao de falha na leitura do cartao.
#  $a1    =    Destino Addr                #
#  $a2    =    Quantidade de Bytes         #           //NOTE: $a2 deve ser uma quantidade de bytes alinhada em words
#  $v0    =    Sucesso? 0 : 1              #
############################################
#sdRead:		DE2(sdReadDE2)
#		# Faz a leitura do arquivo imagem (raw) do cartão SD: "SD.bin" 
#		move 	$t0, $a0		# Salva Endereco de Origem
#		move 	$t1, $a1		# Salva Endereco de Destino
#		move 	$t2, $a2		# Salva o numero de bytes a serem lidos
#		la 	$a0, SDFile		# Abre o arquivo "SD.bin"
#		li 	$a1, 0	
#		li 	$a2, 0
#		li 	$v0, 13		
#		syscall		
#		move 	$t3, $v0		# Salva o Descritor
#		move 	$a0, $t3		# Define o descritor
#		la 	$a1, TempBuffer		# Define o Endereco de Buffer do cartao SD
#		li 	$a2, 512		# numero de bytes do buffer
#		move 	$t4, $t0		# endereco origem = num bytes a pular
#	
#LoopSD: 	ble 	$t4, $zero, ForaSD	# leu todos os setores ?
#		li 	$v0, 14			# Le um bloco de 512 bytes
#		syscall			
#		addi 	$t4, $t4, -512		# subtrai o endereco de origem
#		j 	LoopSD			# volta ao loop
#	
#ForaSD: 	sub  	$a2, $zero, $t4		# numero de bytes faltantes
#		li	$v0, 14		# le o numero de bytes faltantes a pular
#		syscall		
#
#		move 	$a0, $t3		# le os bytes desejados
#		move 	$a1, $t1
#		move 	$a2, $t2
#		li 	$v0, 14
#		syscall		
#		blt 	$v0, $zero, FimSD	# se $v0 <0 entao deu erro
#
#		move 	$a0, $t3		# recupera o descritor
#		li 	$v0, 16			# fecha o arquivo
#		syscall		
#		li 	$v0, 0			# retorna sem erro
#		j 	FimSD			# retorna
#
#
#sdReadDE2:     	la      $s0, SD_INTERFACE_ADDR
#    		la      $s1, SD_INTERFACE_CTRL
#    		la      $s2, SD_BUFFER_INI
#
#sdBusy:     	lbu     $t1, 0($s1)                     # $t1 = SDCtrl
#    		bne     $t1, $zero, sdBusy              # $t1 ? BUSY : READY
#
#sdReadSector:	sw      $a0, 0($s0)                     # &SD_INTERFACE_ADDR = $a0
#    		nop
#    		nop
#    		
#
#sdWaitRead:     lbu     $t1, 0($s1)                     # $t1 = SDCtrl
#    		bne     $t1, $zero, sdWaitRead          # $t1 ? BUSY : READY
#    		li      $t0, 512                        # Tamanho do buffer em bytes
#
#sdDataReady:	lw      $t2, 0($s2)                     # Le word do buffer
#    		sw      $t2, 0($a1)                     # Salva word no destino
#    		addi    $s2, $s2, 4                     # Incrementa endereco do buffer
#    		addi    $a1, $a1, 4                     # Incrementa endereco de destino
#    		addi    $a2, $a2, -4                    # Decrementa quantidade de bytes a serem lidos
#    		addi    $t0, $t0, -4                    # Decrementa contador de bytes lidos no setor
#    		beq     $a2, $zero, FimSDRead           # Se leu todos os bytes desejados, finaliza
#    		bne     $t0, $zero, sdDataReady         # Le proxima word
#
#    		addi    $a0, $a0, 512                   # Define endereco do proximo setor
#    		la      $s2, SD_BUFFER_INI              # Coloca o enderecamento do buffer na posicao inicial
#    		j       sdBusy
#    
# FimSDRead:	li      $v0, 0                          # Sucesso na transferencia.         NOTE: Hardcoded. Um teste de falha deve ser implementado.
# 
# FimSD:		jr      $ra				# retorna
############################################



############################################
#  Time                            	   #
#  $a0    =    Time                 	   #
#  $a1    =    zero	                   #
############################################
time: 	DE2(timeDE2)
	li 	$v0,30				# Chama o syscall do Mars
	syscall
	j 	fimTime				# saida

timeDE2: 	la 	$t0, STOPWATCH			# carrega endereco do TopWatch
	 	lw 	$a0, 0($t0)			# carrega o valor do contador de ms
	 	li 	$a1, 0x0000			# contador eh de 32 bits
fimTime: 	jr 	$ra				# retorna

############################################
#  Sleep                            	   #
#  $a0    =    Tempo em ms             	   #
############################################
sleep: DE2(sleepDE2)
	li 	$v0, 32				# Chama o syscall do Mars
	syscall			
	j 	fimSleep			# Saida

sleepDE2:	la 	$t0, STOPWATCH			# endereco StopWatch
		lw 	$t1, 0($t0)			# carrega o contador de ms
		add 	$t2, $a0, $t1			# soma com o tempo solicitado pelo usuario
		
LoopSleep: 	lw 	$t1, 0($t0)			# carrega o contador de ms
		blt 	$t1, $t2, LoopSleep		# nao chegou ao fim volta ao loop
	
fimSleep: 	jr 	$ra				# retorna

############################################
#  Random                            	   #
#  $a0    =    numero randomico        	   #
############################################
random: DE2(randomDE2)		
	li 	$v0,41			# Chama o syscall do Mars
	syscall	
	j 	fimRandom		# saida
	
randomDE2: 	la 	$t0, LFSR		# carrega endereco do LFSR
		lw 	$a0, 0($t0)		# le a word em $a0
		
fimRandom:	jr 	$ra			# retorna


#################################
#    CLS                        #
#  Clear Screen                 #
#  $a0 = cor                    #
#################################

clsCLS:	la      $t1, VGAADDRESSINI           # Memoria VGA
   	la      $t2, VGAADDRESSFIM
    	andi    $a0, $a0, 0x00FF
    	la 	$t0, 0x01010101
    	mult	$t0, $a0
    	mflo	$a0

forCLS:	beq     $t1, $t2, fimCLS
	sw      $a0, 0($t1)
    	addi    $t1, $t1, 4
    	j       forCLS
    	
fimCLS:	jr      $ra
