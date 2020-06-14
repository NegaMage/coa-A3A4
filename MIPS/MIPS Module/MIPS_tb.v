// MIPS test bench - To drive and simulate the entire MIPS ALU 
`include "MIPS_main.v"
module tb_MIPS_core ();

    reg clk;
	
    MIPS_main mips(.clock(clk));

    initial 
    begin 
        clk = 1'b0;
        #600 $finish;
    end

    always begin 
        #100 clk = ~clk;
    end

endmodule