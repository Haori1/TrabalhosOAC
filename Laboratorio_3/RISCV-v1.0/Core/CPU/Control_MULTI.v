/*
 * Bloco de Controle MULTICICLO
 *
 */	
module Control_MULTI (
	/* I/O type definition */
	input wire iCLK, iRST,
	input wire [6:0] iOpcode,
	output wire oIorD, oMemRead, oMemWrite, oIRWrite, oALUSrcA,
				oRegWrite, oPCWrite, oPCWriteCond, oPCSource,
	output wire [1:0] oALUSrcB, oALUOp, oMemtoReg,
	output wire [5:0] oState
	//Adicionado em 1/2014
	//output wire [2:0] oLoadCase,
	//output wire [1:0] oWriteCase,
	);


wire [14:0] wOutput;			// sinais de controle do caminho de dados
reg  [5:0]  CURRENT_STATE;		// present state
wire [5:0]  wNextState;		// next estate

assign oIorD         = wOutput[14];
assign oMemRead      = wOutput[13];
assign oMemWrite     = wOutput[12];
assign oIRWrite      = wOutput[11];
assign oALUSrcA      = wOutput[10];
assign oALUSrcB      = wOutput[9:8];
assign oALUOp        = wOutput[7:6];
assign oMemtoReg     = wOutput[5:4];
assign oRegWrite     = wOutput[3];
assign oPCWrite      = wOutput[2];
assign oPCWriteCond  = wOutput[1];
assign oPCSource     = wOutput[0];

assign	oState		= CURRENT_STATE;

initial
begin
	CURRENT_STATE	<= FETCH;
end

/* Main control block */
always @(posedge iCLK or posedge iRST)
begin
	if (iRST)
		CURRENT_STATE	<= FETCH;
	else
		CURRENT_STATE	<= wNextState;
end

always @(*)
begin	
	case (CURRENT_STATE)
	
		FETCH:
		begin
			wOutput <= FETCH_OUTPUT;
			wNextState <= DECODE;
		end
		
		DECODE:
		begin
			wOutput <= DECODE_OUTPUT;
			case(iOpcode)
				OPCLOAD,
				OPCSTORE:
					wNextState <= LWSW;	
				OPCR:
					wNextState <= RCALC;	
				OPCIARI:
					wNextState <= ICALC;
				OPCBRANCH:
					wNextState <= BRANCH;
				OPCLUI:
					wNextState <= IMM2RD;
				OPCAUIPC:
					wNextState <= ALU2RD;
				OPCJAL:
					wNextState <= JAL;
				OPCJALR:
					wNextState <= JALR;

				default: wNextState <= FETCH;
			endcase
		end

		LWSW:
		begin
			wOutput <= LWSW_OUTPUT;
			case(iOpcode)
				OPCLOAD:
					wNextState <= LOAD;
				OPCSTORE:
					wNextState <= STORE;
				
				default:
					wNextState <= FETCH;
			endcase		
		end

		LOAD:
		begin
			wOutput <= LOAD_OUTPUT;
			wNextState <= MEM2RD;
		end

		MEM2RD:
		begin
			wOutput <= MEM2RD_OUTPUT;
			wNextState <= FETCH;
		end

		STORE:
		begin
			wOutput <= STORE_OUTPUT;
			wNextState <= FETCH;
		end

		RCALC:
		begin
			wOutput <= RCALC_OUTPUT;
			wNextState <= ALU2RD;
		end

		ICALC:
		begin
			wOutput <= ICALC_OUTPUT;
			wNextState <= ALU2RD;
		end

		ALU2RD:
		begin
			wOutput <= ALU2RD_OUTPUT;
			wNextState <= FETCH;
		end

		BRANCH:
		begin
			wOutput <= BRANCH_OUTPUT;
			wNextState <= FETCH;
		end

		IMM2RD:
		begin
			wOutput <= IMM2RD_OUTPUT;
			wNextState <= FETCH;
		end

		JAL:
		begin
			wOutput <= JAL_OUTPUT;
			wNextState <= FETCH;
		end

		JALR:
		begin
			wOutput <= JALR_OUTPUT;
			wNextState <= FETCH;
		end

		default:
		begin
			wOutput	<= 15'b0;
			wNextState	<= FETCH;
		end
		
	endcase
end

endmodule
