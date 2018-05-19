/*
 * Caminho de dados processador Pipeline
 *
 */
 module Datapath_PIPEM (
	// Clocks and reset
	input wire 				iCLK, iCLK50, iRST,
	input 		[31:0] 	iInitialPC,

	output wire [31:0] 	oPC, oInstr, oDebug, oRegDisp,
	input wire 	[4:0] 	iRegDispSelect,
	input wire 	[4:0] 	iVGASelect,
	output wire [31:0] 	oVGARead,

    output wire [7:0]  oFPUFlagBank,
	 output wire [31:0] oFPRegDisp,
	 input       [4:0]  iVGASelectFPU,
	 output      [31:0] oVGAReadFPU,
	
	// mostradores
	output wire [2:0] 	oLoadType,
	output wire [1:0] 	oWriteType,
	output wire [ 1:0] 	oCRegDst, oCOrigALU, oCSavePC,oCALUOp,
	output wire [ 2:0] 	oCOrigPC,
	output wire        	oCRegWrite,
	output wire 			oCJump, oCBranch, oCJr,

	 output wire [31:0] wBRReadA,
	 output wire [31:0] wBRReadB,
	 output wire [31:0] wBRWrite,
	 output wire [31:0] wULA,	 
 
	// Barramento de Dados
	output wire [31:0] 	DwMemWriteData, DwMemAddress,
	input wire 	[31:0] 	DwMemReadData,
	output wire 			DwMemRead, DwMemWrite,
	output 		[3:0] 	DwByteEnable,

	// Barramento Instrucoes
	output wire [31:0] 	IwMemWriteData, IwMemAddress,
	input wire 	[31:0] 	IwMemReadData,
	output wire 			IwMemRead, IwMemWrite,
	output 		[3:0] 	IwByteEnable

//	input wire iSwitchLock
);


assign oVGARead 		= wVGARead;
assign wVGASelect 	= iVGASelect;

assign oVGAReadFPU 	= wVGAReadFPU;
assign wVGASelectFPU = iVGASelectFPU;
assign oFPUFlagBank  = wFPUFlagBank;

assign wBRReadA		= wID_Read1;
assign wBRReadB		= wID_Read2;
assign wBRWrite		= wWB_WriteData;
assign wULA				= wEX_ResultALU;


assign oDebug 			= EPC; //{31'b0, wHU_Hazard}; // Debug port
assign oPC 				= PC;
assign oInstr 			= wIF_Instr;
assign oCRegDst     	= wID_CRegDst;
assign oCOrigALU     = wID_COrigALU;
assign oCSavePC      = wID_CSavePC;
assign oCOrigPC      = wID_COrigPC;
assign oCRegWrite    = wID_CRegWrite;
assign oCALUOp       = wID_CALUOp;
assign oCJump        = wID_CJump;
assign oCBranch      = wID_CBranch;
assign oCJr          = wID_CJr;

wire iLock;
//assign iLock = iSwitchLock | wEX_Lock;
assign iLock=1'b0;

// Registradores do Pipeline

// Quando fizer alguma modificação basta modificar esses parâmetros
parameter NIFID  = 64,
			 NIDEX  = 212,
			 NEXMEM = 148,
			 NMEMWB = 76;

reg [NIFID-1:0] RegIFID;
reg [NIDEX-1:0] RegIDEX;
reg [NEXMEM-1:0] RegEXMEM;
reg [NMEMWB-1:0] RegMEMWB;

initial begin
	PC       <= BEGINNING_TEXT;
	RegIFID  <= {NIFID{1'b0}};
	RegIDEX  <= {NIDEX{1'b0}};
	RegEXMEM <= {NEXMEM{1'b0}};
	RegMEMWB <= {NMEMWB{1'b0}};
end

//================ Estruturas do Estagio IF - BEGIN ===================//

reg  [31:0] PC;        // registrador do PC
wire [31:0] wIF_iPC;   // fios entrada do PC
wire [31:0] wIF_PC4;   // fios do PC+4
wire [31:0] wIF_Instr; // fio da Instrucao

assign 		wIF_PC4 = PC + 32'h4; /* Calculo PC+4 */

// Mux OrigPC
always @(*) begin
	case(wID_COrigPC)
		3'b000:  wIF_iPC = wIF_PC4; 										// PC + 4
		3'b001:  wIF_iPC = wID_Equal ? wID_BranchPC : wID_PC4; //wIF_PC4; 	//wID_PC4 + 32'h4; // beq address
		3'b010:  wIF_iPC = (wHU_ForwardJr) ? wEX_ResultALU : wID_ResultForwardJr; // Mux jr
		3'b100:  wIF_iPC = BEGINNING_KTEXT; 							// .ktext
		3'b101:  wIF_iPC = ~wID_Equal ? wID_BranchPC : wID_PC4; //wIF_PC4; 	//wID_PC4 + 32'h4; // bne address
		3'b110:	wIF_iPC = EPC;
		default: wIF_iPC = wID_PC4; //wIF_PC4;
	endcase
end

// Memoria de Instrucoes
assign IwMemRead     	= ON;
assign IwMemWrite    	= OFF;
assign IwMemAddress   	= PC;
assign IwMemWriteData 	= ZERO;
assign wIF_Instr 			= IwMemReadData;
assign IwByteEnable 		= 4'b0000;


parameter BRANCH_DELAY_SLOT = 1'b0;

// IF/ID register write
always @(posedge iCLK or posedge iRST) begin
	if(iRST) begin
		PC      	<= iInitialPC;
		RegIFID  <= {NIFID{1'b0}};
	end
	else begin
		if (!wHU_Hazard && !iLock) begin
			PC <= wIF_iPC;
		end
		if (!wHU_Hazard) begin // Se estiver bloqueado, nao da flush
			if (wIFID_Flush && ~BRANCH_DELAY_SLOT) begin
				RegIFID[63: 0] <= {NIFID{1'b0}};
			end
			else begin
				if (!iLock) begin
					RegIFID[31: 0] <= wIF_PC4; //wPC + 32'h4;
					RegIFID[63:32] <= wIF_Instr;
				end
			end
		end
	end
end

//================ Estruturas do Estagio ID - BEGIN ===================//

// IF/ID register wires
wire [31:0] wID_PC4   = RegIFID[31: 0]; // PC+4 do IF/ID
wire [31:0] wID_Instr = RegIFID[63:32];

wire [31:0] wID_Read1;
wire [31:0] wID_Read2;

// Control unit output
wire [1:0] wID_CRegDst;
wire [1:0] wID_COrigALU;
wire       wID_CSavePC;
wire       wID_CRegWrite;
wire       wID_CMemRead;
wire       wID_CMemWrite;
wire [1:0] wID_CALUOp;
wire [2:0] wID_COrigPC;
wire       wID_CJump;
wire       wID_CBranch;
wire       wID_CnBranch;
wire       wID_CJr;
wire		  wID_CEPCWrite;
wire [2:0] wID_LoadType;
wire [1:0] wID_WriteType;

//FP
wire wID_FPStart;
wire wID_FPRegWrite;
wire [1:0] wID_FPRegDst;

wire [31:0] wIDFP_Read1;
wire [31:0] wIDFP_Read2;

// Hazard unit
wire wHU_Hazard;
wire wHU_ForwardJr;
wire wHU_ForwardPC4;
wire wHU_Branch;

wire wIFID_Flush = (wID_CJump || (wID_CBranch && wID_Equal) || (wID_CnBranch && ~wID_Equal)) ? 1'b1 : 1'b0;

// Teste
wire wFU_ForwardBranchRs, wFU_ForwardBranchRt;

// Instruction decode wires
wire [15:0] wID_Imm     = wID_Instr[15: 0];
wire [25:0] wID_Address = wID_Instr[25: 0];
wire [ 5:0] wID_Funct   = wID_Instr[ 5: 0];
wire [ 4:0] wID_NumRt   = wID_Instr[20:16];
wire [ 4:0] wID_NumRs   = wID_Instr[25:21];
wire [ 5:0] wID_Opcode  = wID_Instr[31:26];

wire [31:0] wID_JumpAddr = {wID_PC4[31:28], wID_Address[25:0], 2'b0};
wire [31:0] wID_BranchPC = wID_PC4 + {{14{wID_Imm[15]}}, wID_Imm, 2'b0};
wire [31:0] wID_JrAddr   = wID_Read1;

assign wHU_Branch = wID_CBranch | wID_CnBranch;

wire wID_Equal = (wID_ResultRead1 == wID_ResultRead2) ? 1'b1 : 1'b0;

wire [31:0] wID_ResultJr 			= (wID_CJr) ? wID_JrAddr : wID_JumpAddr;
wire [31:0] wID_ResultForwardJr 	= (wHU_ForwardJr) ? wEX_ResultALU : wID_ResultJr;
wire [31:0] wID_ResultRead1 		= (wFU_ForwardBranchRs) ? wMEM_ResultALU : /* (wID_NumRs == wWB_RegDestino) ? wWB_WriteData : */ wID_Read1;
wire [31:0] wID_ResultRead2 		= (wFU_ForwardBranchRt) ? wMEM_ResultALU : /* (wID_NumRt == wWB_RegDestino) ? wWB_WriteData : */ wID_Read2;

/* Floating Point wires assignments*/
wire [7:0] wFPUFlagBank;

wire [4:0] 	wID_Fs 	= wID_Instr[15:11];
wire [4:0] 	wID_Ft 	= wID_Instr[20:16];
wire [4:0] 	wID_Fd 	= wID_Instr[10:6];
wire [4:0] 	wID_Fmt 	= wID_Instr[25:21];
wire [2:0] 	wID_BranchFlagSelector 	= wID_Instr[20:18];
wire 			wID_SelectedFlagValue 	= wFPUFlagBank[wID_BranchFlagSelector];
wire [2:0] 	wID_FPFlagSelector 		= wID_Instr[10:8];
wire 			wID_BranchTouF 			= wID_Instr[16];

Registers memReg(
	.iCLK(iCLK),
	.iCLR(iRST),
	.iReadRegister1(wID_NumRs),
	.iReadRegister2(wID_NumRt),
	.iWriteRegister(wWB_RegDestino),
	.iWriteData(wWB_WriteData), 
	.iRegWrite(wWB_RegWrite),
	.oReadData1(wID_Read1),
	.oReadData2(wID_Read2),
	// debug
	.iRegDispSelect(iRegDispSelect),
	.oRegDisp(oRegDisp),
	.iVGASelect(wVGASelect),
	.oVGARead(wVGARead)
 );

wire [4:0] wVGASelect;
wire [31:0] wVGARead;

/* Floating Point register bank module*/
FPURegisters FPURegBank (
	.iCLK(iCLK),
	.iCLR(iRST),
	.iReadRegister1(wID_Fs),
	.iReadRegister2(wID_Ft),
   .iWriteRegister(wWB_FPRegDestino),
	.iWriteData(wWB_FPWriteData),
	.iRegWrite(wWB_FPRegWrite),
	.oReadData1(wIDFP_Read1),
	.oReadData2(wIDFP_Read2),
	.iRegDispSelect(iRegDispSelect),
	.oRegDisp(oFPRegDisp),
	.iVGASelect(wVGASelectFPU),
	.oVGARead(wVGAReadFPU)
);

wire [4:0] 	wVGASelectFPU;
wire [31:0] wVGAReadFPU;

/*FPU Flag Bank*/
wire FPFlagWrite;

FlagBank FlagBankModule(
	.iCLK(iCLK),
	.iCLR(iRST),
	.iFlag(wID_FPFlagSelector),
	//.iFlagWrite(FPFlagWrite),
	.iData(wCompResult),
	.oFlags(wFPUFlagBank)
	);

Control_PIPEM Controlunit (
	.iOp(wID_Opcode),
	.iFunct(wID_Funct),
	.oRegDst(wID_CRegDst),
	.oOrigALU(wID_COrigALU),
	.oSavePC(wID_CSavePC),
	.oEscreveReg(wID_CRegWrite),
	.oLeMem(wID_CMemRead),
	.oEscreveMem(wID_CMemWrite),
	.oOpALU(wID_CALUOp),
	.oOrigPC(wID_COrigPC),
	.oJump(wID_CJump),
	.oBranch(wID_CBranch),
	.onBranch(wID_CnBranch),
	.oJr(wID_CJr),
	.oEscreveEPC(wID_CEPCWrite),
	.oLoadType(wID_LoadType),
	.oWriteType(wID_WriteType)
	
/* ****************** Precisa checar esse controle, parece que são cut and paste de projetos diferentes! ******/	
/*	output       oFPUtoULA,
	input  [4:0] iFmt,
	input        iBranchC1,
	output [1:0] oFPDataReg,
	output [1:0] oFPRegDst,
	output       oFPRegWrite,
	output       oFPFlagWrite,
	output       oFPU2Mem,
	output       oFPStart	
	
	.iFPBusy(),
	.oFPStart(wID_FPStart),
	.oFPFlagWrite(FPFlagWrite),
   .oFPDataReg(),
	.oFPRegWrite(wID_FPRegWrite),
	.oFPRegDst(wID_FPRegDst)
*/	
	);

HazardUnitM hUnit (
	.iID_NumRs(wID_NumRs), 
	.iID_NumRt(wID_NumRt), 
	.iEX_NumRt(wEX_NumRt), 
	.iEX_MemRead(wEX_MemRead), 
	.iEX_RegWrite(wEX_RegWrite),
	.iCJr(wID_CJr),
	.iEX_RegDst(wEX_RegDestino),
	.iMEM_MemRead(wMEM_MemRead),
	.iMEM_RegDst(wMEM_RegDestino),
	.iMEM_RegWrite(wMEM_RegWrite),
	.iBranch(wHU_Branch),
	.oHazard(wHU_Hazard),
	.oForwardJr(wHU_ForwardJr),
	.oForwardPC4(wHU_ForwardPC4)
	);

reg 	[31:0] EPC; // Armazena o Endereco de retorno do syscall

// ID/EX register write
always @(posedge iCLK or posedge iRST) begin
	if (iRST) begin
		RegIDEX 	<= {NIDEX{1'b0}};
		EPC		<= 32'b0;
	end
	else begin
		if (wHU_Hazard) begin
			RegIDEX <= {NIDEX{1'b0}};
		end
		else begin
			if (!iLock) begin
				RegIDEX[ 31:  0] <= wID_PC4;   // 32
				RegIDEX[ 63: 32] <= wID_Instr; // 32
				RegIDEX[ 95: 64] <= wID_Read1; // 32
				RegIDEX[127: 96] <= wID_Read2; // 32
				// Control
				RegIDEX[129:128] <= wID_CALUOp;    // 2
				RegIDEX[131:130] <= wID_COrigALU;  // 2
				RegIDEX[133:132] <= wID_CRegDst;   // 2
				RegIDEX[134]     <= wID_CMemRead;  // 1
				RegIDEX[135]     <= wID_CMemWrite; // 1
				RegIDEX[136]     <= wID_CSavePC;   // 1
				RegIDEX[137]     <= wID_CRegWrite; // 1
				RegIDEX[140:138] <= wID_LoadType;  // 3
				RegIDEX[142:141] <= wID_WriteType; // 2
				
				RegIDEX[143]	  <= wID_FPStart;   // 1
				RegIDEX[175:144] <= wIDFP_Read1;  // 32 
				RegIDEX[207:176] <= wIDFP_Read2;  //32
				RegIDEX[208]     <= wID_FPRegWrite; //1
				RegIDEX[210:209] <= wID_FPRegDst; //2  
				
				if(wID_CEPCWrite) begin  // Salva PC+4 em EPC
					EPC <= wID_PC4;
				end
			end
		end
	end
end

//================ Estruturas do Estagio EX - BEGIN ===================//

// ID/EX register wires
wire [31:0] wEX_PC4    = RegIDEX[ 31:  0]; // PC+4 do ID/EX
wire [31:0] wEX_Instr  = RegIDEX[ 63: 32];
wire [31:0] wEX_Read1  = RegIDEX[ 95: 64];
wire [31:0] wEX_Read2  = RegIDEX[127: 96];
// Control
wire [1:0] wEX_ALUOp     = RegIDEX[129:128];
wire [1:0] wEX_OrigALU   = RegIDEX[131:130];
wire [1:0] wEX_RegDst    = RegIDEX[133:132];
wire       wEX_MemRead   = RegIDEX[134];
wire       wEX_MemWrite  = RegIDEX[135];
wire       wEX_SavePC    = RegIDEX[136];
wire       wEX_RegWrite  = RegIDEX[137];
wire [2:0] wEX_LoadType  = RegIDEX[140:138];
wire [1:0] wEX_WriteType = RegIDEX[142:141];

wire [31:0] wEX_ResultALU;      // resultado na saida da ALU
wire [31:0] wEX_ResultForwardA; // resultado do mux ForwardA
wire [31:0] wEX_ResultForwardB; // resultado do mux ForwardB
wire [31:0] wEX_ResultOrigALU;  // resultado do mux controlado por OrigALU

wire [31:0] FP_A 		= RegIDEX[175:144];
wire [31:0] FP_B 		= RegIDEX[207:176];
wire wEX_FPRegWrite 	= RegIDEX[208];
wire [1:0] wEX_FPRegDst 	= RegIDEX[210:209];
// Instruction decode wires
wire [5:0] wEX_Funct  = wEX_Instr[ 5: 0];
wire [4:0] wEX_Shamt  = wEX_Instr[10: 6];
wire [4:0] wEX_NumRd  = wEX_Instr[15:11];
wire [4:0] wEX_NumRt  = wEX_Instr[20:16];
wire [4:0] wEX_NumRs  = wEX_Instr[25:21];
wire [5:0] wEX_Opcode = wEX_Instr[31:26];

wire [4:0] wEX_NumFd  = wEX_Instr[10:6];
wire [4:0] wEX_NumFt  = wEX_Instr[20:16];
wire [4:0] wEX_NumFs  = wEX_Instr[15:11];

// Immediate
wire [31:0] wEX_ConcatZeroImm = {wEX_Instr[15:0], 16'b0};
wire [31:0] wEX_ExtZeroImm    = {16'b0, wEX_Instr[15:0]};
wire [31:0] wEX_ExtSigImm     = {{16{wEX_Instr[15]}}, wEX_Instr[15:0]};

wire [4:0] wEX_ALUControl; // fio que sai da ALUControl e entra na ULA

// wire [1:0] wEX_MemReadWrite;//contem os sinais EscreveMem, LeMem
wire [4:0] wEX_RegDestino; // numero do registrador de destino 
wire [4:0] wEX_FPRegDestino;

wire wEX_Zero, wEX_Overflow;

wire [1:0] wFU_ForwardA, wFU_ForwardB;

//wire wEX_Lock;

// Mux Forward A

//fp wires
wire wCompResult;
wire [31:0] wFPALUResult;

always @(*) begin
	case(wFU_ForwardA)
		2'b00:   wEX_ResultForwardA = wEX_Read1;
		2'b01:   wEX_ResultForwardA = wWB_WriteData;
		2'b10:   wEX_ResultForwardA = wMEM_ResultALU;
		default: wEX_ResultForwardA = wEX_Read1;
	endcase
end

// Mux Forward B
always @(*) begin
	case(wFU_ForwardB)
		2'b00:   wEX_ResultForwardB = wEX_Read2;
		2'b01:   wEX_ResultForwardB = wWB_WriteData;
		2'b10:   wEX_ResultForwardB = wMEM_ResultALU;
		default: wEX_ResultForwardB = wEX_Read2;
	endcase
end

// Mux OrigALU
always @(*) begin
	case(wEX_OrigALU)
		2'b00: wEX_ResultOrigALU = wEX_ResultForwardB;
		2'b01: wEX_ResultOrigALU = wEX_ExtSigImm;
		2'b10: wEX_ResultOrigALU = wEX_ExtZeroImm;
		2'b11: wEX_ResultOrigALU = wEX_ConcatZeroImm;
		default: wEX_ResultOrigALU = 32'bx;
	endcase
end

// Mux RegDst
always @(*) begin
	case(wEX_RegDst)
		2'b00:   wEX_RegDestino = wEX_NumRt;
		2'b01:   wEX_RegDestino = wEX_NumRd;
		2'b10:   wEX_RegDestino = 5'd31;
		default: wEX_RegDestino = 5'd0;
	endcase
	
	case(wEX_FPRegDst)
		2'b00:   wEX_FPRegDestino = wEX_NumFs;
		2'b01:   wEX_FPRegDestino = wEX_NumFt;
		2'b10:   wEX_FPRegDestino = wEX_NumFd;
		default: wEX_FPRegDestino = 5'd0;
	endcase

end

ALUControl ALUControlunit (
	.iFunct(wEX_Funct), 
	.iOpcode(wEX_Opcode), 
	.iALUOp(wEX_ALUOp), 
	.oControlSignal(wEX_ALUControl)
	);

ALU ALUunit(
	.iCLK(iCLK),
	.iRST(iRST),
	.iControlSignal(wEX_ALUControl),
	.iA(wEX_ResultForwardA), 
	.iB(wEX_ResultOrigALU),
	.iShamt(wEX_Shamt),
	.oALUresult(wEX_ResultALU),
	.oZero(wEX_Zero),
	.oOverflow(wEX_Overflow)
//	.oLock(wEX_Lock)
	);

/* Floating Point ALU*/
ula_fp FPALUUnit (
	.iclock(iCLK),  //.iclock(iCLK50),
	.idataa(FP_A),
	.idatab(FP_B),
	//.icontrol(wFPALUControlSignal),
	.oresult(wFPALUResult),
	//.onan(wFPNan),
	//.ozero(wFPZero),
	//.ooverflow(wFPOverflow),
	//.ounderflow(wFPUnderflow),
	.oCompResult(wCompResult)
	
	//.iFPBusyTime(wFPBusyTime),
	//.iFPStart(wFPStart),
	//.oFPBusy(wFPBusy)
	);

// Está incompleto!
wire [3:0]  wFPALUControlSignal;
wire [4:0] wFPBusyTime;

FPALUControl FPALUControlUnit (
	.iFunct(wEX_Funct),
	.oControlSignal(wFPALUControlSignal),
	.oFPBusyTime(wFPBusyTime)
	);

ForwardUnitM fUnit(
	.iID_NumRs(wID_NumRs),
	.iID_NumRt(wID_NumRt),
	.iEX_NumRs(wEX_NumRs),
	.iEX_NumRt(wEX_NumRt),
	.iMEM_NumRd(wMEM_RegDestino),
	.iMEM_RegWrite(wMEM_RegWrite),
	.iWB_NumRd(wWB_RegDestino),
	.iWB_RegWrite(wWB_RegWrite),
	.iWB_MemRead(wMEM_MemRead),
	.oFwdA(wFU_ForwardA),
	.oFwdB(wFU_ForwardB),
	.oFwdBranchRs(wFU_ForwardBranchRs),
	.oFwdBranchRt(wFU_ForwardBranchRt)
	);

// EX/MEM register write
always @(posedge iCLK or posedge iRST) begin
	if (iRST) begin
		RegEXMEM <= {NEXMEM{1'b0}};
	end
	else if (!iLock) begin
		RegEXMEM[ 31:  0] <= wEX_PC4;
		RegEXMEM[ 63: 32] <= wEX_ResultALU;
		RegEXMEM[ 95: 64] <= wEX_ResultForwardB;
		RegEXMEM[100: 96] <= wEX_RegDestino;
		RegEXMEM[    101] <= wEX_MemRead;
		RegEXMEM[    102] <= wEX_MemWrite;
		RegEXMEM[    103] <= wEX_SavePC;
		RegEXMEM[    104] <= wEX_RegWrite;
		RegEXMEM[107:105] <= wEX_LoadType;
		RegEXMEM[109:108] <= wEX_WriteType;
		
		RegEXMEM[    110] <= wEX_FPRegWrite;
		RegEXMEM[115:111]	<= wEX_FPRegDestino;
		RegEXMEM[147:116] <= wFPALUResult;
	end
end

//================ Estruturas do Estagio MEM - BEGIN ===================//

// EX/MEM register wires
wire [31:0] wMEM_PC4            = RegEXMEM[ 31:  0]; // PC+4 do EX/MEM
wire [31:0] wMEM_ResultALU      = RegEXMEM[ 63: 32]; // resultado na saida da ALU
wire [31:0] wMEM_ResultForwardB = RegEXMEM[ 95: 64]; // resultado do mux ForwardB
wire [ 4:0] wMEM_RegDestino     = RegEXMEM[100: 96]; // numero do registrador de destino 
wire        wMEM_MemRead        = RegEXMEM[    101];
wire        wMEM_MemWrite       = RegEXMEM[    102];
wire        wMEM_SavePC         = RegEXMEM[    103];
wire        wMEM_RegWrite       = RegEXMEM[    104];
wire [ 2:0] wMEM_LoadType       = RegEXMEM[107:105];
wire [ 1:0] wMEM_WriteType      = RegEXMEM[109:108];
wire        wMEM_FPRegWrite     = RegEXMEM[110];
wire [4:0]  wMEM_FPRegDestino   = RegEXMEM[115:111];
wire [31:0] wMEM_FPResultALU    = RegEXMEM[147:116];

// ResultMem mux
wire [31:0] wMEM_ResultMem = wMEM_MemRead ? iDataFromMem
                           : wMEM_SavePC ? wMEM_PC4 //+ 32'h4 // $ra = PC + 8 (branch delay)
                           : wMEM_ResultALU;

									
wire [31:0] wMEM_FPWriteData = wMEM_MemRead ? iDataFromMem : wMEM_FPResultALU;									
									
//assign oMemAddress   = wMEM_ResultALU;
//assign oMemWrite     = wMEM_MemWrite;
assign oLoadType     = wMEM_LoadType;
assign oWriteType    = wMEM_WriteType;
//assign oMemWriteData = wMEM_ResultForwardB;

// MEM/WB register write
always @(posedge iCLK or posedge iRST) begin
	if (iRST) begin
		RegMEMWB <= {NMEMWB{1'b0}};
	end
	else if (!iLock) begin
		RegMEMWB[31: 0] <= wMEM_ResultMem;
		RegMEMWB[36:32] <= wMEM_RegDestino;
		RegMEMWB[   37] <= wMEM_RegWrite;
		RegMEMWB[   38] <= wMEM_FPRegWrite;
		RegMEMWB[43:39] <= wMEM_FPRegDestino;
		RegMEMWB[75:44] <= wMEM_FPWriteData;
	end
end

// <<<< Barramento dados usa apenas o ByteEnasble
assign DwMemRead     = wMEM_MemRead;
assign DwMemWrite    = wMEM_MemWrite;
assign DwMemAddress 	= wMEM_ResultALU;

MemStore MemStore0 (
	.iAlignment(DwMemAddress[1:0]),
	.iWriteTypeF(wMEM_WriteType),
	.iOpcode(OPCDUMMY),
	.iData(wMEM_ResultForwardB),
	.oData(DwMemWriteData),
	.oByteEnable(DwByteEnable),
	.oException()
	);

wire [31:0] iDataFromMem;

MemLoad MemLoad0 (
	.iAlignment(DwMemAddress[1:0]),
	.iLoadTypeF(wMEM_LoadType),
	.iOpcode(OPCDUMMY),
	.iData(DwMemReadData),
	.oData(iDataFromMem),
	.oException()
	);

//================ Estruturas do Estagio WB - BEGIN ===================//

// MEM/WB register wires
wire [31:0] wWB_WriteData  	= RegMEMWB[31: 0]; // DataFromMem + ResultALU
wire [ 4:0] wWB_RegDestino 	= RegMEMWB[36:32]; // numero do registrador de destino 
wire        wWB_RegWrite   	= RegMEMWB[   37];
wire 			wWB_FPRegWrite 	= RegMEMWB[   38];
wire [4:0]  wWB_FPRegDestino 	= RegMEMWB[43:39];
wire [31:0] wWB_FPWriteData 	= RegMEMWB[75:44];        

endmodule
