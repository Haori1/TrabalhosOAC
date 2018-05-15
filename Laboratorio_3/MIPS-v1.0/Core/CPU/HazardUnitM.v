/*
 * Unidade de Deteccao de Hazard
 */
 module HazardUnitM (
	input [4:0] iID_NumRs, iID_NumRt, iEX_NumRt, iEX_RegDst, iMEM_RegDst,
	input iEX_MemRead, iEX_RegWrite, iMEM_MemRead, iMEM_RegWrite, iCJr, iBranch,
	output oHazard, oForwardJr, oForwardPC4
);
	
	wire wEX_RegHazard  = (iEX_RegDst == iID_NumRs) || (iEX_RegDst == iID_NumRt);
	wire wMEM_RegHazard = (iMEM_RegDst == iID_NumRs) || (iMEM_RegDst == iID_NumRt);
	
	wire wEX_Hazard  = (iEX_MemRead || iBranch) && iEX_RegWrite && (iEX_RegDst != 5'b0) && wEX_RegHazard;
	wire wMEM_Hazard = iBranch && iMEM_MemRead && iMEM_RegWrite && (iMEM_RegDst != 5'b0) && wMEM_RegHazard;
	
	assign oHazard = (wEX_Hazard || wMEM_Hazard) ? 1'b1 : 1'b0;
	
	assign oForwardJr = ((iCJr) && (iEX_RegDst == iID_NumRs)) ? 1'b1 : 1'b0;
	
	assign oForwardPC4 = ((iCJr) && (iMEM_RegDst == 5'd31)) ? 1'b1 : 1'b0;
	
endmodule
