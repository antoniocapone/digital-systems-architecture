library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity priority_manager is
	port(
		enable : in std_logic_vector(0 to 3);
		dest_0 : in std_logic_vector(1 downto 0);
		dest_1 : in std_logic_vector(1 downto 0);
		dest_2 : in std_logic_vector(1 downto 0);
		dest_3 : in std_logic_vector(1 downto 0);
		s_i : out std_logic_vector(1 downto 0);
		s_o : out std_logic_vector(1 downto 0)
	);
end priority_manager;

architecture dataflow of priority_manager is
begin
	s_i <= "00" when enable(0) = '1' else
		   "01" when enable(1) = '1' else
		   "10" when enable(2) = '1' else
		   "11" when enable(3) = '1' else
		   "--";
	s_o <= dest_0 when enable(0) = '1' else
		   dest_1 when enable(1) = '1' else
		   dest_2 when enable(2) = '1' else
		   dest_3 when enable(3) = '1' else
		   "--";
end dataflow;
