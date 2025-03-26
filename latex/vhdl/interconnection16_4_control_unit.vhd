library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity control_unit is
	port(
		clock : in  std_logic;
		load_first_part : in  std_logic;
		load_second_part :in  std_logic;
		bits_in : in std_logic_vector (0 to 7);
		bits_out : out std_logic_vector (0 to 15)
	);
end control_unit;

architecture behavioral of control_unit is
	
	signal input : std_logic_vector (0 to 15) := (others => '0');

begin
	bits_out <= input;
	
	process (clock)
	begin
		if clock'event and clock = '1' then
			if load_first_part = '1' then
				input (0 to 7) <= bits_in;
			elsif load_second_part = '1' then
				input (8 to 15) <= bits_in;
			end if;
		end if;
	end process;

end behavioral;
