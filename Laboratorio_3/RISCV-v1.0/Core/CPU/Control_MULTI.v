/*
 * Bloco de Controle MULTICICLO
 *
 */	
`ifdef MULTICICLO
module Control_MULTI (
	/* I/O type definition */
	input wire iCLK, iRST,
	input wire [5:0] iOp, iFunct,
	input wire [4:0] iFmt, iRt,		// 1/2016. Adicionado iRt.
	input wire iFt,
	output wire oIRWrite, oMemtoReg, oMemWrite, oMemRead, oIorD, 
					oPCWrite, oPCWriteBEQ, oPCWriteBNE,oRegWrite, oRegDst,
					oFPPCWriteBc1t, oFPPCWriteBc1f, oFPRegWrite, oFPFlagWrite, 
					oFPU2Mem, 
	output wire [1:0] oALUOp, oALUSrcA, oFPDataReg, oFPRegDst,
	output wire [2:0] oALUSrcB, oPCSource, oStore,
	output wire [5:0] oState,
	//Adicionado em 1/2014
	output wire [2:0] oLoadCase,
	output wire [1:0] oWriteCase,
	// feito no semestre 2013/1 para implementar a deteccao de excecoes (COP0)
	input iCOP0ALUoverflow, iCOP0FPALUoverflow, iCOP0FPALUunderflow, 
			iCOP0FPALUnan, iCOP0UserMode, iCOP0ExcLevel,
	input [7:0] iCOP0PendingInterrupt,
	output oCOP0PCOriginalWrite,
	output reg oCOP0RegWrite, oCOP0Eret, oCOP0ExcOccurred,
	output oCOP0BranchDelay,
	output [4:0] oCOP0ExcCode,
	output oCOP0Interrupted,
	// 2017/1
	input iFPBusy,
	output oFPStart
	);


wire [40:0] word;			// sinais de controle do caminho de dados
reg [5:0] current_state;		// present state
wire [5:0] next_state;		// next estate

//assign   oFPStart 			= word[40];
//assign	oWriteCase 			= word[39:38];		//  1/2014
//assign	oLoadCase		 	= word[37:35];		//  1/2014
//assign	oFPRegDst 			= word[34:33];
//assign	oFPDataReg 			= word[32:31];
//assign	oFPRegWrite 		= word[30];
//assign	oFPPCWriteBc1t 	= word[29];
//assign	oFPPCWriteBc1f 	= word[28];
//assign	oFPFlagWrite 		= word[27];
//assign	oFPU2Mem 			= word[26];
//assign	oClearJAction = word[25]; // fio Disponivel
//assign	oJReset 	= word[24];  // fio Disponivel
//assign	oSleepWrite = word[23]; // fio Disponivel
assign	oStore				= word[22:20];
assign	oPCWrite				= word[19];
assign	oPCWriteBNE			= word[18];
assign	oPCWriteBEQ			= word[17];
assign	oIorD					= word[16];
assign	oMemRead				= word[15];
assign	oMemWrite			= word[14];
assign	oIRWrite				= word[13];
assign	oMemtoReg			= word[12];
assign	oPCSource			= word[11:9];
assign	oALUOp				= word[8:7];
assign	oALUSrcB				= word[6:4];
assign	oALUSrcA				= word[3:2];
assign	oRegWrite			= word[1];
//assign	oRegDst				= word[0];

assign	oState		= current_state;

// feito no semestre 2013/1 para implementar a deteccao de excecoes (COP0)
assign 	oCOP0PCOriginalWrite = current_state != COP0EXC;
assign 	oCOP0Interrupted = current_state == COP0EXC && oCOP0ExcCode == EXCODEINT;

initial
begin
	current_state	<= FETCH;
end

// feito no semestre 2013/1 para implementar a deteccao de excecoes (COP0)
wire wCOP0PendingInterrupt;
assign oCOP0BranchDelay = iOp == OPCBEQ || 
								  iOp == OPCBNE || 
								  iOp == OPCJMP || 
								  iOp == OPCJAL || 
								  (iOp == OPCRFMT && iFunct == FUNJR) || 
								  (iOp == OPCFLT && iFmt == FMTBC1);
assign wCOP0PendingInterrupt = iCOP0PendingInterrupt != 8'b0 && ~iCOP0ExcLevel;

/* Main control block */
always @(posedge iCLK or posedge iRST)
begin
	if (iRST)
		current_state	<= FETCH;
	else
		current_state	<= next_state;
end

// feito no semestre 2013/1 para implementar a deteccao de excecoes (COP0)
always @(*)
begin
	if (iOp == OPCRFMT && iFunct == FUNSYS)
		oCOP0ExcCode <= EXCODESYS;
	else if ((iOp == OPCRFMT && (iFunct == FUNADD || iFunct == FUNSUB) || iOp == OPCADDI) && iCOP0ALUoverflow)
		oCOP0ExcCode <= EXCODEALU;
	else if (
		iOp == OPCFLT && 
		(
			(((iFmt == FMTW && iFunct == FUNCVTSW) || 
			  (iFmt == FMTS && (iFunct == FUNADDS || 
			   iFunct == FUNSUBS ||
				iFunct == FUNMULS ||
				iFunct == FUNDIVS))) &&
			(iCOP0FPALUoverflow || iCOP0FPALUunderflow)) ||
			(iFmt == FMTW && iFunct == FUNCVTWS && iCOP0FPALUoverflow)
		)
	)
		oCOP0ExcCode <= EXCODEFPALU;
	else if (iOp == OPCCOP0)
		oCOP0ExcCode <= EXCODEINSTR;
	else if (wCOP0PendingInterrupt)
		oCOP0ExcCode <= EXCODEINT;
	else
		oCOP0ExcCode <= EXCODEINSTR;
end

always @(*)
begin
	// feito no semestre 2013/1 para implementar a deteccao de excecoes (COP0)
	oCOP0RegWrite <= current_state == COP0MTC0;
	oCOP0Eret <= current_state == COP0ERET;
	oCOP0ExcOccurred <= current_state == COP0EXC;
	// feito no semestre 2013/1 para implementar a deteccao de excecoes (COP0)
	
	case (current_state)
	
		FETCH:
		begin
			word	<= 41'b00000000000000000000010001010000000010000;
			next_state	<= DECODE;
		end
		
		DECODE:
		begin
			word	<= 41'b00000000000000000000000000000000000110000;
			case (iOp)
				OPCRM: 	// Grupo 2 - (2/2016)
					if (iFunct == FUNMADD || iFunct == FUNMSUB || iFunct == FUNMADDU || iFunct == FUNMSUBU)
						next_state	<= wCOP0PendingInterrupt ? COP0EXC : RM;
					else
						next_state	<= FETCH;
						
				OPCRFMT:
					case (iFunct)
						FUNJR:
							next_state <= wCOP0PendingInterrupt ? COP0EXC : JR;
						FUNSLL, 
						FUNSRL, 
						FUNSRA: 						
							next_state	<= SHIFT;
						FUNSYS:
							next_state	<= iCOP0UserMode ? COP0EXC : FETCH;
						default:
							next_state	<= RFMT;
					endcase
									
				OPCJMP:
					next_state	<= wCOP0PendingInterrupt ? COP0EXC : JUMP;
					
				OPCBEQ:
					next_state	<= wCOP0PendingInterrupt ? COP0EXC : BEQ;
					
				OPCBNE:
					next_state	<= wCOP0PendingInterrupt ? COP0EXC : BNE;
					
				OPCJAL:
					next_state	<= wCOP0PendingInterrupt ? COP0EXC : JAL;

				//operações implementadas em 1/2016 - bgtz, blez, bgez, bgezal, bgltz, bltzal.
				OPCBGTZ:
					next_state	<= wCOP0PendingInterrupt ? COP0EXC : BGTZ;
					
				OPCBLEZ:
					next_state	<= wCOP0PendingInterrupt ? COP0EXC : BLEZ;
					
				OPCBGE_LTZ:
					case (iRt)
						RTBGEZ:
							next_state	<= wCOP0PendingInterrupt ? COP0EXC : BGEZ;
						RTBGEZAL:
							next_state	<= wCOP0PendingInterrupt ? COP0EXC : BGEZAL;
						RTBLTZ:
							next_state	<= wCOP0PendingInterrupt ? COP0EXC : BLTZ;
						RTBLTZAL:
							next_state	<= wCOP0PendingInterrupt ? COP0EXC : BLTZAL;
						default:
							next_state	<= ERRO;
					endcase
				
				//operaçoes adicionadas em 1/2014
				OPCLB,
				OPCLBU,
				OPCLH,
				OPCLHU,
				OPCSB,
				OPCSH,
				OPCLW,
				OPCSW,
				OPCLWC1,	//Load e Store da FPU
				OPCSWC1:
					next_state	<= LWSW;

				OPCANDI,
				OPCORI,
				OPCXORI:
					next_state	<= IFMTL;
					
				OPCADDI,
				OPCADDIU,
				OPCSLTI,
				OPCSLTIU,
				OPCLUI:
					next_state	<= IFMTA;
					
				OPCFLT:
					case (iFmt)
						FMTMTC:
							next_state <= FPUMTC1;
						FMTMFC:
							next_state <= FPUMFC1;
						FMTBC1:
						begin
							if (wCOP0PendingInterrupt)
								next_state <= COP0EXC;
							else 
								if (iFt)
									next_state <= FPUBC1T;
								else
									next_state <= FPUBC1F;
						end
						FMTW,
						FMTS:
							case(iFunct)
								FUNMOV:
									next_state	<= FPUMOV;
								FUNCEQ,
								FUNCLT,
								FUNCLE:
									next_state	<= FPUCOMP;
								default:
									next_state	<= FPUFRSTART;
							endcase
						default:
							next_state <= COP0EXC;
					endcase
					
				// feito no semestre 2013/1 para implementar a deteccao de excecoes (COP0)
				OPCCOP0:
				begin
					case (iFmt)
						FMTMTC:
							next_state <= iCOP0UserMode ? COP0EXC : COP0MTC0;
						FMTMFC:
							next_state <= iCOP0UserMode ? COP0EXC : COP0MFC0;
						FMTERET:
							next_state <= (iFunct != FUNERET) || iCOP0UserMode ? COP0EXC : COP0ERET;
						default:
							next_state <= COP0EXC;
					endcase
				end
				// feito no semestre 2013/1 para implementar a deteccao de excecoes (COP0)
				
				default:
					next_state	<= COP0EXC;
			endcase
		end
		
		FPUMTC1:
		begin
			word	<= 41'b00000001101000000000000000000000000000000;
			next_state	<= wCOP0PendingInterrupt ? COP0EXC : FETCH;
		end
		
		FPUMFC1:
		begin
			word	<= 41'b00000000000000000010100000000000000000010;
			next_state <= wCOP0PendingInterrupt ? COP0EXC : FETCH;
		end
		
		FPUBC1T:
		begin
			word	<= 41'b00000000000100000000000000000001000000000;
			next_state <= FETCH;
		end
		
		FPUBC1F:
		begin
			word	<= 41'b00000000000010000000000000000001000000000;
			next_state <= FETCH;
		end
		
		FPUMOV:
		begin
			word	<= 41'b00000000111000000000000000000000000000000;
			next_state <= wCOP0PendingInterrupt ? COP0EXC : FETCH;
		end
		
		FPUCOMP:
		begin
			word	<= 41'b00000000000001000000000000000000000000000;
			next_state <= wCOP0PendingInterrupt ? COP0EXC : FETCH;
		end
		
		FPUFRSTART:
		begin
			word	<= 41'b10000000000000000000000000000000000000000;
			next_state <= FPUFRWAIT;
		end
		
		FPUFRWAIT:
		begin
			word	<= 41'b00000000000000000000000000000000000000000;
			next_state <= iFPBusy ? FPUFRWAIT : FPUFR2;
		end
		
		FPUFR2:
		begin
			word	<= 41'b00000000001000000000000000000000000000000;
			if (
				wCOP0PendingInterrupt ||
				(
					(
						(((iFmt == FMTW && iFunct == FUNCVTSW) || 
						   (iFmt == FMTS && (iFunct == FUNADDS || 
						    iFunct == FUNSUBS || iFunct == FUNMULS || 
						    iFunct == FUNDIVS))) && 
						  (iCOP0FPALUoverflow || iCOP0FPALUunderflow)) ||
						(iFmt == FMTW && iFunct == FUNCVTWS && iCOP0FPALUoverflow)
					) &&
					~iCOP0ExcLevel
				)
			)
				next_state <= COP0EXC;
			else
				next_state <= FETCH;
		end
		
		LWSW:
		begin
			word	<= 41'b00000000000000000000000000000000000100100;
			case (iOp)
				OPCLW,				
				OPCLB,
				OPCLBU,
				OPCLH,
				OPCLHU,		// 1/2014
				OPCLWC1:
					next_state	<= LW;
				OPCSB:								// 1/2014
					next_state <= STATE_SB;		// 1/2014
				OPCSH:								// 1/2014
					next_state <= STATE_SH;		// 1/2014
				OPCSW:
					next_state	<= SW;
				OPCSWC1:
					next_state	<= FPUSWC1;
				default:
					next_state	<= ERRO;
			endcase
		end
		
		LW:
		begin
			word	<= 41'b00000000000000000000000011000000000000000;
			case (iOp)
				OPCLW:
					next_state	<= LW2;
				OPCLWC1:
					next_state	<= FPULWC1;
				//Listinha de casos 1/2014
				OPCLB:
					next_state <= STATE_LB;
				OPCLBU:
					next_state <= STATE_LBU;
				OPCLH:
					next_state <= STATE_LH;
				OPCLHU:
					next_state <= STATE_LHU;
				default:
					next_state	<= ERRO;
			endcase
		end
		
		FPULWC1:
		begin
			word	<= 41'b00000010011000000000000000000000000000000;
			next_state	<= wCOP0PendingInterrupt ? COP0EXC : FETCH;
		end
		
		FPUSWC1:
		begin
			word	<= 41'b00000000000000100000000010100000000000000;
			next_state	<= wCOP0PendingInterrupt ? COP0EXC : FETCH;
		end
		
		LW2:
		begin
			word	<= 41'b00000000000000000000000000001000000000010;
			next_state	<= wCOP0PendingInterrupt ? COP0EXC : FETCH;
		end
		
		STATE_LB:
		begin
			word	<= 41'b00001100000000000000000000001000000000010;
			next_state	<= wCOP0PendingInterrupt ? COP0EXC : FETCH;
		end
		
		STATE_LBU:
		begin
			word	<= 41'b00010000000000000000000000001000000000010;
			next_state	<= wCOP0PendingInterrupt ? COP0EXC : FETCH;
		end
		
		STATE_LH:
		begin
			word	<= 41'b00000100000000000000000000001000000000010;
			next_state	<= wCOP0PendingInterrupt ? COP0EXC : FETCH;
		end
		
		STATE_LHU:
		begin
			word	<= 41'b00001000000000000000000000001000000000010;
			next_state	<= wCOP0PendingInterrupt ? COP0EXC : FETCH;
		end
		
		STATE_SB:
		begin
			word	<= 41'b01000000000000000000000010100000000000000;
			next_state	<= wCOP0PendingInterrupt ? COP0EXC : FETCH;
		end
		
		STATE_SH:
		begin
			word	<= 41'b00100000000000000000000010100000000000000;
			next_state	<= wCOP0PendingInterrupt ? COP0EXC : FETCH;
		end
		
		SW:
		begin
			word	<= 41'b00000000000000000000000010100000000000000;
			next_state	<= wCOP0PendingInterrupt ? COP0EXC : FETCH;
		end
		
		RM:
		begin
			word	<= 41'b00000000000000000000000000000000110000100;
			next_state	<= FETCH;
		end
		
		RFMT:
		begin
			word	<= 41'b00000000000000000000000000000000100000100;
			case (iFunct)
				FUNMULT,
				FUNDIV,
				FUNMULTU,
				FUNDIVU:
					next_state	<= FETCH;
				default:
					next_state	<= RFMT2;
			endcase
		end
		
		RFMT2:
		begin
			word	<= 41'b00000000000000000000000000000000000000011;
			next_state	<= ((iFunct == FUNADD || iFunct == FUNSUB) && iCOP0ALUoverflow && ~iCOP0ExcLevel) || wCOP0PendingInterrupt ? COP0EXC : FETCH;
		end
		
		SHIFT:
		begin
			word	<= 41'b00000000000000000000000000000000100001000;
			next_state	<= RFMT2;
		end
		
		IFMTL:
		begin
			word	<= 41'b00000000000000000000000000000000111000100;
			next_state	<= IFMT2;
		end
		
		IFMTA:
		begin
			word	<= 41'b00000000000000000000000000000000110100100;
			next_state	<= IFMT2;
		end
		
		IFMT2:
		begin
			word	<= 41'b00000000000000000000000000000000000000010;
			next_state	<= (iOp == OPCADDI && iCOP0ALUoverflow && ~iCOP0ExcLevel) || wCOP0PendingInterrupt ? COP0EXC : FETCH;
		end
		
		BEQ:
		begin
			word	<= 41'b00000000000000000000000100000001010000100;
			next_state	<= FETCH;
		end

		BNE:
		begin
			word	<= 41'b00000000000000000000001000000001010000100;
			next_state	<= FETCH;
		end

		JUMP:
		begin
			word	<= 41'b00000000000000000000010000000010000000000;
			next_state	<= FETCH;
		end

		JAL:
		begin
			word	<= 41'b00000000000000000000110000000010111010010;
			next_state	<= FETCH;
		end		
		
		//adicionado em 1/2016, bgez, bgezal, bltz, bltzal.
		BGEZ:
		begin
			word	<= 41'b00000000000000000000000100000001111010100;
			next_state	<= FETCH;
		end
		
		BGEZAL:
		begin
			word	<= 41'b00000000000000000000100100000001111010110;
			next_state	<= FETCH;
		end
		
		BLTZ:
		begin
			word	<= 41'b00000000000000000000001000000001111010100;
			next_state	<= FETCH;
		end
		
		BLTZAL:
		begin
			word	<= 41'b00000000000000000011101000000001111010110;
			next_state	<= FETCH;
		end
		
		BGTZ: //1/2016
		begin
			word	<= 41'b00000000000000000000000100000001111010100;
			next_state	<= FETCH;
		end
		
		BLEZ://1/2016
		begin
			word	<= 41'b00000000000000000000001000000001111010100;
			next_state	<= FETCH;
		end

		JR:
		begin
			word	<= 41'b00000000000000000000010000000011000000000;
			next_state	<= FETCH;
		end
		
		// feito no semestre 2013/1 para implementar a deteccao de excecoes (COP0)
		COP0MTC0:
		begin
			word	<= 41'b00000000000000000000000000000000000000000;
			next_state	<= FETCH;
		end
		
		COP0MFC0:
		begin
			word	<= 41'b00000000000000000011000000000000000000010;
			next_state	<= FETCH;
		end
		
		COP0ERET:
		begin
			word	<= 41'b00000000000000000000010000000101000000000;
			next_state	<= FETCH;
		end
		
		COP0EXC:
		begin
			word	<= 41'b00000000000000000000010000000100000000000;
			next_state	<= FETCH;
		end
		// feito no semestre 2013/1 para implementar a deteccao de excecoes (COP0)
				
		ERRO:
		begin
			word  <= 41'b00000000000000000000000000000000000000001;
			next_state	<= ERRO;
		end

		default:
		begin
			word	<= 41'b0;
			next_state	<= ERRO;
		end
		
	endcase
end

endmodule
`endif
