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
		7'b0000011:
		/* lb,
			lh,
			lbu,
			lw, 
			lhu */
		begin	
			oOrigALU            = 1'b1;
			oMemparaReg         = 3'b001;
			oEscreveReg         = 1'b1;
			oLeMem              = 1'b1;
			oEscreveMem         = 1'b0;
			oOrigPC             = 3'b000;
			oOpALU              = 2'b00;
		end
		
		7'b0010011:
		/* addi,
			slli,
			slti,
			sltiu,
			xori,
			srli,
			srai,
			ori,
			andi */
		begin	
			oOrigALU            = 1'b1;
			oMemparaReg         = 3'b000;
			oEscreveReg         = 1'b1;
			oLeMem              = 1'b0;
			oEscreveMem         = 1'b0;
			oOrigPC             = 3'b000;
			oOpALU              = 2'b11;
		end
		
		7'b0010111:
		/* auipc */
		begin
			oOrigALU            = 1'b0;
			oMemparaReg         = 3'b010;
			oEscreveReg         = 1'b1;
			oLeMem              = 1'b0;
			oEscreveMem         = 1'b0;
			oOrigPC             = 3'b000;
			oOpALU              = 2'b00;
		end
		
		7'b0100011:
		/* sb,
			sh, 
			sw */
		begin
			oOrigALU            = 1'b1;
			oMemparaReg         = 3'b000;
			oEscreveReg         = 1'b0;
			oLeMem              = 1'b0;
			oEscreveMem         = 1'b1;
			oOrigPC             = 3'b000;
			oOpALU              = 2'b00;
		end
		
		7'b0110011:
		/* add, 
			sub,
			sll,
			slt,
			sltu,
			xor,
			srl,
			sra,
			or,
			and,
			mul,
			mulh,
			mulhsu,
			mulhu,
			div,
			divu,
			rem,
			remu */
		begin
			oOrigALU            = 1'b0;
			oMemparaReg         = 3'b000;
			oEscreveReg         = 1'b1;
			oLeMem              = 1'b0;
			oEscreveMem         = 1'b0;
			oOrigPC             = 3'b000;
			oOpALU              = 2'b10;
		end
		
		7'b0110111:
		/* lui */
		begin
			oOrigALU            = 1'b1;
			oMemparaReg         = 3'b000;
			oEscreveReg         = 1'b1;
			oLeMem              = 1'b0;
			oEscreveMem         = 1'b0;
			oOrigPC             = 3'b000;
			oOpALU              = 2'b01;
		end
		
		7'b1100011:
		/* beq,
			bne,
			blt,
			bge,
			bltu,
			bgeu */
		begin
			oOrigALU            = 1'b0;
			oMemparaReg         = 3'b000;
			oEscreveReg         = 1'b0;
			oLeMem              = 1'b0;
			oEscreveMem         = 1'b0;
			oOrigPC             = 3'b001;
			oOpALU              = 2'b01;
		end
		
		7'b1100111:
		/* jalr */
		begin
			oOrigALU            = 1'b1;
			oMemparaReg         = 3'b011;
			oEscreveReg         = 1'b1;
			oLeMem              = 1'b0;
			oEscreveMem         = 1'b0;
			oOrigPC             = 3'b010;
			oOpALU              = 2'b00;
		end
		
		7'b1101111:
		/* jal */
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
