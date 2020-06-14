<<<<<<< Updated upstream
/*
Module for converting a 32 bit mips instruction into the separate parts that can be sent to different modules. For ease of coding it generates all possible parts of the instruction, regardless of whether they'll be used.
=======
/* 
Module for converting a 32 bit mips instruction into the separate parts that can be sent to different modules. It generates all possible parts of the instruction, regardless of whether they'll be used.
>>>>>>> Stashed changes
*/
module ins_parser(
    output rwire [5:0] opcode,
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

<<<<<<< Updated upstream
        if(opcode == 6'h0)
        begin        //R-type
=======
        //R-type 
        if(opcode == 6'h0) 
        begin        
>>>>>>> Stashed changes
            shamt = instruction[10:6];
            rd = instruction[15:11];
            rt = instruction[20:16];
            rs = instruction[25:21];
            funct = instruction[5:0];
        end
<<<<<<< Updated upstream
        else if(opcode == 6'h2 | opcode == 6'h3)
        begin   // J-type
            address = instruction[25:0];
        end
        else
        begin                               // I-type
=======

        // J-type
        else if(opcode == 6'h2 | opcode == 6'h3) 
        begin   
            address = instruction[25:0];
        end
        
        // I-type
        else 
        begin                               
>>>>>>> Stashed changes
            rt = instruction[20:16];
            rs = instruction[25:21];
            imm = instruction[15:0];
        end
    end
endmodule
