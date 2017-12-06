library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

package MIPS_package is
    type Instruction_type is (ADD, XXOR, SW, LW, ADDI, ORI, SLT, SLTU, SSLL, BEQ, BNE, LUI, INVALID_INSTRUCTION);

    type control is record
        PCSource : std_logic;
        WrPC     : std_logic;
        PCconditional : std_logic;  --for conditional jumps
        ALUOp    : Instruction_type;           --ALU operation from assembly code
        ALUSrcB  : std_logic_vector(1 downto 0);
        ALUSrcA  : std_logic;
        WrRfile  : std_logic;        --controls register file writing
        RegDst   : std_logic;       --controls which input chooses the register to be written
        WrIR     : std_logic;       --writes on instruction register
        MemToReg : std_logic;       --active for when writing memory data in the register file
        WrMem    : std_logic;        --RAM write control
        RdMem    : std_logic;         --RAM read control
        WrMDR    : std_logic;        --writes the memory data register
        IorD     : std_logic;        --controls instruction or data memory addressing
        WrA, WrB : std_logic;       --controls a and b registers from register file data
        WrALU    : std_logic;       --controls aluout register write
    end record;

    type flags is record:
        zero : std_logic;   --zero flag
        instruction : std_logic_vector(5 downto 0); --relevant part of the instruction for the control block
        funct   : std_logic_vector(5 downto 0);     --funct field for R type instructions
    end record;
end package;
