
`ifndef PARAM
	`include "Parametros.v"
`endif

`timescale 1 ns / 1 ps

module TopDE_tb;


reg iCLOCK;


always
	#10 iCLOCK = ~iCLOCK;	// T=10+10 Clock de 50MHz

	reg [9:0] iSW;
	reg [3:0] iKEY;
	wire [9:0] oLEDR;
	
   wire          oClock, oClock_25, oClock_100, oClock_200;
	wire  [31:0]  oPC, oMem_Instrucao;
	wire  [4:0]   oRegDispSelect;
	wire  [31:0]  oRegDisp, oRegDispFPU;
	wire  [7:0]   oFlagsFPU;
	wire          oLe_Mem, oEsc_Mem;
	wire  [31:0]  oODAddress, oODWriteData, oODReadData;
	wire  [31:0]  oMem_Dados;
	wire  [3:0]   oODByteEnable;
	wire  [31:0]  oOIAddress, oOIReadData;
	wire  [6:0]   oEstado;
	wire  [31:0]  oBR_Leitura1, oBR_Leitura2, oBR_Escrita, oSaida_ULA, oDebug;

TopDE top1 (
      ///////// ADC Analog-Digital Converter/////////
      .ADC_CS_N(),
      .ADC_DIN(),
      .ADC_DOUT(),
      .ADC_SCLK(),

      ///////// AUD Audio Codec /////////
      .AUD_ADCDAT(),
      .AUD_ADCLRCK(),
      .AUD_BCLK(),
      .AUD_DACDAT(),
      .AUD_DACLRCK(),
      .AUD_XCK(),

      ///////// CLOCK2 /////////
      .CLOCK2_50(iCLOCK),

      ///////// CLOCK3 /////////
      .CLOCK3_50(iCLOCK),

      ///////// CLOCK4 /////////
      .CLOCK4_50(iCLOCK),

      ///////// CLOCK /////////
      .CLOCK_50(iCLOCK),

      ///////// DRAM Syncronous Dynamic RAM/////////
      .DRAM_ADDR(),
      .DRAM_BA(),
      .DRAM_CAS_N(),
      .DRAM_CKE(),
      .DRAM_CLK(),
      .DRAM_CS_N(),
      .DRAM_DQ(),
      .DRAM_LDQM(),
      .DRAM_RAS_N(),
      .DRAM_UDQM(),
      .DRAM_WE_N(),

      ///////// FAN /////////
      .FAN_CTRL(),

      ///////// FPGA I2C controler /////////
      .FPGA_I2C_SCLK(),
      .FPGA_I2C_SDAT(),

      ///////// GPIO Generic Paralel I/O/////////
      .GPIO_0(),
      .GPIO_1(),

      ///////// HEX0 /////////
      .HEX0(),

      ///////// HEX1 /////////
      .HEX1(),

      ///////// HEX2 /////////
      .HEX2(),

      ///////// HEX3 /////////
      .HEX3(),

      ///////// HEX4 /////////
      .HEX4(),

      ///////// HEX5 /////////
      .HEX5(),

      ///////// IRDA InfraRed Data Associaton /////////
		.IRDA_RXD(),
      .IRDA_TXD(),

      ///////// KEY Push-Bottom /////////
      .KEY(iKEY),

      ///////// LEDR  LED Red/////////
      .LEDR(oLEDR),

      ///////// PS2 Interface /////////
      .PS2_CLK(),
      .PS2_CLK2(),
      .PS2_DAT(),
      .PS2_DAT2(),

      ///////// SW  Switches /////////
      .SW(iSW),

      ///////// TD  TV Decoder /////////
      .TD_CLK27(),
      .TD_DATA(),
      .TD_HS(),
      .TD_RESET_N(),
      .TD_VS(),

      ///////// VGA Interface /////////
      .VGA_B(),
      .VGA_BLANK_N(),
      .VGA_CLK(),
      .VGA_G(),
      .VGA_HS(),
      .VGA_R(),
      .VGA_SYNC_N(),
      .VGA_VS(),

		.Clock(oClock), .Clock_25(oClock_25), .Clock_100(oClock_100), .Clock_200(oClock_200),
		.PC(oPC), 
		.Mem_Instrucao(oMem_Instrucao),
		.RegDispSelect(oRegDispSelect),
		.RegDisp(oRegDisp), 
		.RegDispFPU(oRegDispFPU),
		.FlagsFPU(oFlagsFPU),
		.Le_Mem(oLe_Mem),
		.Esc_Mem(oEsc_Mem),
		.ODAddress(oODAddress), 
		.ODWriteData(oODWriteData), 
		.ODReadData(oODReadData),
		.Mem_Dados(oMem_Dados),
		.ODByteEnable(oODByteEnable),
		.OIAddress(oOIAddress), 
		.OIReadData(oOIReadData),
		.Estado(oEstado),
		.BR_Leitura1(oBR_Leitura1), 
		.BR_Leitura2(oBR_Leitura2), 
		.BR_Escrita(oBR_Escrita),
		.Saida_ULA(oSaida_ULA), 
		.Debug(oDebug)

);	
	
	


	
initial
	begin
	
		$display($time, " << Início da Simulação >> ");
		iCLOCK=1'b0;
		iSW=10'b0000000000;
		iKEY=4'b1111;
	
		#100
		iKEY=4'b1001;
		
		#200
		iKEY=4'b1111;
		
		#200
		$display($time, "<< Final da Simulação >>");
		$stop;
	end

	
initial
	begin			
		$display("time\tPC\tInstr"); 
		$monitor("%d\t%h\t%h",$time,oPC,oMem_Instrucao);	
	
	end


endmodule
