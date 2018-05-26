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
 * 01        |    The funct3 field determines the ALU operation (type-SB + lui)
 * 10        |    The funct3 (and the funct7, if necessary) field determines the ALU operation (type-R)
 * 11        |    The funct3 (and the funct7, if necessary) field determines the ALU operation (type-I)
 */

module ALUControl (
	input wire [1:0] iALUOp,
	input wire [2:0] iFunct3,
	input wire [6:0] iFunct7,
	input wire		 iOpcb6,		//apenas o bit mais significativo do opcode é necessário
	output reg [4:0] oControlSignal
	);
	
always @(*)
begin
		case (iALUOp)
			2'b00:
            	oControlSignal  = OPADD;
			
			2'b01:
			begin
				case (iOpcb6)
					1'b0:
						oControlSignal  = OPLUI;
					
					1'b1:
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
								
							default:
								oControlSignal  = 5'b0;
						endcase
					end
				endcase
			end
			
			2'b10:
			begin
            case (iFunct3)
				FUN3ADD,
				FUN3SUB,
				FUN3MUL:
				begin
					case (iFunct7)
							FUN7ADD:
								oControlSignal  = OPADD;
							FUN7SUB:
								oControlSignal  = OPSUB;
							
							`ifdef RV32M 
							FUN7MUL:
								oControlSignal	 = OPMUL;
							`endif
							
							default:
								oControlSignal	 = 5'b0;
					endcase
				end
				
				FUN3SLL,
				FUN3MULH:
				`ifdef RV32M
				begin
					case (iFunct7)
							FUN7SLL:
								oControlSignal  = OPSLL;
							FUN7MULH:
								oControlSignal  = OPMULH;
							
							default:
								oControlSignal	 = 5'b0;
					endcase
				end
				`else
					oControlSignal  = OPSLL;
				`endif
			
				FUN3SLT,
				FUN3MULHSU:
				`ifdef RV32M
				begin
					case (iFunct7)
							FUN7SLT:
								oControlSignal	= OPSLT;
							FUN7MULHSU:
								oControlSignal = OPMULHSU;
							
							default:
								oControlSignal	 = 5'b0;
					endcase
				end
				`else
					oControlSignal  = OPSLT;
				`endif
				
			
				FUN3SLTU,
				FUN3MULHU:
				`ifdef RV32M
				begin
					case (iFunct7)
							FUN7SLTU:
								oControlSignal = OPSLTU;
							FUN7MULHU:
								oControlSignal = OPMULHU;
							
							default:
								oControlSignal	 = 5'b0;
					endcase
				end
				`else
					oControlSignal  = OPSLTU;
				`endif
			
				FUN3XOR,
				FUN3DIV:
				`ifdef RV32M
				begin
					case (iFunct7)
							FUN7XOR:
								oControlSignal = OPXOR;
							FUN7DIV:
								oControlSignal = OPDIV;
								
							default:
								oControlSignal	 = 5'b0;
					endcase
				end
				`else
					oControlSignal  = OPXOR;
				`endif
				
			
				FUN3SRL,
				FUN3SRA,
				FUN3DIVU:
				begin
					case (iFunct7)
							FUN7SRL:
								oControlSignal  = OPSRL;
							FUN7SRA:
								oControlSignal  = OPSRA;
							
							`ifdef RV32M
							FUN7DIVU:
								oControlSignal = OPDIVU;
							`endif
							
							default:
								oControlSignal	 = 5'b0;
					endcase
				end
				
				FUN3OR,
				FUN3REM:
				`ifdef RV32M
				begin
					case (iFunct7)
							FUN7OR:
								oControlSignal = OPOR;
							FUN7DIV:
								oControlSignal = OPREM;
								
							default:
								oControlSignal	 = 5'b0;
					endcase
				end
				`else
					oControlSignal = OPOR;
				`endif
									
			
				FUN3AND,
				FUN3REMU:
				`ifdef RV32M
				begin
					case (iFunct7)
							FUN7AND:
								oControlSignal = OPAND;
							FUN7REMU:
								oControlSignal = OPREMU;
								
							default:
								oControlSignal	 = 5'b0;
					endcase
				end
				`else
					oControlSignal  = OPAND;
				`endif

				
				default:
					  oControlSignal  = 5'b0;
            endcase
			end
			
			2'b11:
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
									
									default:
										oControlSignal	 = 5'b0;
							endcase
					 end
					 
					 FUN3ORI:
						  oControlSignal  = OPOR;
					 FUN3ANDI:
						  oControlSignal  = OPAND;
				  
					 default:
						  oControlSignal  = 5'b0;
				endcase
			end
			
    endcase
end

endmodule
