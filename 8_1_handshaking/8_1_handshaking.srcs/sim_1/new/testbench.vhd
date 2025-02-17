library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity testbench is
--  Port ( );
end testbench;

architecture behavioral of testbench is

    signal clock : std_logic;
    signal reset : std_logic;
    signal start : std_logic;

    constant CLK_PERIOD : time := 10 ns;
    
    component handshaking
        port(
            clock: in std_logic;
            reset: in std_logic;
            start: in std_logic
        );
    end component;

begin

    uut: handshaking
    port map(
        clock => clock,
        reset => reset,
        start => start
    );

    CLK_process :process
	begin
		clock <= '0';
		wait for CLK_period/2;
		clock <= '1';
		wait for CLK_period/2;
	end process;
	
	test_process: process
	begin
	
	wait for 100ns;
	
	reset <= '1';
	
	wait for 15ns;
	
	reset <= '0';
	
	wait for 15ns;
	
	start <= '1';
	
	wait for 15ns;
	
	start <= '0';
	
	wait;
	
	end process;


end behavioral;
