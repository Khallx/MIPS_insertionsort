library IEEE;
use IEEE.std_logic_1164.all;
use work.MIPS_package.all;


entity ControlPath is
    port (
        clock           : in std_logic;
        reset           : in std_logic;
        ctrl            : out control;
        flg             : in flags
    );
end ControlPath;

architecture arch of ControlPath is
    type state is (s0, s1, s2, s3, s4, s5, s6, s7, s8, s9);
    signal cs : state;
    -- Alias to identify the instructions based on the 'opcode' and 'funct' fields
    alias  opcode: std_logic_vector(5 downto 0) is flg.instruction(31 downto 26);
    alias  funct: std_logic_vector(5 downto 0) is flg.instruction(5 downto 0);

    -- Retrieves the rs field from the instruction
    alias rs: std_logic_vector(4 downto 0) is flg.instruction(25 downto 21);
    -- Retrieves the rt field from the instruction
    alias rt: std_logic_vector(4 downto 0) is flg.instruction(20 downto 16);
    -- Retrieves the rd field from the instruction
    alias rd: std_logic_vector(4 downto 0) is flg.instruction(15 downto 11);

    signal decodedInstruction: operation_type;

begin

    ctrl.ALUop <= decodedInstruction;     -- Used to set the ALU operation

    -- Instruction decode
    decodedInstruction <=   ADD     when (opcode = "000000" and funct = "100000") or cs = s0  or cs = s1 else
                            --we use add on state 0 and 1 (for pc and branch instructions)
                            XXOR    when opcode = "000000" and funct = "100110" else
                            SLT     when opcode = "000000" and funct = "101010" else
                            SLTU    when opcode = "000000" and funct = "101011" else
                            SSLL    when opcode = "000000" and funct = "000000" else
                            SW      when opcode = "101011" else
                            LW      when opcode = "100011" else
                            ADDI    when opcode = "001000" else
                            ORI     when opcode = "001101" else
                            BEQ     when opcode = "000100" else
                            BNE     when opcode = "000101" else
                            LUI     when opcode = "001111" and rs = "00000" else
                            INVALID_INSTRUCTION;
                            --if INVALID_INSTRUCTION, ALU returns XXXXXXX (this is considered an error)

    state_logic : process(flg.instruction, clock, reset)
    begin
        if reset = '1' then
            cs <= s0;
        elsif rising_edge(clock) then
            case cs is
                when s0 =>
                    cs <= s1;
                when s1 =>
                    if opcode = "000000" then       --R type
                        cs <= s2;
                    elsif opcode = "001000" or opcode = "001111" or opcode = "001101" then
                        --for immediate operations addi, lui, ori:
                        cs <= s4;
                    elsif opcode = "000100" or opcode = "000101" then
                        cs <= s6;                                               --beq or bne
                    elsif opcode = "101011" or opcode = "100011" then           --sw or lw
                        cs <= s7;
                    end if;
                when s2 =>
                    cs <= s3;
                when s3 =>
                    cs <= s0;
                when s4 =>
                    cs <= s5;
        		when s5 =>
        		    cs <= s0;
                when s6 =>
                    cs <= s0;
                when s7 =>
                    cs <= s8;
                when s8 =>
                    if opcode = "101011" then       --sw
                        cs <= s0;
                    elsif opcode = "100011" then    --lw
                        cs <= s9;
                    end if;
                when s9 =>
                    cs <= s0;
            end case;
        end if;
    end process;

    
    --note that some signals are mealy (depend on state and input)
    ctrl.PCSource <= '1' when cs = s6 else '0';
    ctrl.WrPC <= '1' when cs = s0  or (cs = s6 and ((opcode = "000100" and flg.zero = '1')  or (opcode = "000101" and flg.zero = '0'))) else '0';
    ctrl.WrRfile <= '1' when cs = s3 or cs = s5 or cs = s9 else '0';
    ctrl.RegDst <= '1' when cs = s3 else '0';
    ctrl.WrIR <= '1' when cs = s0 else '0';
    ctrl.MemToReg <= '1' when cs = s9 else '0';
    ctrl.WrMem <= '1' when cs = s8 and opcode = "101011" else '0';  --for sw
    ctrl.WrMDR <= '1' when cs = s8 and opcode = "100011" else '0';  --for lw
    ctrl.IorD <= '1' when cs = s8 else '0';                         --Selects instruction address or Data address
    ctrl.WrA <= '1' when cs = s1 else '0';
    ctrl.WrB <= '1' when cs = s1 else '0';
    ctrl.ALUSrcB <= "11" when cs = s1 else
                    "10" when cs = s4 or cs = s7 or (cs = s2 and funct = "000000") else    --used if the R-type is SLL
                    "01" when cs = s0 else
                    "00";
    ctrl.ALUSrcA <= '0' when cs = s0 or cs = s1 else '1';   -- 0 selects the pc and we only use it in the ALU in the fetch phase
    ctrl.WrALU  <= '1' when cs = s1 or cs = s2 or cs = s4 or cs = s7 else '0';

end architecture;
