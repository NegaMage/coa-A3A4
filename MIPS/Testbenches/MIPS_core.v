/* MIPS Core Module is the centre of all operations that handles all the operations and instantiates
   all the necessary modules
*/
`include "Control_Unit.v"
`include "Read_Registers.v"
`include "ALU32bit.v"
`include "Read_ins.v"
`include "Read_mem.v"
`include "Ins_parse.v"


module mips_core(clock);

    input clock;   // Execution happens only at positive level-transition (edge sensitive)
	
    // Program counter
    reg[31:0] PC = 32'b0;
	
    // Instruction
    wire [31:0] instruction;
	
    // Parse instruction
    wire [5:0] funct;
    wire [4:0] rs, rt, rd, shamt;
    wire [25:0] address;
    wire [15:0] immediate;
    wire [5:0] opcode;
	
    // Signals
    wire RegRead, RegWrite, RegDst;  
    wire MemRead, MemWrite;
    wire branch_signal;
	
    // Registers contents
    wire [31:0] write_data, rs_content, rt_content, memory_read_data;
	
	
    // Instantiating all necessary modules
    read_instructions inst_mem (
        .instruction(instruction),
        .program_counter(PC));
	
    ins_parser parse (.opcode(opcode),
        .rs(rs),
        .rt(rt),
        .rd(rd),.shamt(shamt),
        .funct(funct),
        .immediate(immediate),
        .address(address),
        .instruction(instruction),
        .p_count(PC));
	
    control_unit signals (
        .RegRead(RegRead),
        .RegWrite(RegWrite),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .RegDst(RegDst),
        .Branch(branch_signal),
        .opcode(opcode),
        .funct(funct));

    read_registers contents (
        .read_data_1(rs_content),
        .read_data_2(rt_content),
        .write_data(write_data),
        .rs(rs),
        .rt(rt),
        .rd(rd),
        .opcode(opcode),                                  .RegRead(RegRead),
        .RegWrite(RegWrite),
        .RegDst(RegDst),
        .clk(clock));
								 
    ALU32bit alu_process (
        .ALU_result(write_data),
        .sig_branch(branch_signal),
        .opcode(opcode),
        .rs_content(rs_content),
        .rt_content(rt_content),
        .shamt(shamt),
        .funct(funct),
        .immediate(immediate));
	
    read_data_memory dataMemory (
        .read_data(memory_read_data),
        .write_data(write_data),
        .address(rt_content),
        .opcode(opcode),
        .MemRead(MemRead),
        .MemWrite(MemWrite));
	
    
	
    // PC operations - The next instruction is read only when the clock is at positive edge
    always @(posedge clock) begin 
        // JUMP 
        if(opcode == 6'h2) begin
            PC = address;
        end
        // JUMP REGISTER
        else if(opcode == 6'h0 & funct == 6'h08)begin
            PC = rs_content;
        end
        // BRANCH
        else if(write_data == 0 & branch_signal == 1) begin
            PC = PC + 1 + $signed(immediate); 
        end
        else begin
            PC = PC+1;
        end
    end 

    initial begin
        $dumpfile("MIPS_Core.vcd"); 
        $dumpvars(0, mips_core);
    end
endmodule