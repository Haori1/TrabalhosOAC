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
		
		/* TABELA VERDADE */
		
    endcase
end

endmodule
