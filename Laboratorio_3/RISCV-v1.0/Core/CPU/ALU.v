/*
 * ALU
 *
 */

 
module ALU (
	input [4:0] iControlSignal,
	input signed [31:0] iA, 
	input signed [31:0] iB,
	output reg oZero,
	output reg [31:0] oALUResult
	);

assign oZero = (oALUResult == ZERO);

wire [63:0] mul, mulu, mulsu;
assign mul = iA*iB;
assign mulu = $unsigned(iA)*$unsigned(iB);
assign mulsu= $unsigned(iA)*iB;

always @(*)
begin
    case (iControlSignal)
		OPAND:
			oALUResult  = iA & iB;
		OPOR:
			oALUResult  = iA | iB;
		OPXOR:
			oALUResult  = iA ^ iB;
		OPADD:
			oALUResult  = iA + iB;
		OPSUB:
			oALUResult  = iA - iB;
		OPSLT:
			oALUResult  = iA < iB;
		OPSLTU:
			oALUResult  = $unsigned(iA) < $unsigned(iB);
		OPGE:
			oALUResult 	= iA >= iB;
		OPGEU:
			oALUResult  = $unsigned(iA) >= $unsigned(iB);
		OPSLL:
			oALUResult  = iA << iB[4:0];
		OPSRL:
			oALUResult  = iA >> iB[4:0];
		OPSRA:
			oALUResult  = iA >>> iB[4:0];
		OPLUI:
			oALUResult  = {iB[19:0],12'b0};
		OPMUL:
			oALUResult  = mul[31:0];
		OPMULH:
			oALUResult  = mul[63:32];
		OPMULHU:
			oALUResult  = mulu[63:32];
		OPMULHSU:
			oALUResult  = mulsu[63:32];	
		OPDIV:
			oALUResult  = iA / iB;
		OPDIVU:
			oALUResult  = $unsigned(iA) / $unsigned(iB);
		OPREM:
			oALUResult  = iA % iB;
		OPREMU:
			oALUResult  = $unsigned(iA) % $unsigned(iB);
		default:
			oALUResult  = ZERO;
    endcase
end

endmodule
