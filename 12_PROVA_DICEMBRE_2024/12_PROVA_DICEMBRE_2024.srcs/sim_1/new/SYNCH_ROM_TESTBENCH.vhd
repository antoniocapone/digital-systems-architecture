library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SYNCH_ROM_TESTBENCH is
end SYNCH_ROM_TESTBENCH;

architecture behavioral of SYNCH_ROM_TESTBENCH is

    constant CLOCK_PERIOD: time := 10ns;

    signal GEN_CLK: std_logic;
    signal read: std_logic;
    signal addr: std_logic_vector(2 downto 0);
    signal data: std_logic_vector(0 to 3);

    component SYNCH_ROM
    port (
        clk: in std_logic;
        read: in std_logic;
        addr: in std_logic_vector(2 downto 0);
        data: out std_logic_vector(0 to 3)
    );
    end component;

begin

    dut: SYNCH_ROM
    port map (
        clk => GEN_CLK,
        read => read,
        addr => addr,
        data => data
    );
    
    -- Clock generation process
    clock_proc: process
    begin
        GEN_CLK <= '1';
        wait for CLOCK_PERIOD / 2;
        GEN_CLK <= '0';
        wait for CLOCK_PERIOD / 2;
    end process;
    
    -- Device test process
    stim_proc: process
    begin
        wait for 15ns;
        addr <= "000";
        read <= '1';
        wait for 15ns;
        read <= '0';
        
        wait for 15ns;
        addr <= "100";
        read <= '1';
        wait for 15ns;
        read <= '0';
        
        wait for 15ns;
        addr <= "111";
        read <= '1';
        wait for 15ns;
        read <= '0';
        
        wait for 50ns;
        read <= '1';
        wait for 10ns;
        addr <= "101";
        wait;
    end process;


end behavioral;
