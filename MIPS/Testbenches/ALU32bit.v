`timescale 1ns/1ns
/* 
ALU Module - takes the opcode, contents of the registers, shiftAmount, ALUResult and AluSrc signals, with the signedImm as arguments
*/

module ALU32bit(ALU_result, branch_sig, AluSrc, opcode, rs, rt, rs_value, rt_value, shamt, funct, imm);
	
    input [5:0] funct, opcode;
    input [4:0] shamt; // shift amount
    input [15:0] imm;
    input [31:0] rs_value, rt_value; //inputs
    input [4:0] rs, rt;
    output reg branch_sig, AluSrc;
    output reg [31:0] ALU_result; //Output of the ALU
	
    integer i; //Loop counter
    // Temporary variable - temp for SRA
    reg signed [31:0] temp, signed_rs, signed_rt; 
    reg [31:0] signExtend, zeroExtend;

    // initial begin
    //     rs_value = 32'b0;
    //     rt_value = 32'b0;
    // end

    always @ (funct, rs_value, rt_value, shamt, imm) begin
		
		
        // Signed value assignment
        signed_rs = rs_value;
        signed_rt = rt_value;
			
        // R-type instruction
        if(opcode == 6'h0) begin
			
            case(funct)
			
                6'h20 : //ADD
                    begin
                    ALU_result = signed_rs + signed_rt;

                    end
                6'h21 : //ADDU - Add unsigned
                    ALU_result = rs_value + rt_value;
					
                6'h22 : //SUB - Subtract
                    ALU_result = signed_rs - signed_rt;
					
                6'h23 : //SUBU - Subtract unsigned
                    ALU_result = rs_value - rt_value;
					
                6'h24 : //AND
                    ALU_result = rs_value & rt_value;
					
                6'h25 : //OR
                    ALU_result = rs_value | rt_value;
					
                6'h27 : //NOR
                    ALU_result = ~(rs_value | rt_value);
					
                6'h03 : //SRA (Shift Right Arithmetic - An arithmetic right shift replicates the sign bit as needed to fill bit positions)
                    begin
                        temp = rt_value;
                        for(i = 0; i < shamt; i = i + 1) begin
                            temp = {temp[31],temp[31:1]}; //add the lsb for msb
                        end
					
                    ALU_result = temp;
                    end
					
                6'h02 : //SRL - Shift Right Logical >>
                    ALU_result = (rt_value >> shamt);
			
                6'h00 : //SLL - Shift Left Logical <<
                    ALU_result = (rt_value << shamt);
				
                6'h2b : //SLTU - Set less than unsigned
                    begin
                        if(rs_value < rt_value) begin
                            ALU_result = 1;
                        end else begin
                            ALU_result = 0;
                        end
                    end
					
                6'h2a : //SLT - Set less than
                    begin
                        if(signed_rs < signed_rt) begin
                            ALU_result = 1;
                        end else begin
                            ALU_result = 0;
                        end
                    end
			
            endcase
			
        end 
		
        // I type
        else begin
			
            signExtend = {{16{imm[15]}}, imm};
            zeroExtend = {{16{1'b0}}, imm};
			
            case(opcode)
		
                6'h8 : // ADDI - Add Immediate
                    ALU_result = signed_rs + signExtend;
					
                6'h9 : // ADDIU - Add Immediate unsigned
                    ALU_result = rs_value + signExtend;
					
                6'b010010 : // ANDI - And Immediate
                    ALU_result = rs_value & zeroExtend;
					
                6'h4 : // BEQ - Branch on Equal
                    begin
                        ALU_result = signed_rs - signed_rt;
                        if(ALU_result == 0) begin
                            branch_sig = 1'b1;
                        end
                        else begin
                            branch_sig = 1'b0;
                        end
                    end
				
                6'h5 : // BNE - Branch not equal
                    begin
                        ALU_result = signed_rs - signed_rt;
                        if(ALU_result != 0) begin
                            branch_sig = 1'b1;
                            ALU_result = 1'b0;
                        end
                        else begin
                            branch_sig = 1'b0;
                        end
                    end
				
                6'b010101 : // LUI - Load upper imm
                    ALU_result = {imm, {16{1'b0}}};
				
                6'b010011 : // ORI - Or Immediate
                    ALU_result = rs_value | zeroExtend;
				
                6'b001010 : // SLTI - Set less than imm
                    begin
                        if(signed_rs < $signed(signExtend)) begin
                            ALU_result = 1;
                        end else begin
                            ALU_result = 0;
                        end
                    end
				
                6'b001011 : // SLTIU - Set less than imm unsigned
                    begin
                        if(rs_value < signExtend) begin
                            ALU_result = 1;
                        end else begin
                            ALU_result = 0;
                        end
                    end
                6'h28 : // SB - Store byte
                    ALU_result = signed_rs + signExtend;
                6'h29 : // SH -Store halfword
                    ALU_result = signed_rs + signExtend;
                6'h2b : // SW - Store Word
                    ALU_result = signed_rs + signExtend;
                6'h23 : // LW - Load Word
                    ALU_result = signed_rs + signExtend;
                6'h24 : // LBU - Load 
                    ALU_result = signed_rs + signExtend;
                6'h25 : // LHU - Load halfword unsigned
                    ALU_result = signed_rs + zeroExtend;
                6'h30 : // LL - Load linked
                    ALU_result = signed_rs + signExtend;
				
            endcase
		
        end
		
    end

    always @ (funct, rs, rt, shamt, imm) 
    begin
        $display("Opcode : %6b, RS : %32b, RT : %32b, signExtendImm = %32b, Result : %32b\n",opcode, rs_value, rt_value, signExtend, ALU_result);
    end
	
endmodule

module alu32bittb();
    reg [5:0] funct, opcode;
    reg [4:0] shamt; // shift amount
    reg [15:0] imm;
    reg [31:0] rs_value, rt_value; //inputs
    reg [4:0] rs, rt;
    wire branch_sig, AluSrc;
    wire [31:0] ALU_result; //Output of the ALU


    ALU32bit testerboi(.ALU_result(ALU_result),
             .branch_sig(branch_sig),
             .opcode(opcode),
             .rs_value(rs_value),
             .rt_value(rt_value),
             .rs(rs),
             .rt(rt),
             .shamt(shamt),
             .funct(funct),
             .imm(imm));

    initial begin
        opcode = 6'h0;
        
        //Add 12 and -10
        rs_value = 12;
        rt_value = -10;
        funct = 6'h20;
        shamt = 0;
        imm = 20;
        #10;

        //Subtract 3 from 1
        rs_value = 1;
        rt_value = 3;
        funct = 6'h22;
        shamt = 0;
        imm = 20;
        #10;

        //Shift 13 twice to left
        rs_value = 0;
        rt_value = 13;
        funct = 6'h00;
        shamt = 2;
        imm = 20;
        #10;
        
        //Add 15 to 1500 from imm field
        opcode = 6'h8;
        rs_value = 15;
        rt_value = 0;
        imm = 1500;
        #10;
        
        //Or Imm of 7 and 1024 from imm
        opcode = 6'b010011;
        rs_value = 7;
        rt_value = 0;
        imm = 1024;
        #10;

        //generate address for load word
        opcode = 6'h23;
        rs_value = -8;
        rt_value = 0;
        imm = 1024;
        #10;

        //signal on beq
        opcode = 6'h4;
        rs_value = 4;
        rt_value = 4;
        imm = 1024;
        #10;

        //signal on beq
        opcode = 6'h4;
        rs_value = 4;
        rt_value = 5;
        imm = 1024;
        #10;

    end

    initial begin
        $dumpfile("ALU32Bittb.vcd"); 
        $dumpvars(0, alu32bittb);
    end

endmodule