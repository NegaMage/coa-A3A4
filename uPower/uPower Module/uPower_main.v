/* uPowerISA Core Module is the centre of all operations that handles all the operations and instantiates
all the necessary modules
*/
`include "control_unit.v"
`include "instruction_parse.v"
`include "alu64bit.v"
`include "read_instructions.v"
`include "read_memory.v"
`include "read_registers.v"

module uPower_core(clock);

input clock; //Execution happens only at positive level-transition (edge sensitive)

//Program counter

reg [31:0] PC = 32'b0;

//Instruction
wire [31:0] instruction;

//Parse instruction
wire [5:0] opcode;
wire [4:0] rs,rt,rd,bo,bi;
wire [8:0] xoxo;
wire [9:0] xox;
wire rc,aa,lk,oe;
wire [13:0] bd,ds;
wire [15:0] si;
wire [23:0] li;
wire [1:0] xods;

//Signals

wire RegRead, RegWrite, MemRead, MemWrite, Branch, MemToReg, ALUSrc, PCSrc;

//Register contents
wire [63:0] write_data, rs_content, rt_content, rd_content, memory_read_data;

//Instantiating all necessary modules
instr_reader instr_mem(instruction, PC);

instruction_parser splitter(opcode, rs, rt, rd, bo, bi, aa, lk, rc, oe, xox, xoxo, si, bd, ds, xods, li, instruction, PC);

signal_gen control_signals(RegRead, RegWrite, MemRead, MemWrite, Branch, MemToReg, ALU_Src, PCSrc, opcode, xox, xoxo, xods);

al_unit ALU(write_data, Branch, ALUSrc, rs_content, rt_content, opcode, rs, rt, rd, bo, bi, si, ds, xox, xoxo, aa, xods);

memory_reader dataMemory(memory_read_data, write_data, rd_content, rd, opcode, MemWrite, MemRead, MemToReg);

register_reader registers(rs_content, rt_content, rd_content, write_data, rs, rt, rd, bo, bi, opcode, RegRead, RegWrite, clock);

// PC operations - The next instruction is read only when the clock is at positive edge

always @(posedge clock) 
 begin
     if(opcode == 6'd18)
       PC = {{8{1'b0}},li};
     
     else if(write_data == 0 & Branch == 1 & aa == 0 & opcode == 6'd19) begin          //Branch Conditional
       PC = PC + 1 + {{50{bd[13]}}, bd};
       $display("BD : %14d", $signed(bd));
     end
     else if(write_data == 0 & Branch == 1 & aa == 1 & opcode == 6'd19)          //Branch Absolute
       PC = {{50{bd[13]}}, bd};

     else if(write_data == 0 & Branch == 1 & aa == 1 & opcode == 6'd18)
       PC = {{40{li[23]}}, li};

     else if(write_data == 0 & Branch == 1 & aa == 0 & opcode == 6'd18)
       PC = PC + 1 + {{40{li[23]}}, li};
     else 
       PC = PC + 1;
 end


endmodule