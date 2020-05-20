/* Module designed to read the instruction and assign the various
   components of the instruction to suitable variables depending on the format
*/

module ins_parse(
    output wire [5:0] opcode, 
    output reg [4:0] rs, rt, rd, bo, bi, 
    output reg aa, lk, rc, oe,
    output reg [9:0] xox,
    output reg [8:0] xoxo, 
    output reg [15:0] si, 
    output reg [13:0] bd, ds,
    output reg [1:0] xods, 
    output reg [23:0] li,
    input [31:0] instruction, p_count
);

    assign opcode = instruction[31:26];

    always @(instruction) 
    begin

        //XO
        if(opcode == 6'd31 & (instruction[9:1] == 9'd266 | instruction[9:1] == 9'd40))
        begin
            rd = instruction[25:21];
            rt = instruction[20:16];
            rs = instruction[15:11];
            oe = instruction[10];
            xoxo = instruction[9:1];
            rc = instruction[0];
        end

        //X
        else if(opcode == 6'd31)
        begin
            rd = instruction[25:21];
            rt = instruction[20:16];
            rs = instruction[15:11];
            xox = instruction[10:1];
            rc = instruction[0];
        end

        //D
        else if(opcode == 6'd14 | opcode == 6'd15 | opcode == 6'd28 | opcode == 6'd24 | opcode == 6'd26 | opcode == 6'd32 | opcode == 6'd36 | opcode == 6'd37 |opcode == 6'd40 | opcode == 6'd42 |opcode == 6'd44 |opcode == 6'd34 |opcode == 6'd38)
        begin
            rd = instruction[25:21];
            rt = instruction[20:16];   
            si = instruction[15:0];
        end

        //B
        else if(opcode == 6'd19)
        begin
            bo = instruction[25:21];
            bi = instruction[20:16];
            bd = instruction[15:2];
            aa = instruction[1];
            lk = instruction[0];
        end

        //I
        else if(opcode == 6'd18)
        begin
            li = instruction[25:2];
            aa = instruction[1];
            lk = instruction[0];
        end

        //DS
        else
        begin
            rd = instruction[25:21];
            rt = instruction[20:16];
            ds = instruction[15:2];
            xods = instruction[1:0];
        end
    end
endmodule
