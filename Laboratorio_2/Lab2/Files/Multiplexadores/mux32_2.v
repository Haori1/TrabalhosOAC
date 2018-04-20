module mux32_2(
	input sel,
	input [31:0] dado[1:0],
	output [31:0] saida
	);
	
	always @(*)
		case (sel)
			1'b0: saida = dado[0];
			1'b1: saida = dado[1];
			default: saida = 32'b0;
		endcase
			
endmodule
	