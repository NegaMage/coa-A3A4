`timescale 1ns/1ns
/* 
Module to read 32 bit mips instructions stored in instructions.mem
*/
module read_instructions (instruction, program_counter);

    input [31:0] program_counter;
    output reg [31:0] instruction;
	
    reg [31:0] instructions[1:0];  //hardcoded to number of instructions.
	
    initial begin 
        $readmemb("instructions.mem", instructions, 0, 1); 
    end
	
    always @ (program_counter) begin
        instruction = instructions[program_counter];
    end

endmodule

module read_instructions_tb();
    reg [31:0] program_counter;
    wire [31:0] instruction;

    read_instructions instructionReader(
        .program_counter(program_counter),
        .instruction(instruction)
    );

    initial begin

        //first instruction
        program_counter = 32'b0;
        #10;

        //second instruction
        program_counter = program_counter + 1;
        #10;
    end

    initial begin
        $dumpfile("read_instructions_tb.vcd");
        $dumpvars(0,read_instructions_tb);
    end
endmodule
