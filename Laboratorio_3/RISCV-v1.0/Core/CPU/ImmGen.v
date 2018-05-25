/*
 * Geração de imediato
 */
 
 module ImmGen (
	input  wire [31:0] iInstr,
	output wire [31:0] oImmResult
);
	
always @(*)
begin
	case (iInstr[6:2])	// 5 bits mais significativos do opcode; os últimos 2 nunca se alteram
		
		5'b00000,
		5'b00100:	
		begin
			oImmResult = { {20{iInstr[31]}},wInstr[31:20] };									// tipo I	
			end
		5'b00101:
		begin
			oImmResult = { wInstr[31],wInstr[31:12],11'b0 };			//Nao seria 12 em vez de 11						// AUIPC
			end
		5'b01000:
		begin
			oImmResult = { {20{wInstr[31]}},wInstr[31:25],wInstr[11:7] };					// tipo S
			end
		5'b01101:
		begin
			oImmResult = { {12{wInstr[31]}},wInstr[31:12] };									// lui
			end
		5'b11000:
		begin
			oImmResult = { {21{wInstr[31]}},wInstr[7],wInstr[30:25],wInstr[11:8] };		// tipo SB
			end
		5'b11001:
		begin
			oImmResult = { {20{wInstr[31]}},wInstr[31:20] };									// jalr
			end
		5'b11011:
		begin
			oImmResult = { {13{wInstr[31]}},wInstr[19:12], wInstr[20],wInstr[30:21]};	// jal
			end
					
		default:
		begin
			oImmResult = ZERO;
			end
	
	endcase
end

endmodule
