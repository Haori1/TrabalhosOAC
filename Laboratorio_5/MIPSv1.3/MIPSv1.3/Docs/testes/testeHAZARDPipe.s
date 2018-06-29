.data
	
.text
	lui $t1,0xACAB
	ori $t1,0xA0AC
	nop
	nop
	nop
	nop
	nop
	jal TESTE
	nop
	nop
TESTE:	jr  $ra
	nop
	nop
	nop