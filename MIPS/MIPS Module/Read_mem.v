/* Module designed to read and write to the main memory
*/

module read_data_memory(
    output reg [31:0] read_data,  //The data read from the main memory (from the given address)
    input  [31:0] address, write_data, //The ADDRESS and WRITE_DATA are inputs to this module after ALU processing
    input [5:0] opcode,
    input [4:0] rs,
    input MemRead,MemWrite,MemToReg    // Read and Write signals to main memory
);
	
    reg [31:0] data_mem [255:0];   // The contents of the main memory
    reg [31:0] reg_mem [31:0];

    always @(address, MemWrite) begin
        if(MemWrite) begin
            $readmemb("data.mem", data_mem, 31 ,0); // adjust according to the number of entries in data.mem
            if(opcode == 6'h28) begin
                data_mem[address][7:0] = write_data[7:0];
            end 
            else if(opcode == 6'h29) begin
                data_mem[address][15:0] = write_data[15:0];
            end
            else begin
                data_mem[address] = write_data;
            end
            // Write the updated contents back to the data_mem file
            $writememb("data.mem", data_mem);
        end
    end
	
    always @(address) begin
        $readmemb("data.mem", data_mem, 31 ,0); // adjust according to the number of entries in data.mem
        $readmemb("registers.mem", reg_mem, 31, 0); //32 registers so..
        if(MemRead) begin
            read_data = data_mem[address];
        end
        if(MemToReg) begin
            reg_mem[rs] = read_data;
            $writememb("registers.mem", reg_mem);
        end
    end	

endmodule
