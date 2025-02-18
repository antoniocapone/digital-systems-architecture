library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.MATH_REAL.ALL;
use IEEE.NUMERIC_STD.ALL;


entity counter is
	port(
		clock : in std_logic;
		enable : in std_logic;
		reset : in std_logic;
		output : out std_logic_vector(0 to 2);
		Q : out std_logic
	);
end counter;

architecture behavioral of counter is
begin
	process(clock)
	variable count : integer range 0 to 7 := 0;
	begin
		if clock'event and clock = '1' then
			if reset = '1' then
				count := 0;
				output <= (others => '0');
				Q <= '0';
			elsif enable = '1' then
				if count >= 7 then
					count := 0;
					Q <= '1';
				else
					count := count + 1;
					Q <= '0';
				end if;
			end if;
			output <= std_logic_vector(to_unsigned(count, 3));
		end if;
	end process;
end behavioral;