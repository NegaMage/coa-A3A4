/* 
Module to read 32 bit mips instructions stored in instructions.mem
*/
module instr_reader (instruction, pc);

    input [31:0] pc;
    output reg [31:0] instruction;
	
    reg [31:0] instructions[1:0];  //hardcoded to number of instructions.
	
    initial begin 
        $readmemb("instructions.mem", instructions, 0, 1); 
    end
	
    always @ (pc) begin
        instruction = instructions[pc];
    end

endmodule

