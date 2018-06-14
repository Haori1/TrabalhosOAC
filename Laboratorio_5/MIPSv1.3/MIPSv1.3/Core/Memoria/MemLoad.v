`ifndef PARAM
	`include "../Parametros.v"
`endif

/* Controlador da memoria */
/* define a partir do opcode qual a forma de acesso a memoria lb, lh, lw*/

module MemLoad(
	input [1:0] iAlignment,
	input [2:0] iLoadTypeF,
	input [5:0] iOpcode,
	input [31:0] iData,
	output logic [31:0] oData,
	output oException
);


/* Para poder usar no Multiciclo e no Uniciclo que recebe Opcode */
logic [2:0] iLoadType;
always @(*)
begin
	case (iOpcode)
		OPCLW:		iLoadType = LOAD_TYPE_LW;
		OPCLH:		iLoadType = LOAD_TYPE_LH;
		OPCLHU:		iLoadType = LOAD_TYPE_LHU;
		OPCLB:		iLoadType = LOAD_TYPE_LB;
		OPCLBU:		iLoadType = LOAD_TYPE_LBU;
		OPCDUMMY:	iLoadType = iLoadTypeF;   //So para o PIPELINEM
		default:		iLoadType = LOAD_TYPE_DUMMY;
	endcase 
end



assign oException = (iLoadType == LOAD_TYPE_LW && iAlignment != 2'b00)
                  | (iLoadType == LOAD_TYPE_LH && iAlignment[0] != 1'b0)
                  | (iLoadType == LOAD_TYPE_LHU && iAlignment[0] != 1'b0);

logic  [15:0] Halfword;
logic [ 7:0] Byte;

always @(*) begin
	case (iAlignment[1])
		1'b0: Halfword = iData[15: 0];
		1'b1: Halfword = iData[31:16];
		default: Halfword = 16'b0;
	endcase
end

always @(*) begin
	case (iAlignment)
		2'b00: Byte = iData[ 7: 0];
		2'b01: Byte = iData[15: 8];
		2'b10: Byte = iData[23:16];
		2'b11: Byte = iData[31:24];
		default: Byte = 8'b0;
	endcase
end

always @(*) begin
	case (iLoadType)
		LOAD_TYPE_LW:  oData = iData;
		LOAD_TYPE_LH:  oData = {{16{Halfword[15]}}, Halfword};
		LOAD_TYPE_LHU: oData = {16'b0, Halfword};
		LOAD_TYPE_LB:  oData = {{24{Byte[7]}}, Byte};
		LOAD_TYPE_LBU: oData = {24'b0, Byte};
		default:       oData = 32'b0;
	endcase
end

endmodule
