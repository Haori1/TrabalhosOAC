module lfsr_word    (
	output reg [32:0] out,
	input clk
	);
	
wire linear_feedback,lf1,lf2,lf3;

assign lf1 = out[31] ^ out[21];
assign lf2 = out[1] ^ lf1;
assign lf3 = out[0] ^ lf2;
assign linear_feedback = lf3 ^ 1'b1;

always @(posedge clk) begin
	out[32] = linear_feedback;
	out = out >> 1'b1;
end 

endmodule
