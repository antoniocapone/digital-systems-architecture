library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_2_1 is
	port(
		a : in std_logic_vector(0 to 1);
		s : in std_logic;
		y : out std_logic 
	);
end mux_2_1;

architecture dataflow of mux_2_1 is
begin
	with s select
		y <=	a(0) when '0',
				a(1) when '1',
				'-' when others;
end dataflow;
