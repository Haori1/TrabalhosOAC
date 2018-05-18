/*
 * Bloco de Controle PIPELINE
 *
 */
module Control_PIPEM (
	input [5:0]  iOp, iFunct,
	output 		 oEscreveReg, oLeMem, oEscreveMem, oJump, oBranch, onBranch, oJr, oSavePC,
	output [1:0] oOpALU, oOrigALU, oRegDst,
	output [2:0] oOrigPC,
	output		 oEscreveEPC,
	output [2:0] oLoadType,
	output [1:0] oWriteType,
	
	output       oFPUtoULA,
	input  [4:0] iFmt,
	input        iBranchC1,
	output [1:0] oFPDataReg,
	output [1:0] oFPRegDst,
	output       oFPRegWrite,
	output       oFPFlagWrite,
	output       oFPU2Mem,
	output       oFPStart
);

always @(*) 
	case(iOp)
		OPCRM:
			case (iFunct)
				FUNMADD,	// Relatorio questao 6.B) - Grupo 2 - (2/2016)
				FUNMSUB:	// Relatorio questao 6.B) - Grupo 2 - (2/2016)
				begin
					oRegDst     <= 2'b01;  // seleciona o Rd
					oOrigALU    <= 2'b00;  // seleciona o resultado do fowardB
					oSavePC     <= 1'b0;   // seleciona o resultado da ALU
					oEscreveReg <= 1'b1;   // ativa EscreveReg
					oLeMem      <= 1'b0;   // desativa LeMem
					oEscreveMem <= 1'b0;   // desativa EscreveMem
					oOrigPC     <= 3'b000; // seleciona PC+4
					oOpALU      <= 2'b11;  // funct determina a operacao da ALU
					oJump       <= 1'b0;   // desativa jump
					oBranch     <= 1'b0;   // desativa branch
					onBranch    <= 1'b0;   // desativa BNE
					oJr         <= 1'b0;   // desativa o Jr
					oEscreveEPC	<= 1'b0;	  // Escreve EPC
					oLoadType   <= 3'b000; // load word/ignore
					oWriteType  <= 2'b00;  // write word/ignore
				
					oFPDataReg     <= 2'b00;
					oFPRegDst      <= 2'b00;
					oFPRegWrite    <= 1'b0;
					oFPFlagWrite   <= 1'b0;
					oFPU2Mem       <= 1'b0;
					oFPStart       <= 1'b0;
					oFPUtoULA      <= 1'b0;
				end

				FUNMADDU,	// Relatorio questao 6.B) - Grupo 2 - (2/2016)
				FUNMSUBU:	// Relatorio questao 6.B) - Grupo 2 - (2/2016)
				begin
					oRegDst     <= 2'b01;  // seleciona o Rd
					oOrigALU    <= 2'b00;  // seleciona o resultado do fowardB
					oSavePC     <= 1'b0;   // seleciona o resultado da ALU
					oEscreveReg <= 1'b1;   // ativa EscreveReg
					oLeMem      <= 1'b0;   // desativa LeMem
					oEscreveMem <= 1'b0;   // desativa EscreveMem
					oOrigPC     <= 3'b000; // seleciona PC+4
					oOpALU      <= 2'b11;  // funct determina a operacao da ALU
					oJump       <= 1'b0;   // desativa jump
					oBranch     <= 1'b0;   // desativa branch
					onBranch    <= 1'b0;   // desativa BNE
					oJr         <= 1'b0;   // desativa o Jr
					oEscreveEPC	<= 1'b0;	  // Escreve EPC
					oLoadType   <= 3'b000; // load word/ignore
					oWriteType  <= 2'b00;  // write word/ignore
				
					oFPDataReg     <= 2'b00;
					oFPRegDst      <= 2'b00;
					oFPRegWrite    <= 1'b0;
					oFPFlagWrite   <= 1'b0;
					oFPU2Mem       <= 1'b0;
					oFPStart       <= 1'b0;	
					oFPUtoULA      <= 1'b0;
				end
				
				default: // Instrucao Nao reconhecida
				begin
					oRegDst     <= 2'b00;
					oOrigALU    <= 2'b00;
					oSavePC     <= 1'b0;
					oEscreveReg <= 1'b0;
					oLeMem      <= 1'b0;
					oEscreveMem <= 1'b0;
					oOrigPC     <= 3'b111; // default: ignora a instrução não reconhecida
					oOpALU      <= 2'b00;
					oJump       <= 1'b0;   // desativa jump
					oBranch     <= 1'b0;   // desativa branch
					onBranch    <= 1'b0;   // desativa BNE
					oJr         <= 1'b0;   // desativa o Jr
					oEscreveEPC	<= 1'b0;	  // Escreve EPC
					oLoadType   <= 3'b000; // load word/ignore
					oWriteType  <= 2'b00;  // write word/ignore
				
					oFPDataReg     <= 2'b00;
					oFPRegDst      <= 2'b00;
					oFPRegWrite    <= 1'b0;
					oFPFlagWrite   <= 1'b0;
					oFPU2Mem       <= 1'b0;
					oFPStart       <= 1'b0;
					oFPUtoULA      <= 1'b0;
				end
			endcase

		OPCLW://OK
			begin
				oRegDst     <= 2'b00;  // seleciona o Rt
				oOrigALU    <= 2'b01;  // seleciona o imediato
				oSavePC     <= 1'b0;   // seleciona o resultado da memoria de dados
				oEscreveReg <= 1'b1;   // ativa EscreveReg
				oLeMem      <= 1'b1;   // ativa LeMem
				oEscreveMem <= 1'b0;   // desativa EscreveMem
				oOrigPC     <= 3'b000; // seleciona PC+4
				oOpALU      <= 2'b00;  // realiza ADD
				oJump       <= 1'b0;   // desativa jump
				oBranch     <= 1'b0;   // desativa branch
				onBranch    <= 1'b0;   // desativa BNE
				oJr         <= 1'b0;   // desativa o Jr
				oEscreveEPC	<= 1'b0;	  // Escreve EPC
				oLoadType   <= LOAD_TYPE_LW; // load word/ignore
				oWriteType  <= 2'b00;  // write word/ignore
				
				oFPDataReg     <= 2'b00;
				oFPRegDst      <= 2'b00;
				oFPRegWrite    <= 1'b0;
				oFPFlagWrite   <= 1'b0;
				oFPU2Mem       <= 1'b0;
				oFPStart       <= 1'b0;
				oFPUtoULA      <= 1'b0;
			end
			
		OPCLH:
			begin
				oRegDst     <= 2'b00;  // seleciona o Rt
				oOrigALU    <= 2'b01;  // seleciona o imediato
				oSavePC     <= 1'b0;   // seleciona o resultado da MD
				oEscreveReg <= 1'b1;   // ativa EscreveReg
				oLeMem      <= 1'b1;   // ativa LeMem
				oEscreveMem <= 1'b0;   // desativa EscreveMem
				oOrigPC     <= 3'b000; // seleciona PC+4
				oOpALU      <= 2'b00;  // realiza ADD
				oJump       <= 1'b0;   // desativa jump
				oBranch     <= 1'b0;   // desativa branch
				onBranch    <= 1'b0;   // desativa BNE
				oJr         <= 1'b0;   // desativa o Jr
				oEscreveEPC	<= 1'b0;	  // Escreve EPC
				oLoadType   <= LOAD_TYPE_LH; // load signed halfword
				oWriteType  <= 2'b00;  // write word/ignore
				
				oFPDataReg     <= 2'b00;
				oFPRegDst      <= 2'b00;
				oFPRegWrite    <= 1'b0;
				oFPFlagWrite   <= 1'b0;
				oFPU2Mem       <= 1'b0;
				oFPStart       <= 1'b0;
				oFPUtoULA      <= 1'b0;
			end
			
		OPCLHU:
			begin
				oRegDst     <= 2'b00;  // seleciona o Rt
				oOrigALU    <= 2'b01;  // seleciona o imediato
				oSavePC     <= 1'b0;   // seleciona o resultado da MD
				oEscreveReg <= 1'b1;   // ativa EscreveReg
				oLeMem      <= 1'b1;   // ativa LeMem
				oEscreveMem <= 1'b0;   // desativa EscreveMem
				oOrigPC     <= 3'b000; // seleciona PC+4
				oOpALU      <= 2'b00;  // realiza ADD
				oJump       <= 1'b0;   // desativa jump
				oBranch     <= 1'b0;   // desativa branch
				onBranch    <= 1'b0;   // desativa BNE
				oJr         <= 1'b0;   // desativa o Jr
				oEscreveEPC	<= 1'b0;	  // Escreve EPC
				oLoadType   <= LOAD_TYPE_LHU; // load unsigned halfword
				oWriteType  <= 2'b00;  // write word/ignore
				
				oFPDataReg     <= 2'b00;
				oFPRegDst      <= 2'b00;
				oFPRegWrite    <= 1'b0;
				oFPFlagWrite   <= 1'b0;
				oFPU2Mem       <= 1'b0;
				oFPStart       <= 1'b0;
				oFPUtoULA      <= 1'b0;
			end
			
		OPCLB:
			begin
				oRegDst     <= 2'b00;  // seleciona o Rt
				oOrigALU    <= 2'b01;  // seleciona o imediato
				oSavePC     <= 1'b0;   // seleciona o resultado da MD
				oEscreveReg <= 1'b1;   // ativa EscreveReg
				oLeMem      <= 1'b1;   // ativa LeMem
				oEscreveMem <= 1'b0;   // desativa EscreveMem
				oOrigPC     <= 3'b000; // seleciona PC+4
				oOpALU      <= 2'b00;  // realiza ADD
				oJump       <= 1'b0;   // desativa jump
				oBranch     <= 1'b0;   // desativa branch
				onBranch    <= 1'b0;   // desativa BNE
				oJr         <= 1'b0;   // desativa o Jr
				oEscreveEPC	<= 1'b0;	  // Escreve EPC
				oLoadType   <= LOAD_TYPE_LB; // load signed byte
				oWriteType  <= 2'b00;  // write word/ignore
				
				oFPDataReg     <= 2'b00;
				oFPRegDst      <= 2'b00;
				oFPRegWrite    <= 1'b0;
				oFPFlagWrite   <= 1'b0;
				oFPU2Mem       <= 1'b0;
				oFPStart       <= 1'b0;
				oFPUtoULA      <= 1'b0;
			end
			
		OPCLBU:
			begin
				oRegDst     <= 2'b00;  // seleciona o Rt
				oOrigALU    <= 2'b01;  // seleciona o imediato
				oSavePC     <= 1'b0;   // seleciona o resultado da MD
				oEscreveReg <= 1'b1;   // ativa EscreveReg
				oLeMem      <= 1'b1;   // ativa LeMem
				oEscreveMem <= 1'b0;   // desativa EscreveMem
				oOrigPC     <= 3'b000; // seleciona PC+4
				oOpALU      <= 2'b00;  // realiza ADD
				oJump       <= 1'b0;   // desativa jump
				oBranch     <= 1'b0;   // desativa branch
				onBranch    <= 1'b0;   // desativa BNE
				oJr         <= 1'b0;   // desativa o Jr
				oEscreveEPC	<= 1'b0;	  // Escreve EPC
				oLoadType   <= LOAD_TYPE_LBU; // byte unsigned
				oWriteType  <= 2'b00;  // write word/ignore
				
				oFPDataReg     <= 2'b00;
				oFPRegDst      <= 2'b00;
				oFPRegWrite    <= 1'b0;
				oFPFlagWrite   <= 1'b0;
				oFPU2Mem       <= 1'b0;
				oFPStart       <= 1'b0;
				oFPUtoULA      <= 1'b0;
			end
			
		OPCSW://OK
			begin
				oRegDst     <= 2'b00;  // seleciona o Rt
				oOrigALU    <= 2'b01;  // seleciona o imediato
				oSavePC     <= 1'b0;   // seleciona o resultado da MD (pra nada)
				oEscreveReg <= 1'b0;   // desativa EscreveReg
				oLeMem      <= 1'b0;   // desativa LeMem
				oEscreveMem <= 1'b1;   // ativa EscreveMem
				oOrigPC     <= 3'b000; // seleciona PC+4
				oOpALU      <= 2'b00;  // realiza ADD
				oJump       <= 1'b0;   // desativa jump
				oBranch     <= 1'b0;   // desativa branch
				onBranch    <= 1'b0;   // desativa BNE
				oJr         <= 1'b0;   // desativa o Jr
				oEscreveEPC	<= 1'b0;	  // Escreve EPC
				oLoadType   <= 3'b000; // load word/ignore
				oWriteType  <= STORE_TYPE_SW;  // write word/ignore
				
				oFPDataReg     <= 2'b00;
				oFPRegDst      <= 2'b00;
				oFPRegWrite    <= 1'b0;
				oFPFlagWrite   <= 1'b0;
				oFPU2Mem       <= 1'b0;
				oFPStart       <= 1'b0;
				oFPUtoULA      <= 1'b0;
			end
			
		OPCSH:
			begin
				oRegDst     <= 2'b00;  // seleciona o Rt
				oOrigALU    <= 2'b01;  // seleciona o imediato
				oSavePC     <= 1'b0;   // seleciona o resultado da MD (pra nada)
				oEscreveReg <= 1'b0;   // desativa EscreveReg
				oLeMem      <= 1'b0;   // desativa LeMem
				oEscreveMem <= 1'b1;   // ativa EscreveMem
				oOrigPC     <= 3'b000; // seleciona PC+4
				oOpALU      <= 2'b00;  // realiza ADD
				oJump       <= 1'b0;   // desativa jump
				oBranch     <= 1'b0;   // desativa branch
				onBranch    <= 1'b0;   // desativa BNE
				oJr         <= 1'b0;   // desativa o Jr
				oEscreveEPC	<= 1'b0;	  // Escreve EPC
				oLoadType   <= 3'b000; // load word/ignore
				oWriteType  <= STORE_TYPE_SH;  // store halfword
				
				oFPDataReg     <= 2'b00;
				oFPRegDst      <= 2'b00;
				oFPRegWrite    <= 1'b0;
				oFPFlagWrite   <= 1'b0;
				oFPU2Mem       <= 1'b0;
				oFPStart       <= 1'b0;
				oFPUtoULA      <= 1'b0;
			end
			
		OPCSB:
			begin
				oRegDst     <= 2'b00;  // seleciona o Rt
				oOrigALU    <= 2'b01;  // seleciona o imediato
				oSavePC     <= 1'b0;   // seleciona o resultado da MD (pra nada)
				oEscreveReg <= 1'b0;   // desativa EscreveReg
				oLeMem      <= 1'b0;   // desativa LeMem
				oEscreveMem <= 1'b1;   // ativa EscreveMem
				oOrigPC     <= 3'b000; // seleciona PC+4
				oOpALU      <= 2'b00;  // realiza ADD
				oJump       <= 1'b0;   // desativa jump
				oBranch     <= 1'b0;   // desativa branch
				onBranch    <= 1'b0;   // desativa BNE
				oJr         <= 1'b0;   // desativa o Jr
				oEscreveEPC	<= 1'b0;	  // Escreve EPC
				oLoadType   <= 3'b000; // load word/ignore
				oWriteType  <= STORE_TYPE_SB;  // store byte
				
				oFPDataReg     <= 2'b00;
				oFPRegDst      <= 2'b00;
				oFPRegWrite    <= 1'b0;
				oFPFlagWrite   <= 1'b0;
				oFPU2Mem       <= 1'b0;
				oFPStart       <= 1'b0;
				oFPUtoULA      <= 1'b0;
			end
			
		OPCBEQ://OK
			begin
				oRegDst     <= 2'b00;  // seleciona o Rt (pra nada)
				oOrigALU    <= 2'b00;  // seleciona o resultado do fowardB (pra nada)
				oSavePC     <= 1'b0;   // seleciona o resultado da MD (pra nada)
				oEscreveReg <= 1'b0;   // desativa EscreveReg
				oLeMem      <= 1'b0;   // desativa LeMem
				oEscreveMem <= 1'b0;   // desativa EscreveMem
				oOrigPC     <= 3'b001; // seleciona o endereco do branch
				oOpALU      <= 2'b01;  // seleciona subtracao (pra nada)
				oJump       <= 1'b0;   // desativa jump
				oBranch     <= 1'b1;   // ativa branch
				onBranch    <= 1'b0;   // desativa BNE
				oJr         <= 1'b0;   // desativa o Jr
				oEscreveEPC	<= 1'b0;	  // Escreve EPC
				oLoadType   <= 3'b000; // load word/ignore
				oWriteType  <= 2'b00;  // write word/ignore
				
				oFPDataReg     <= 2'b00;
				oFPRegDst      <= 2'b00;
				oFPRegWrite    <= 1'b0;
				oFPFlagWrite   <= 1'b0;
				oFPU2Mem       <= 1'b0;
				oFPStart       <= 1'b0;
				oFPUtoULA      <= 1'b0;
			end
			
		OPCBNE://OK
			begin
				oRegDst     <= 2'b00;  // seleciona o Rt (pra nada)
				oOrigALU    <= 2'b00;  // seleciona o resultado do fowardB (pra nada)
				oSavePC     <= 1'b0;   // seleciona o resultado da MD (pra nada)
				oEscreveReg <= 1'b0;   // desativa EscreveReg
				oLeMem      <= 1'b0;   // desativa LeMem
				oEscreveMem <= 1'b0;   // desativa EscreveMem
				oOrigPC     <= 3'b101; // seleciona o endereco do branch
				oOpALU      <= 2'b01;  // seleciona subtracao (pra nada)
				oJump       <= 1'b0;   // desativa jump
				oBranch     <= 1'b0;   // desativa branch
				onBranch    <= 1'b1;   // ativa BNE
				oJr         <= 1'b0;   // desativa o Jr
				oEscreveEPC	<= 1'b0;	  // Escreve EPC
				oLoadType   <= 3'b000; // load word/ignore
				oWriteType  <= 2'b00;  // write word/ignore
				
				oFPDataReg     <= 2'b00;
				oFPRegDst      <= 2'b00;
				oFPRegWrite    <= 1'b0;
				oFPFlagWrite   <= 1'b0;
				oFPU2Mem       <= 1'b0;
				oFPStart       <= 1'b0;
				oFPUtoULA      <= 1'b0;
			end
			
		OPCRFMT:
			case (iFunct)
				FUNJR://OK
					begin
						oRegDst     <= 2'b00;  // seleciona o Rt (pra nada)
						oOrigALU    <= 2'b00;  // seleciona o resultado do fowardB (pra nada)
						oSavePC     <= 1'b0;   // seleciona o resultado da MD (pra nada)
						oEscreveReg <= 1'b0;   // desativa EscreveReg
						oLeMem      <= 1'b0;   // desativa LeMem
						oEscreveMem <= 1'b0;   // desativa EscreveMem
						oOrigPC     <= 3'b010; // seleciona resultado do MUX Jr
						oOpALU      <= 2'b10;  // seleciona campo funct
						oJump       <= 1'b1;   // ativa jump (mesmo que um jr nao seja tipo J)
						oBranch     <= 1'b0;   // desativa branch
						onBranch    <= 1'b0;   // desativa BNE
						oJr         <= 1'b1;   // ativa o Jr
						oEscreveEPC	<= 1'b0;	  // Escreve EPC
						oLoadType   <= 3'b000; // load word/ignore
						oWriteType  <= 2'b00;  // write word/ignore
				
						oFPDataReg     <= 2'b00;
						oFPRegDst      <= 2'b00;
						oFPRegWrite    <= 1'b0;
						oFPFlagWrite   <= 1'b0;
						oFPU2Mem       <= 1'b0;
						oFPStart       <= 1'b0;	
						oFPUtoULA      <= 1'b0;
					end
					
				FUNSYS:
					begin
						oRegDst     <= 2'b00; 
						oOrigALU    <= 2'b00;
						oSavePC     <= 1'b0;  
						oEscreveReg <= 1'b0;  
						oLeMem      <= 1'b0;
						oEscreveMem <= 1'b0;
						oOrigPC     <= 3'b100; // Endereco do .ktext
						oOpALU      <= 2'b10;
						oJump       <= 1'b1;   // ativa flush IF
						oBranch     <= 1'b0;   
						onBranch    <= 1'b0;   
						oJr         <= 1'b0;   
						oEscreveEPC	<= 1'b1;	  // Aciona o Escreve EPC
						oLoadType   <= 3'b000; 
						oWriteType  <= 2'b00;  
				
						oFPDataReg     <= 2'b00;
						oFPRegDst      <= 2'b00;
						oFPRegWrite    <= 1'b0;
						oFPFlagWrite   <= 1'b0;
						oFPU2Mem       <= 1'b0;
						oFPStart       <= 1'b0;
						oFPUtoULA      <= 1'b0;	
					end
				//TIPO R
				default://OK
					begin
						oRegDst     <= 2'b01;  // seleciona o Rd
						oOrigALU    <= 2'b00;  // seleciona o resultado do fowardB
						oSavePC     <= 1'b0;   // seleciona o resultado da ALU
						oEscreveReg <= 1'b1;   // ativa EscreveReg
						oLeMem      <= 1'b0;   // desativa LeMem
						oEscreveMem <= 1'b0;   // desativa EscreveMem
						oOrigPC     <= 3'b000; // seleciona PC+4
						oOpALU      <= 2'b10;  // funct determina a operacao da ALU
						oJump       <= 1'b0;   // desativa jump
						oBranch     <= 1'b0;   // desativa branch
						onBranch    <= 1'b0;   // desativa BNE
						oJr         <= 1'b0;   // desativa o Jr
						oEscreveEPC	<= 1'b0;	  // Escreve EPC
						oLoadType   <= 3'b000; // load word/ignore
						oWriteType  <= 2'b00;  // write word/ignore
				
						oFPDataReg     <= 2'b00;
						oFPRegDst      <= 2'b00;
						oFPRegWrite    <= 1'b0;
						oFPFlagWrite   <= 1'b0;
						oFPU2Mem       <= 1'b0;
						oFPStart       <= 1'b0;
						oFPUtoULA      <= 1'b0;	
					end
				endcase
		
		OPCJMP://OK
			begin
				oRegDst     <= 2'b00;  // seleciona o Rt (pra nada)
				oOrigALU    <= 2'b00;  // seleciona o resultado do fowardB (pra nada)
				oSavePC     <= 1'b0;   // seleciona o resultado da MD (pra nada)
				oEscreveReg <= 1'b0;   // desativa EscreveReg
				oLeMem      <= 1'b0;   // desativa LeMem
				oEscreveMem <= 1'b0;   // desativa EscreveMem
				oOrigPC     <= 3'b010; // seleciona resultado do MUX Jr
				oOpALU      <= 2'b00;  // seleciona ADD (pra nada)
				oJump       <= 1'b1;   // ativa jump
				oBranch     <= 1'b0;   // desativa branch
				onBranch    <= 1'b0;   // desativa BNE
				oJr         <= 1'b0;   // desativa o Jr
				oEscreveEPC	<= 1'b0;	  // Escreve EPC
				oLoadType   <= 3'b000; // load word/ignore
				oWriteType  <= 2'b00;  // write word/ignore
				
				oFPDataReg     <= 2'b00;
				oFPRegDst      <= 2'b00;
				oFPRegWrite    <= 1'b0;
				oFPFlagWrite   <= 1'b0;
				oFPU2Mem       <= 1'b0;
				oFPStart       <= 1'b0;
				oFPUtoULA      <= 1'b0;
			end
			
		OPCADDI,
		OPCADDIU://OK
			begin
				oRegDst     <= 2'b00;  // seleciona o Rt
				oOrigALU    <= 2'b01;  // seleciona o imediato com extensao de sinal
				oSavePC     <= 1'b0;   // seleciona o resultado da ALU
				oEscreveReg <= 1'b1;   // ativa EscreveReg
				oLeMem      <= 1'b0;   // desativa LeMem
				oEscreveMem <= 1'b0;   // desativa EscreveMem
				oOrigPC     <= 3'b000; // seleciona PC+4
				oOpALU      <= 2'b11;  // opcode determina operacao da ALU
				oJump       <= 1'b0;   // desativa jump
				oBranch     <= 1'b0;   // desativa branch
				onBranch    <= 1'b0;   // desativa BNE
				oJr         <= 1'b0;   // desativa o Jr
				oEscreveEPC	<= 1'b0;	  // Escreve EPC
				oLoadType   <= 3'b000; // load word/ignore
				oWriteType  <= 2'b00;  // write word/ignore
				
				oFPDataReg     <= 2'b00;
				oFPRegDst      <= 2'b00;
				oFPRegWrite    <= 1'b0;
				oFPFlagWrite   <= 1'b0;
				oFPU2Mem       <= 1'b0;
				oFPStart       <= 1'b0;
				oFPUtoULA      <= 1'b0;
			end
			
		OPCANDI://OK
			begin
				oRegDst     <= 2'b00;  // seleciona o Rt
				oOrigALU    <= 2'b10;  // seleciona o imediato com extensao com zeros
				oSavePC     <= 1'b0;   // seleciona o resultado da ALU
				oEscreveReg <= 1'b1;   // ativa EscreveReg
				oLeMem      <= 1'b0;   // desativa LeMem
				oEscreveMem <= 1'b0;   // desativa EscreveMem
				oOrigPC     <= 3'b000; // seleciona PC+4
				oOpALU      <= 2'b11;  // opcode determina operacao da ALU
				oJump       <= 1'b0;   // desxativa jump
				oBranch     <= 1'b0;   // desativa branch
				onBranch    <= 1'b0;   // desativa BNE
				oJr         <= 1'b0;   // desativa o Jr
				oEscreveEPC	<= 1'b0;	  // Escreve EPC
				oLoadType   <= 3'b000; // load word/ignore
				oWriteType  <= 2'b00;  // write word/ignore
				
				oFPDataReg     <= 2'b00;
				oFPRegDst      <= 2'b00;
				oFPRegWrite    <= 1'b0;
				oFPFlagWrite   <= 1'b0;
				oFPU2Mem       <= 1'b0;
				oFPStart       <= 1'b0;
				oFPUtoULA      <= 1'b0;
			end
			
		OPCXORI://OK
			begin
				oRegDst     <= 2'b00;  // seleciona o Rt
				oOrigALU    <= 2'b10;  // seleciona o imediato com extensao com zeros
				oSavePC     <= 1'b0;   // seleciona o resultado da ALU
				oEscreveReg <= 1'b1;   // ativa EscreveReg
				oLeMem      <= 1'b0;   // desativa LeMem
				oEscreveMem <= 1'b0;   // desativa EscreveMem
				oOrigPC     <= 3'b000; // seleciona PC+4
				oOpALU      <= 2'b11;  // opcode determina operacao da ALU
				oJump       <= 1'b0;   // desxativa jump
				oBranch     <= 1'b0;   // desativa branch
				onBranch    <= 1'b0;   // desativa BNE
				oJr         <= 1'b0;   // desativa o Jr
				oEscreveEPC	<= 1'b0;	  // Escreve EPC
				oLoadType   <= 3'b000; // load word/ignore
				oWriteType  <= 2'b00;  // write word/ignore
				
				oFPDataReg     <= 2'b00;
				oFPRegDst      <= 2'b00;
				oFPRegWrite    <= 1'b0;
				oFPFlagWrite   <= 1'b0;
				oFPU2Mem       <= 1'b0;
				oFPStart       <= 1'b0;
				oFPUtoULA      <= 1'b0;
			end
			
		OPCORI://OK
			begin
				oRegDst     <= 2'b00;  // seleciona o Rt
				oOrigALU    <= 2'b10;  // seleciona o imediato com extensao com zeros
				oSavePC     <= 1'b0;   // seleciona o resultado da ALU
				oEscreveReg <= 1'b1;   // ativa EscreveReg
				oLeMem      <= 1'b0;   // desativa LeMem
				oEscreveMem <= 1'b0;   // desativa EscreveMem
				oOrigPC     <= 3'b000; // seleciona PC+4
				oOpALU      <= 2'b11;  // opcode determina operacao da ALU
				oJump       <= 1'b0;   // desativa jump
				oBranch     <= 1'b0;   // desativa branch
				onBranch    <= 1'b0;   // desativa BNE
				oJr         <= 1'b0;   // desativa o Jr
				oEscreveEPC	<= 1'b0;	  // Escreve EPC
				oLoadType   <= 3'b000; // load word/ignore
				oWriteType  <= 2'b00;  // write word/ignore
				
				oFPDataReg     <= 2'b00;
				oFPRegDst      <= 2'b00;
				oFPRegWrite    <= 1'b0;
				oFPFlagWrite   <= 1'b0;
				oFPU2Mem       <= 1'b0;
				oFPStart       <= 1'b0;
				oFPUtoULA      <= 1'b0;
			end
			
		OPCJAL://OK
			begin
				oRegDst     <= 2'b10;  // Seleciona 31 (ra)
				oOrigALU    <= 2'b00;  // seleciona o resultado do fowardB (pra nada)
				oSavePC     <= 1'b1;   // Escreve PC + 4
				oEscreveReg <= 1'b1;   // ativa EscreveReg
				oLeMem      <= 1'b0;   // desativa LeMem
				oEscreveMem <= 1'b0;   // desativa EscreveMem
				oOrigPC     <= 3'b010; // seleciona o resultado do MUX Jr
				oOpALU      <= 2'b00;  // seleciona ADD (pra nada)
				oJump       <= 1'b1;   // ativa jump
				oBranch     <= 1'b0;   // desativa branch
				onBranch    <= 1'b0;   // desativa BNE
				oJr         <= 1'b0;   // desativa o Jr
				oEscreveEPC	<= 1'b0;	  // Escreve EPC
				oLoadType   <= 3'b000; // load word/ignore
				oWriteType  <= 2'b00;  // write word/ignore
				
				oFPDataReg     <= 2'b00;
				oFPRegDst      <= 2'b00;
				oFPRegWrite    <= 1'b0;
				oFPFlagWrite   <= 1'b0;
				oFPU2Mem       <= 1'b0;
				oFPStart       <= 1'b0;
				oFPUtoULA      <= 1'b0;
			end
			
		OPCLUI://OK
			begin
				oRegDst     <= 2'b00;  // Seleciona o Rt
				oOrigALU    <= 2'b11;  // seleciona o imediato concatenado com 16 zeros
				oSavePC     <= 1'b0;   // seleciona o resultado da ALU (antes selecionava Imm)
				oEscreveReg <= 1'b1;   // ativa EscreveReg
				oLeMem      <= 1'b0;   // desativa LeMem
				oEscreveMem <= 1'b0;   // desativa EscreveMem
				oOrigPC     <= 3'b000; // seleciona PC+4
				oOpALU      <= 2'b00;  // seleciona ADD (pra nada)
				oJump       <= 1'b0;   // desativa jump
				oBranch     <= 1'b0;   // desativa branch
				onBranch    <= 1'b0;   // desativa BNE
				oJr         <= 1'b0;   // desativa o Jr
				oEscreveEPC	<= 1'b0;	  // Escreve EPC
				oLoadType   <= 3'b000; // load word/ignore
				oWriteType  <= 2'b00;  // write word/ignore
				
				oFPDataReg     <= 2'b00;
				oFPRegDst      <= 2'b00;
				oFPRegWrite    <= 1'b0;
				oFPFlagWrite   <= 1'b0;
				oFPU2Mem       <= 1'b0;
				oFPStart       <= 1'b0;
				oFPUtoULA      <= 1'b0;
			end
			
		OPCSLTI:
			begin
				oRegDst     <= 2'b00;  // Seleciona o Rt
				oOrigALU    <= 2'b01;  // seleciona o imediato com extensao de sinal
				oSavePC     <= 1'b0;   // seleciona o resultado da ALU (antes selecionava Imm)
				oEscreveReg <= 1'b1;   // ativa EscreveReg
				oLeMem      <= 1'b0;   // desativa LeMem
				oEscreveMem <= 1'b0;   // desativa EscreveMem
				oOrigPC     <= 3'b000; // seleciona PC+4
				oOpALU      <= 2'b11;  // seleciona ADD (pra nada)
				oJump       <= 1'b0;   // desativa jump
				oBranch     <= 1'b0;   // desativa branch
				onBranch    <= 1'b0;   // desativa BNE
				oJr         <= 1'b0;   // desativa o Jr
				oEscreveEPC	<= 1'b0;	  // Escreve EPC
				oLoadType   <= 3'b000; // load word/ignore
				oWriteType  <= 2'b00;  // write word/ignore
				
				oFPDataReg     <= 2'b00;
				oFPRegDst      <= 2'b00;
				oFPRegWrite    <= 1'b0;
				oFPFlagWrite   <= 1'b0;
				oFPU2Mem       <= 1'b0;
				oFPStart       <= 1'b0;
				oFPUtoULA      <= 1'b0;
			end
			
		OPCSLTIU:
			begin
				oRegDst     <= 2'b00;  // Seleciona o Rt
				oOrigALU    <= 2'b10;  // seleciona o imediato com extensao com zeros
				oSavePC     <= 1'b0;   // seleciona o resultado da ALU (antes selecionava Imm)
				oEscreveReg <= 1'b1;   // ativa EscreveReg
				oLeMem      <= 1'b0;   // desativa LeMem
				oEscreveMem <= 1'b0;   // desativa EscreveMem
				oOrigPC     <= 3'b000; // seleciona PC+4
				oOpALU      <= 2'b11;  // seleciona ADD (pra nada)
				oJump       <= 1'b0;   // desativa jump
				oBranch     <= 1'b0;   // desativa branch
				onBranch    <= 1'b0;   // desativa BNE
				oJr         <= 1'b0;   // desativa o Jr
				oEscreveEPC	<= 1'b0;	  // Escreve EPC
				oLoadType   <= 3'b000; // load word/ignore
				oWriteType  <= 2'b00;  // write word/ignore
				
				oFPDataReg     <= 2'b00;
				oFPRegDst      <= 2'b00;
				oFPRegWrite    <= 1'b0;
				oFPFlagWrite   <= 1'b0;
				oFPU2Mem       <= 1'b0;
				oFPStart       <= 1'b0;
				oFPUtoULA      <= 1'b0;
			end
			
/*		OPCFLT:
			case (iFmt)
				FMTMTC:
					begin
						oRegDst     <= 2'b00;
						oOrigALU    <= 2'b00;
						oSavePC     <= 1'b0;
						oEscreveReg <= 1'b0;
						oLeMem      <= 1'b0;
						oEscreveMem <= 1'b0;
						oOrigPC     <= 3'b000; // PC+4
						oOpALU      <= 2'b00;
						oJump       <= 1'b0;   // desativa jump
						oBranch     <= 1'b0;   // desativa branch
						onBranch    <= 1'b0;   // desativa BNE
						oJr         <= 1'b0;   // desativa o Jr
						oEscreveEPC	<= 1'b0;	  // Escreve EPC
						oLoadType   <= 3'b000; // load word/ignore
						oWriteType  <= 2'b00;  // write word/ignore
				
				
						oFPDataReg     <= 2'b10; //IMPORTANTE: isso define que sera escrito na FPU
														//o dado da ULA normal. Ver datapath uniciclo
						oFPRegDst      <= 2'b01;
						oFPRegWrite    <= 1'b1;
						oFPFlagWrite   <= 1'b0;
						oFPU2Mem       <= 1'b0;
						oFPStart       <= 1'b0;
						oFPUtoULA      <= 1'b0;
					end
					
				FMTMFC:
					begin
						oRegDst     <= 2'b00;
						oOrigALU    <= 2'b00;
						oSavePC     <= 1'b0;
						oEscreveReg <= 1'b1;
						oLeMem      <= 1'b0;
						oEscreveMem <= 1'b0;
						oOrigPC     <= 3'b000; // PC+4
						oOpALU      <= 2'b00;
						oJump       <= 1'b0;   // desativa jump
						oBranch     <= 1'b0;   // desativa branch
						onBranch    <= 1'b0;   // desativa BNE
						oJr         <= 1'b0;   // desativa o Jr
						oEscreveEPC	<= 1'b0;	  // Escreve EPC
						oLoadType   <= 3'b000; // load word/ignore
						oWriteType  <= 2'b00;  // write word/ignore
				
						oFPDataReg     <= 2'b00;
						oFPRegDst      <= 2'b00;
						oFPRegWrite    <= 1'b0;
						oFPFlagWrite   <= 1'b0;
						oFPU2Mem       <= 1'b0;
						oFPStart       <= 1'b0;
						oFPUtoULA      <= 1'b1; //IMPORTANTE: isso define que sera escrito na ULA normal
														//o dado da FPU
					end
					
				FMTBC1:
					case (iBranchC1)
						1'b0:
							begin
							oRegDst     <= 2'b00;
							oOrigALU    <= 2'b00;
							oSavePC     <= 1'b0;
							oEscreveReg <= 1'b0;
							oLeMem      <= 1'b0;
							oEscreveMem <= 1'b0;
							oOrigPC     <= 3'b111; // IMPORTANTE: ver datapath do uniciclo
							oOpALU      <= 2'b00;
							oJump       <= 1'b0;   // desativa jump
							oBranch     <= 1'b0;   // desativa branch
							onBranch    <= 1'b0;   // desativa BNE
							oJr         <= 1'b0;   // desativa o Jr
							oEscreveEPC	<= 1'b0;	  // Escreve EPC
							oLoadType   <= 3'b000; // load word/ignore
							oWriteType  <= 2'b00;  // write word/ignore
				
							oFPDataReg     <= 2'b00;
							oFPRegDst      <= 2'b00;
							oFPRegWrite    <= 1'b0;
							oFPFlagWrite   <= 1'b0;
							oFPU2Mem       <= 1'b0;
							oFPStart       <= 1'b0;
							oFPUtoULA      <= 1'b0;
							end
						1'b1:
							begin
							oRegDst     <= 2'b00;
							oOrigALU    <= 2'b00;
							oSavePC     <= 1'b0;
							oEscreveReg <= 1'b0;
							oLeMem      <= 1'b0;
							oEscreveMem <= 1'b0;
							oOrigPC     <= 3'b110; // IMPORTANTE: ver datapath do uniciclo
							oOpALU      <= 2'b00;
							oJump       <= 1'b0;   // desativa jump
							oBranch     <= 1'b0;   // desativa branch
							onBranch    <= 1'b0;   // desativa BNE
							oJr         <= 1'b0;   // desativa o Jr
							oEscreveEPC	<= 1'b0;	  // Escreve EPC
							oLoadType   <= 3'b000; // load word/ignore
							oWriteType  <= 2'b00;  // write word/ignore
				
							oFPDataReg     <= 2'b00;
							oFPRegDst      <= 2'b00;
							oFPRegWrite    <= 1'b0;
							oFPFlagWrite   <= 1'b0;
							oFPU2Mem       <= 1'b0;
							oFPStart       <= 1'b0;
							oFPUtoULA      <= 1'b0;
							end
					endcase
					
				FMTW,
				FMTS:
					case (iFunct)
						FUNMOV:
							begin
							oRegDst     <= 2'b00;
							oOrigALU    <= 2'b00;
							oSavePC     <= 1'b0;
							oEscreveReg <= 1'b0;
							oLeMem      <= 1'b0;
							oEscreveMem <= 1'b0;
							oOrigPC     <= 3'b000; // PC+4
							oOpALU      <= 2'b00;
							oJump       <= 1'b0;   // desativa jump
							oBranch     <= 1'b0;   // desativa branch
							onBranch    <= 1'b0;   // desativa BNE
							oJr         <= 1'b0;   // desativa o Jr
							oEscreveEPC	<= 1'b0;	  // Escreve EPC
							oLoadType   <= 3'b000; // load word/ignore
							oWriteType  <= 2'b00;  // write word/ignore
				
							oFPDataReg     <= 2'b11;
							oFPRegDst      <= 2'b00;
							oFPRegWrite    <= 1'b1;
							oFPFlagWrite   <= 1'b0;
							oFPU2Mem       <= 1'b0;
							oFPStart       <= 1'b0;
							oFPUtoULA      <= 1'b0;
							end
						
						FUNCEQ,
						FUNCLT,
						FUNCLE:
							begin
							oRegDst     <= 2'b00;
							oOrigALU    <= 2'b00;
							oSavePC     <= 1'b0;
							oEscreveReg <= 1'b0;
							oLeMem      <= 1'b0;
							oEscreveMem <= 1'b0;
							oOrigPC     <= 3'b000; // PC+4
							oOpALU      <= 2'b00;
							oJump       <= 1'b0;   // desativa jump
							oBranch     <= 1'b0;   // desativa branch
							onBranch    <= 1'b0;   // desativa BNE
							oJr         <= 1'b0;   // desativa o Jr
							oEscreveEPC	<= 1'b0;	  // Escreve EPC
							oLoadType   <= 3'b000; // load word/ignore
							oWriteType  <= 2'b00;  // write word/ignore
				
							oFPDataReg     <= 2'b00;
							oFPRegDst      <= 2'b00;
							oFPRegWrite    <= 1'b0;
							oFPFlagWrite   <= 1'b1;
							oFPU2Mem       <= 1'b0;
							oFPStart       <= 1'b0;//IMPORTANTE: talvez tenha que mudar para oFPStart=1'b1
							oFPUtoULA      <= 1'b0;
							end
						
						default: // iFunt FMTS desconhecido
							begin
							oRegDst     <= 2'b00;
							oOrigALU    <= 2'b00;
							oSavePC     <= 1'b0;
							oEscreveReg <= 1'b0;
							oLeMem      <= 1'b0;
							oEscreveMem <= 1'b0;
							oOrigPC     <= 3'b000; // PC+4
							oOpALU      <= 2'b00;
							oJump       <= 1'b0;   // desativa jump
							oBranch     <= 1'b0;   // desativa branch
							onBranch    <= 1'b0;   // desativa BNE
							oJr         <= 1'b0;   // desativa o Jr
							oEscreveEPC	<= 1'b0;	  // Escreve EPC
							oLoadType   <= 3'b000; // load word/ignore
							oWriteType  <= 2'b00;  // write word/ignore
				
							oFPDataReg     <= 2'b00;
							oFPRegDst      <= 2'b00;
							oFPRegWrite    <= 1'b1;
							oFPFlagWrite   <= 1'b0;
							oFPU2Mem       <= 1'b0;
							oFPStart       <= 1'b1;
							oFPUtoULA      <= 1'b0;
							end
						
					endcase
					
				default: // iFmt FMTS Instrucao Nao reconhecida
				begin
					oRegDst     <= 2'b00;
					oOrigALU    <= 2'b00;
					oSavePC     <= 1'b0;
					oEscreveReg <= 1'b0;
					oLeMem      <= 1'b0;
					oEscreveMem <= 1'b0;
					oOrigPC     <= 3'b111; // default: ignora a instrução não reconhecida
					oOpALU      <= 2'b00;
					oJump       <= 1'b0;   // desativa jump
					oBranch     <= 1'b0;   // desativa branch
					onBranch    <= 1'b0;   // desativa BNE
					oJr         <= 1'b0;   // desativa o Jr
					oEscreveEPC	<= 1'b0;	  // Escreve EPC
					oLoadType   <= 3'b000; // load word/ignore
					oWriteType  <= 2'b00;  // write word/ignore
				
					oFPDataReg     <= 2'b00;
					oFPRegDst      <= 2'b00;
					oFPRegWrite    <= 1'b0;
					oFPFlagWrite   <= 1'b0;
					oFPU2Mem       <= 1'b0;
					oFPStart       <= 1'b0;
					oFPUtoULA      <= 1'b0;
				end
			endcase*/
			
      OPCCOP0:
			if (iFunct==FUNERET)
						begin
				            oRegDst        <= 2'b00;
                        oOrigALU       <= 2'b00;
								oSavePC        <= 1'b0;
                        oEscreveReg    <= 1'b0;
                        oLeMem         <= 1'b0;
                        oEscreveMem    <= 1'b0;
                        oOrigPC        <= 3'b110;		// Seleciona EPC
                        oOpALU         <= 2'b00;
								oJump       	<= 1'b1;   // ativa jump flush IF
								oBranch     	<= 1'b0;   // desativa branch
								onBranch    	<= 1'b0;   // desativa BNE
								oJr         	<= 1'b0;   // desativa o Jr
								oEscreveEPC		<= 1'b0;	  // Escreve EPC
								oLoadType   	<= 3'b000; // load word/ignore
								oWriteType  	<= 2'b00;  // write word/ignore
				
								oFPDataReg    	<= 2'b00;
								oFPRegDst     	<= 2'b00;
								oFPRegWrite    <= 1'b0;
								oFPFlagWrite   <= 1'b0;
								oFPU2Mem       <= 1'b0;
								oFPStart       <= 1'b0;
								oFPUtoULA      <= 1'b0;
						end
						else 
						begin
								oRegDst     	<= 2'b00;
								oOrigALU    	<= 2'b00;
								oSavePC     	<= 1'b0;
								oEscreveReg 	<= 1'b0;
								oLeMem      	<= 1'b0;
								oEscreveMem 	<= 1'b0;
								oOrigPC     	<= 3'b111; // default: ignora a instrução não reconhecida
								oOpALU      	<= 2'b00;
								oJump       	<= 1'b0;   // desativa jump
								oBranch     	<= 1'b0;   // desativa branch
								onBranch    	<= 1'b0;   // desativa BNE
								oJr         	<= 1'b0;   // desativa o Jr
								oEscreveEPC		<= 1'b0;	  // Escreve EPC
								oLoadType   	<= 3'b000; // load word/ignore
								oWriteType  	<= 2'b00;  // write word/ignore
				
								oFPDataReg     <= 2'b00;
								oFPRegDst      <= 2'b00;
								oFPRegWrite    <= 1'b0;
								oFPFlagWrite   <= 1'b0;
								oFPU2Mem       <= 1'b0;
								oFPStart       <= 1'b0;
								oFPUtoULA      <= 1'b0;
						end
						
		default: // iOp Instrucao Nao reconhecida
			begin
				oRegDst     <= 2'b00;
				oOrigALU    <= 2'b00;
				oSavePC     <= 1'b0;
				oEscreveReg <= 1'b0;
				oLeMem      <= 1'b0;
				oEscreveMem <= 1'b0;
				oOrigPC     <= 3'b111; //default: ignora a instrução não reconhecida
				oOpALU      <= 2'b00;
				oJump       <= 1'b0;   // desativa jump
				oBranch     <= 1'b0;   // desativa branch
				onBranch    <= 1'b0;   // desativa BNE
				oJr         <= 1'b0;   // desativa o Jr
				oEscreveEPC	<= 1'b0;	  // Escreve EPC
				oLoadType   <= 3'b000; // load word/ignore
				oWriteType  <= 2'b00;  // write word/ignore
				
				oFPDataReg     <= 2'b00;
				oFPRegDst      <= 2'b00;
				oFPRegWrite    <= 1'b0;
				oFPFlagWrite   <= 1'b0;
				oFPU2Mem       <= 1'b0;
				oFPStart       <= 1'b0;
				oFPUtoULA      <= 1'b0;
			end
	endcase 

endmodule
