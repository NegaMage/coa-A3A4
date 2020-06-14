Read_ins (Same for MIPS and Upower)
(Explain Simultaneously if both are in one Video)

The purpose of Read instruction module is to read instructions from the instruction.mem

as we can see here (highlight) we have a stored the instruction in a 32 bit varaible register.

(Show the code for both MIPS and Upower)


Read_mem

This module takes care of reading and writing data from the main memory
Which is represented by data.mem in this case...

//MIPS
(Show line 16 from read_mem.v)
Here data is written into data_mem varaible at the specified address
depending upon the type of instruction that (based on the opcode)
(Highlight all the cases)

(Line 29) Then the data_mem is sent to the data.mem file

In the case that we are reading data from main memory and storing it in the Register file.
(Line 36,37) based on MemRead parameter we read data from the the data_mem at the specified address and store it in read_data varaible
(Line 39,40,41) This is then stored in the register file at the appropriate location given by rs (Highlight stuff as u speak)


//Upower
It has similar structure to that of Read_mem in MIPS...
As we can see here (Line 17)
Here too data is written to data_mem at the specififed address nased on the opcode of the instruction
at the appropriate place based on the opcode

(Line 39)In the case of reading data from main memory the data is read from data_mem at the address
(Line 41,42) then based on MemtoRed the data is written int the corect register and then saved to the register file in register.mem (Line 44)
