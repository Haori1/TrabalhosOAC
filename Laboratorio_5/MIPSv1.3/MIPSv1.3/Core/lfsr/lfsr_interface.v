`ifndef PARAM
	`include "../Parametros.v"
`endif


module LFSR_interface(
	 input         iCLK_50,
    input         wReadEnable, 
    input  			[31:0] wAddress,
    output logic 	[31:0] wReadData
);

wire [31:0] out;

LFSR_word lfsr(
	.out(out),
	.clk(iCLK_50)
);
	
always @(*)
	if(wReadEnable)
		if(wAddress == LFSR_ADDRESS)
			wReadData <= out;
		else	
			wReadData <= 32'hzzzzzzzz;
	else	
		wReadData <= 32'hzzzzzzzz;
		
endmodule
