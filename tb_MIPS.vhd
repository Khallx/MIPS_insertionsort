library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.MIPS_package.all;


entity MIPS_multiciclo is
end MIPS_multiciclo;


architecture structural of MIPS_multiciclo is
    constant PC_START_ADDRESS : std_logic_vector(31 downto 0) := x"00400000";
    constant START : integer := TO_INTEGER(UNSIGNED(PC_START_ADDRESS));
    constant size : integer := 20; --memory size

    signal clock: std_logic := '0';
    signal reset, MemWrite: std_logic;
    signal Address, instruction, data_in, data_out : std_logic_vector(31 downto 0);
    signal ctrl : control;
    signal flg : flags;

begin
    --we should make a single MIPS entity but who cares
    control_path: entity work.controlpath
      port map(
        clock => clock,
        reset => reset,
        flg => flg,
        ctrl => ctrl
      );

    data_path: entity work.datapath
      generic map(
        PC_START_ADDRESS => START
      )
      port map(
        clock => clock,
        reset => reset,
        Address => address,
        data_in => data_in,
        data_out => data_out,
        ctrl => ctrl,
        flg => flg
      );

      RAM: entity work.memory
        generic map(
            SIZE => SIZE,
            START_ADDRESS => PC_START_ADDRESS,
            imageFileName => "text.txt"
        )
        port map(
            clock => clock,
            MemWrite => ctrl.WrMem,
            address => address,
            data_i => data_in,
            data_o => data_out
        );

end architecture;
