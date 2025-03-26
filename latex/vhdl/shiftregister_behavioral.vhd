library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity shiftregister_behavioral is
	generic(
		bit_number : integer := 8
	);
	port(
		clock : in std_logic;
		reset : in std_logic;
		load : in std_logic;
		Y : in std_logic;
		shift_left : in std_logic;
		input : in std_logic_vector(0 to bit_number - 1);
		output : out std_logic_vector(0 to bit_number - 1)
	);
end shiftregister_behavioral;

architecture behavioral of shiftregister_behavioral is
	signal bit_array : std_logic_vector(0 to bit_number - 1) := (others => '0');
begin
	output <= bit_array;
	process(clock)
	begin
		if clock'event and clock = '1' then
			if reset = '1' then
				bit_array <= (others => '0');
			elsif load = '1' then
				bit_array <= input;
			else
				if shift_left = '1' then
					if Y = '0' then
						bit_array <= bit_array(1 to bit_number - 1) & bit_array(0);
					else
						bit_array <= bit_array(2 to bit_number - 1) & bit_array(0 to 1);
					end if;
				else
					if Y = '0' then
						bit_array <= bit_array(bit_number - 1) & bit_array(0 to bit_number - 2);
					else
						bit_array <= bit_array(bit_number - 2 to bit_number - 1) & bit_array(0 to bit_number - 3);
					end if;
				end if;
			end if;
		end if;
	end process;
end behavioral;
