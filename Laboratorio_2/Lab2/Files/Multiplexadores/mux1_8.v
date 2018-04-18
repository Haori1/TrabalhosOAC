module mux1_8(
	input [2:0] sel,
	input dado [7:0],
	output saida
	);
	
	always @(*)
		case (sel)
			3'b000: saida = dado[0];
			3'b001: saida = dado[1];
			3'b010: saida = dado[2];
			3'b011: saida = dado[3];
			3'b100: saida = dado[4];
			3'b101: saida = dado[5];
			3'b110: saida = dado[6];
			3'b111: saida = dado[7];
			default: saida = 3'b000;
		endcase
			
endmodule
	