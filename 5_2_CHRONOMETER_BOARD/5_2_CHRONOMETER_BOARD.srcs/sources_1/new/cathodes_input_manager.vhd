library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity cathodes_input_manager is
	port(
		counter : in std_logic_vector(2 downto 0);
		value: in std_logic_vector(0 to 16);
		nibble_out : out std_logic_vector(3 downto 0);
		dot_out : out std_logic
	);
end cathodes_input_manager;

architecture behavioral of cathodes_input_manager is

	signal seconds : integer range 0 to 59;
	signal minutes : integer range 0 to 59;
	signal hours : integer range 0 to 23;

begin
	seconds <= to_integer(unsigned(value(11 to 16)));
	minutes <= to_integer(unsigned(value(5 to 10)));
	hours	<= to_integer(unsigned(value(0 to 4)));
	with counter select
		nibble_out <=	std_logic_vector(to_unsigned(hours / 10, 4))		when "101",
						std_logic_vector(to_unsigned(hours mod 10, 4))		when "100",
						std_logic_vector(to_unsigned(minutes / 10, 4))		when "011",
						std_logic_vector(to_unsigned(minutes mod 10, 4))	when "010",
						std_logic_vector(to_unsigned(seconds / 10, 4))		when "001",
						std_logic_vector(to_unsigned(seconds mod 10, 4))	when "000",
						"0000" when others;
	with counter select
		dot_out <=	'1' when "100",
					'1' when "010",
					'0' when others;
end behavioral;
