`timescale 1ns/1ns
/* 
Module to read instructions from instructions.mem, which stores the 32 bit mips instructions in binary.
*/
module read_instructions(instruction, pc);

    input [31:0] pc;
    output reg [31:0] instruction;
	
    reg [31:0] instructions [2:0]; //hardcoded to the number of instructions in the file
	
    initial begin 
        $readmemb("instructions.mem", instructions, 0, 2); 
    end
	
    always @ (pc) begin
        instruction = instructions[pc];
    end

endmodule

module read_instructions_tb();
    reg [31:0] pc;
    wire [31:0] instruction;

    read_instructions instructionReader(
        .pc(pc),
        .instruction(instruction)
    );

    initial begin

        //first instruction
        pc = 32'b0;
        #10;

        //second instruction
        pc = pc + 1;
        #10;

        //third instruction
        pc = pc + 1;
        #10;
    end

    initial begin
        $dumpfile("read_instructions_tb.vcd");
        $dumpvars(0,read_instructions_tb);
    end
endmodule
