library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity COUNTER_TESTBENCH is
end COUNTER_TESTBENCH;

architecture behavioral of COUNTER_TESTBENCH is

    constant CLK_PERIOD: time := 20ns;

    signal GEN_CLK: std_logic := '0';
    signal en: std_logic := '0';
    signal rst: std_logic := '0';
    signal output: std_logic_vector(2 downto 0);
    signal q: std_logic;

    component COUNTER_MOD_8
    port (
        clk: in std_logic;
        en: in std_logic;
        rst: in std_logic;
        output: out std_logic_vector(2 downto 0) := "000"; -- counter exit
        q: out std_logic -- EOC bit
    );
    end component;

begin

    dut: COUNTER_MOD_8
    port map (
        clk => GEN_CLK,
        en => en,
        rst => rst,
        output => output,
        q => q
    );
    
    clk_proc: process
    begin
        GEN_CLK <= '1';
        wait for CLK_PERIOD / 2;
        GEN_CLK <= '0';
        wait for CLK_PERIOD / 2;
    end process;

    stim_proc: process
    begin
        wait for 20ns;
        en <= '1';
        wait for 300ns;
        rst <= '1';
        wait for 30ns;
        rst <= '0';
        wait for 30ns;
        en <= '0';
        wait;
    end process;

end behavioral;
