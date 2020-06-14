/* Module designed to read the instruction and assign the various
   components of the instruction to suitable variables depending on the format
*/
module ins_parser(
    output wire [5:0] opcode,
    output reg [4:0] rs, rt, rd, shamt, 
    output reg [5:0] funct,
    output reg[15:0] immediate,
    output reg [25:0] address,
    input [31:0] instruction, p_count
);

    assign opcode = instruction[31:26];
	
    always @(instruction) begin

        rs = 5'b00000;
        rt = 5'b00000;
        rd = 5'b00000;
        shamt = 5'b00000;
        funct = 6'b000000;
        immediate = 16'b0000000000000000;
        address = 26'b00000000000000000000000000;

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