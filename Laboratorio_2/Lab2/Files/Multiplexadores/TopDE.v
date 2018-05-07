parameter 
	NBits=32,
   Mux=32;

module TopDE(
	input [9:0] SW,
	input CLOCK50,
	input [35:0] GPIO_1,
	output [35:0] GPIO_0
	);

	
reg [NBits-1:0] entrada [0:Mux-1];

always@(posedge CLOCK50)
 entrada[SW[4:0]] = GPIO_1;

 
mux mux0 (
	.sel(SW[4:0]),
	.dado( entrada[0:Mux-1] ),
	.saida(GPIO_0)
	);


	
endmodule
	