library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.MIPS_package.all;


entity DataPath is
    generic (
        PC_START_ADDRESS    : integer := 0
    );
    port (
        clock               : in  std_logic;
        reset               : in  std_logic;
        Address           : out std_logic_vector(31 downto 0);
        data_in           : in  std_logic_vector(31 downto 0);
        data_out          : out std_logic_vector(31 downto 0);
        ctrl              : in  control;                        --control path controls
        flg               : out flags                            --control path flags
    );
end DataPath;


architecture structural of DataPath is
    signal instruction, pc, MUXpc, MDR, result, readData1, readData2, A, B, ALUoperand1, ALUoperand2, ALUout, writeData: std_logic_vector(31 downto 0);
    signal rs, rt, rd : std_logic_vector(4 downto 0);
    signal writeRegister : std_logic_vector(4 downto 0);
    signal immediate : std_logic_vector(15 downto 0);       --holds the constant part of instructions
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

    Pogram_counter: entity work.RegisterNbits
        generic map(
            LENGTH => 32,
            INIT_VALUE  => PC_START_ADDRESS
        )
        port map(
            clock  => clock,
            reset  => reset,
            ce     => ctrl.WrPC,
            d      => MUXpc,
            q      => pc
        );

    Memory_data_register: entity work.RegisterNbits
        generic map(
            LENGTH => 32,
            INIT_VALUE  => 0
        )
        port map(
            clock  => clock,
            reset  => reset,
            ce     => ctrl.WrMDR,
            d      => data_in,
            q      => MDR
        );

    Instruction_register: entity work.RegisterNbits
        generic map(
            LENGTH => 32,
            INIT_VALUE  => 0
        )
        port map(
            clock  => clock,
            reset  => reset,
            ce     => ctrl.WrIR,
            d      => data_in,
            q      => instruction
        );

    --selects which register is written on based on instruction
    writeRegister <= rd when ctrl.RegDst = '1' else rt;
    --chooses which data is written in register file
    writeData <= MDR when ctrl.MemToReg = '1' else ALUout;

    Register_file: entity work.RegisterFile
        port map(
            clock   => clock,
            reset   => reset,
            write   => ctrl.WrRfile,
            readRegister1   => rs,
            readRegister2   => rt,
            writeRegister   => writeRegister,
            writeData       => writeData,
            readData1       => readData1,
            readData2       => readData2
        );

    --register A stores data read from register file
    A_reg:  entity work.RegisterNbits
        generic map(
            LENGTH => 32,
            INIT_VALUE  => 0
        )
        port map(
            clock  => clock,
            reset  => reset,
            ce     => ctrl.WrA,
            d      => readData1,
            q      => A
        );

    --register B stores data read from register file
    B_reg:  entity work.RegisterNbits
        generic map(
            LENGTH => 32,
            INIT_VALUE  => 0
        )
        port map(
            clock  => clock,
            reset  => reset,
            ce     => ctrl.WrB,
            d      => readData2,
            q      => B
        );

    ext_immediate(15 downto 0) <= immediate;    --extends signal
    ext_immediate(31 downto 16) <= x"ffff" when immediate(15) = '1' else x"0000";


    ALUoperand1 <= A when ctrl.ALUSrcA = '1' else PC;

    ALUoperand2 <= x"00000004" when ctrl.ALUSrcB = "01" else
                   ext_immediate when ctrl.ALUSrcB = "10" else
                   ext_immediate(29 downto 0) & "00" when ctrl.ALUSrcB = "11" else
                   B;

    ALU: entity work.ALU
	port map(
            operand1    => ALUoperand1,
            operand2    => ALUoperand2,
            result      => result,
            zero        => flg.zero,
            operation   => ctrl.ALUop
        );

    --register that stores ULA results
    ALU_out: entity work.RegisterNbits
        generic map(
            LENGTH => 32,
            INIT_VALUE  => 0
        )
        port map(
            clock  => clock,
            reset  => reset,
            ce     => ctrl.WrALU,
            d      => result,
            q      => ALUout
        );

    --memory interface
    address <= ALUout when ctrl.IorD = '1' else PC;
    data_out <= B;
end architecture;
