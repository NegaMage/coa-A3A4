/* Module to read the 32-bit registers and read/write according to the 
   RegWrite an RegRead signals
*/
module read_registers(
    output reg [31:0] read_data_1, read_data_2,   // data stored in RS and RT
    input [31:0] write_data,   // The data to be written
    input [4:0] rs, rt, rd,    // RS and RT - read registers and RD (Destination register) - the write register
    input [5:0] opcode,        // opcode
    input RegRead, RegWrite, RegDst, clk   // control unit signals
);

    reg [31:0] registers [31:0];    // set of 32-bit registers
	
    always @(rd, write_data) begin  
        
        $readmemb("registers.mem", registers);   //read all registers values
        if(RegWrite) begin
            /* RegDst = 0 => Write to RT
               RegDst = 1 => Write to RD
            */
            if(RegDst) begin
                if(opcode == 6'h24)begin    // LBU(load byte unsigned) or LHU (Load halfword unsigned)
                    registers[rd][7:0] = write_data[7:0];
                end
                if(opcode == 6'h25)begin
                    registers[rd][15:0] = write_data[15:0];
                end
                else begin   // LL(Load linked)
                    registers[rd] = write_data;
                end
            end
            else begin
                if(opcode == 6'h24)begin        // LBU(load byte unsigned)
                    registers[rt][7:0] = write_data[7:0];
                end
                if(opcode == 6'h25)begin        // LHU (Load halfword unsigned)
                    registers[rt][15:0] = write_data[15:0];
                end
                else begin
                    registers[rt] = write_data;
                end
            end

            // Write back the updated values to the registers file
            $writememb("registers.mem",registers);
        end
    end

    always @(rs, rt) begin
        $readmemb("registers.mem", registers);   //read all registers values
        if(RegRead) begin
            read_data_1 = registers[rs];
            read_data_2 = registers[rt];
        end
    end
endmodule