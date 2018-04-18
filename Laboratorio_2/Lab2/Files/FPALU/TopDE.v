module TopDE ( /* I/O type definition */
	input CLOCK_50,
	input [3:0] KEY,
	input [9:0] SW,
	output [9:0] LEDR,
	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5
	);


reg [31:0] idataa,idatab;

reg [31:0] oresult;
wire [31:0] wresult;

reg onan, ozero, ooverflow, ounderflow;
reg oCompResult;

initial
	begin
		idataa	<= 32'b0;
		idatab	<= 32'b0;
		oresult	<= 32'b0;
		onan		<= 1'b0;
		ozero		<= 1'b0;
		ooverflow  <= 1'b0;
		ounderflow <= 1'b0;
		oCompResult<= 1'b0;
	end
	

always @(SW[0])
		if (SW[0] == 1'b0)
			idataa <= {SW[9:1],23'b0};
		else
			idatab <= {SW[9:1],23'b0};

always @(CLOCK_50)		
		if(KEY == 4'b0000)		// Pressionando todos os botões
			oresult <= idataa;
		else
			if (KEY == 4'b0001)
				oresult <= idatab;
			else
				oresult <= wresult;
	
	
assign LEDR[0]=ozero;
assign LEDR[1]=ooverflow;
assign LEDR[2]=ounderflow;
assign LEDR[3]=oCompResult;
assign LEDR[4]=onan;


FPALU fpalu1 (
	.iclock(CLOCK_50), 
	.idataa(idataa),
	.idatab(idatab),
	.icontrol(~KEY),
	.oresult(wresult),
	.onan(onan),
	.ozero(ozero),
	.ooverflow(ooverflow),
	.ounderflow(ounderflow),
	.oCompResult(oCompResult)
	);

Decoder7 d0 (oresult[11: 8],HEX0);
Decoder7 d1 (oresult[15:12],HEX1);
Decoder7 d2 (oresult[19:16],HEX2);
Decoder7 d3 (oresult[23:20],HEX3);
Decoder7 d4 (oresult[27:24],HEX4);
Decoder7 d5 (oresult[31:28],HEX5);


endmodule
