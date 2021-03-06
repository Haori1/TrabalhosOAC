/* Parametros Gerais*/
parameter
    ON          = 1'b1,
    OFF         = 1'b0,
    ZERO        = 32'h0,

/* Operacoes da ULA */
	OPAND 		= 5'd0,
	OPOR			= 5'd1,
	OPXOR			= 5'd2,
	OPADD			= 5'd3,
	OPSUB			= 5'd4,
	OPSLT			= 5'd5,
	OPSLTU		= 5'd6,
	OPGE			= 5'd7,
	OPGEU			= 5'd8,
	OPSLL			= 5'd9,
	OPSRL			= 5'd10,
	OPSRA			= 5'd11,
	//OPLUI			= 5'd12,
	
	OPMUL			= 5'd13,
	OPMULH		= 5'd14,
	OPMULHU		= 5'd15,
	OPMULHSU		= 5'd16,
	OPDIV			= 5'd17,
	OPDIVU		= 5'd18,
	OPREM			= 5'd19,
	OPREMU		= 5'd20,
	 
	 
/* Campo FUNCT3 */

	FUN3ADD		= 3'd0,
	FUN3SUB		= 3'd0,
	FUN3AND		= 3'd7,
	FUN3OR		= 3'd6,
	FUN3XOR		= 3'd4,	
	FUN3SLT		= 3'd2,
	FUN3SLTU		= 3'd3,	
	FUN3SLL		= 3'd1,
	FUN3SRL		= 3'd5,
	FUN3SRA		= 3'd5,
	FUN3ADDI		= 3'd0,
	FUN3ANDI		= 3'd7,
	FUN3ORI		= 3'd6,
	FUN3XORI		= 3'd4,
	FUN3SLTI		= 3'd2,
	FUN3SLTIU	= 3'd3,
	FUN3SLLI		= 3'd1,
	FUN3SRLI		= 3'd5,
	FUN3SRAI		= 3'd5,
	FUN3BEQ		= 3'b000,
	FUN3BNE		= 3'b001,
	FUN3BLT		= 3'b100,
	FUN3BGE		= 3'b101,
	FUN3BLTU		= 3'b110,
	FUN3BGEU		= 3'b111,
	FUN3JALR		= 3'd0,
	FUN3LB		= 3'd0,
	FUN3LBU		= 3'd4,
	FUN3LH		= 3'd1,
	FUN3LHU		= 3'd5,
	FUN3LW		= 3'd2,
	FUN3SB		= 3'd0,
	FUN3SH		= 3'd1,
	FUN3SW		= 3'd2,
	
	FUN3MUL		= 3'd0,
	FUN3MULH		= 3'd1,
	FUN3MULHU	= 3'd3,
	FUN3MULHSU	= 3'd2,
	FUN3DIV		= 3'd4,
	FUN3DIVU		= 3'd5,
	FUN3REM		= 3'd6,
	FUN3REMU		= 3'd7,
	
/* Campo FUNCT7 */
	FUN7ADD		= 7'h00,
	FUN7SUB		= 7'h20,
	FUN7AND		= 7'h00,
	FUN7OR		= 7'h00,
	FUN7XOR		= 7'h00,	
	FUN7SLT		= 7'h00,
	FUN7SLTU		= 7'h00,	
	FUN7SLL		= 7'h00,
	FUN7SRL		= 7'h00,
	FUN7SRA		= 7'h20,
	FUN7SLLI		= 7'h00,
	FUN7SRLI		= 7'h00,
	FUN7SRAI		= 7'h20,
	
	FUN7MUL		= 7'h01,
	FUN7MULH		= 7'h01,
	FUN7MULHU	= 7'h01,
	FUN7MULHSU	= 7'h01,
	FUN7DIV		= 7'h01,
	FUN7DIVU		= 7'h01,
	FUN7REM		= 7'h01,
	FUN7REMU		= 7'h01,

/* Campo Opcode */
	OPCLOAD		= 7'h03,
	OPCSTORE		= 7'h23,
	OPCR			= 7'h33,
	OPCIARI		= 7'h13,
	OPCAUIPC		= 7'h17,
	OPCLUI		= 7'h37,
	OPCBRANCH	= 7'h63,
	OPCJALR		= 7'h67,
	OPCJAL		= 7'h6F,
	
	OPCMUL		= 7'h33,
		
	//OPCDUMMY    = 6'h3F,                // Para o MemStore e MemLoad

	INITIAL_INTERRUPT = 32'h00000911,   // 00000111  00000511 ou 00000911 teclado habilitado

/* Memory access types ***********************************************************************************************/
    LOAD_TYPE_LW        = 3'b000,
    LOAD_TYPE_LH        = 3'b001,
    LOAD_TYPE_LHU       = 3'b010,
    LOAD_TYPE_LB        = 3'b011,
    LOAD_TYPE_LBU       = 3'b100,
    LOAD_TYPE_DUMMY     = 3'b111,

    STORE_TYPE_SW       = 2'b00,
    STORE_TYPE_SH       = 2'b01,
    STORE_TYPE_SB       = 2'b10,
    STORE_TYPE_DUMMY    = 2'b11,

//Mapeamento da memoria
/* ADDRESS MACROS *****************************************************************************************************/

    BACKGROUND_IMAGE    = "display.mif",

	 BEGINNING_BOOT      = 32'h0000_0000,
	 BOOT_WIDTH				= 9,					// 128 words = 128x4 = 512 bytes
    END_BOOT            = (BEGINNING_BOOT + 2**BOOT_WIDTH) - 1,	 
//    END_BOOT            = 32'h000001FF,	// 128 words

    BEGINNING_TEXT      = 32'h0040_0000,
	 TEXT_WIDTH				= 14,					// 4096 words = 4096x4 = 16384 bytes
    END_TEXT            = (BEGINNING_TEXT + 2**TEXT_WIDTH) - 1,	 
//    END_TEXT            = 32'h00403FFF,	// 4096 words

	 
    BEGINNING_DATA      = 32'h1001_0000,
	 DATA_WIDTH				= 13,					// 2048 words = 2048x4 = 8192 bytes
    END_DATA            = (BEGINNING_DATA + 2**DATA_WIDTH) - 1,	 
//    END_DATA            = 32'h10011FFF,	// 2048 words


	 STACK_ADDRESS       = END_DATA-3,
	 
	 //Mantidos do MIPS para evitar mais problemas com os códigos das memórias
    BEGINNING_KTEXT     = 32'h8000_0000,
	 KTEXT_WIDTH			= 13,					// 2048 words = 2048x4 = 8192 bytes
    END_KTEXT           = (BEGINNING_KTEXT + 2**KTEXT_WIDTH) - 1,	 	 
//    END_KTEXT           = 32'h80001FFF,	// 2048 words
	 
    BEGINNING_KDATA     = 32'h9000_0000,
	 KDATA_WIDTH			= 12,					// 1024 words = 1024x4 = 4096 bytes
    END_KDATA           = (BEGINNING_KDATA + 2**KDATA_WIDTH) - 1,	 	 
//    END_KDATA           = 32'h900007FF, 	// 1024 words

	/* O que isso faz? 
	 ASCII_MIN           = 32'h00000080,
	 ASCII_MAX           = 32'h0000407F,
	 BACKGROUND          = 32'h00004080,
	 MAIN_COLOR          = 32'h00004084,
	 //LETRAS_MIN = 32'h00000100,
	 //LETRAS_MAX = 32'h00001763,
	 //NUMBER_MIN = 32'h00001764,
	 //NUMBER_MAX = 32'h00002403,*/
	 
    BEGINNING_IODEVICES         = 32'hFF00_0000,
	 
    BEGINNING_VGA               = 32'hFF00_0000,
    END_VGA                     = 32'hFF01_2C00,  // 320 x 240 = 76800 bytes

	 KDMMIO_CTRL_ADDRESS		     = 32'hFF20_0000,	// Para compatibilizar com o KDMMIO
	 KDMMIO_DATA_ADDRESS		  	  = 32'hFF20_0004,
	 
	 BUFFER0_TECLADO_ADDRESS     = 32'hFF20_0100,
    BUFFER1_TECLADO_ADDRESS     = 32'hFF20_0104,
	 
    TECLADOxMOUSE_ADDRESS       = 32'hFF20_0110,
    BUFFERMOUSE_ADDRESS         = 32'hFF20_0114,
	  
	 AUDIO_INL_ADDRESS           = 32'hFF20_0160,
    AUDIO_INR_ADDRESS           = 32'hFF20_0164,
    AUDIO_OUTL_ADDRESS          = 32'hFF20_0168,
    AUDIO_OUTR_ADDRESS          = 32'hFF20_016C,
    AUDIO_CTRL1_ADDRESS         = 32'hFF20_0170,
    AUDIO_CRTL2_ADDRESS         = 32'hFF20_0174,

    NOTE_SYSCALL_ADDRESS        = 32'hFF20_0178,
    NOTE_CLOCK                  = 32'hFF20_017C,
    NOTE_MELODY                 = 32'hFF20_0180,
    MUSIC_TEMPO_ADDRESS         = 32'hFF20_0184,
    MUSIC_ADDRESS               = 32'hFF20_0188,         // Endereco para uso do Controlador do sintetizador
    PAUSE_ADDRESS               = 32'hFF20_018C,
		
	 IRDA_DECODER_ADDRESS		 = 32'hFF20_0500,
	 IRDA_CONTROL_ADDRESS       = 32'hFF20_0504, 	 	// Relatorio questao B.10) - Grupo 2 - (2/2016)
	 IRDA_READ_ADDRESS          = 32'hFF20_0508,		 	// Relatorio questao B.10) - Grupo 2 - (2/2016)
    IRDA_WRITE_ADDRESS         = 32'hFF20_050C,		 	// Relatorio questao B.10) - Grupo 2 - (2/2016)
    
	 STOPWATCH_ADDRESS			 = 32'hFF20_0510,	 //Feito em 2/2016 para servir de cronometro
	 
	 LFSR_ADDRESS					 = 32'hFF20_0514,			// Gerador de numeros aleatorios
	 
	 KEYMAP0_ADDRESS				 = 32'hFF20_0520,			// Mapa do teclado 2017/2
	 KEYMAP1_ADDRESS				 = 32'hFF20_0524,
	 KEYMAP2_ADDRESS				 = 32'hFF20_0528,
	 KEYMAP3_ADDRESS				 = 32'hFF20_052C,
	 
	 BREAK_ADDRESS					 = 32'hFF20_0600,  	  // Buffer do endereço do Break Point
	 
	 
/* STATES ************************************************************************************************************/
    FETCH           = 6'd0,
    DECODE          = 6'd1,
    LWSW            = 6'd2,
    LOAD            = 6'd3,
    MEM2RD          = 6'd4,
    STORE           = 6'd5,
    RCALC           = 6'd6,
    ICALC           = 6'd7,
    ALU2RD          = 6'd8,
    IMM2RD          = 6'd9,
    BRANCH          = 6'd10,
	JAL             = 6'd11,
	JALR            = 6'd12,

/* guia:
	oIorD         = wOutput[14]
	oMemRead      = wOutput[13]
	oMemWrite     = wOutput[12]
	oIRWrite      = wOutput[11]
	oALUSrcA      = wOutput[10]
	oALUSrcB      = wOutput[9:8]
	oALUOp        = wOutput[7:6]
	oMemtoReg     = wOutput[5:4]
	oRegWrite     = wOutput[3]
	oPCWrite      = wOutput[2]
	oPCWriteCond  = wOutput[1]
	oPCSource     = wOutput[0]
*/
	FETCH_OUTPUT    = 15'b0_1_0_1_0_01_00_00_0_1_0_0,
	DECODE_OUTPUT   = 15'b0_0_0_0_0_11_00_00_0_0_0_0,
	LWSW_OUTPUT     = 15'b0_0_0_0_1_10_00_00_0_0_0_0,
	LOAD_OUTPUT     = 15'b1_1_0_0_1_00_00_00_0_0_0_0,
	MEM2RD_OUTPUT   = 15'b0_0_0_0_1_00_00_10_1_0_0_0,
	STORE_OUTPUT    = 15'b1_0_1_0_1_00_00_00_0_0_0_0,
	RCALC_OUTPUT    = 15'b0_0_0_0_1_00_10_00_0_0_0_0,
	ICALC_OUTPUT    = 15'b0_0_0_0_1_10_11_00_0_0_0_0,
	ALU2RD_OUTPUT   = 15'b0_0_0_0_1_00_00_00_1_0_0_0,
	IMM2RD_OUTPUT   = 15'b0_0_0_0_1_00_00_11_1_0_0_0,
	BRANCH_OUTPUT   = 15'b0_0_0_0_1_00_01_00_0_0_1_1,
	JAL_OUTPUT      = 15'b0_0_0_0_1_00_00_01_1_1_0_1,
	JALR_OUTPUT     = 15'b0_0_0_0_1_10_00_01_1_1_0_0,

    //Adicionados em 1/2014
    STATE_LB        = 6'd49,
    STATE_LBU       = 6'd50,
    STATE_LH        = 6'd51,
    STATE_LHU       = 6'd52,
    STATE_SB        = 6'd53,
    STATE_SH        = 6'd54,

	  
	  //Adicionados em 2/2016 (Grupo 2)
	  RM				  = 6'd61,

	  ERRO           = 6'd63;  // Estado de Erro ---> boa sorte pessoal dos proximos semestre :)
