.data
	NOTA_DURACAO_DELAY:	.word 64,300,200,  64,300,200,  64,300,200,  60,300,200,  64,300,200,  67,300,200,  55,300,200
				      60,300,200,  55,300,200,  52,300,200,  57,300,200,  59,300,200,  58,300,200,  57,300,200,  55,300,200,   
				      64,300,200,  67,300,200,  69,300,200,  65,300,200,  67,300,200,  64,300,200,  60,300,200,  62,300,200,  59,300,200,  	 
				      60,300,200,  55,300,200,  52,300,200,  57,300,200,  59,300,200,  58,300,200,  57,300,200,  55,300,200,	
				      64,300,200,  67,300,200,  69,300,200,  65,300,200,  67,300,200,  64,300,200,  60,300,200,  62,300,200,  59,300,200,	
			 	      67,300,200,  66,300,200,  65,300,200,  63,300,200,  64,300,200,  56,300,200,  57,300,200,  60,300,200,  57,300,200,  60,300,200,  62,300,200,  
			 	      67,300,200,  66,300,200,  65,300,200,  63,300,200,  64,300,200,  72,300,200,  72,300,200,  72,300,200,  
				      67,300,200,  66,300,200,  65,300,200,  63,300,200,  64,300,200,  56,300,200,  57,300,200,  60,300,200,  57,300,200,  60,300,200,  62,300,200,
				      63,300,200,  62,300,200,  60,300,5000  

	
			######	
			#61 49 = C# or Db
			#62 50 = D					
			#63 51 = D# or Eb
			#64 52 = E or Fb
			#65 53 = E# or F
			#66 54 = F# or Gb
			#67 55 = G
			#68 56 = G# or Ab
			#69 57 = A
			#70 58 = A# or Bb
			#71 59 = B or Cb
			#72 60 = B# or C
			#####



.text
INICIO:
	la s0, NOTA_DURACAO_DELAY
	li a2, 0 			#intrumento piano 0	
	li a3, 64			#volume medio
	li t0, 0
	li t6, 74			#t6 = TAMANHO DO ARRAY DAS NOTAS
MUSICA:

	jal VERIFY_KEY
RA:
	lw a0, 0(s0)			#a0 = nota	
	lw a1, 4(s0)			#a1 = duracao	
	li a7, 31			#a2 = instrumento
	ecall				#a3 = volume
	
	li a7, 32
	lw a0, 8(s0)
	ecall
	
	addi t0, t0, 1
	addi s0, s0, 12
	
	bne t0, t6, MUSICA		
	
	j INICIO
	
VERIFY_KEY:

	li t1, 0xFF200000
	lw t2, 0(t1)
	andi t2, t2, 0x0001 
	beqz t2, JUMPR
	j FIM	
	
JUMPR:

	j RA
	
FIM:
	li a7, 10
	ecall
