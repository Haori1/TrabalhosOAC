module mux32_32a(
	input [4:0] sel,
	input [31:0] dado [31:0],
	output [31:0] saida
	);
	
assign saida=dado[sel];
			
endmodule
	