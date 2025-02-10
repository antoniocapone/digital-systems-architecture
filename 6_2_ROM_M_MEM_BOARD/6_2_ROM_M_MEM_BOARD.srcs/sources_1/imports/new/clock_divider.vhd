library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity clock_divider is
	generic(
		clock_frequency_in : integer := 100000000;	--100MHz
		clock_frequency_out : integer := 500 		--500 Hz
	);
	port(
		clock : in  std_logic;
		reset : in std_logic;
		clock_divided : out  std_logic
	);
end clock_divider;

architecture Behavioral of clock_divider is

	constant count_max_value : integer := (clock_frequency_in/clock_frequency_out) -1;
	
	signal clock_sig: std_logic := '0';

begin
	clock_divided <= clock_sig;
	
	process(clock)
	variable counter : integer range 0 to count_max_value := 0;
	begin
		if clock'event and clock = '1' then
			if reset = '1' then
				counter := 0;
				clock_sig <= '0';
			else
				if counter = count_max_value then
					clock_sig <=  '1';
					counter := 0;
				else
					clock_sig <=  '0';
					counter := counter + 1;
				end if;
			end if;
		end if;
	end process;
end behavioral;
