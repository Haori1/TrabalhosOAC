module mux1_2a(
	input sel,
	input dado0,
	input dado1,
	output saida
	);
	
	always @(*)
		case (sel)
			1'b0: saida = dado0;
			1'b1: saida = dado1;
			default: saida = 1'b0;
		endcase
			
endmodule
	