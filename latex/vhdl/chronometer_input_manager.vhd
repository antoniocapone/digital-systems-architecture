library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity input_manager is
	port(
		clock : in std_logic;
		button_hours : in std_logic;
		button_minutes : in std_logic;
		button_seconds : in std_logic;
		switches : in std_logic_vector(5 downto 0);
		value: out std_logic_vector(0 to 16)
	);
end input_manager;

architecture behavioral of input_manager is

	signal value_sig : std_logic_vector(0 to 16) := (others => '0');

begin
	value <= value_sig;
	process(clock)
	begin
		if clock'event and clock = '1' then
			if button_seconds = '1' then
				value_sig(11 to 16) <= switches;
			elsif button_minutes = '1' then
				value_sig(5 to 10) <= switches;
			elsif button_hours = '1' then
				value_sig(0 to 4) <= switches(4 downto 0);
			end if;
		end if;
	end process;
end behavioral;
