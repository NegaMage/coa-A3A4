/* Module designed to act as the ALU - takes in the opcode, contents of the registers, shiftAmount, ALUResult and AluSrc signals
   with the signedImm as arguments
*/

module ALU64bit(
    output reg [63:0] ALU_result,
    output reg Branch, ALUSrc,
    input [63:0] rs_content, rt_content,
    input [5:0] opcode,
    input [4:0] rs, rt, rd, bo, bi,
    input [15:0] si,
    input [13:0] ds, 
    input [9:0] xox,
    input [8:0] xoxo,
    input aa, 
    input [1:0] xods
);

    reg signed [63:0] temp, signed_rt, signed_rs;
    reg [63:0] zeroExtendSI, signExtendSI, zeroExtendDS;

    always @(rs_content, rt_content, si, xoxo, xox, xods, bo, bi, aa, ds, rs, rt)
    begin

      signed_rs = rs_content;
      signed_rt = rt_content;
      zeroExtendSI = {{48{1'b0}}, si[15:0]};
      signExtendSI = {{48{si[15]}},si[15:0]};
      zeroExtendDS = {{50{1'b0}},ds[13:0]};

      if(opcode == 6'd31 & xoxo != 9'd0)    //XO Format
      begin
            // $display("ADDING\n");
          case(xoxo)
            9'd266: //ADD
                ALU_result = signed_rs + signed_rt;
            9'd40 : //SUBF
                ALU_result = signed_rt - signed_rs;
          endcase
      end  

      else if(opcode == 6'd31 & xox != 10'd0)   //X Format
      begin

        case(xox)

            10'd28: //AND
                ALU_result = signed_rt & signed_rs;
            10'd476: //NAND
                ALU_result = ~(signed_rs & signed_rt);
            10'd444: //OR
                ALU_result = signed_rs | signed_rt;
            10'd316: //XOR
                ALU_result = signed_rs ^ signed_rt;
            10'd986: //EXTSW
                ALU_result = {{32{signed_rs[31]}}, signed_rs[31:0]};
        endcase
      end

      else if(opcode == 6'd19)      //B Format 
      begin
        if(aa == 1) //BEQ
        begin
          ALU_result = signed_rs - signed_rt;
          if(ALU_result == 0)
              Branch = 1'b1;
          else
              Branch = 1'b0;
        end
        else if(aa == 0) //BNE
        begin
            ALU_result = signed_rs - signed_rt;
            if(ALU_result != 0) begin
              Branch = 1'b1;
              ALU_result = 1'b0;
              end
            else
              Branch = 1'b0; 
        end
      end

      else if(opcode == 6'd18) //I Format
            Branch = 1'b1;
    
      else if(si != 15'b0)      //D Format
      begin
        //   $display("ADD");
          case(opcode)

            6'd14: //ADDI
                ALU_result = signed_rs + zeroExtendSI;
            6'd15: //ADDIS
                ALU_result = signed_rs + signExtendSI;
            6'd28: //ANDI
                ALU_result = signed_rs & zeroExtendSI;
            6'd24: //ORI
                ALU_result = signed_rs | zeroExtendSI;
            6'd26: //XORI
                ALU_result = signed_rs ^ zeroExtendSI;
            6'd32: //LW0
                ALU_result = signed_rs + zeroExtendSI;
            6'd36: //SW
                ALU_result = signed_rs + signExtendSI;
            6'd37: //SWU
                ALU_result = signed_rs + signExtendSI;
            6'd40: //LHW
                ALU_result = signed_rs + signExtendSI;
            6'd42: //LHWA
                ALU_result = signed_rs + signExtendSI;
            6'd44: //SHW
                ALU_result = signed_rs + signExtendSI;
            6'd34: //LB0    
                ALU_result = signed_rs + zeroExtendSI;
            6'd38: //SB
                ALU_result = signed_rs + signExtendSI;
          endcase
      end  

      else if(ds != 14'b0)      //DS Format
      begin
        if(opcode == 6'd58)
            ALU_result = signed_rs + zeroExtendDS;
        else if(opcode == 6'd62)
            ALU_result = signed_rs + zeroExtendDS;  
      end
    end

    //Display
    always @(rs, rt, bo, bi, si, xoxo, xox, xods)
    begin
        $monitor("Opcode : %6b\n, rs : %5b, rt : %5b, rd : %5b, \nRS : %64b\n, RT : %64b\n, signExtendSI = %64b\n, zeroExtendSI = %64b\n, zeroExtendDS = %64b\n, Result : %64b\n",
        opcode, rs, rt, rd, rs_content, rt_content, signExtendSI, zeroExtendSI, zeroExtendDS, ALU_result);
    end
	
endmodule



