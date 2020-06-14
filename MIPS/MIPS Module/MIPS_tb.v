// MIPS test bench - To drive and simulate the entire MIPS ALU 
`include "MIPS_core.v"
module tb_MIPS_core ();

    reg clk;
	
    MIPS_core test(.clock(clk));

    initial 
    begin 
        clk = 1'b0;
        #600 $finish;
    end

    always begin 
        #100 clk = ~clk;
    end

    // always @(clk) begin
    //     $display("Clock : %1b", clk);
    // end

endmodule