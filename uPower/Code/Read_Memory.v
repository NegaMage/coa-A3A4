module read_data_memory (
    output reg [63:0] read_data,
    input [63:0] address, 
    input [63:0] write_data,
    input [5:0] opcode, 
    input MemWrite, MemRead
);

    reg [63:0] data_mem [255:0];

    initial
    begin
        $readmemb("data.mem", data_mem, 5, 0);
    end

    always @ (address) 
    begin
        if(MemWrite) 
        begin
            if(opcode == 6'd38)     
            begin
                data_mem[address] = {{56{1'b0}}, write_data[7:0]};
            end

            else if(opcode == 6'd44) 
            begin
                data_mem[address] = {{48{1'b0}}, write_data[7:0]};
            end
            
            else if(opcode == 6'd36) begin
                data_mem[address] = {{32{1'b0}}, write_data[7:0]};
            end
            
            else 
            begin
                data_mem[address] = write_data;
            end
            // Write the updated contents back to the data_mem file
            $writememb("data.mem", data_mem);            
        end

    end
endmodule