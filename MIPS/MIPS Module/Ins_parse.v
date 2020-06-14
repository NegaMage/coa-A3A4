/* 
Module designed to read the instruction and assign the various components of the instruction to suitable variables depending on the format
*/
module ins_parser(
    output wire [5:0] opcode,
    output reg [4:0] rs, rt, rd, shamt, 
    output reg [5:0] funct,
    output reg[15:0] imm,
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
        imm = 16'd0;
        address = 26'd0;

        if(opcode == 6'h0) 
        begin        //R-type 
            shamt = instruction[10:6];
            rd = instruction[15:11];
            rt = instruction[20:16];
            rs = instruction[25:21];
            funct = instruction[5:0];
        end
        else if(opcode == 6'h2 | opcode == 6'h3) 
        begin   // J-type
            address = instruction[25:0];
        end
        else 
        begin                               // I-type
            rt = instruction[20:16];
            rs = instruction[25:21];
            imm = instruction[15:0];
        end
    end
endmodule