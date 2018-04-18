module mux1_4(
	input [1:0] sel,
	input dado [3:0],
	output saida
	);
	
	always @(*)
		case (sel)
			2'b00: saida = dado[0];
			2'b01: saida = dado[1];
			2'b10: saida = dado[2];
			2'b11: saida = dado[3];
			default: saida = 2'b00;
		endcase
			
endmodule
	