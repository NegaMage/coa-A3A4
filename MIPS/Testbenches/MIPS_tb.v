// MIPS test bench - To drive and simulate the entire MIPS ALU 
`include "MIPS_core.v"
module mips_testbench ();

    reg clock;
    wire result;
	
    mips_core test(clock);

    initial clock = 0;

    initial 
    begin 
        #100 clock=~clock; #100 clock=~clock;
        #100 clock=~clock; #100 clock=~clock;
        #100 clock=~clock; #100 clock=~clock;
        #100 clock=~clock; #100 clock=~clock;
        #100 clock=~clock; #100 clock=~clock;
        #100 clock=~clock; #100 clock=~clock;
        #100 clock=~clock; #100 clock=~clock;
        #100 clock=~clock; #100 clock=~clock;
        #100 clock=~clock; #100 clock=~clock;
    end

initial begin
  $dumpfile("mips_testbench.vcd"); 
  $dumpvars(0, mips_testbench);
end

endmodule