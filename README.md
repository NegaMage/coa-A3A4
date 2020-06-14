# COA A3 and A4

This project is submitted as part of course requirements for CS250. Computer Organization and Architecture.


A datapath for MIPS and UPower ISA built in verilog.

# Execution

Video demos are up! at :

https://drive.google.com/drive/folders/1x6ZXkRyPD3YazumilLAJqLHjfP6HGpEI?usp=sharing

## MIPS part

Run

`
iverilog MIPS/MIPS\ Module/mips_tb.v
`

`
./a.out 
`
## uPower part

Run

`
iverilog uPower/uPower\ Module/uPowerISA_Core.v
`

`
./a.out 
`

## Unit testing, extra details

We've meticulously tested every module used in each of the mips and uPower datapaths. While we haven't run the entire possible set of instructions, we are confident that our code works. 


In each folder you will find folders containing appropriate .out files from compiling the module, and .vcd files for the simulated module. Also enclosed are screenshots of each vcd file in GTKWave, for ease of checking.

## Submitted by:

1. Feyaz Baker - 181co119

2. Shrvan Warke - 181co151

3. Nihar KG Rai - 181co235

4. Vignesh Srinivasan - 181co258
