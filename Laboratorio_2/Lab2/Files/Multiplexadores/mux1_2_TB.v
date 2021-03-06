module mux1_2_TB;

reg tb_dado0, tb_dado1, tb_sel;
wire tb_saida;

mux1_2a DUT(.sel(tb_sel), .dado0(tb_dado0), .dado1(tb_dado1), .saida(tb_saida));

initial
	begin
	
		tb_sel = 1'b0; tb_dado0 = 1'b0; tb_dado1 = 1'b0;
		$display("Sel = %x, Dado0 = %x, Dado1 = %x, Saida = %x", tb_sel, tb_dado0, tb_dado1, tb_saida);
	
		#10;
	
		tb_sel = 1'b0; tb_dado0 = 1'b0; tb_dado1 = 1'b1;
		$display("Sel = %x, Dado0 = %x, Dado1 = %x, Saida = %x", tb_sel, tb_dado0, tb_dado1, tb_saida);
	
		#10;
	
		tb_sel = 1'b0; tb_dado0 = 1'b1; tb_dado1 = 1'b0;
		$display("Sel = %x, Dado0 = %x, Dado1 = %x, Saida = %x", tb_sel, tb_dado0, tb_dado1, tb_saida);
	
		#10;
	
		tb_sel = 1'b0; tb_dado0 = 1'b1; tb_dado1 = 1'b1;
		$display("Sel = %x, Dado0 = %x, Dado1 = %x, Saida = %x", tb_sel, tb_dado0, tb_dado1, tb_saida);
	
		#10;
	
		tb_sel = 1'b1; tb_dado0 = 1'b0; tb_dado1 = 1'b0;
		$display("Sel = %x, Dado0 = %x, Dado1 = %x, Saida = %x", tb_sel, tb_dado0, tb_dado1, tb_saida);
	
		#10;
	
		tb_sel = 1'b1; tb_dado0 = 1'b0; tb_dado1 = 1'b1;
		$display("Sel = %x, Dado0 = %x, Dado1 = %x, Saida = %x", tb_sel, tb_dado0, tb_dado1, tb_saida);
	
		#10;
	
		tb_sel = 1'b1; tb_dado0 = 1'b1; tb_dado1 = 1'b0;
		$display("Sel = %x, Dado0 = %x, Dado1 = %x, Saida = %x", tb_sel, tb_dado0, tb_dado1, tb_saida);
	
		#10;
	
		tb_sel = 1'b1; tb_dado0 = 1'b1; tb_dado1 = 1'b1;
		$display("Sel = %x, Dado0 = %x, Dado1 = %x, Saida = %x", tb_sel, tb_dado0, tb_dado1, tb_saida);
		
		$finish;
	
	end
	endmodule
	