module mux1_2(
	input sel,
	input dado[1:0],
	output saida
	);
	
	always @(*)
		case (sel)
			1'b0: saida = dado[0];
			1'b1: saida = dado[1];
			default: saida = 1'b0;
		endcase
			
endmodule
	