/*
 * Geração de imediato
 */
 
 module ImmGen (
	input  wire [31:0] iInstr;
	output wire [31:0] oImmResult;
);
	
always @(*)
begin
	case (iInstr[6:2])	// 5 bits mais significativos do opcode; os últimos 2 nunca se alteram
		
		5'b00000,
		5'b00100:	
			oImmResult = { 20{iInstr[31]},wInstr[31:20] }									// tipo I	
		5'b00101:
			oImmResult = { wInstr[31],wInstr[31:12],11b'0 }									// AUIPC
		5'b01000:
			oImmResult = { 20{wInstr[31]},wInstr[31:25],wInstr[11:7] }					// tipo S
		5'b01101:
			oImmResult = { 12{wInstr[31]},wInstr[31:12] }									// lui
		5'b11000:
			oImmResult = { 21{wInstr[31]},wInstr[7],wInstr[30:25],wInstr[11:8] }		// tipo SB
		5'b11001:
			oImmResult = { 20{wInstr[31]},wInstr[31:20] }									// jalr
		5'b11011:
			oImmResult = { 13{wInstr[31]},wInstr[19:12], wInstr[20],wInstr[30:21]}	// jal
					
		default:
			oImmResult = ZERO;
	
	endcase
end

endmodule
