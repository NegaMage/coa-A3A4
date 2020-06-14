`timescale 1ns/1ns
/* Module to read the 32-bit registers and read/write according to the 
   RegWrite an RegRead signals
*/
module read_registers(
    output reg [31:0] read_data_1, read_data_2,   // The output are two 32-bit binary numbers that contain the data stored in RS and RT
    input [31:0] write_data,   // The data to be written
    input [4:0] rs, rt, rd,    // RS and RT are the read registers and RD (Destination register) is the write register
    input [5:0] opcode,        // The 6-bit opcode of the instruction
    input RegRead, RegWrite, RegDst, clk   // RegRead and RegWrite are signals that indicate whether the instruction needs to read from registers and/or write to a register
);

    reg [31:0] registers [31:0];    // The set of 32 registers (32-bit)
	
    initial begin
        $readmemb("registers.mem", registers);   //Reads all the values stored in the 32 registers
        registers[5'd0] = 32'd0;
    end
	
    always @(rd, write_data) begin    // If a change in the data to be written is noticed
        if(RegWrite) begin
            /* RegWrite = 0 => Write to RT
               RegWrite = 1 => Write to RD
            */
            read_data_1 = 32'd0;
            read_data_2 = 32'd0;
            if(RegDst) begin
                // LBU (Load byte unsigned)
                if(opcode == 6'h24)
                begin
                    registers[rd] <= {{24{1'b0}}, write_data[7:0]};
                end
                // LHU (Load halfword unsigned)
                if(opcode == 6'h25)begin
                    registers[rd] <= {{16{1'b0}}, write_data[15:0]};
                end
                // else begin   // LL(Load linked)
                //     registers[rd] = write_data;
                // end
            end
            else begin
                // LBU(load byte unsigned)
                if(opcode == 6'h24)
                begin        
                    registers[rt] <= {{24{1'b0}}, write_data[7:0]};
                end
                // LHU (Load halfword unsigned)
                if(opcode == 6'h25)
                begin        
                    registers[rt] <= {{16{1'b0}}, write_data[15:0]};
                end
                // else begin
                //     registers[rt] = write_data;
                // end
            end
            // Write back the updated values to the registers file
            registers[0]=32'd0;
            $writememb("registers.mem",registers);
        end
    end
	
    always @(rs, rt) 
    begin
        // Read from registers
        // if(RegRead) begin
            read_data_1 = registers[rs];
            read_data_2 = registers[rt];
        // end
    end

    initial begin
        $monitor("opcode : %6b, read_data_1 : %32b, read_data_2 : %32b, write_data : %32b, rs : %5b, rt : %5b, rd : %5b, RegRead : %1b, RegWrite : %1b, RegDst : %1b\n", opcode, read_data_1, read_data_2, write_data, rs, rt, rd, RegRead, RegWrite, RegDst);
    end

endmodule

module read_registers_tb();
    wire [31:0] read_data_1, read_data_2;
    reg [31:0] write_data;
    reg [4:0] rs, rt, rd;
    reg [5:0] opcode;
    reg RegRead, RegWrite, RegDst, clk;

    read_registers testerboi(
        .read_data_1(read_data_1),
        .read_data_2(read_data_2),
        .write_data(write_data),
        .rs(rs),
        .rt(rt),
        .rd(rd),
        .opcode(opcode),
        .RegRead(RegRead),
        .RegWrite(RegWrite),
        .RegDst(RegDst),
        .clk(clk)
    );

    initial begin
        RegWrite=0;
        RegRead =1;
        RegDst = 0;

        // Read r0 and r11.
        rs = 5'd0;
        rt = 5'd11;
        rd = 5'd14;
        #10;

        RegWrite=1;
        RegRead =0;
        RegDst = 1;

        // LBU into r14
        opcode = 6'h24;
        rd = 5'd14;
        RegDst = 1;
        write_data = 32'd5550123;
        #10;

        // LHU into r0
        rt = 5'd0;
        RegDst = 0;
        opcode = 6'h25;
        write_data = 32'd5550123;
        #10;

        // Read r0 and r14.
        opcode = 6'dx;
        RegWrite=0;
        RegRead =1;
        RegDst = 0;
        rs = 5'd0;
        rt = 5'd14;
        #10;

    end

    initial begin
        $dumpfile("read_registers.vcd"); 
        $dumpvars(0, read_registers_tb);
    end


endmodule
