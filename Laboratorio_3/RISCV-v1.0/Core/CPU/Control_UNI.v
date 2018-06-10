/*
 * Bloco de Controle UNICICLO
 *
 */

 module Control_UNI(
    input  wire        iCLK,
    input  wire [6:0]  iOp,
    output wire        oEscreveReg, oLeMem, oEscreveMem, oOrigALU,
    output wire [1:0]  oOpALU,
    output wire [2:0]  oOrigPC, oMemparaReg
);

//wire        wInterruptNotZero, wNotExcLevel, wNotUserMode, wIntException, wALUException, wFPALUException;
//wire [4:0]  wALUExcCode, wFPALUExcCode;

/*assign wInterruptNotZero    = iPendingInterrupt != 8'b0;
assign wNotExcLevel         = ~iExcLevel;
assign wNotUserMode         = ~iUserMode;
assign wIntException        = wInterruptNotZero && wNotExcLevel;
assign wALUException        = (iALUOverflow || wInterruptNotZero) && wNotExcLevel;
assign wALUExcCode          = iALUOverflow ? EXCODEALU : EXCODEINT;
assign wFPALUException      = (iFPALUOverflow || iFPALUUnderflow || wInterruptNotZero) && wNotExcLevel;
assign wFPALUExcCode        = iFPALUOverflow || iFPALUUnderflow ? EXCODEFPALU : EXCODEINT;
*/
initial
begin
    oOrigALU            = 1'b0;
    oMemparaReg         = 3'b000;
    oEscreveReg         = 1'b0;
    oLeMem              = 1'b0;
    oEscreveMem         = 1'b0;
    oOrigPC             = 3'b000;
    oOpALU              = 2'b00;
end


always @(*)
begin
    case(iOp)
		OPCLOAD:
		begin	
			oOrigALU            = 1'b1;
			oMemparaReg         = 3'b001;
			oEscreveReg         = 1'b1;
			oLeMem              = 1'b1;
			oEscreveMem         = 1'b0;
			oOrigPC             = 3'b000;
			oOpALU              = 2'b00;
		end
		
		OPCIARI:
		begin	
			oOrigALU            = 1'b1;
			oMemparaReg         = 3'b000;
			oEscreveReg         = 1'b1;
			oLeMem              = 1'b0;
			oEscreveMem         = 1'b0;
			oOrigPC             = 3'b000;
			oOpALU              = 2'b11;
		end
		
		OPCAUIPC:
		begin
			oOrigALU            = 1'b0;
			oMemparaReg         = 3'b010;
			oEscreveReg         = 1'b1;
			oLeMem              = 1'b0;
			oEscreveMem         = 1'b0;
			oOrigPC             = 3'b000;
			oOpALU              = 2'b00;
		end
		
		OPCSTORE:
		begin
			oOrigALU            = 1'b1;
			oMemparaReg         = 3'b000;
			oEscreveReg         = 1'b0;
			oLeMem              = 1'b0;
			oEscreveMem         = 1'b1;
			oOrigPC             = 3'b000;
			oOpALU              = 2'b00;
		end
		
		OPCR,
		OPCMUL:
		begin
			oOrigALU            = 1'b0;
			oMemparaReg         = 3'b000;
			oEscreveReg         = 1'b1;
			oLeMem              = 1'b0;
			oEscreveMem         = 1'b0;
			oOrigPC             = 3'b000;
			oOpALU              = 2'b10;
		end
		
		OPCLUI:
		begin
			oOrigALU            = 1'b1;
			oMemparaReg         = 3'b000;
			oEscreveReg         = 1'b1;
			oLeMem              = 1'b0;
			oEscreveMem         = 1'b0;
			oOrigPC             = 3'b000;
			oOpALU              = 2'b01;
		end
		
		OPCBRANCH:
		begin
			oOrigALU            = 1'b0;
			oMemparaReg         = 3'b000;
			oEscreveReg         = 1'b0;
			oLeMem              = 1'b0;
			oEscreveMem         = 1'b0;
			oOrigPC             = 3'b001;
			oOpALU              = 2'b01;
		end
		
		OPCJALR:
		begin
			oOrigALU            = 1'b1;
			oMemparaReg         = 3'b011;
			oEscreveReg         = 1'b1;
			oLeMem              = 1'b0;
			oEscreveMem         = 1'b0;
			oOrigPC             = 3'b010;
			oOpALU              = 2'b00;
		end
		
		OPCJAL:
		begin
			oOrigALU            = 1'b0;
			oMemparaReg         = 3'b011;
			oEscreveReg         = 1'b1;
			oLeMem              = 1'b0;
			oEscreveMem         = 1'b0;
			oOrigPC             = 3'b011;
			oOpALU              = 2'b00;
		end
		
		default:	// instrução inválida
		begin
			oOrigALU            = 1'b0;
			oMemparaReg         = 3'b000;
			oEscreveReg         = 1'b0;
			oLeMem              = 1'b0;
			oEscreveMem         = 1'b0;
			oOrigPC             = 3'b000;
			oOpALU              = 2'b00;
		end
		
    endcase
end

endmodule
