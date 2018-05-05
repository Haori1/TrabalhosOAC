module mux32_32(
	input [4:0] sel,
	input [31:0] dado [31:0],
	output [31:0] saida
	);
	
	always @(*)
		case (sel)
			5'd0: saida = dado[0];
			5'd1: saida = dado[1];
			5'd2: saida = dado[2];
			5'd3: saida = dado[3];
			5'd4: saida = dado[4];
			5'd5: saida = dado[5];
			5'd6: saida = dado[6];
			5'd7: saida = dado[7];
			5'd8: saida = dado[8];
			5'd9: saida = dado[9];
			5'd10: saida = dado[10];
			5'd11: saida = dado[11];
			5'd12: saida = dado[12];
			5'd13: saida = dado[13];
			5'd14: saida = dado[14];
			5'd15: saida = dado[15];
			5'd16: saida = dado[16];
			5'd17: saida = dado[17];
			5'd18: saida = dado[18];
			5'd19: saida = dado[19];
			5'd20: saida = dado[20];
			5'd21: saida = dado[21];
			5'd22: saida = dado[22];
			5'd23: saida = dado[23];
			5'd24: saida = dado[24];
			5'd25: saida = dado[25];
			5'd26: saida = dado[26];
			5'd27: saida = dado[27];
			5'd28: saida = dado[28];
			5'd29: saida = dado[29];
			5'd30: saida = dado[30];
			5'd31: saida = dado[31];
			default: saida = 32'b0;
		endcase
			
endmodule
	