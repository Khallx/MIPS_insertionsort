library IEEE;
use IEEE.std_logic_1164.all;
use work.MIPS_package.all;


entity ControlPath is
    port (
        clock           : in std_logic;
        reset           : in std_logic;
        instruction     : in std_logic_vector(31 downto 0);
        ctrl            : out command;
        ULAoperation    : out operation_type
    );
end ControlPath;

architecture arch of ControlPath is
    type state is (s0, s1, s2, s3, s4, s5);
    signal cs : state;
    -- Alias to identify the instructions based on the 'opcode' and 'funct' fields
    alias  opcode: std_logic_vector(5 downto 0) is instruction(31 downto 26);
    alias  funct: std_logic_vector(5 downto 0) is instruction(5 downto 0);

    -- Retrieves the rs field from the instruction
    alias rs: std_logic_vector(4 downto 0) is instruction(25 downto 21);
    -- Retrieves the rt field from the instruction
    alias rt: std_logic_vector(4 downto 0) is instruction(20 downto 16);
    -- Retrieves the rd field from the instruction
    alias rd: std_logic_vector(4 downto 0) is instruction(15 downto 11);

    signal decodedInstruction: operation_type;

begin

    ctrl.ALUop <= decodedInstruction;     -- Used to set the ALU operation

    -- Instruction decode
    decodedInstruction <=   ADD     when opcode = "000000" and funct = "100000" else
                            XXOR    when opcode = "000000" and funct = "100110" else
                            --check this later
                            SLT     when opcode = "000000" and funct = "101010" else
                            SLTU    when opcode = "000000" and funct = "101011" else
                                --check this later
                            SW      when opcode = "101011" else
                            LW      when opcode = "100011" else
                            ADDI    when opcode = "001000" else
                            ORI     when opcode = "001101" else
                            BEQ     when opcode = "000100" else
                            BNE     when opcode = "000101" else
                            J       when opcode = "000010" else
                            LUI     when opcode = "001111" and rs = "00000" else
                            ADD;    --default operation is add

    state_logic : process(instruction, clk, rst)
    begin
        if rst = '1' then
            cs <= s0;
        elsif rising_edge(clk) then
            case cs is
                when s0 =>
                    cs <= s1;
                when s1 =>
                    cs <= s2;
                when s2 =>
                    if opcode = "000000" then       --R type
                        cs <= s3;
                    else
                    end if;
                when s3 =>
                    cs <= s4;
                when s4 =>
                    cs <= s0;
            end case;
        end if;
    end process;

    --all command signals are only state based (moore FSM)
    ctrl.PCSource
    ctrl.WrPC
    ctrl.PCconditional
    ctrl.ALUSrcB
    ctrl.ALUSrcA
    ctrl.WrRfile
    ctrl.RegDst
    ctrl.WrIR
    ctrl.MemToReg
    ctrl.WrMem
    ctrl.RdMem
    ctrl.WrMDR
    ctrl.IorD
    ctrl.WrA
    ctrl.WrB
    ctrl.WrALU
    
end architecture;
