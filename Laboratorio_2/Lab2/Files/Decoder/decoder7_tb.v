
`timescale 1 ns / 100 ps

module decoder7_tb;

	reg CLOCK;
	reg [3:0] IN;
	wire [6:0] OUT;

decoder7 dec0 (
	.In(IN),
	.Out(OUT),
	.Clk(CLOCK)
	);


//Clock de 50MHz
always
	#10 CLOCK = ~CLOCK;

always @(posedge CLOCK)
	#0 IN=IN+1;


initial
	begin
		$display($time, " << Starting Simulation >> ");
		CLOCK = 1'b0;
		IN = 4'b0000;
	
		#320;
		$display($time, "<< Simulation Complete >>");
		$stop;
	end

	
initial
	begin
		$display("\t\ttime,\tclk,\tSW,\tHEX0"); 
		$monitor("%d,\t%b,\t%b,\t%b,",$time, CLOCK,IN,OUT);	
	end
	
	
endmodule
