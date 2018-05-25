/*
 * Caminho de dados processador Uniciclo
 *
 */

module Datapath_UNI (
    // Inputs e clocks
    input  wire        iCLK, iCLK50, iRST,
    input  wire [31:0] iInitialPC,

    // Para monitoramento
    output wire [31:0] wPC, woInstr,
    output wire [31:0] wRegDisp, wRegDispCOP0,
    input  wire [4:0]  wRegDispSelect,
    output wire [31:0] wDebug,
	 
    input       [4:0]  wVGASelect,
    output      [31:0] wVGARead,

    output wire        wCRegWrite, wCOrigALU,
    output wire [1:0]  wCALUOp,
    output wire [2:0]  wCOrigPC,
    output wire [2:0]  wCMem2Reg,
	 
	 output wire [31:0] wBRReadA,
	 output wire [31:0] wBRReadB,
	 output wire [31:0] wBRWrite,
	 output wire [31:0] wULA,	 


    //  Barramento de Dados
    output             DwReadEnable, DwWriteEnable,
    output      [3:0]  DwByteEnable,
    output      [31:0] DwAddress, DwWriteData,
    input       [31:0] DwReadData,

    // Barramento de Instrucoes
    output             IwReadEnable, IwWriteEnable,
    output      [3:0]  IwByteEnable,
    output      [31:0] IwAddress, IwWriteData,
    input       [31:0] IwReadData,

    input [7:0] iPendingInterrupt                           // feito no semestre 2013/1 para implementar a deteccao de excecoes (COP0)
    );


assign DwReadEnable     = wCMemRead;
assign DwWriteEnable    = wCMemWrite;

assign wBRReadA		= wRead1;
assign wBRReadB		= wRead2;
assign wBRWrite		= wDataReg;
assign wULA				= wALUresult;

/* Padrao de nomenclatura
 *
 * XXXXX - registrador XXXX
 * wXXXX - wire XXXX
 * wCXXX - wire do sinal de controle XXX
 * memXX - memoria XXXX
 * Xunit - unidade funcional X
 * iXXXX - sinal de entrada/input
 * oXXXX - sinal de saida/output
 */

reg  [31:0] PC, PCgambs;                                    // registrador do PC
wire [31:0] wPC4;
wire [31:0] wiPC;
wire [31:0] wInstr;
wire [31:0] wMemDataWrite;
wire [4:0]  wAddrRs1, wAddrRs2, wAddrRd, wRegDs2;     // enderecos dos reg rs,rt ,rd e saida do Mux regDs2
wire [31:0] wOrigALU;
wire        wZero;
wire [1:0]  WBranchPC;
wire [4:0]  wALUControl;
wire [31:0] wALUresult, wRead1, wRead2, wMemAccess;
wire [31:0] wReadData;
wire [31:0] wDataReg;
wire [31:0] wImm;
wire [31:0] wJumpAddr;
wire        wCMemRead, wCMemWrite;
wire [6:0]  wOpcode, wFunct7;
wire [2:0]  wFunct3;

//Semestre 2014/2 para implementacao do bootloader
//wire        wCodeMemoryWrite;

/* Inicializacao */
initial
begin
    PC         <= BEGINNING_TEXT;
    PCgambs    <= BEGINNING_TEXT;
end

assign wPC4         = wPC + 32'h4;              	/* Calculo PC+4 */
assign wJumpAddr    = wPC + {wImm[30:0],1'b0};   	/* Endereco do Jump/branch */
assign wPC          = PC;
assign wOpcode      = wInstr[6:0];
assign wAddrRs1     = wInstr[19:15];
assign wAddrRs2     = wInstr[24:20];
assign wAddrRd      = wInstr[11:7];
assign wFunct7      = wInstr[31:25];
assign wFunct3		= wInstr[14:12];

assign woInstr      = wInstr;
assign wCodeMemoryWrite     = ((PC >= BEGINNING_BOOT && PC <= END_BOOT) ? 1'b1 : 1'b0);

/* Assigns para debug */
assign wDebug   = 32'h00BEBAD0;//005AD1C0//00F1A5C0//0ACEF0DA;

/*Assigns FPU
assign wFmt                 = wInstr[25:21];
assign wAddrFt              = wInstr[20:16];
assign wAddrFs              = wInstr[15:11];
assign wAddrFd              = wInstr[10:6];
assign wFlagSelector        = wInstr[10:8];
assign wBranchFlagSelector  = wInstr[20:18];
assign wBranchC1            = wInstr[16];
assign wSelectedFlagValue   = wFPUFlagBank[wBranchFlagSelector];*/


/* Barramento da Memoria de Instrucoes */
assign    IwReadEnable      = ON;
assign    IwWriteEnable     = wCodeMemoryWrite;
assign    IwByteEnable      = wMemEnable;
assign    IwAddress         = wPC;
assign    IwWriteData       = ZERO;
assign    wInstr            = IwReadData;


/* Banco de Registradores */
Registers RegsUNI (
    .iCLK(iCLK),
    .iCLR(iRST),
    .iReadRegister1(wAddrRs1),
    .iReadRegister2(wAddrRs2),
    .iWriteRegister(wAddrRd),
    .iWriteData(wDataReg),
    .iRegWrite(wCRegWrite),
    .oReadData1(wRead1),
    .oReadData2(wRead2),
    .iRegDispSelect(wRegDispSelect),    // seleção para display
    .oRegDisp(wRegDisp),                // Reg display
    .iVGASelect(wVGASelect),            // para mostrar Regs na tela
    .oVGARead(wVGARead)                 // para mostrar Regs na tela
	);

`ifdef FPU
/*Banco de Registradores FPU
FPURegisters memRegFPU(
    .iCLK(iCLK),
    .iCLR(iRST),
    .iReadRegister1(wAddrFs),
    .iReadRegister2(wAddrFt),
    .iWriteRegister(wRegDstFPU),
    .iWriteData(wDataRegFPU),
    .iRegWrite(wCRegWriteFPU),
    .oReadData1(wRead1FPU),
    .oReadData2(wRead2FPU),
    .iRegDispSelect(wRegDispSelect),    // para mostrar Regs no display
    .oRegDisp(wRegDispFPU),             // para mostrar Regs no display
    .iVGASelect(wVGASelectFPU),         // para mostrar Regs na tela
    .oVGARead(wVGAReadFPU)              // para mostrar Regs na tela
	); 
	
/* FP ALU Control
FPALUControl FPALUControlUnit (
    .iFunct(wFunct),
    .oControlSignal(wFPALUControl)
);

/*ULA FPU
ula_fp FPALUunit (
    .iclock(iCLK50),
    .idataa(wRead1FPU),
    .idatab(wRead2FPU),
    .icontrol(wFPALUControl),
    .oresult(wFPALUresult),
    .onan(wNanFPU),
    .ozero(wZeroFPU),
    .ounderflow(wUnderflowFPU),
    .oCompResult(wCompResult)
	);

/* Banco de flags da FPU
FlagBank FlagBankModule(
    .iCLK(iCLK),
    .iCLR(iRST),
    .iFlag(wFlagSelector),
    .iFlagWrite(wCFPFlagWrite),
    .iData(wCompResult),
    .oFlags(wFPUFlagBank)
	);
`endif */

/* Geração de imediato */
ImmGen ImmGen0 (
	.iInstr(wInstr)
	.oImmResult(wImm)
	);

/* ALU CTRL */
ALUControl ALUControlunit (
    .iFunct7(wFunct7), //funct alterado 18/1
	 .iFunct3(wFunct3),		//riscv
    .iALUOp(wCALUOp),
    .iOpcb6(wOpcode[6]),
    .oControlSignal(wALUControl)
	);

/* ALU */
ALU ALUunit(
    //.iCLK(iCLK),
    //.iRST(iRST),
    .iControlSignal(wALUControl),
    .iA(wRead1),
    .iB(wOrigALU),
    .oALUresult(wALUresult),
    .oZero(wZero),
	);

MemStore MemStore0 (
    .iAlignment(wALUresult[1:0]),
    .iWriteTypeF(STORE_TYPE_DUMMY),
    .iOpcode(wOpcode),
    .iData(wRead2),
    .oData(wMemStore),
    .oByteEnable(wMemEnableStore),
    .oException()
	);

/* Barramento da memoria de dados */
assign DwReadEnable     = wCMemRead;
assign DwWriteEnable    = wCMemWrite;
assign DwByteEnable     = wMemEnable;
assign DwWriteData      = wMemDataWrite;
assign wReadData        = DwReadData;
assign DwAddress        = wALUresult;

MemLoad MemLoad0 (
    .iAlignment(wALUresult[1:0]),
    .iLoadTypeF(LOAD_TYPE_DUMMY),
    .iOpcode(wOpcode),
    .iData(wReadData),
    .oData(wMemAccess),
    .oException()
	);

/* Unidade de Controle */
Control_UNI CtrUNI (
    .iCLK(iCLK),
    .iOp(wOpcode),
    /*.iFunct(wFunct),
    .iFmt(wFmt),
    .iBranchC1(wBranchC1),
    .oRegDst(wCRegDst), */
    .oOrigALU(wCOrigALU),
    .oMemparaReg(wCMem2Reg),
    .oEscreveReg(wCRegWrite),
    .oLeMem(wCMemRead),
    .oEscreveMem(wCMemWrite),
    .oOpALU(wCALUOp),
    .oOrigPC(wCOrigPC),
    /*.oEscreveRegFPU(wCRegWriteFPU),
    .oRegDstFPU(wCRegDstFPU),
    .oFPUparaMem(wCFPUparaMem),
    .oDataRegFPU(wCDataRegFPU),
    .oFPFlagWrite(wCFPFlagWrite),
    // feito no semestre 2013/1 para implementar a deteccao de excecoes (COP0)
    .iExcLevel(wCOP0ExcLevel),
    .iFPALUOverflow(wOverflowFPU),
    .iFPALUUnderflow(wUnderflowFPU),
    .iFPALUNaN(wNanFPU),
    .iUserMode(wCOP0UserMode),    // para detectar instrucoes reservadas
    .iPendingInterrupt(wCOP0InterruptMask),
    .oEscreveRegCOP0(wCRegWriteCOP0),
    .oEretCOP0(wCEretCOP0),
    .oExcOccurredCOP0(wCExcOccurredCOP0),
    .oBranchDelayCOP0(wCBranchDelayCOP0),
    .oExcCodeCOP0(wCExcCodeCOP0),
    .iRt(wAddrRt)*/                       // 1/2016, Implementar intruções bgez, bgezal, bgltz, bltzal.
	);

// feito no semestre 2013/1 para implementar a deteccao de excecoes (COP0)
/* Banco de registradores do Coprocessador 0 
COP0RegistersUNI cop0reg (
    .iCLK(iCLK),
    .iCLR(iRST),

    // register file interface
    .iReadRegister(wAddrRd),
    .iWriteRegister(wAddrRd),
    .iWriteData(wDataRegCOP0),
    .iRegWrite(wCRegWriteCOP0),
    .oReadData(wCOP0ReadData),

    // eret interface
    .iEret(wCEretCOP0),

    // COP0 interface
    .iExcOccurred(wCExcOccurredCOP0),
    .iBranchDelay(wCBranchDelayCOP0),
    .iPendingInterrupt(iPendingInterrupt),
    .iExcCode(wCExcCodeCOP0),
    .oInterruptMask(wCOP0InterruptMask),
    .oUserMode(wCOP0UserMode),
    .oExcLevel(wCOP0ExcLevel),

    // DE2-70 interface
    .iRegDispSelect(wRegDispSelect),
    .oRegDisp(wRegDispCOP0)
	);
*/


/*Decide o que entrara na segunda entrada da ULA*/
always @(*)
    case(wCOrigALU)
        1'b0:		wOrigALU <= wRead2;   
        1'b1:		wOrigALU <= wImm;    
		  default:	wOrigALU <= 5'bx;
    endcase


/*Decide qual sera o proximo PC*/
always @(*)
begin
    case(wCOrigPC)
        3'b001:
        begin
            case (wFunct3)
                3'b000:     // beq
                begin  
                    if (wZero)          wiPC <= wJumpAddr;
                    else                wiPC <= wPC4;
                end

                3'b001:     // bne
                begin
                    if (~wZero)         wiPC <= wJumpAddr;
                    else                wiPC <= wPC4;
                end

                3'b100,     // blt
                3'b101,     // bge
                3'b110,     // bltu
                3'b111:     // bgeu
                begin
                    if (wALUresult[0])  wiPC <= wJumpAddr;
                    else                wiPC <= wPC4;
                end

                default:
                    wiPC <= wPC4;
            endcase
        end

        3'b010:             // jalr - endereço esta na ULA
            wiPC <= wALUresult;
        
        3'b011:             // jal
            wiPC <= wJumpAddr;
        
        default:            // qualquer outra instruçao
            wiPC <= wPC4;
    endcase
end

/*Decide o que sera escrito no banco de registradores*/
always @(*)
    case(wCMem2Reg)
        3'b000:     wDataReg <= wALUresult;
        3'b001:     wDataReg <= wMemAccess; 	// ler da memória
        3'b010:	  wDataReg <= wJumpAddr;	// auipc
		  3'b011:     wDataReg <= wPC4;
        default:    wDataReg <= 32'b0;
    endcase


/*Decide em qual registrador sera escrito o dado na FPU
always @(*)
    case(wCRegDstFPU)
        2'b00:      wRegDstFPU <= wAddrFd;
        2'b01:      wRegDstFPU <= wAddrFs;
        2'b10:      wRegDstFPU <= wAddrFt;
        default:    wRegDstFPU <= 5'b0;
    endcase


Decide o que sera escrito no banco de registradores da FPU
wire [31:0] wx1;
assign wx1 = (wReadData==32'hzzzzzzzz ? 32'h00000000 : wReadData);
always @(*)
    case(wCDataRegFPU)
        2'b00:      wDataRegFPU <= wFPALUresult;
        2'b01:      wDataRegFPU <= wx1;
        2'b10:      wDataRegFPU <= wRead2;
        2'b11:      wDataRegFPU <= wRead1FPU;
        default:    wDataRegFPU <= 5'bx;
    endcase
*/

/*Decide o que sera escrito na Memoria de Dados*/
assign wMemDataWrite        = wMemStore;
assign wMemEnable           = wMemEnableStore;

always @(*) // mecanismo anterior do case(wCFPUparaMem) simplificado
    if (wOpcode == 1'b0100011)  // sb, sh ou sw
    begin
        wMemDataWrite       <= wMemStore;
        wMemEnable          <= wMemEnableStore;
    end
    else
    begin
        wMemDataWrite       <= wRead2;
        wMemEnable          <= 4'b1111;
    end
/*
always @(*)
    case(wCFPUparaMem)
        2'b00:                                          // Nao deve estar mais sendo usado para sw
           begin
            wMemDataWrite   <= wRead2;
            wMemEnable      <= 4'b1111;
           end
        2'b01:
           begin
            wMemDataWrite   <= wRead2FPU;
            wMemEnable      <= 4'b1111;
           end
        2'b10:
           begin
            wMemDataWrite   <= wMemStore;
            wMemEnable      <= wMemEnableStore;
           end
        default:
           begin
            wMemDataWrite   <= 32'b0;
            wMemEnable      <= 4'b1111;
           end
    endcase
*/
// feito no semestre 2013/1 para implementar a deteccao de excecoes (COP0)
/* Decide o que sera escrito no banco de registradores do Coprocessador 0 
always @(*)
    case(wCExcOccurredCOP0)
        1'b0:   wDataRegCOP0 <= wRead2;
        1'b1:   wDataRegCOP0 <= PCgambs - 4;   //////  VERIFICAR SE -4 ESTA CORRETO PARA FICAR IGUAL AO MARS
		  default: wDataRegCOP0 <= 32'bx;
    endcase
*/


/* Para cada ciclo de Clock */
always @(posedge iCLK or posedge iRST)
begin
    if(iRST)
    begin
        PC      <= iInitialPC;
        PCgambs <= iInitialPC;
    end
    else begin
        PC 	<= wiPC;
        //if (~wCExcOccurredCOP0)
            PCgambs <= wiPC;
    end
end

endmodule
