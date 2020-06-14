
`include "uPowerISA_Core.v"

// uPowerISA test bench - To drive and simulate the entire MIPS ALU 
module uPower_testbench();

reg clk;

uPower_core lezgo(clk);

initial 
begin 
    clk = 1'b0;
    #800 $finish;
end

always begin 
    #10 clk = ~clk;
end

endmodule