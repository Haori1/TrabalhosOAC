module TopDE(
	input [9:0] SW,
	input [3:0] KEY,
	output [9:0] LEDR

	);
	
	
	
mux1_2 mux0 (
	.sel(KEY[0]),
	.dado0(SW[0]),
	.dado1(SW[1]),
	.saida(LEDR[0])
	);

	
endmodule
	