`timescale 1ns/1ns
/* 
Module to behave like the control unit to set the necessary signals for the execution of an instruction -
   1. RegDst - Which field of the instruction is the register to be written to
   2. RegWrite - Write to register file
   3. RegRead - Read from a register
   4. ALUSrc - The source for the second input to the ALU
   5. PCSrc - Source for PC (next instruction to be executed)
   6. MemRead - Read from the main memory
   7. MemWrite - Write to the main memory
   8. MemToReg - Source of write_data (data to be written to the register file)
   9. Branch -  When a branch/jump instruction is used
*/
module control_unit(
    output reg  RegRead,
                RegWrite,
                MemRead,
                MemWrite,
                RegDst, // if this is 0 select rt, otherwise select rd
                Branch,
                ALUSrc,
                PCSrc,
                MemToReg,
    input [5:0] opcode, funct
);

    always @(opcode, funct) 
    begin
	    // Reset the signals to 0
        MemRead  = 1'b0;
        MemWrite = 1'b0;
        RegWrite = 1'b0;
        RegRead  = 1'b0;
        RegDst   = 1'b0;
        Branch   = 1'b0;
        ALUSrc   = 1'b0;
        PCSrc    = 1'b0;
        MemToReg = 1'b0;
		
        // R type
        if(opcode == 6'h0) begin
            RegDst = 1'b1;
            RegRead = 1'b1;
            // If NOT JR  - Jump Register
            if(funct != 6'h08) begin
                RegWrite = 1'b1;
            end

        end
        // LUI(load unsigned immediate) => no need to read any register => immediate value is written to a register
        else if(opcode == 6'b001111) begin
            RegWrite = 1'b1;
            ALUSrc   = 1'b1;
        end

        // For r-type, beq, bne, sb, sh and sw there is no need to register write
        else if(opcode != 6'h0 & opcode != 6'h4 & opcode != 6'h5 & opcode != 6'h28 & opcode != 6'h29 & opcode != 6'h2b) begin
            RegWrite = 1'b1;
        end
        // For branch instructions
        else if(opcode == 6'h4 | opcode == 6'h5) begin
            Branch   = 1'b1;
        end
        // For memory write operation - sb, sh and sw use memory to write
        else if(opcode != 6'h0 & (opcode == 6'h28 | opcode == 6'h29 | opcode == 6'h2b)) begin
            MemWrite = 1'b1;
            RegRead  = 1'b1;
            ALUSrc   = 1'b1;
        end
        // For memory read operation - lw, 
        else if(opcode != 6'h0 & (opcode == 6'h23))begin
            MemRead = 1'b1;
            ALUSrc  = 1'b1;
            MemToReg= 1'b1;
            RegRead = 1'b1;
        end
        // J type
        else
        begin
            PCSrc = 1'b1;
        end
    end
endmodule

module control_unit_tb();

    wire  RegRead, RegWrite, MemRead, MemWrite, RegDst, Branch, ALUSrc, PCSrc, MemToReg;
    reg [5:0] opcode, funct;

    control_unit controller(
        .RegRead(RegRead),
        .RegWrite(RegWrite),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .RegDst(RegDst),
        .Branch(Branch),
        .ALUSrc(ALUSrc),
        .PCSrc(PCSrc),
        .MemToReg(MemToReg),
        .opcode(opcode),
        .funct(funct)
    );

    initial begin   
        //add - R type
        opcode = 6'b000000;
        funct = 6'b100000;
        #10;

        //lw - I type
        opcode = 6'b100011;
        #10;
        
        //j - J type
        opcode = 6'b000010;
        #10;
        
        //sll - R type 
        opcode = 6'b000000;
        funct = 6'b000000;
        #10;
        
        //sb - I type
        opcode = 6'b101000;
        #10;
        
        //jal - J type
        opcode = 6'b000011;
        #10;
        
        //bne - I type
        opcode = 6'b000101;
        #10;
        
        //nor - R type
        opcode = 6'b000000;
        funct = 6'b100111;
        #10;
    end

    initial begin
        $dumpfile("control_unit_tb.vcd"); 
        $dumpvars(0, control_unit_tb);
    end

endmodule