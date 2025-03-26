library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity dmux_1_2_2bit is
	port(
		i : in std_logic_vector(0 to 1);
		s : in std_logic;
		y0 : out std_logic_vector(0 to 1);
		y1 : out std_logic_vector(0 to 1)
	);
end dmux_1_2_2bit;

architecture dataflow of dmux_1_2_2bit is
begin
	y0 <= i when s = '0' else "00";
	y1 <= i when s = '1' else "00";
end dataflow;
