/*
 * Registers.v
 *
 * Coprocessor 1 register bank testbench.
 * Stores information in 32-bit registers. 32 registers are available for
 * writing and 32 are available for reading.
 * Also allows for two simultaneous data reads, has a write enable signal
 * input, is clocked and has a synchronous reset signal input.
 */
module FPURegisters (
	input wire iCLK, iCLR, iRegWrite,
	input wire [4:0] iReadRegister1, iReadRegister2, iWriteRegister, iRegDispSelect,
	input wire [31:0] iWriteData,
	output wire [31:0] oReadData1, oReadData2, oRegDisp,
	input wire [4:0] iVGASelect,
	output reg [31:0] oVGARead
	);
	
/* Local register bank */
reg [31:0] registers[31:0];

reg [5:0] i;

initial
begin
	for (i = 0; i <= 31; i = i + 1'b1)
		registers[i] = 32'b0;
end

/* Output definition */
assign oReadData1 =	registers[iReadRegister1];
assign oReadData2 =	registers[iReadRegister2];

assign oRegDisp =	registers[iRegDispSelect];
assign oVGARead = registers[iVGASelect];

/* Main block for writing and reseting */
always @(posedge iCLK or posedge iCLR)
begin
	if (iCLR)
		for (i = 0; i <= 31; i = i + 1'b1)
			registers[i] <= 32'b0;
	else
	begin
		i<=6'bx; // para não dar warning
		if (iRegWrite)
			registers[iWriteRegister] <= iWriteData;
	end
end

endmodule
