-------------------------------------------------------------------------
-- Design unit: ALU
-- Description:
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.MIPS_package.all;

entity ALU is
    port(
        operand1    : in std_logic_vector(31 downto 0);
        operand2    : in std_logic_vector(31 downto 0);
        result      : out std_logic_vector(31 downto 0);
        zero        : out std_logic;
        operation   : in operation_type
    );
end ALU;

architecture behavioral of ALU is

    signal temp, op1, op2: UNSIGNED(31 downto 0);

begin

    op1 <= UNSIGNED(operand1);
    op2 <= UNSIGNED(operand2);

    result <= STD_LOGIC_VECTOR(temp);

    temp <= op1 - op2               when operation = BEQ or operation = BNE else
            op1 or  op2             when operation = ORI else
            op1 xor op2             when operation = XXOR else
            x"00000001"             when operation = SLT and SIGNED(op1) < SIGNED(op2) else
            x"00000000"             when operation = SLT and not (SIGNED(op1) < SIGNED(op2)) else
            x"00000001"             when operation = SLTU and op1 < op2 else
            x"00000000"             when operation = SLTU and not (op1 < op2) else
            shift_left(op1, TO_INTEGER(op2(10 downto 6))) when operation = SSLL else     --for SLL, we shift the amount in the shamt part of the instruction
            op2(15 downto 0) & x"0000"           when operation = LUI else
            (others=>'X')           when operation = INVALID_INSTRUCTION else
            op1 + op2;    -- default for ADD, ADDI, SW, LW

    -- Generates the zero flag
    zero <= '1' when temp = 0 else '0';

end behavioral;
