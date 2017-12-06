library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.MIPS_package.all;


entity DataPath is
    generic (
        PC_START_ADDRESS    : integer := 0
    );
    port (
        clk               : in  std_logic;
        rst               : in  std_logic;
        Address         : out std_logic_vector(31 downto 0);  -- Data memory address bus
        data_in             : in  std_logic_vector(31 downto 0);  -- Data bus from data memory
        data_out            : out std_logic_vector(31 downto 0);  -- Data bus to data memory
        ctrl                : in  command;                        --control path controls
        flg                 : out flags                            --control path flags
    );
end DataPath;


architecture structural of DataPath is
    signal instruction, pc, MUXpc, MDR, result, readData1, readData2, A, B, ALUoperand1, ALUoperand2, ALUout, offset32bits, writeData: std_logic_vector(31 downto 0);
    signal rs, rt, rd : std_logic_vector(4 downto 0);
    signal writeRegister : std_logic_vector(4 downto 0);
    signal immediate : std_logic_vector(15 downto 0);   --holds the constant part of instructions
    signal ext_immediate : std_logic_vector(31 downto 0);   --immediate with extended signal

begin
    --instruction to be decoded by the control block
    flg.instruction <= instruction;
    -- Retrieves the rs field from the instruction
    rs <= instruction(25 downto 21);
    -- Retrieves the rt field from the instruction
    rt <= instruction(20 downto 16);
    -- Retrieves the rd field from the instruction
    rd <= instruction(15 downto 11);
    --holds the constant part of instructions
    immediate <= instruction(15 downto 0);


    MUXpc <= ALUout when ctrl.PCSource = '1' else result;
    PC: entity work.RegisterNbits
        generic map(
            LENGTH => 32,
            INIT_VALUE  => PC_START_ADDRESS
        );
        port (
            clock  => clk,
            reset  => rst,
            ce     => ctrl.WrPC,
            d      => MUXpc,
            q      => pc
        );

    Memory_data_register: entity work.RegisterNbits
        generic map(
            LENGTH => 32,
            INIT_VALUE  => 0
        );
        port (
            clock  => clk,
            reset  => rst,
            ce     => ctrl.WrMDR,
            d      => data_in,
            q      => MDR
        );

    Instruction_register: entity work.RegisterNbits
        generic map(
            LENGTH => 32,
            INIT_VALUE  => 0
        );
        port (
            clock  => clk,
            reset  => rst,
            ce     => ctrl.WrIR,
            d      => data_in,
            q      => instruction
        );

    --selects which register is written on based on instruction
    MUX_RF: writeData <= rd when ctrl.RegDst = '1' else rt;

    Register_file: entity work.RegisterFile
        port map(
            clock   => clk,
            reset   => rst,
            write   => ctrl.WrRfile,
            readRegister1   => readData1,
            readRegister2   => readData2,
            writeRegister   => writeRegister,
            writeData       => writeData,
            readData1       => rs,
            readData2       => rt
        );

    --register A stores data read from register file
    A:  entity work.RegisterNbits
        generic map(
            LENGTH => 32,
            INIT_VALUE  => 0
        );
        port (
            clock  => clk,
            reset  => rst,
            ce     => ctrl.WrA,
            d      => readData1,
            q      => A
        );

    --register B stores data read from register file
    B:  entity work.RegisterNbits
        generic map(
            LENGTH => 32,
            INIT_VALUE  => 0
        );
        port (
            clock  => clk,
            reset  => rst,
            ce     => ctrl.WrB,
            d      => readData2,
            q      => B
        );

    ext_immediate(15 downto 0) <= immediate;    --extends signal
    ext_immediate(31 downto 0) <= x"ffff" when immediate(immediate'left) = '1' else x"0000";
    --register that stores ULA results

    ALUoperand1 <= A when ALUSrcA = '1' else PC;

    ALUoperand2 <= x"00000004" when ALUSrcB = "01" else
                   ext_immediate when ALUSrcB = "10" else
                   ext_immediate(29 downto 0) && "00" when ALUSrcB = "11" else
                   B;

    ALU: entity work.ALU
            operand1    => ALUoperand1,
            operand2    => ALUoperand2,
            result      => result,
            zero        => flg.zero,
            operation   => cmd.ALUop
        );


    ALU_out: entity work.RegisterNbits
        generic map(
            LENGTH => 32,
            INIT_VALUE  => 0
        );
        port (
            clock  => clk,
            reset  => rst,
            ce     => ctrl.WrALU,
            d      => result,
            q      => ALUout
        );

end architecture;
