/*
 * Registers.v
 *
 * Main processor register bank testbench.
 * Stores information in 32-bit registers. 31 registers are available for
 * writing and 32 are available for reading.
 * Also allows for two simultaneous data reads, has a write enable signal
 * input, is clocked and has an asynchronous reset signal input.
 */
module Registers (
    input wire iCLK, iCLR, iRegWrite,
    input wire [4:0] iReadRegister1, iReadRegister2, iWriteRegister, iRegDispSelect, //rs1, rs2, rd, seleção do dado para ser mostrado fora
    input wire [31:0] iWriteData, //dado a ser escrito
    output wire [31:0] oReadData1, oReadData2, oRegDisp, //
    input wire [4:0] iVGASelect, //Banco de registradores que são exibidos na tela
    output reg [31:0] oVGARead
    );

/* Local register bank */
reg [31:0] registers[31:0];

parameter    SPR=5'd29;                    // $SP //em vez de 29 colocar 2 para o riscv

reg [5:0] i;

initial
begin
    for (i = 0; i <= 31; i = i + 1'b1)
        registers[i] = 32'b0;
    registers[SPR] = STACK_ADDRESS; //definido no parameters.v
end

/* Output definition */
assign oReadData1 =    registers[iReadRegister1]; //register[0 até 32] é passado para o oreaddata
assign oReadData2 =    registers[iReadRegister2]; //sintese transforma em um mux

assign oRegDisp =    registers[iRegDispSelect];
assign oVGARead = registers[iVGASelect];

/* Main block for writing and reseting */
`ifdef PIPELINE
    always @(negedge iCLK or posedge iCLR)
`else
    always @(posedge iCLK or posedge iCLR) //sempre que tiver borda de subida o banco de reg e pilha é resetado
`endif
begin
    if (iCLR)
    begin // reseta o banco de registradores e pilha
        for (i = 0; i <= 31; i = i + 1'b1)
            registers[i] <= 32'b0;
			registers[SPR]   <= STACK_ADDRESS;  // $SP
    end
    else
	 begin
		i<=6'bx; // para não dar warning
		if(iRegWrite)
			if (iWriteRegister != 5'b0)
					registers[iWriteRegister] <= iWriteData;
	 end
end

endmodule
