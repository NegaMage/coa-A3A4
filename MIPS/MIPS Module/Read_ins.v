/* Module to read instructions from instructions.mem, which stores the 32 bit mips instructions in binary.*/
module read_instructions(instruction, pc);

    input [31:0] pc;
    output reg [31:0] instruction;
	
    reg [31:0] instructions[2:0];  // there are two instructions in the file
	
    initial begin 
        $readmemb("instructions.mem", instructions, 0, 2); 
    end
	
    always @ (pc) begin
        instruction = instructions[pc];
    end

endmodule

