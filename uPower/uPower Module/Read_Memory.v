module read_data_memory (
    output reg [63:0] read_data,
    input [63:0] address, write_data,
    input [4:0] rd, 
    input [5:0] opcode, 
    input MemWrite, MemRead, MemToReg
);

    reg [63:0] data_mem [31:0];
    reg [63:0] registers [31:0];

    always @ (address, MemWrite) 
    begin
        if(MemWrite) begin
            $readmemb("data.mem", data_mem, 0, 31);
            $readmemb("registers.mem", registers, 0, 31);
            if(opcode == 6'd38) begin
                data_mem[address] = {{56{1'b0}}, write_data[7:0]};
            end
            else if(opcode == 6'd44) begin
                data_mem[address] = {{48{1'b0}}, write_data[15:0]};
            end
            else if(opcode == 6'd36) begin
                data_mem[address] = {{32{1'b0}}, write_data[31:0]};
            end
            else begin
                data_mem[address] = write_data;
            end
            // Write the updated contents back to the data_mem file
            $writememb("data.mem", data_mem);            
        end
    end

    always @(address)
    begin
        $readmemb("data.mem", data_mem, 0, 31);
        $readmemb("registers.mem", registers, 0, 31);
        if(MemRead) begin
            read_data = data_mem[address];
        end
        if(MemToReg) begin
            registers[rd] = read_data;
            $display("Reg 0 : %64b\nReg 1 : %64b\nReg 2 : %64b\nReg 3 : %64b\n",registers[0], registers[1], registers[2], registers[3]);
            $writememb("registers.mem", registers);
        end
    end
endmodule