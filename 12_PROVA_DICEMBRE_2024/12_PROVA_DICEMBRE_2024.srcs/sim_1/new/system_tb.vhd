library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity system_tb is
end system_tb;

architecture behavioral of system_tb is

    signal clkA: std_logic;
    signal clkB: std_logic;
    signal startA: std_logic;

    component PROVA_DICEMBRE
        port (
            clkA: in std_logic;
            clkB: in std_logic;
            startA: in std_logic
        );
    end component;

begin

    uut: PROVA_DICEMBRE
    port map (
        clkA => clkA,
        clkB => clkB,
        startA => startA
    );
    
    clkA_proc: process
    begin
        clkA <= '1';
        wait for 20ns;
        clkA <= '0';
        wait for 20ns;
    end process;
    
    clkB_proc: process
    begin
        clkB <= '1';
        wait for 50ns;
        clkB <= '0';
        wait for 50ns;
    end process;
    
    stim_proc: process
    begin
        wait for 10ns;
        startA <= '1';
        wait for 20ns;
        startA <= '0';
        wait for 700ns;
        wait;
    end process;

end behavioral;
