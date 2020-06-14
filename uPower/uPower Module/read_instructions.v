/* 
Module to read 32 bit mips instructions stored in instructions.mem
*/

module instr_reader(instruction, pc);

    input [31:0] pc;
    output reg [31:0] instruction;

    reg [31:0] instructions[5:0];     //set to the number of instructions in the file

    initial begin
        $readmemb("instructions.mem", instructions, 0, 5);
    end

    always @ (pc) begin
        instruction = instructions[pc];
        $display("Instruction : %32b \n PC : %32b\n", instruction, pc);
    end

endmodule