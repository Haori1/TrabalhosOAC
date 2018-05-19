module FPALUControl (
	input wire [5:0] iFunct,
	output reg [3:0] oControlSignal,
	output reg [4:0] oFPBusyTime
	);
	
always @(iFunct)
begin
	case (iFunct)
			FUNADDS:
				begin
					oControlSignal <= OPADDS;
					oFPBusyTime    <= 5'h06;
				end
			FUNSUBS:
				begin
					oControlSignal <= OPSUBS;
					oFPBusyTime    <= 5'h06;
				end
			FUNMULS:
				begin
					oControlSignal <= OPMULS;
					oFPBusyTime    <= 5'h04;
				end
			FUNDIVS:
				begin
					oControlSignal <=	OPDIVS;
					oFPBusyTime    <= 5'h05;
				end
			FUNSQRT:
				begin
					oControlSignal <=	OPSQRT;
					oFPBusyTime    <= 5'h0F;
				end
			FUNABS:
				begin
					oControlSignal <=	OPABS;
					oFPBusyTime    <= 5'h01;
				end
			FUNNEG:
				begin
					oControlSignal <=	OPNEG;
					oFPBusyTime    <= 5'h01;
				end
			FUNCEQ:
				begin
					oControlSignal <=	OPCEQ;
					oFPBusyTime    <= 5'h01;
				end
			FUNCLT:
				begin
					oControlSignal <=	OPCLT;
					oFPBusyTime    <= 5'h01;
				end
			FUNCLE:
				begin
					oControlSignal <=	OPCLE;
					oFPBusyTime    <= 5'h01;
				end
			FUNCVTSW:
				begin
					oControlSignal <=	OPCVTSW;
					oFPBusyTime    <= 5'h05;
				end
			FUNCVTWS:
				begin
					oControlSignal <=	OPCVTWS;
					oFPBusyTime    <= 5'h05;
				end
 			FUNCEILWS:
				begin
					oControlSignal <= OPCEILWS;
					oFPBusyTime    <= 5'h0C;
				end
 			FUNFLOORWS:
				begin
					oControlSignal <= OPFLOORWS;
					oFPBusyTime    <= 5'h0C;
				end
 			FUNROUNDWS:
				begin
					oControlSignal <= OPROUNDWS;
					oFPBusyTime    <= 5'h05;
				end

			default:
				begin
					oControlSignal <=	4'b0000;
					oFPBusyTime    <= 5'h00;
				end
		endcase
end

endmodule