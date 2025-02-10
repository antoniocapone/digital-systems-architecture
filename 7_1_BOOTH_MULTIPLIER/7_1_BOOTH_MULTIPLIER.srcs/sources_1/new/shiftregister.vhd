library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity shiftregister_behavioral is
	port(
		clock : in std_logic;
		reset : in std_logic;
		load : in std_logic;
		input : in std_logic_vector(15 downto 0);
		output : out std_logic_vector(15 downto 0);
		serial_output : out std_logic
	);
end shiftregister_behavioral;

architecture behavioral of shiftregister_behavioral is
	signal bit_array : std_logic_vector(15 downto 0) := (others => '0');
begin
	output <= bit_array;
	process(clock)
	begin
		if clock'event and clock = '1' then
			if reset = '1' then
				bit_array <= (others => '0');
			elsif load = '1' then
				bit_array <= input;
				serial_output <= '0';
			else
				serial_output <= bit_array(0);
				bit_array <= bit_array(15) & bit_array(15 downto 1);
			end if;
		end if;
	end process;
end behavioral;
