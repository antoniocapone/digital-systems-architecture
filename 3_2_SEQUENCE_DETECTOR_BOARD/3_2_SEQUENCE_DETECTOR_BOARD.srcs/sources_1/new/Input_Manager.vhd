library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Input_Manager is
	port(
		clock : in std_logic;
		input : in std_logic_vector (0 to 1);
		load_next : in std_logic;
		change_mode : in std_logic;
		detector_input : out std_logic;
		detector_M : out std_logic;
		detector_enable : out std_logic
	);
end Input_Manager;

architecture behavioral of Input_Manager is
	
begin
	input_manager : process(clock)
	begin
		if clock'event and clock = '1' then
			detector_enable <= '0';
			if load_next = '1' then
				detector_input <= input(0);
				detector_enable <= '1';
			elsif change_mode = '1' then
				detector_M <= input(1);
			end if;
		end if;
	end process;
end behavioral;
