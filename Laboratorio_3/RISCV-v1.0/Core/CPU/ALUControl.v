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
 * 10        |    The funct field determines the ALU operation.
 * 11        |    The opcode field (and the funct, of necessary) determines the ALU operation.
 */

module ALUControl (
	input wire [6:0]iFunct7,
	input wire [2:0] iFunct3,// iOpcode, //iRt,   // 1/2016. Adicionado iRt.
	input wire [1:0] iALUOp,
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
					 FUN3ADD:
                    oControlSignal  = OPADD;
                FUN3SUB:
                    oControlSignal  = OPSUB;
					 FUN3AND:
                    oControlSignal  = OPAND;
                FUN3OR:
                    oControlSignal  = OPOR;
                FUN3XOR:
                    oControlSignal  = OPXOR;
					 FUN3SLT:
                    oControlSignal  = OPSLT;
                FUN3SLTU:
                    oControlSignal  = OPSLTU;  
                FUN3SLL:
                    oControlSignal  = OPSLL;
                FUN3SRL:
                    oControlSignal  = OPSRL;
                FUN3SRA:
                    oControlSignal  = OPSRA;
					 OPCADDI:
                    oControlSignal  = OPADD;
                OPCANDI:
                    oControlSignal  = OPAND;
					 OPCORI:
						  oControlSignal  = OPOR;
					 OPCXORI:
						  oControlSignal  = OPXOR;
                OPCSLTI:
                    oControlSignal  = OPSLT;
                OPCSLTIU:
                    oControlSignal  = OPSLTU;
					 OPCSLLI:
						  oControlSignal  = OPSLL;
					 OPCSRLI:
						  oControlSignal  = OPSRL;
					 OPCSRAI:
						  oControlSignal  = OPSRA;
                /*OPCLUI:
                    oControlSignal  = OPLUI;
                OPCJAL:                                 //2016/1
                    oControlSignal  = OPAND;*/
						  
                /*`ifdef MULT
					 FUN3MULT:
                    oControlSignal  = OPMULT;
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
        /*2'b11:	TALVEZ USAR COMO LUI
            case (iOpcode)
					 OPMFUNCT:
					 begin
							case (iFunct)
								 FUNMADD:												  // Relatorio questao B.9) - Grupo 2 - (2/2016)
									  oControlSignal  = OPMADD;
								 FUNMADDU:												  // Relatorio questao B.9) - Grupo 2 - (2/2016)
									  oControlSignal  = OPMADDU;
								 FUNMSUB:												  // Relatorio questao B.9) - Grupo 2 - (2/2016)
									  oControlSignal  = OPMSUB;
								 FUNMSUBU:												  // Relatorio questao B.9) - Grupo 2 - (2/2016)
									  oControlSignal  = OPMSUBU;
								 default:
										oControlSignal  = 5'b00000;
							endcase
					end	 
					
                
                OPCBLEZ,                                //2016/1
                OPCBGTZ:
                    case (iRt)
                        RTZERO:                         //Garante que $rt seja zero/instruções válidas
                            oControlSignal  = OPSGT;
                        default:                        //instr. inválida
                            oControlSignal  = 5'b00000;
                    endcase
                OPCBGE_LTZ:                         //2016/1
                begin
                    case (iRt)
                        RTBGEZ,
                        RTBGEZAL,
                        RTBLTZ,
                        RTBLTZAL:
                            oControlSignal  = OPSLT;
                        default:
                            oControlSignal  = 5'b00000;
                    endcase
                end
					 
                default:
                    oControlSignal  = 5'b00000;
            endcase*/
    endcase
end

endmodule
