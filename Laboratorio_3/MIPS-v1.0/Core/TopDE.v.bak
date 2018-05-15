/* **************************************************** */
/* * Escolha o tipo de processador a ser implementado * */
`define UNICICLO
//`define MULTICICLO 
//`define PIPELINE //FPU esta incompleta

// Define se a FPU será sintetizada ou não
`define FPU

/*   ******************  Historico ***********************
 Top Level para processador MIPS UNICICLO v0 baseado no processador desenvolvido por
Alexandre Lins                          09/40097
Daniel Dutra                            09/08436
*Yuri Maia                              09/16803
em 2010/1 na disciplina OAC

 Top Level para processador MIPS UNICICLO v1 baseado no processador desenvolvido por
Emerson Grzeidak                        09/93514
Gabriel Calache Cozendey                09/47946
Glauco Medeiros Volpe                   10/25091
*Luiz Henrique Dias Navarro             10/00748
Waldez Azevedo Gomes Junior             10/08617
em 2011/1 na disciplina OAC

 Top Level para processador MIPS UNICICLO v2 baseado no processador desenvolvido por
*Antonio Martino Neto                   09/89886
Bruno de Matos Bertasso                 08/25590
Carolina S. R. de Oliveira              07/45006
Herman Ferreira M. de Asevedo           09/96319
Renata Cristina                         09/0130600
em 2011/2 na disciplina OAC

 Top Level para processador MIPS UNICICLO v3 baseado no processador desenvolvido por
Andre Franca                            10/0007457
Felipe Carvalho Gules                   08/29137
Filipe Tancredo Barros                  10/0029329
Guilherme Ferreira                      12/0051133
*Vitor Coimbra de Oliveira              10/0021832
em 2012/1 na disciplina OAC

 Top Level para processador MIPS UNICICLO v4 baseado no processador desenvolvido por
Alexandre Dantas                        10/0090788
Ciro Viana                              09/0137531
*Matheus Pimenta                        09/0125789
em 2013/1 na disciplina OAC

 Top Level para processador MIPS UNICICLO v6 baseado no processador desenvolvido por
Vitor de Alencastro Lacerda             11/0067142
*Hugo Luis Andrade Silva                12/0012987
em 2013/2 na disciplina OAC

Top Level para processador MIPS UNICICLO v7 baseado no processador desenvolvido por
*Thales Marques Ramos                   09/0133421
Daniel Magalhaes dos Santos             11/0113403
Gustavo Ribeiro Teixeira                09/0115791
Lorena Goncalves Miquett                10/0015581
Thales Moreira Vinkler                  10/0050638
Wilson Domingos Sidinei Alves Miranda   14/0053344
em 2014/1 na disciplina OAC

Top Level para processador MIPS MULTICICLO v0 baseado no processador desenvolvido por
David A. Patterson e John L. Hennessy
Computer Organization and Design
3a Edicao

Top Level para processador MIPS MULTICICLO v01 baseado no processador desenvolvido por
Alexandre Lins                          09/40097
Daniel Dutra                            09/08436
*Yuri Maia                              09/16803
em 2010/1 na disciplina OAC

 Top Level para processador MIPS UNICICLO v1 baseado no processador desenvolvido por
Emerson Grzeidak                        09/93514
Gabriel Calache Cozendey                09/47946
Glauco Medeiros Volpe                   10/25091
*Luiz Henrique Dias Navarro             10/00748
Waldez Azevedo Gomes Junior             10/08617
em 2011/1 na disciplina OAC

 Top Level para processador MIPS UNICICLO v2 baseado no processador desenvolvido por
*Antonio Martino Neto                   09/89886
Bruno de Matos Bertasso                 08/25590
Carolina S. R. de Oliveira              07/45006
Herman Ferreira M. de Asevedo           09/96319
Renata Cristina                         09/0130600
em 2011/2 na disciplina OAC

 Top Level para processador MIPS MULTICICLO v9 baseado no processador desenvolvido por
Andre Franca                            10/0007457
Felipe Carvalho Gules                   08/29137
Filipe Tancredo Barros                  10/0029329
Guilherme Ferreira                      12/0051133
*Vitor Coimbra de Oliveira              10/0021832
em 2012/1 na disciplina OAC

 Top Level para processador MIPS MULTICICLO v10 baseado no processador desenvolvido por
Alexandre Dantas                        10/0090788
Ciro Viana                              09/0137531
*Matheus Pimenta                        09/0125789
em 2013/1 na disciplina OAC

Top Level para processador MIPS PIPELINE v1 baseado no processador desenvolvido por
Andre Figueira Lourenco                 09/89525
Jose Chaves Junior                      08/40122
Hugo Marello                            10/29444
em 2010/2 na disciplina OAC

Top Level para processador MIPS PIPELINE v1.5 baseado no processador desenvolvido por
Emerson Grzeidak                        09/93514
Gabriel Calache Cozendey                09/47946
Glauco Medeiros Volpe                   10/25091
*Luiz Henrique Dias Navarro             10/00748
Waldez Azevedo Gomes Junior             10/08617
em 2011/1 na disciplina OAC

Top Level para processador MIPS PIPELINE v2 baseado no processador desenvolvido por
*Antonio Martino Neto                   09/89886
Bruno de Matos Bertasso                 08/25590
Carolina S. R. de Oliveira              07/45006
Herman Ferreira M. de Asevedo           09/96319
Renata Cristina                         09/0130600
em 2012/1 na disciplina OAC

Top Level para processador MIPS PIPELINE v3 baseado no processador desenvolvido por
Antonio Martino Neto                    09/89886
em 2013/1 na disciplina TG1

Top Level para processador MIPS PIPELINE v4 baseado no processador desenvolvido por
*Hugo Luis Andrade Silva                12/0012987
Leonardo de Oliveira Lourenco           13/0120197
*Thales Marques Ramos                   09/0133421
Daniel Magalhaes dos Santos             11/0113403
Marcus da Silva Ferreira                10/0056881
Wilson Domingos Sidinei Alves Miranda   11/0144201
em 2013/2 na disciplina OAC

 V8.2 Com eret para PC (calcular PC+4 no programa)
 v8.3 Arrumado todos os PARAMETROS, ULA nova
 v9 com RS232 e BootLoader baseado no processador desenvolvido por
Filipe Lima                             09/0113802
Sinayra Moreira                         10/0020666
Tulio Matias                            10/0055150
*Gabriel Naves                          12/0011867
Gabriel Sousa                           12/0060353
Icaro Mota                              12/0051389
em 2014/2 na disciplina OAC

Com sintetizador de áudio programável e MTHI/MTLO
*Maxwell M. Fernandes                   10/0116175
Túlio de Carvalho Matias                10/0055150
*Luiz Henrique Campos Barboza           09/0010256
*Diego Marques de Azevedo               11/0027876
Marcos de Moura Gonçalves               15/0093349
Yuri Barcellos Galli                    12/0024098
em 2015/1 na disciplina OAC

Com leitor de cartão SD
André Abreu R. de Almeida 					12/0007100
*Arthur de Matos Beggs 						12/0111098
Bruno Takashi Tengan 						12/0167263
Gabriel Pires Iduarte 						13/0142166
Guilherme Caetano 							13/0112925
João Pedro Franch 							12/0060795
Rafael Lima 									10/0131093
em 2016/1 na disciplina OAC


Com receptor IRDA, LFSR e STOPWATCH
*Eduardo Scartezini C. Carvalho 			14/0137084
Camila Ferreira Thé Pontes 				15/0156120 
Aurora Li Min de Freitas Wang 			13/0006408
Renato Estevam Nogueira 					13/0036579 
em 2016/2 na disciplina OAC


Com sintese da FPU no Pipeline (incompleto!), está sem floor e ceil
Cristiane Naves Cardoso						15/0008023
Gabriel Oliveira Taumaturgo				14/0140522
Matheus Eiji Endo								15/0018169
Rafael Cascardo Campos						14/0159401
*Rafael Lourenço de Lima Chehab			15/0045123
Yuri Ferreira Gomes							12/0043998
em 2017/1 na disciplina OAC

 Adaptado para a placa de desenvolvimento DE1-SoC.
 Prof. Marcus Vinicius Lamar   2018/1
 UnB - Universidade de Brasilia
 Dep. Ciencia da Computacao

 */
//`define ENABLE_HPS

module TopDE (
      ///////// ADC Analog-Digital Converter/////////
      inout              ADC_CS_N,
      output             ADC_DIN,
      input              ADC_DOUT,
      output             ADC_SCLK,

      ///////// AUD Audio Codec /////////
      input              AUD_ADCDAT,
      inout              AUD_ADCLRCK,
      inout              AUD_BCLK,
      output             AUD_DACDAT,
      inout              AUD_DACLRCK,
      output             AUD_XCK,

      ///////// CLOCK2 /////////
      input              CLOCK2_50,

      ///////// CLOCK3 /////////
      input              CLOCK3_50,

      ///////// CLOCK4 /////////
      input              CLOCK4_50,

      ///////// CLOCK /////////
      input              CLOCK_50,

      ///////// DRAM Syncronous Dynamic RAM/////////
      output      [12:0] DRAM_ADDR,
      output      [1:0]  DRAM_BA,
      output             DRAM_CAS_N,
      output             DRAM_CKE,
      output             DRAM_CLK,
      output             DRAM_CS_N,
      inout       [15:0] DRAM_DQ,
      output             DRAM_LDQM,
      output             DRAM_RAS_N,
      output             DRAM_UDQM,
      output             DRAM_WE_N,

      ///////// FAN /////////
      output             FAN_CTRL,

      ///////// FPGA I2C controler /////////
      output             FPGA_I2C_SCLK,
      inout              FPGA_I2C_SDAT,

      ///////// GPIO Generic Paralel I/O/////////
      inout     [35:0]         GPIO_0,
      inout     [35:0]         GPIO_1,
 

      ///////// HEX0 /////////
      output      [6:0]  HEX0,

      ///////// HEX1 /////////
      output      [6:0]  HEX1,

      ///////// HEX2 /////////
      output      [6:0]  HEX2,

      ///////// HEX3 /////////
      output      [6:0]  HEX3,

      ///////// HEX4 /////////
      output      [6:0]  HEX4,

      ///////// HEX5 /////////
      output      [6:0]  HEX5,

`ifdef ENABLE_HPS
      ///////// HPS - Hard Processor System  ARMv7/////////
      inout              HPS_CONV_USB_N,
      output      [14:0] HPS_DDR3_ADDR,
      output      [2:0]  HPS_DDR3_BA,
      output             HPS_DDR3_CAS_N,
      output             HPS_DDR3_CKE,
      output             HPS_DDR3_CK_N,
      output             HPS_DDR3_CK_P,
      output             HPS_DDR3_CS_N,
      output      [3:0]  HPS_DDR3_DM,
      inout       [31:0] HPS_DDR3_DQ,
      inout       [3:0]  HPS_DDR3_DQS_N,
      inout       [3:0]  HPS_DDR3_DQS_P,
      output             HPS_DDR3_ODT,
      output             HPS_DDR3_RAS_N,
      output             HPS_DDR3_RESET_N,
      input              HPS_DDR3_RZQ,
      output             HPS_DDR3_WE_N,
      output             HPS_ENET_GTX_CLK,
      inout              HPS_ENET_INT_N,
      output             HPS_ENET_MDC,
      inout              HPS_ENET_MDIO,
      input              HPS_ENET_RX_CLK,
      input       [3:0]  HPS_ENET_RX_DATA,
      input              HPS_ENET_RX_DV,
      output      [3:0]  HPS_ENET_TX_DATA,
      output             HPS_ENET_TX_EN,
      inout       [3:0]  HPS_FLASH_DATA,
      output             HPS_FLASH_DCLK,
      output             HPS_FLASH_NCSO,
      inout              HPS_GSENSOR_INT,
      inout              HPS_I2C1_SCLK,
      inout              HPS_I2C1_SDAT,
      inout              HPS_I2C2_SCLK,
      inout              HPS_I2C2_SDAT,
      inout              HPS_I2C_CONTROL,
      inout              HPS_KEY,
      inout              HPS_LED,
      inout              HPS_LTC_GPIO,
      output             HPS_SD_CLK,
      inout              HPS_SD_CMD,
      inout       [3:0]  HPS_SD_DATA,
      output             HPS_SPIM_CLK,
      input              HPS_SPIM_MISO,
      output             HPS_SPIM_MOSI,
      inout              HPS_SPIM_SS,
      input              HPS_UART_RX,
      output             HPS_UART_TX,
      input              HPS_USB_CLKOUT,
      inout       [7:0]  HPS_USB_DATA,
      input              HPS_USB_DIR,
      input              HPS_USB_NXT,
      output             HPS_USB_STP,
`endif /*ENABLE_HPS*/

      ///////// IRDA InfraRed Data Associaton /////////
      input              IRDA_RXD,
      output             IRDA_TXD,

      ///////// KEY Push-Bottom /////////
      input       [3:0]  KEY,

      ///////// LEDR  LED Red/////////
      output      [9:0]  LEDR,

      ///////// PS2 Interface /////////
      inout              PS2_CLK,
      inout              PS2_CLK2,
      inout              PS2_DAT,
      inout              PS2_DAT2,

      ///////// SW  Switches /////////
      input       [9:0]  SW,

      ///////// TD  TV Decoder /////////
      input              TD_CLK27,
      input      [7:0]  TD_DATA,
      input             TD_HS,
      output             TD_RESET_N,
      input             TD_VS,

      ///////// VGA Interface /////////
      output      [7:0]  VGA_B,
      output             VGA_BLANK_N,
      output             VGA_CLK,
      output      [7:0]  VGA_G,
      output             VGA_HS,
      output      [7:0]  VGA_R,
      output             VGA_SYNC_N,
      output             VGA_VS
		

	// Descomentar para simulacao em forma de onda do TopDE
    //output          Clock, Clock_25, Clock_100, Clock_200,
    //output  [31:0]  PC, Mem_Instrucao
    //output  [4:0]   RegDispSelect,
	 //output  [31:0]  RegDisp, RegDispFPU,
    //output  [7:0]   FlagsFPU,
    //output          Le_Mem, Esc_Mem,
    //output  [31:0]  ODAddress, ODWriteData, ODReadData,
	 //output  [31:0]  Mem_Dados,
    //output  [3:0]   ODByteEnable,
    //output  [31:0]  OIAddress, OIReadData,
    //output  [6:0]   Estado
    //output  [31:0]  BR_Leitura1, BR_Leitura2, BR_Escrita, Saida_ULA, Debug


);

	// Comentar para simulacao em forma de onda do TopDE
    wire          Clock, Clock_25, Clock_100, Clock_200;
    wire  [31:0]  PC, Mem_Instrucao;
    wire  [4:0]   RegDispSelect;
	 wire  [31:0]  RegDisp, RegDispFPU;
    wire  [7:0]   FlagsFPU;
    wire          Le_Mem, Esc_Mem;
    wire  [31:0]  ODAddress, ODWriteData, ODReadData;
	 wire  [31:0]  Mem_Dados;
    wire  [3:0]   ODByteEnable;
    wire  [31:0]  OIAddress, OIReadData;
    wire  [6:0]   Estado;
	 wire  [31:0]  BR_Leitura1, BR_Leitura2, BR_Escrita, Saida_ULA, Debug;


// Para simulacao de forma de onda <Nomes ajustados>
assign Clock            = CLK;
assign Clock_25			= oCLK_25;
assign Clock_100        = oCLK_100;
assign Clock_200        = oCLK_200;
assign PC             	= wPC;
assign Mem_Instrucao    = wInstr;
assign BR_Leitura1		= wBRReadA;
assign BR_Leitura2		= wBRReadB;
assign BR_Escrita			= wBRWrite;
assign Saida_ULA			= wULA;
assign RegDispSelect  	= wRegDispSelect;
assign RegDisp        	= wRegDisp;
assign RegDispFPU     	= wRegDispFPU;
assign FlagsFPU       	= flagBank;
assign Le_Mem     		= DReadEnable;
assign Esc_Mem    		= DWriteEnable;
assign ODAddress        = DAddress;
assign ODWriteData      = DWriteData;
assign Mem_Dados       	= DReadData;
assign ODByteEnable     = DByteEnable;
assign OIAddress        = IAddress;
assign OIReadData       = IReadData;
assign Estado    			= wControlState;
assign Debug  				= wDebug;



/* ********************* Gerador e gerenciador de Clock ********************* */
wire CLK, oCLK_50, oCLK_25, oCLK_100, oCLK_150, oCLK_200, oCLK_27, oCLK_18;
wire Reset, CLKSelectFast, CLKSelectAuto;

CLOCK_Interface CLOCK0(
	 .iCLK_50(CLOCK_50),						 // 50MHz
    .oCLK_50(oCLK_50),                  // 50MHz  <<  Que será usado em todos os dispositivos	 
    .oCLK_100(oCLK_100),                // 100MHz
	 .oCLK_150(oCLK_150),
    .oCLK_200(oCLK_200),                // 200MHz Usado no SignalTap II
	 .oCLK_25(oCLK_25),						// Usado na VGA
	 .oCLK_27(oCLK_27),
	 .oCLK_18(oCLK_18),						// Usado no Audio
    .CLK(CLK),                          // Clock da CPU
    .Reset(Reset),                      // Reset de todos os dispositivos
    .CLKSelectFast(CLKSelectFast),      // visualização
    .CLKSelectAuto(CLKSelectAuto),      // visualização
    .iKEY(KEY),                        // controles dos clocks e reset
    .fdiv({3'b0,SW[4:0]}),             // divisor da frequencia CLK = iCLK_50/fdiv
    .Timer(SW[5]),                   // Timmer de 10 segundos 
	 .iBreak(wbreak)							 // Break Point
);




/* LEDs sinais de controle */

assign LEDR[9:4]   = wControlState;
assign LEDR[3]		 = 1'b0;
assign LEDR[2]     = CLKSelectAuto;
assign LEDR[1]     = CLKSelectFast;
assign LEDR[0]     = CLK;

							 

//  Define o endereco inicial do PC
wire [31:0]  PCinicial;
assign PCinicial = (SW[6]? BEGINNING_BOOT : BEGINNING_TEXT);  // Controle do Boot


// Barramento de Dados
wire [31:0] DAddress, DWriteData;
wire [31:0] DReadData;
wire        DWriteEnable, DReadEnable;
wire [3:0]  DByteEnable;

// Barramento de Instrucoes
wire [31:0] IAddress, IWriteData;
wire [31:0] IReadData;
wire        IWriteEnable, IReadEnable;
wire [3:0]  IByteEnable;



// Interface Comum entre o processador e os mostradores
wire [4:0]  wRegDispSelect;
wire [31:0] wPC, wRegDisp, wRegDispCOP0, wInstr;
wire [31:0] wDebug;  // ligar no local desejado!
wire [31:0] wRegDispFPU;
wire [7:0]  flagBank;
wire [17:0] wSinaisControle;
wire [5:0]  wControlState;
wire [4:0]  wVGASelect;
wire [4:0]  wVGASelectFPU;
wire [31:0] wVGARead;
wire [31:0] wVGAReadFPU;
wire [31:0] wBRReadA,wBRReadB, wBRWrite, wULA;



/* ********************************* CPU ************************************ */
CPU CPU0 (
    .iCLK(CLK),             // Clock real do Processador
    .iCLK50(oCLK_50),       // Clock 50MHz fixo, usado so na FPU Uniciclo
    .iRST(Reset),
    .iInitialPC(PCinicial),

    // Sinais de monitoramento
    .wPC(wPC),
    .wInstr(wInstr),
    .wDebug(wDebug),
    .wRegDispSelect(wRegDispSelect),
    .wRegDisp(wRegDisp),
    .wRegDispFPU(wRegDispFPU),
    .wRegDispCOP0(wRegDispCOP0),
    .flagBank(flagBank),
    .wControlState(wControlState),
    .wControlSignals(wSinaisControle),
    .wVGASelect(wVGASelect),
    .wVGARead(wVGARead),
    .wVGASelectFPU(wVGASelectFPU),
    .wVGAReadFPU(wVGAReadFPU),
	 .wBRReadA(wBRReadA),
	 .wBRReadB(wBRReadB),
	 .wBRWrite(wBRWrite),
	 .wULA(wULA),
	 
    // Barramento Dados
    .DwReadEnable(DReadEnable), 
	 .DwWriteEnable(DWriteEnable),
    .DwByteEnable(DByteEnable),
    .DwAddress(DAddress), 
	 .DwWriteData(DWriteData),
	 .DwReadData(DReadData),

    // Barramento Instrucoes - Nao tem no multiciclo
    .IwReadEnable(IReadEnable), 
	 .IwWriteEnable(IWriteEnable),
    .IwByteEnable(IByteEnable),
    .IwAddress(IAddress), 
	 .IwWriteData(IWriteData), 
	 .IwReadData(IReadData),

    // Interrupcao
    .iPendingInterrupt(wPendingInterrupt)
);



/* ************************* Memoria RAM Interface ************************** */

`ifdef MULTICICLO // Multiciclo

Memory_Interface MEMORY(
    .iCLK(CLK), 
	 .iCLKMem(oCLK_50),
    // Barramento
    .wReadEnable(DReadEnable), 
	 .wWriteEnable(DWriteEnable),
    .wByteEnable(DByteEnable),
    .wAddress(DAddress), 
	 .wWriteData(DWriteData), 
	 .wReadData(DReadData)
    //Barramento do Sintetizador
    //.wAddressS(DAddressS), .wReadDataS(DReadDataS)
);
`endif

`ifndef MULTICICLO  // Uniciclo e Pipeline

DataMemory_Interface MEMDATA(
    .iCLK(CLK), 
	 .iCLKMem(oCLK_50),
    // Barramento de dados
    .wReadEnable(DReadEnable), 
	 .wWriteEnable(DWriteEnable),
    .wByteEnable(DByteEnable),
    .wAddress(DAddress), 
	 .wWriteData(DWriteData), 
	 .wReadData(DReadData)
    //Barramento do Sintetizador
    //.wAddressS(DAddressS), .wReadDataS(DReadDataS)
);

CodeMemory_Interface MEMCODE(
    .iCLK(CLK), 
	 .iCLKMem(oCLK_50),
    // Barramento de Instrucoes
    .wReadEnable(IReadEnable), 
	 .wWriteEnable(IWriteEnable),
    .wByteEnable(IByteEnable),
    .wAddress(IAddress), 
	 .wWriteData(IWriteData), 
	 .wReadData(IReadData)
);
`endif



/* ***************************** Interrupcoes ****************************** */
// feito no semestre 2013/1 para implementar a deteccao de excecoes (COP0)
wire [7:0] wPendingInterrupt;

assign wPendingInterrupt = {5'b0,
    (!reg_mouse_keyboard)&&(received_data_en_contador_enable) ,
    (audio_clock_flip_flop ^ audio_proc_clock_flip_flop),
    reg_mouse_keyboard&&(ps2_scan_ready_clock ^ keyboard_interrupt)&&0};



/* ********************* 7 Segment Displays Interface ********************** */
wire [31:0] wOutput;

assign wOutput = 	SW[9:8]==2'b11 ? wPC :
						SW[9:8]==2'b10 ? wInstr :
						SW[9:8]==2'b01 ? wDebug :
						SW[9:8]==2'b00 ? {24'b0,flagBank}: 32'b0;

Display7_Interface Display70   (	.HEX0_D(HEX0), 
											.HEX1_D(HEX1), 
											.HEX2_D(HEX2), 
											.HEX3_D(HEX3), 
											.HEX4_D(HEX4), 
											.HEX5_D(HEX5), 
											.Output(wOutput));


/* ***************************** VGA Interface ****************************** */
wire [4:0]  wVGASelectIn;
wire [31:0] wVGAReadIn;
assign wVGAReadIn       = SW[7] ? wVGAReadFPU : wVGARead;
assign wVGASelect       = wVGASelectIn;
assign wVGASelectFPU    = wVGASelectIn;

VGA_Interface VGA0 (
    .CLK(CLK), 
	 .iCLK_50(oCLK_50),
	 .iCLK2_50(CLOCK2_50), 
	 .iRST(Reset),
	 .oVGA_CLK(VGA_CLK),
    .oVGA_HS(VGA_HS), 
	 .oVGA_VS(VGA_VS), 
	 .oVGA_BLANK_N(VGA_BLANK_N), 
	 .oVGA_SYNC_N(VGA_SYNC_N),
    .oVGA_R(VGA_R), 
	 .oVGA_G(VGA_G), 
	 .oVGA_B(VGA_B),
    .oVGASelect(wVGASelectIn),
    .iVGARead(wVGAReadIn),
    .iDebugEnable(SW[9]),
    // Barramento
    .wReadEnable(DReadEnable), 
	 .wWriteEnable(DWriteEnable),
    .wByteEnable(DByteEnable),
    .wAddress(DAddress), 
	 .wWriteData(DWriteData), 
	 .wReadData(DReadData)
);



/* ************************* Audio CODEC Interface ************************** */
wire audio_clock_flip_flop, audio_proc_clock_flip_flop;

AudioCODEC_Interface Audio0 (
    .iCLK(CLK), 
	 .iCLK_50(oCLK_50),  
    .iCLK_18(oCLK_18),
	 .Reset(Reset),
    .oTD1_RESET_N(TD_RESET_N),
    .I2C_SDAT(FPGA_I2C_SDAT),
    .oI2C_SCLK(FPGA_I2C_SCLK),
    .AUD_ADCLRCK(AUD_ADCLRCK),
    .iAUD_ADCDAT(AUD_ADCDAT),
    .AUD_DACLRCK(AUD_DACLRCK),
    .oAUD_DACDAT(AUD_DACDAT),
    .AUD_BCLK(AUD_BCLK),
    .oAUD_XCK(AUD_XCK),
    // Para o sintetizador
    .wsaudio_outL(wsaudio_outL),
    .wsaudio_outR(wsaudio_outR),
    // Barramento
    .wReadEnable(DReadEnable), 
	 .wWriteEnable(DWriteEnable),
    .wByteEnable(DByteEnable),
    .wAddress(DAddress), 
	 .wWriteData(DWriteData), 
	 .wReadData(DReadData),
    // Interrupcao
    .audio_clock_flip_flop(audio_clock_flip_flop),
    .audio_proc_clock_flip_flop(audio_proc_clock_flip_flop)
);


/* ************************* Teclado PS2 Interface ************************** */
wire ps2_scan_ready_clock, keyboard_interrupt;

TecladoPS2_Interface TecladoPS20 (
    .iCLK(CLK), 
	 .iCLK_50(oCLK_50), 
	 .Reset(Reset),
    .PS2_KBCLK(PS2_CLK),
    .PS2_KBDAT(PS2_DAT),
    // Barramento
    .wReadEnable(DReadEnable), 
	 .wWriteEnable(DWriteEnable),
    .wByteEnable(DByteEnable),
    .wAddress(DAddress), 
	 .wWriteData(DWriteData), 
	 .wReadData(DReadData),
    //Interrupcao
    .ps2_scan_ready_clock(ps2_scan_ready_clock),
    .keyboard_interrupt(keyboard_interrupt)
);



/* ************************ Sintetizador Interface ************************* */
wire [15:0] wsaudio_outL, wsaudio_outR;
wire        DReadEnableS;
wire [31:0] DAddressS, DReadDataS;

Sintetizador_Interface Sintetizador0 (
    .iCLK(CLK), 
	 .iCLK_50(oCLK_50), 
	 .Reset(Reset),
    .AUD_DACLRCK(AUD_DACLRCK),
    .AUD_BCLK(AUD_BCLK),
    .wsaudio_outL(wsaudio_outL), 
	 .wsaudio_outR(wsaudio_outR),
    //  Barramento Principal
    .wReadEnable(DReadEnable), 
	 .wWriteEnable(DWriteEnable),
    .wByteEnable(DByteEnable),
    .wAddress(DAddress), 
	 .wWriteData(DWriteData), 
	 .wReadData(DReadData)
    //  Barramento do Sintetizador
    //.wAddressS(DAddressS), .wReadDataS(DReadDataS)
);


/* **************************** Mouse Interface ***************************** */
wire reg_mouse_keyboard, received_data_en_contador_enable;
//
MousePS2_Interface Mouse0 (
    .iCLK(CLK), 
	 .iCLK_50(oCLK_50), 
	 .Reset(Reset),
    .PS2_KBCLK(PS2_CLK),
    .PS2_KBDAT(PS2_DAT),
    //  Barramento
    .wReadEnable(DReadEnable), 
	 .wWriteEnable(DWriteEnable),
    .wByteEnable(DByteEnable),
    .wAddress(DAddress), 
	 .wWriteData(DWriteData), 
	 .wReadData(DReadData),
    // Interrupcao
    .reg_mouse_keyboard(reg_mouse_keyboard),
    .received_data_en_contador_enable(received_data_en_contador_enable)
);



/* **************************** IrDA Interface ***************************** */
// Relatorio questao B.10) - Grupo 2 - (2/2016)
IrDA_Interface  IrDA0 (
   .iCLK_50(oCLK_50), 
	.iCLK(CLK), 
	.Reset(Reset),
   .oIRDA_TXD(IRDA_TXD),    //    IrDA Transmitter
   .iIRDA_RXD(IRDA_RXD),    //    IrDA Receiver
    //  Barramento
    .wReadEnable(DReadEnable), 
	 .wWriteEnable(DWriteEnable),
    .wByteEnable(DByteEnable),
    .wAddress(DAddress), 
	 .wWriteData(DWriteData), 
	 .wReadData(DReadData)
);


// 1/2017
IrDA_decoder  IrDA_decoder0 (
   .iCLK_50(oCLK_50), 
	.iCLK(CLK), 
	.Reset(Reset),
   .iIRDA_RXD(IRDA_RXD),    //    IrDA Receiver
	
	.wAddress(DAddress),
	.oCode(DReadData),
	.wReadEnable(DReadEnable),
	.iselect(IRDAWORD)
);


/* **************************** StopWatch Interface ***************************** */
STOPWATCH_Interface  stopwatch0 (
   .iCLK_50(oCLK_50), 
	.iCLK(CLK),
    //  Barramento
    .wReadEnable(DReadEnable), 
	 .wWriteEnable(DWriteEnable),
    .wByteEnable(DByteEnable),
    .wAddress(DAddress), 
	 .wWriteData(DWriteData), 
	 .wReadData(DReadData)
);


/* **************************** LFSR Interface ***************************** */
lfsr_interface  lfsr0 (
	.iCLK_50(oCLK_50),
	//  Barramento
	.wReadEnable(DReadEnable), 
	.wAddress(DAddress), 
	.wReadData(DReadData)
);



/* **************************** Break Interface ***************************** */
wire wbreak;

Break_Interface  break0 (
   .iCLK_50(oCLK_50), 
	.iCLK(CLK), 
	.Reset(Reset),
   .oBreak(wbreak),
	.iKEY(KEY),
	.iPC(wPC),
    //  Barramento Dados
    .wReadEnable(DReadEnable), 
	 .wWriteEnable(DWriteEnable),
    .wByteEnable(DByteEnable),
    .wAddress(DAddress), 
	 .wWriteData(DWriteData), 
	 .wReadData(DReadData)
);


endmodule




