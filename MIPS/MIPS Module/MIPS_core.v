/*
MIPS Core module is where we put everything together, and if connected properly should simulate a MIPS datapath.
*/
`include "Control_Unit.v"
`include "Read_Registers.v"
`include "ALU32bit.v"
`include "Read_ins.v"
`include "Read_mem.v"
`include "Ins_parse.v"


module MIPS_core(clock);

    input clock;   // Execution happens only at pos-edge
	
    // Program counter
    reg[31:0] PC = 32'b0; 
	
    // Instruction
    wire [31:0] instruction;
	
    // Parse instruction
    wire [5:0] funct;
    wire [4:0] rs, rt, rd, shamt;
    wire [25:0] address;
    wire [15:0] imm;
    wire [5:0] opcode;
	
    // Signals
    wire RegRead, RegWrite, RegDst;  
    wire MemRead, MemWrite, MemToReg;
    wire branch_sig;
    wire PCSrc, ALUSrc;
	
    // Registers contents
    wire [31:0] write_data, rs_value, rt_value, memory_read_data;
	
    // Instantiating all necessary modules
    read_instructions inst_mem (instruction, PC);
	
    ins_parser ins_parse (opcode, rs, rt, rd, shamt, funct, imm, address, instruction, PC);
	
    control_unit c_unit (RegRead, RegWrite, MemRead, MemWrite, RegDst, ALUSrc, PCSrc, MemToReg, branch_sig, opcode, funct);
								 
    ALU32bit al_unit (write_data, branch_sig, ALUSrc, opcode, rs, rt, rs_value, rt_value, shamt, funct, imm);
	
    read_data_memory data_memory (memory_read_data, write_data, rt_value, opcode, rs, MemRead, MemWrite, MemToReg);
	
    read_registers reg_val (rs_value, rt_value, write_data, rs, rt, rd, opcode, RegRead, RegWrite, RegDst, clock);
	
    // PC operations - The next instruction is read only when the clock is at positive edge
    always @(posedge clock) begin 
        // JUMP 
        if(opcode == 6'h2) begin
            PC = address;
        end
        // JUMP REGISTER
        else if(opcode == 6'h0 & funct == 6'h08)begin
            PC = rs_value;
        end
        // BRANCH
        else if(write_data == 0 & branch_sig == 1) begin
            PC = PC + 1 + $signed(imm); 
        end
        else begin
            PC = PC + 1;
        end
    end 
endmodule