/* Module to read the 64-bit registers and read/write according to the RegWrite an RegRead signals*/

module read_registers(
    output reg [63:0] read_data_1, read_data_2, // The output are two 64-bit binary numbers that contain the data stored in RS and RT
    input [63:0] write_data, // The output are two 32-bit binary numbers that contain the data stored in RS and RT
    input [4:0] rs, rt, rd,  // RS and RT are the read registers and RD (Destination register) is the write register
    input [5:0] opcode,  // 6 bit opcode
    input RegRead, RegWrite, RegDst, clk  // RegRead and RegWrite are signals that indicate whether the instruction needs to read from registers and/or write to a register
);

    reg [63:0] registers [31:0];  //The set of 64 bit registers

    initial 
    begin
        $readmemb("registers.mem", registers);  //Reads all the values stored in the 32 registers
    end

    always @(write_data)
    begin
        if(RegWrite)
        begin
            /* RegWrite = 0 => Write to RT
               RegWrite = 1 => Write to RD    */
            if (RegDst)
            begin
                if(opcode == 6'd34)     //Load Byte
                    registers[rd] = {{56{1'b0}}, write_data[7:0]};
                else if (opcode == 6'd40)       //Load halfword and Zero
                    registers[rd] = {{48{1'b0}}, write_data[15:0]};
                else if (opcode == 6'd42)       //Load halfword with sign extension
                    registers[rd] = {{48{write_data[15]}}, write_data[15:0]};
                else if(opcode == 6'd32)        //Load word
                    registers[rd] = {{32{1'b0}}, write_data[31:0]};
                else                            //Load doubleword
                    registers[rd] = write_data;
            end
            else
            begin
                if(opcode == 6'd34)             //Load byte
                    registers[rt] = {{56{1'b0}}, write_data[7:0]};
                else if (opcode == 6'd40)       //Load halfword and zero
                    registers[rt] = {{48{1'b0}}, write_data[15:0]};
                else if (opcode == 6'd42)       //Load halfword with sign extension
                    registers[rt] = {{48{write_data[15]}}, write_data[15:0]};
                else if(opcode == 6'd32)        //Load word
                    registers[rt] = {{32{1'b0}}, write_data[31:0]};
                else                            //Load doubleword
                    registers[rt] = write_data;
            end
            //Write back the values in the registers file
            $writememb("registers.mem", registers);
        end
    end
    
    always @(read_data_1, read_data_2)
    begin
        //Read from registers
        if(RegRead)
        begin
            read_data_1 = registers[rs];
            read_data_2 = registers[rt];
        end
    end
endmodule