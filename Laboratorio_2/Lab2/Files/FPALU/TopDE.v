/* 
   Colocar valores SW[9:0] e pressionar KEY[0] para armazenar em A
   Colocar valores SW[9:0] e pressionar KEY[1] para armazenar em B
	Pressionar KEY[2] para ver o valor de A
	Pressionar KEY[3] para ver o valor de B
	As chaves SW[3:0] definem a operação de acordo com Paramentros
	Os LEDR[9:5]={NaN, CompResult, Underflow, Overflow, Zero}
	Os LEDR[3:0] mostram a Operação
*/

module TopDE (
	input CLOCK_50,
	input [3:0] KEY,
	input [9:0] SW,
	output [9:0] LEDR,
	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5
	);


reg [31:0] idataa,idatab,oresult;

wire [31:0] wresult;

reg onan, ozero, ooverflow, ounderflow, oCompResult;

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

assign LEDR[3:0]=SW[3:0];
assign LEDR[5]=ozero;
assign LEDR[6]=ooverflow;
assign LEDR[7]=ounderflow;
assign LEDR[8]=oCompResult;
assign LEDR[9]=onan;
	
	
always @(negedge KEY[0])
		idataa <= {SW[9:0],22'b0};
		
always @(negedge KEY[1])
		idatab <= {SW[9:0],22'b0};

always @(posedge CLOCK_50)
	begin
		if(~KEY[2])
			oresult<=idataa;
		else
			if(~KEY[3])
				oresult<=idatab;
			else
				oresult<=wresult;
	end				

FPALU fpalu1 (
	.iclock(CLOCK_50), 
	.idataa(idataa),
	.idatab(idatab),
	.icontrol(SW[3:0]),
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
