/* 
Module to take in a 32 bit wide mips instruction and split into relevant fields for sending to other modules.
*/
module instruction_parser(
    output wire [5:0] opcode,
    output reg [4:0] rs, rt, rd, shamt, 
    output reg [5:0] funct,
    output reg[15:0] immediate,
    output reg [25:0] address,
    input [31:0] instruction, p_count
);

    assign opcode = instruction[31:26];
	
    always @(instruction) begin

        rs = 5'd0;
        rt = 5'd0;
        rd = 5'd0;
        shamt = 5'd0;
        funct = 6'd0;
        immediate = 16'd0;
        address = 26'd0;

        if(opcode == 6'h0) 
        begin        //R-type 
            shamt = instruction[10:6];
            rd = instruction[15:11];
            rt = instruction[20:16];
            rs = instruction[25:21];
            funct = instruction[5:0];
            // $display("shamt : %5b--- rd : %5b --- rt : %5b --- rs : %5b --- funct : %6b, PC: %32b", shamt, rd, rt, rs, funct, p_count);
        end
        else if(opcode == 6'h2 | opcode == 6'h3) 
        begin   // J-type
            address = instruction[25:0];
        end
        else 
        begin                               // I-type
            rt = instruction[20:16];
            rs = instruction[25:21];
            immediate = instruction[15:0];
        end
    end
	
endmodule