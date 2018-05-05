module mux(
	input [4:0] sel,
	input [NBits-1:0] dado [Mux-1:0],
	output [NBits-1:0] saida
	);
	
assign saida=dado[sel];
			
endmodule
	