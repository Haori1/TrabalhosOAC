/*
 * ALUcontrol.v
 *
 * Arithmetic Logic Unit control module.
 * Generates control signal to the ALU depending on the opcode and the funct field in the
 * current operation and on the signal sent by the processor control module.
 *
 * ALUOp    |    Control signal
 * -------------------------------------------
 * 00        |    The ALU performs an add operation.
 * 01        |    The ALU performs a subtract operation.
 * 10        |    The funct3 (and the funct7, if necessary) field determines the ALU operation (type-R)
 * 11        |    The opcode, the func3 and funct7 fields determine the ALU operation (type-I and type-SB)
 */

module ALUControl (
	input wire [1:0] iALUOp,
	input wire [2:0] iFunct3,
	input wire [6:0] iFunct7,
	input wire iOpcb6,			// apenas o bit mais significativo do opcode é necessário
	output reg [4:0] oControlSignal
	);
	
always @(*)
begin
		case (iALUOp)
			2'b00:
            oControlSignal  = OPADD;
			2'b01:
            oControlSignal  = OPSUB;
			
			2'b10:
			begin
            case (iFunct3)
					 FUN3ADD,
					 FUN3SUB:
					 begin
							case (iFunct7)
									FUN7ADD:
										oControlSignal  = OPADD;
									FUN7SUB:
										oControlSignal  = OPSUB;
							endcase
					 end
					 FUN3SLL:
                    oControlSignal  = OPSLL;
					 FUN3SLT:
                    oControlSignal  = OPSLT;
					 FUN3SLTU:
                    oControlSignal  = OPSLTU;
					 FUN3XOR:
                    oControlSignal  = OPXOR;
		
                FUN3SRL,
					 FUN3SRA:
					 begin
							case (iFunct7)
									FUN7SRL:
										oControlSignal  = OPSRL;
									FUN7SRA:
										oControlSignal  = OPSRA;
							endcase
					 end
					 
					 FUN3OR:
                    oControlSignal  = OPOR;
                FUN3AND:
                    oControlSignal  = OPAND;

						  
                /*`ifdef MULT
					 FUN3MUL:
                    oControlSignal  = OPMUL;
                FUN3DIV:
                    oControlSignal  = OPDIV;
                FUN3MULTU:
                    oControlSignal  = OPMULTU;
                FUN3DIVU:
                    oControlSignal  = OPDIVU;
                `endif*/
					 
                default:
                    oControlSignal  = 5'b00000;
            endcase
			end
			
			2'b11:
			begin
				case (iOpcb6)
					1'b0:			// tipo I
					begin
						case (iFunct3)
							 FUN3ADDI:
								  oControlSignal 	= OPADD;
							 FUN3SLLI:
								  oControlSignal  = OPSLL;
							 FUN3SLTI:
								  oControlSignal  = OPSLT;
							 FUN3SLTIU:
								  oControlSignal  = OPSLTU;
							 FUN3XORI:
								  oControlSignal  = OPXOR;
				
							 FUN3SRLI,
							 FUN3SRAI:
							 begin
									case (iFunct7)
											FUN7SRLI:
												oControlSignal  = OPSRL;
											FUN7SRAI:
												oControlSignal  = OPSRA;
									endcase
							 end
							 
							 FUN3ORI:
								  oControlSignal  = OPOR;
							 FUN3ANDI:
								  oControlSignal  = OPAND;
						  
							 default:
								  oControlSignal  = 5'b00000;
						endcase
					end
						
					1'b1:			// branches
					begin
						case (iFunct3)
							FUN3BEQ,
							FUN3BNE:
								oControlSignal  = OPSUB;
								
							FUN3BLT:
								oControlSignal  = OPSLT;
							FUN3BGE:
								oControlSignal	 = OPGE;
							FUN3BLTU:
								oControlSignal	 = OPSLTU;
							FUN3BGEU:
								oControlSignal	 = OPGEU;
							
						endcase
					end
				endcase
			end
			
    endcase
end

endmodule
