module Debouncer
(
	input wire iClock,
	input wire iBouncy,
	output reg oPulse,
	output reg oState
);

reg [1:0] FF = 2'b0;

always @(posedge iClock)
	FF <= { FF[0], iBouncy };
	
reg [18:0] Counter = 19'b0;
wire [18:0] NextCounter;
wire CarryOut;

assign { CarryOut, NextCounter } = Counter + 1'b1;

always @(posedge iClock)
	if (^FF)
		Counter <= 19'b0;
	else if (!CarryOut)
		Counter <= NextCounter;
		
reg State = 1'b0;
		
always @(posedge iClock)
	if (CarryOut)
		State <= FF[1];
		
assign oState = State;
assign oPulse = State != FF[1] && CarryOut && !State;

endmodule
