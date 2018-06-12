/*
 * Bloco de Controle MULTICICLO
 *
 */	
`ifdef MULTICICLO
module Control_MULTI (
	/* I/O type definition */
	input wire iCLK, iRST,
	input wire [5:0] iOpcode,
	output wire oIorD, oMemRead, oMemWrite, oIRWrite, oALUSrcA,
				oRegWrite, oPCWrite, oPCWriteCond, oPCSource,
	output wire [1:0] oALUSrcB, oALUOp, oMemtoReg,
	output wire [2:0]  oStore,
	output wire [5:0] oState,
	//Adicionado em 1/2014
	output wire [2:0] oLoadCase,
	output wire [1:0] oWriteCase,
	);


//wire [14:0] wOutput;			// sinais de controle do caminho de dados
reg  [5:0]  CURRENT_STATE;		// present state
wire [5:0]  wNextState;		// next estate

//assign   oFPStart 			= wOutput[40];
//assign	oWriteCase 			= wOutput[39:38];		//  1/2014
//assign	oLoadCase		 	= wOutput[37:35];		//  1/2014
//assign	oFPRegDst 			= wOutput[34:33];
//assign	oFPDataReg 			= wOutput[32:31];
//assign	oFPRegWrite 		= wOutput[30];
//assign	oFPPCWriteBc1t 	= wOutput[29];
//assign	oFPPCWriteBc1f 	= wOutput[28];
//assign	oFPFlagWrite 		= wOutput[27];
//assign	oFPU2Mem 			= wOutput[26];
//assign	oClearJAction = wOutput[25]; // fio Disponivel
//assign	oJReset 	= wOutput[24];  // fio Disponivel
//assign	oSleepWrite = wOutput[23]; // fio Disponivel
assign oIorD = wOutput[14];
assign oMemRead = wOutput[13];
assign oMemWrite = wOutput[12];
assign oIRWrite = wOutput[11];
assign oALUSrcA = wOutput[10];
assign oALUSrcB = wOutput[9:8];
assign oALUOp = wOutput[7:6];
assign oMemtoReg = wOutput[5:4];
assign oRegWrite = wOutput[3];
assign oPCWrite = wOutput[2];
assign oPCWriteCond = wOutput[1];
assign oPCSource = wOutput[0];

assign	oState		= CURRENT_STATE;

// feito no semestre 2013/1 para implementar a deteccao de excecoes (COP0)
assign 	oCOP0PCOriginalWrite = CURRENT_STATE != COP0EXC;
assign 	oCOP0Interrupted = CURRENT_STATE == COP0EXC && oCOP0ExcCode == EXCODEINT;

initial
begin
	CURRENT_STATE	<= FETCH;
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
		CURRENT_STATE	<= FETCH;
	else
		CURRENT_STATE	<= wNextState;
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
	oCOP0RegWrite <= CURRENT_STATE == COP0MTC0;
	oCOP0Eret <= CURRENT_STATE == COP0ERET;
	oCOP0ExcOccurred <= CURRENT_STATE == COP0EXC;
	// feito no semestre 2013/1 para implementar a deteccao de excecoes (COP0)
	
	case (CURRENT_STATE)
	
		FETCH:
		begin
			wOutput	<= 41'b00000000000000000000010001010000000010000;
			wNextState	<= DECODE;
		end
		
		DECODE:
		begin
			wOutput	<= 41'b00000000000000000000000000000000000110000;
			case (iOp)
				OPCRM: 	// Grupo 2 - (2/2016)
					if (iFunct == FUNMADD || iFunct == FUNMSUB || iFunct == FUNMADDU || iFunct == FUNMSUBU)
						wNextState	<= wCOP0PendingInterrupt ? COP0EXC : RM;
					else
						wNextState	<= FETCH;
						
				OPCRFMT:
					case (iFunct)
						FUNJR:
							wNextState <= wCOP0PendingInterrupt ? COP0EXC : JR;
						FUNSLL, 
						FUNSRL, 
						FUNSRA: 						
							wNextState	<= SHIFT;
						FUNSYS:
							wNextState	<= iCOP0UserMode ? COP0EXC : FETCH;
						default:
							wNextState	<= RFMT;
					endcase
									
				OPCJMP:
					wNextState	<= wCOP0PendingInterrupt ? COP0EXC : JUMP;
					
				OPCBEQ:
					wNextState	<= wCOP0PendingInterrupt ? COP0EXC : BEQ;
					
				OPCBNE:
					wNextState	<= wCOP0PendingInterrupt ? COP0EXC : BNE;
					
				OPCJAL:
					wNextState	<= wCOP0PendingInterrupt ? COP0EXC : JAL;

				//operações implementadas em 1/2016 - bgtz, blez, bgez, bgezal, bgltz, bltzal.
				OPCBGTZ:
					wNextState	<= wCOP0PendingInterrupt ? COP0EXC : BGTZ;
					
				OPCBLEZ:
					wNextState	<= wCOP0PendingInterrupt ? COP0EXC : BLEZ;
					
				OPCBGE_LTZ:
					case (iRt)
						RTBGEZ:
							wNextState	<= wCOP0PendingInterrupt ? COP0EXC : BGEZ;
						RTBGEZAL:
							wNextState	<= wCOP0PendingInterrupt ? COP0EXC : BGEZAL;
						RTBLTZ:
							wNextState	<= wCOP0PendingInterrupt ? COP0EXC : BLTZ;
						RTBLTZAL:
							wNextState	<= wCOP0PendingInterrupt ? COP0EXC : BLTZAL;
						default:
							wNextState	<= ERRO;
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
					wNextState	<= LWSW;

				OPCANDI,
				OPCORI,
				OPCXORI:
					wNextState	<= IFMTL;
					
				OPCADDI,
				OPCADDIU,
				OPCSLTI,
				OPCSLTIU,
				OPCLUI:
					wNextState	<= IFMTA;
					
				OPCFLT:
					case (iFmt)
						FMTMTC:
							wNextState <= FPUMTC1;
						FMTMFC:
							wNextState <= FPUMFC1;
						FMTBC1:
						begin
							if (wCOP0PendingInterrupt)
								wNextState <= COP0EXC;
							else 
								if (iFt)
									wNextState <= FPUBC1T;
								else
									wNextState <= FPUBC1F;
						end
						FMTW,
						FMTS:
							case(iFunct)
								FUNMOV:
									wNextState	<= FPUMOV;
								FUNCEQ,
								FUNCLT,
								FUNCLE:
									wNextState	<= FPUCOMP;
								default:
									wNextState	<= FPUFRSTART;
							endcase
						default:
							wNextState <= COP0EXC;
					endcase
					
				// feito no semestre 2013/1 para implementar a deteccao de excecoes (COP0)
				OPCCOP0:
				begin
					case (iFmt)
						FMTMTC:
							wNextState <= iCOP0UserMode ? COP0EXC : COP0MTC0;
						FMTMFC:
							wNextState <= iCOP0UserMode ? COP0EXC : COP0MFC0;
						FMTERET:
							wNextState <= (iFunct != FUNERET) || iCOP0UserMode ? COP0EXC : COP0ERET;
						default:
							wNextState <= COP0EXC;
					endcase
				end
				// feito no semestre 2013/1 para implementar a deteccao de excecoes (COP0)
				
				default:
					wNextState	<= COP0EXC;
			endcase
		end
		
		FPUMTC1:
		begin
			wOutput	<= 41'b00000001101000000000000000000000000000000;
			wNextState	<= wCOP0PendingInterrupt ? COP0EXC : FETCH;
		end
		
		FPUMFC1:
		begin
			wOutput	<= 41'b00000000000000000010100000000000000000010;
			wNextState <= wCOP0PendingInterrupt ? COP0EXC : FETCH;
		end
		
		FPUBC1T:
		begin
			wOutput	<= 41'b00000000000100000000000000000001000000000;
			wNextState <= FETCH;
		end
		
		FPUBC1F:
		begin
			wOutput	<= 41'b00000000000010000000000000000001000000000;
			wNextState <= FETCH;
		end
		
		FPUMOV:
		begin
			wOutput	<= 41'b00000000111000000000000000000000000000000;
			wNextState <= wCOP0PendingInterrupt ? COP0EXC : FETCH;
		end
		
		FPUCOMP:
		begin
			wOutput	<= 41'b00000000000001000000000000000000000000000;
			wNextState <= wCOP0PendingInterrupt ? COP0EXC : FETCH;
		end
		
		FPUFRSTART:
		begin
			wOutput	<= 41'b10000000000000000000000000000000000000000;
			wNextState <= FPUFRWAIT;
		end
		
		FPUFRWAIT:
		begin
			wOutput	<= 41'b00000000000000000000000000000000000000000;
			wNextState <= iFPBusy ? FPUFRWAIT : FPUFR2;
		end
		
		FPUFR2:
		begin
			wOutput	<= 41'b00000000001000000000000000000000000000000;
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
				wNextState <= COP0EXC;
			else
				wNextState <= FETCH;
		end
		
		LWSW:
		begin
			wOutput	<= 41'b00000000000000000000000000000000000100100;
			case (iOp)
				OPCLW,				
				OPCLB,
				OPCLBU,
				OPCLH,
				OPCLHU,		// 1/2014
				OPCLWC1:
					wNextState	<= LW;
				OPCSB:								// 1/2014
					wNextState <= STATE_SB;		// 1/2014
				OPCSH:								// 1/2014
					wNextState <= STATE_SH;		// 1/2014
				OPCSW:
					wNextState	<= SW;
				OPCSWC1:
					wNextState	<= FPUSWC1;
				default:
					wNextState	<= ERRO;
			endcase
		end
		
		LW:
		begin
			wOutput	<= 41'b00000000000000000000000011000000000000000;
			case (iOp)
				OPCLW:
					wNextState	<= LW2;
				OPCLWC1:
					wNextState	<= FPULWC1;
				//Listinha de casos 1/2014
				OPCLB:
					wNextState <= STATE_LB;
				OPCLBU:
					wNextState <= STATE_LBU;
				OPCLH:
					wNextState <= STATE_LH;
				OPCLHU:
					wNextState <= STATE_LHU;
				default:
					wNextState	<= ERRO;
			endcase
		end
		
		FPULWC1:
		begin
			wOutput	<= 41'b00000010011000000000000000000000000000000;
			wNextState	<= wCOP0PendingInterrupt ? COP0EXC : FETCH;
		end
		
		FPUSWC1:
		begin
			wOutput	<= 41'b00000000000000100000000010100000000000000;
			wNextState	<= wCOP0PendingInterrupt ? COP0EXC : FETCH;
		end
		
		LW2:
		begin
			wOutput	<= 41'b00000000000000000000000000001000000000010;
			wNextState	<= wCOP0PendingInterrupt ? COP0EXC : FETCH;
		end
		
		STATE_LB:
		begin
			wOutput	<= 41'b00001100000000000000000000001000000000010;
			wNextState	<= wCOP0PendingInterrupt ? COP0EXC : FETCH;
		end
		
		STATE_LBU:
		begin
			wOutput	<= 41'b00010000000000000000000000001000000000010;
			wNextState	<= wCOP0PendingInterrupt ? COP0EXC : FETCH;
		end
		
		STATE_LH:
		begin
			wOutput	<= 41'b00000100000000000000000000001000000000010;
			wNextState	<= wCOP0PendingInterrupt ? COP0EXC : FETCH;
		end
		
		STATE_LHU:
		begin
			wOutput	<= 41'b00001000000000000000000000001000000000010;
			wNextState	<= wCOP0PendingInterrupt ? COP0EXC : FETCH;
		end
		
		STATE_SB:
		begin
			wOutput	<= 41'b01000000000000000000000010100000000000000;
			wNextState	<= wCOP0PendingInterrupt ? COP0EXC : FETCH;
		end
		
		STATE_SH:
		begin
			wOutput	<= 41'b00100000000000000000000010100000000000000;
			wNextState	<= wCOP0PendingInterrupt ? COP0EXC : FETCH;
		end
		
		SW:
		begin
			wOutput	<= 41'b00000000000000000000000010100000000000000;
			wNextState	<= wCOP0PendingInterrupt ? COP0EXC : FETCH;
		end
		
		RM:
		begin
			wOutput	<= 41'b00000000000000000000000000000000110000100;
			wNextState	<= FETCH;
		end
		
		RFMT:
		begin
			wOutput	<= 41'b00000000000000000000000000000000100000100;
			case (iFunct)
				FUNMULT,
				FUNDIV,
				FUNMULTU,
				FUNDIVU:
					wNextState	<= FETCH;
				default:
					wNextState	<= RFMT2;
			endcase
		end
		
		RFMT2:
		begin
			wOutput	<= 41'b00000000000000000000000000000000000000011;
			wNextState	<= ((iFunct == FUNADD || iFunct == FUNSUB) && iCOP0ALUoverflow && ~iCOP0ExcLevel) || wCOP0PendingInterrupt ? COP0EXC : FETCH;
		end
		
		SHIFT:
		begin
			wOutput	<= 41'b00000000000000000000000000000000100001000;
			wNextState	<= RFMT2;
		end
		
		IFMTL:
		begin
			wOutput	<= 41'b00000000000000000000000000000000111000100;
			wNextState	<= IFMT2;
		end
		
		IFMTA:
		begin
			wOutput	<= 41'b00000000000000000000000000000000110100100;
			wNextState	<= IFMT2;
		end
		
		IFMT2:
		begin
			wOutput	<= 41'b00000000000000000000000000000000000000010;
			wNextState	<= (iOp == OPCADDI && iCOP0ALUoverflow && ~iCOP0ExcLevel) || wCOP0PendingInterrupt ? COP0EXC : FETCH;
		end
		
		BEQ:
		begin
			wOutput	<= 41'b00000000000000000000000100000001010000100;
			wNextState	<= FETCH;
		end

		BNE:
		begin
			wOutput	<= 41'b00000000000000000000001000000001010000100;
			wNextState	<= FETCH;
		end

		JUMP:
		begin
			wOutput	<= 41'b00000000000000000000010000000010000000000;
			wNextState	<= FETCH;
		end

		JAL:
		begin
			wOutput	<= 41'b00000000000000000000110000000010111010010;
			wNextState	<= FETCH;
		end		
		
		//adicionado em 1/2016, bgez, bgezal, bltz, bltzal.
		BGEZ:
		begin
			wOutput	<= 41'b00000000000000000000000100000001111010100;
			wNextState	<= FETCH;
		end
		
		BGEZAL:
		begin
			wOutput	<= 41'b00000000000000000000100100000001111010110;
			wNextState	<= FETCH;
		end
		
		BLTZ:
		begin
			wOutput	<= 41'b00000000000000000000001000000001111010100;
			wNextState	<= FETCH;
		end
		
		BLTZAL:
		begin
			wOutput	<= 41'b00000000000000000011101000000001111010110;
			wNextState	<= FETCH;
		end
		
		BGTZ: //1/2016
		begin
			wOutput	<= 41'b00000000000000000000000100000001111010100;
			wNextState	<= FETCH;
		end
		
		BLEZ://1/2016
		begin
			wOutput	<= 41'b00000000000000000000001000000001111010100;
			wNextState	<= FETCH;
		end

		JR:
		begin
			wOutput	<= 41'b00000000000000000000010000000011000000000;
			wNextState	<= FETCH;
		end
		
		// feito no semestre 2013/1 para implementar a deteccao de excecoes (COP0)
		COP0MTC0:
		begin
			wOutput	<= 41'b00000000000000000000000000000000000000000;
			wNextState	<= FETCH;
		end
		
		COP0MFC0:
		begin
			wOutput	<= 41'b00000000000000000011000000000000000000010;
			wNextState	<= FETCH;
		end
		
		COP0ERET:
		begin
			wOutput	<= 41'b00000000000000000000010000000101000000000;
			wNextState	<= FETCH;
		end
		
		COP0EXC:
		begin
			wOutput	<= 41'b00000000000000000000010000000100000000000;
			wNextState	<= FETCH;
		end
		// feito no semestre 2013/1 para implementar a deteccao de excecoes (COP0)
				
		ERRO:
		begin
			wOutput  <= 41'b00000000000000000000000000000000000000001;
			wNextState	<= ERRO;
		end

		default:
		begin
			wOutput	<= 41'b0;
			wNextState	<= ERRO;
		end
		
	endcase
end

endmodule
`endif
