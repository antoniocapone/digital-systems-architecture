library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity register_8 is
	port(
		clock : in std_logic;
		reset : in std_logic;
		load : in std_logic;
		input : in std_logic_vector(7 downto 0);
		output : out std_logic_vector(7 downto 0)
	);
end register_8;

architecture behavioral of register_8 is
	signal data : std_logic_vector(7 downto 0);
begin
	output <= data;
	
	process(clock)
	begin
		if clock'event and clock = '1' then
			if reset = '1' then
				data <= (others => '0');
			elsif load = '1' then
				data <= input;
			end if;
		end if;
	end process;
end behavioral;