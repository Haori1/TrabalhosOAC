/*
 * Caminho de Dados do Processador Multiciclo
 *
 */

module Datapath_MULTI (
// Inputs e clocks
input wire iCLK, iCLK50, iRST,
input wire [31:0] iInitialPC,

// Para testes

input wire 	[4:0]  iRegDispSelect,
output wire [31:0] oPC, oDebug, oInstr, oRegDisp, oRegDispCOP0,

output wire [31:0] oFPRegDisp,
output wire [7:0]  oFPUFlagBank,
input wire 	[4:0]  wVGASelectFPU,
output wire [31:0] wVGAReadFPU,

input wire 	[4:0]  wVGASelect,
output wire [31:0] wVGARead,

output wire [1:0] oALUOp, oALUSrcB,
output wire       oALUSrcA,oIRWrite, oIorD, oPCWrite, oRegWrite, oPCSource,
output wire [5:0] owControlState,

 output wire [31:0] wBRReadA,
 output wire [31:0] wBRReadB,
 output wire [31:0] wBRWrite,
 output wire [31:0] wULA,	 


//Barramento
output wire [31:0] DwAddress, DwWriteData,
input wire 	[31:0] DwReadData,
output wire DwWriteEnable, DwReadEnable,
output wire [3:0] DwByteEnable,

);


//Adicionado no semestre 2014/1 para os load/stores
wire [2:0] 	wLoadCase;
wire [1:0] 	wWriteCase;
wire [3:0] 	wByteEnabler;
wire [31:0] wTreatedToRegister;		
wire [31:0] wTreatedToMemory;
wire [1:0]	wLigaULA_PASSADA;
reg [1:0]	ULA_PASSADA; /*em um ciclo a gente puxa o dado da memoria e no segundo a gente escreve. Eu preciso saber
o resultado passado no proximo ciclo, quando eu vou selecionar o que guardar.*/
assign wLigaULA_PASSADA = ULA_PASSADA;


assign wBRReadA		= wReadData1;
assign wBRReadB		= wReadData2;
assign wBRWrite		= wDataReg;
assign wULA				= wALUResult;

	
/*
 * Local registers
 *
 * Registers are named in camel case and use shortcuts to describe each word
 * in the full name as defined by the COD datapath.
 */
reg [31:0] A, B, MDR, IR, PC, ALUOut, PCBACK;

/*
 * Local wires
 *
 * Wires are named after the named signals as defined by the COD.
 * Wires that are unnamed in the COD are named as 'w' followed by a short
 * description.
 */
wire [6:0] 	wOpcode;
wire [2:0]  wFunct3;
wire [6:0]  wFunct7;
wire [4:0] 	wAddrRs1, wAddrRs2, wAddrRd;
wire wCIRWrite, wCMemWrite, wCMemRead, wCIorD, wCPCWrite, wCPCWriteCond,
	  wCRegWrite, wALUZero, wCALUSrcA, wBranchControl;
wire [1:0] 	wCALUOp, wCALUSrcB, wCMemtoReg;
//wire [2:0] 	Store;
wire [4:0] 	wALUControlSignal;
wire [31:0] wALUMuxA, wALUMuxB, wALUResult, wImm, wShiftImm,
				wReadData1, wReadData2, wDataReg, wRegWriteData, wMemorALU,
				wMemWriteData, wMemReadData, wMemAddress, wPCMux, wCPCSource;
//wire [63:0] wTimerOut, wEndTime;

/*
 * Local FP wires
 
wire [7:0] 	wFPUFlagBank;
wire [4:0] 	wFs, wFt, wFd, wFmt, wFPWriteRegister;
wire [3:0] 	wFPALUControlSignal;
wire [2:0] 	wBranchFlagSelector, wFPFlagSelector;
wire [31:0] wFPALUResult, wFPWriteData, wFPReadData1, wFPReadData2, wFPRegDisp;
wire wFPOverflow, wFPZero, wFPUnderflow, wSelectedFlagValue, wFPNan, wBranchTouF, wCompResult;
*/

/* FPU Control Signals*//*
wire [1:0] 	FPDataReg, FPRegDst;
wire FPPCWriteBc1t, FPPCWriteBc1f, FPRegWrite, FPU2Mem, FPFlagWrite;

wire wFPStart, wFPBusy;
wire [4:0] 	wFPBusyTime;

*/
// feito no semestre 2013/1 para implementar a deteccao de excecoes (COP0)
/*
 * Local COP0 wires
 
wire [31:0] wCOP0DataReg, wCOP0ReadData;
wire [7:0] 	wCOP0InterruptMask;
wire PCOriginalWrite, COP0RegWrite, COP0Eret, COP0ExcOccurred, COP0BranchDelay, 
	  COP0Interrupted, wCOP0UserMode, wCOP0ExcLevel;
wire [4:0] 	COP0ExcCode;
*/

/*
 * Wires assignments
 *
 * 2 to 1 multiplexers are also handled here.
 */
assign wOpcode			= IR[6:0];
assign wFunct3			= IR[14:12];
assign wFunct7			= IR[31:25];
assign wAddrRs1			= IR[19:15];
assign wAddrRs2			= IR[24:20];
assign wAddrRd			= IR[11:7];
assign wShiftImm		= {wImm[30:0], 1'b0};

assign wMemWriteData	= B;

//assign wMemorALU		= wCMemtoReg ? MDR : ALUOut;
assign wMemAddress	= wCIorD ? ALUOut : PC;


/* Floating Point wires assignments*//*
assign wFs 				= IR[15:11];
assign wFt 				= IR[20:16];
assign wFd 				= IR[10:6];
assign wFmt 			= IR[25:21];
assign wBranchFlagSelector = IR[20:18];
assign wSelectedFlagValue = wFPUFlagBank[wBranchFlagSelector];
assign wFPFlagSelector 	= IR[10:8];
assign wBranchTouF 		= IR[16];
*/
/* Output wires */
assign oPC			= PC;
assign oALUOp		= wCALUOp;
assign oPCSource	= wCPCSource;
assign oALUSrcB	= wCALUSrcB;
assign oIRWrite	= wCIRWrite;
assign oIorD		= wCIorD;
assign oPCWrite	= wCPCWrite;
assign oALUSrcA	= wCALUSrcA;
assign oRegWrite	= wCRegWrite;
assign oInstr 		= IR;
//assign oFPUFlagBank = wFPUFlagBank;

assign oDebug = COP0ExcCode; //32'hB0DEF0F0;

// feito no semestre 2013/1 para implementar a deteccao de excecoes (COP0)
//assign wCOP0DataReg = COP0ExcOccurred ? PC_original : B;
//assign oCOP0Interrupted = COP0Interrupted;
//assign oCOP0ExcCode = COP0ExcCode;

/*
 * Processor initial state
 */
initial
begin
	PC			<= BEGINNING_TEXT;
	PCBACK		<= BEGINNING_TEXT;
	IR			<= ZERO;
	ALUOut		<= ZERO;
	MDR 		<= ZERO;
	A 			<= ZERO;
	B 			<= ZERO;
end

/*
 * Clocked events
 *
 * Registers in the Datapath outside any modules are written here.
 */
always @(posedge iCLK or posedge iRST)
begin
	if (iRST)
	begin
		PC			<= iInitialPC;
		PCBACK		<= iInitialPC;
		IR			<= 32'b0;
		ALUOut	<= 32'b0;
		MDR 		<= 32'b0;
		A 			<= 32'b0;
		B 			<= 32'b0;
	end
	else
	begin
		/* Unconditional */

		ALUOut	<= wALUResult;
		A			<= wReadData1;
		B			<= wReadData2;
		MDR		<= wMemReadData;
		PCBACK <= PC;


		/* Conditional */
		if (wCPCWrite || (wCPCWriteCond && wBranchControl))
			PC	<= wPCMux;

		if (wCIRWrite)
			IR	<= wMemReadData;

		//2014, detecta que e um load ou write que nao precisa do resultado passado da ula passada
		if(wLoadCase==0)
			ULA_PASSADA <= wMemAddress[1:0];

	end
end



/*
 * Modules instantiation
 */

ImmGen ImmGen0 (
	.iInstr(IR),
	.oImmResult(wImm)
	);

/* Control module - State Machine*/
Control_MULTI CrlMULTI (
	.iCLK(iCLK),
	.iRST(iRST),
	.iOpcode(wOpcode),
	
	.oIorD(wCIorD),
	.oMemRead(wCMemRead),
	.oMemWrite(wCMemWrite),
	.oIRWrite(wCIRWrite),
	.oALUSrcA(wCALUSrcA),
	.oALUSrcB(wCALUSrcB),
	.oALUOp(wCALUOp),
	.oMemtoReg(wCMemtoReg),
	.oRegWrite(wCRegWrite),
	.oPCWrite(wCPCWrite),
	.oPCWriteCond(wCPCWriteCond),
	//.oPCWriteBEQ(PCWriteBEQ),
	//.oPCWriteBNE(PCWriteBNE),
	.oPCSource(wCPCSource),

	.oState(owControlState),
	/*
	.oStore(Store),
	
	.oFPDataReg(FPDataReg),
	.oFPRegDst(FPRegDst),
	.oFPPCWriteBc1t(FPPCWriteBc1t),
	.oFPPCWriteBc1f(FPPCWriteBc1f),
	.oFPRegWrite(FPRegWrite),
	.oFPFlagWrite(FPFlagWrite),
	.oFPU2Mem(FPU2Mem),
	// feito no semestre 2013/1 para implementar a deteccao de excecoes (COP0)
	.iCOP0ALUoverflow(ALUoverflow),
	.iCOP0FPALUoverflow(FPALUoverflow),
	.iCOP0FPALUunderflow(FPALUunderflow),
	.iCOP0FPALUnan(FPALUnan),
	.iCOP0UserMode(wCOP0UserMode),
	.iCOP0ExcLevel(wCOP0ExcLevel),
	.iCOP0PendingInterrupt(wCOP0InterruptMask),
	.oCOP0PCOriginalWrite(PCOriginalWrite),
	.oCOP0RegWrite(COP0RegWrite),
	.oCOP0Eret(COP0Eret),
	.oCOP0ExcOccurred(COP0ExcOccurred),
	.oCOP0BranchDelay(COP0BranchDelay),
	.oCOP0ExcCode(COP0ExcCode),
	.oCOP0Interrupted(COP0Interrupted),
	//adicionado em 1/2014
	.oLoadCase(wLoadCase),
	.oWriteCase(wWriteCase),
	//adicionado em 1/2016 para implementação dos branchs
	.iRt (wRT),
	
	.iFPBusy(wFPBusy),
	.oFPStart(wFPStart)
	*/
	);

/* Register bank module */
Registers RegsMULTI (
	.iCLK(iCLK),
	.iCLR(iRST),
	.iReadRegister1(wAddrRs1),
	.iReadRegister2(wAddrRs2),
	.iWriteRegister(wAddrRd),
	.iWriteData(wDataReg),
	.iRegWrite(wCRegWrite),
	.oReadData1(wReadData1),
	.oReadData2(wReadData2),
	.iRegDispSelect(iRegDispSelect),
	.oRegDisp(oRegDisp),
	.iVGASelect(wVGASelect),
	.oVGARead(wVGARead)
	);


/* Arithmetic Logic Unit module */
ALU ALU0 (
	.iA(wALUMuxA),
	.iB(wALUMuxB),
	.iControlSignal(wALUControlSignal),
	.oZero(wALUZero),
	.oALUresult(wALUResult),
	);

/* Arithmetic Logic Unit control module */
ALUControl ALUcont0 (
	.iFunct3(wFunct3),
	.iFunct7(wFunct7),
	.iALUOp(wCALUOp),
	.oControlSignal(wALUControlSignal)
	);


// Mux ALU input 'A'
always @(*)
	case (wCALUSrcA)
		1'b0: wALUMuxA <= PCBACK;
		1'b1: wALUMuxA <= A;
		default: wALUMuxA <= 32'd0;
	endcase


// Mux ALU input 'B'
always @(*)
	case (wCALUSrcB)
		2'b00: wALUMuxB <= B;
		2'b01: wALUMuxB <= 32'd4;
		2'b10: wALUMuxB <= wImm;
		2'b11: wALUMuxB <= wShiftImm;			//adicionado em 1/2016 para calculo dos branchs
		default: wALUMuxB <= 32'd0;
	endcase

// Mux MemToReg
always @(*)
	case (wCMemtoReg)
		2'b00: wDataReg <= ALUOut;
		2'b01: wDataReg <= PC;
		2'b10: wDataReg <= wTreatedToRegister;	//dado do MDR tratado pelo memload
		2'b11: wDataReg <= wShiftImm;
		default: wDataReg <= ZERO;
	endcase

// Branch Control
always @(*)
	case (iFunct3)
		FUN3BEQ:
			wBranchControl <= wALUZero;
		FUN3BNE:
			wBranchControl <= ~wALUZero;
		FUN3BLT,
		FUN3BGE,
		FUN3BLTU,
		FUN3BGEU:
			wBranchControl <= wALUResult[0];
		default:
			wBranchControl <= 1'b0;
	endcase

// Mux OrigPC
always @(*)
	case (wCPCSource)
		1'b0: wPCMux <= wALUResult;		
		1'b1: wPCMux <= ALUOut;
		default: wPCMux <= ZERO;
	endcase


MemStore MemStore0 (
	.iAlignment(wMemAddress[1:0]),
	//.iWriteTypeF(wWriteCase),
	.iFunct3(wFunct3),
	.iData(wMemWriteData),
	.oData(wTreatedToMemory),
	.oByteEnable(wByteEnabler),
	.oException()
	);


/* RAM Memory block module */

assign DwAddress 		= wMemAddress;
assign DwWriteData 	= wTreatedToMemory;
assign wMemReadData 	= DwReadData;
assign DwWriteEnable = wCMemWrite;
assign DwReadEnable 	= wCMemRead;
assign DwByteEnable 	= wByteEnabler;


MemLoad MemLoad0 (
	.iAlignment(wLigaULA_PASSADA),
	//.iLoadTypeF(wLoadCase),
	.iFunct3(wFunct3),
	.iData(MDR),
	.oData(wTreatedToRegister),
	.oException()
	);


// feito no semestre 2013/1 para implementar a deteccao de excecoes (COP0)
/* Banco de registradores do Coprocessador 0 
COP0RegistersMULTI cop0reg (
	.iCLK(iCLK),
	.iCLR(iRST),

	// register file interface
	.iReadRegister(wRD),
	.iWriteRegister(wRD),
	.iWriteData(wCOP0DataReg),
	.iRegWrite(COP0RegWrite),
	.oReadData(wCOP0ReadData),

	// eret interface
	.iEret(COP0Eret),

	// COP0 interface
	.iExcOccurred(COP0ExcOccurred),
	.iBranchDelay(COP0BranchDelay),
	.iPendingInterrupt(iPendingInterrupt),
	.iInterrupted(COP0Interrupted),
	.iExcCode(COP0ExcCode),
	.oInterruptMask(wCOP0InterruptMask),
	.oUserMode(wCOP0UserMode),
	.oExcLevel(wCOP0ExcLevel),
//	.oInterruptEnable(oCOP0InterruptEnable),
	// DE2-70 interface
	.iRegDispSelect(iRegDispSelect),
	.oRegDisp(oRegDispCOP0)
	);

*/

endmodule
