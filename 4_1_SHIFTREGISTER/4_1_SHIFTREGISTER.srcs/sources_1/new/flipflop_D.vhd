library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity flipflop_D is
	port(
		clock : in std_logic;
		reset : in std_logic;
		d : in std_logic;
		y : out std_logic
	);
end flipflop_D;

architecture behavioral of flipflop_D is
begin
	process(clock)
	begin
		if clock'event and clock = '1' then
			if reset = '1' then
				y <= '0';
			else
				y <= d;
			end if;
		end if;
	end process;
end behavioral;
