module mux1_2_v2_TB ();
 
  reg [1:0] a, b;
 
  function [1:0] mux;
    input [1:0] i_data;
    input [0:0] i_sel;
    begin
      mux = i_data[i_sel];
    end
  endfunction
 
  initial
    begin
		  b = 1'b0;
		  
        a = 2'b00;
        $display("Input = %x, Select = %x, Saida = %x", a, b, mux(a, b));
		  
		  #10;
		  
		  a = 2'b01;
		  $display("Input = %x, Select = %x, Saida = %x", a, b, mux(a, b));
		  
		  #10;
		  
		  a = 2'b10;
		  $display("Input = %x, Select = %x, Saida = %x", a, b, mux(a, b));
		  
		  #10;
		  
		  a = 2'b11;
		  $display("Input = %x, Select = %x, Saida = %x", a, b, mux(a, b));
		  
		  #10;
		  
        b = 1'b1;
		  
        a = 2'b00;
        $display("Input = %x, Select = %x, Saida = %x", a, b, mux(a, b));
		  
		  #10;
		  
		  a = 2'b01;
		  $display("Input = %x, Select = %x, Saida = %x", a, b, mux(a, b));
		  
		  #10;
		  
		  a = 2'b10;
		  $display("Input = %x, Select = %x, Saida = %x", a, b, mux(a, b));
		  
		  #10;
		  
		  a = 2'b11;
		  $display("Input = %x, Select = %x, Saida = %x", a, b, mux(a, b));
    end
endmodule