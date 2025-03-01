library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity mux_2_1_2bit is
	port(
		a0 : in std_logic_vector(0 to 1);
		a1 : in std_logic_vector(0 to 1);
		s : in std_logic;
		y : out std_logic_vector(0 to 1)
	);
end mux_2_1_2bit;

architecture dataflow of mux_2_1_2bit is
begin
	with s select
		y <= a0 when '0',
			 a1 when '1',
			 "--" when others;
end dataflow;
