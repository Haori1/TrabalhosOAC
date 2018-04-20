`ifndef PARAM
`define PARAM
/* Parametros Gerais*/
parameter
    ON          = 1'b1,
    OFF         = 1'b0,
    ZERO        = 32'b0,

/* Operacoes da ULA */
		OPAND	= 5'd0,
		OPOR	= 5'd1,
		OPXOR	= 5'd2,
		OPADD	= 5'd3,
		OPSUB	= 5'd4,
		OPSLT	= 5'd5,
		OPSLTU	= 5'd6,
		OPGE	= 5'd7,
		OPGEU	= 5'd8,
		OPSLL	= 5'd9,
		OPSRL	= 5'd10,
		OPSRA	= 5'd11,
		OPLUI	= 5'd12,
		OPMUL	= 5'd13,
		OPMULH	= 5'd14,
		OPMULHU	= 5'd15,
		OPMULHSU= 5'd16,
		OPDIV	= 5'd17,
		OPDIVU	= 5'd18,
		OPREM	= 5'd19,
		OPREMU	= 5'd20,

	 
/* Operacoes da ULA FP */
    FOPADD      = 4'd0,
    FOPSUB      = 4'd1,
    FOPMUL      = 4'd2,
    FOPDIV      = 4'd3,
    FOPSQRT      = 4'd4,
    FOPABS       = 4'd5,
    FOPNEG       = 4'd6,
    FOPCEQ       = 4'd7,
    FOPCLT       = 4'd8,
    FOPCLE       = 4'd9,
    FOPCVTSW     = 4'd10,
    FOPCVTWS     = 4'd11;

`endif