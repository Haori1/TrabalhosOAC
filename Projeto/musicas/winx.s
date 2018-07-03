.data
	NOTA_DURACAO_DELAY:	.word 67,300,100,  67,300,100,  66,300,100,  62,300,700,
				      67,300,100,  67,300,100,  66,300,100,  62,300,1250,
				      62,600,500,  64,600,400,  66,400,300,  64,700,900,
				      66,700,800,  66,400,250,  66,400,250,  66,500,350,  62,400,250,  62,550,450,  66,400,250,  64,700,800,   
				      66,400,300,  66,400,300,  66,400,550,  67,600,550,  66,300,200,  62,800,1000,
				      66,400,250,  66,400,250,  66,500,350,  62,400,250,  62,550,450,  66,400,250,  64,600,500,
				      69,800,650,  71,800,650,  69,800,1500,
				      67,300,100,  67,300,100,  66,300,100,  62,300,700,
				      67,300,100,  67,300,100,  66,300,100,  62,300,1250,
				      62,600,500,  64,600,400,  66,400,300,  64,700,900,
				      
				      ##VIM ATE AQUI COM A MUSICA DAS WINX 

	
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

	li t1, 0xFF100000
	lw t2, 0(t1)
	andi t2, t2, 0x0001 
	beqz t2, JUMPR
	j FIM	
	
JUMPR:

	j RA
	
FIM:
	li a7, 10
	ecall
