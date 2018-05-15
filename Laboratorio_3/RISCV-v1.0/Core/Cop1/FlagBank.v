
module FlagBank (
	input iCLK, iCLR, iFlagWrite, iData,
	input [2:0] iFlag,
	output reg [7:0] oFlags
	);

//integer i;
reg [3:0] i;

initial begin
	for (i = 0; i <= 7; i = i + 1'b1)
		oFlags[i] <= 1'b0;
end

/*Escrever a cada subida do clock*/
always @(posedge iCLK or posedge iCLR)
begin
	if (iCLR)
	begin
		for (i = 0; i <= 7; i = i + 1'b1)
			oFlags[i] <= 1'b0;
	end
	else 
	begin
		i<=4'bx; // para não dar warning
		if (iCLK && iFlagWrite)
			oFlags[iFlag] <= iData;
	end
end

endmodule
