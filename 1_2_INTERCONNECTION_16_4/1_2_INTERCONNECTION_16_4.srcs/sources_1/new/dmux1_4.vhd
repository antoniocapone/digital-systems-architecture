library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity dmux1_4 is
	port(
		i : in std_logic;
		s : in std_logic_vector(1 downto 0);
		y : out std_logic_vector(0 to 3)
	);
end dmux1_4;

architecture dataflow of dmux1_4 is
begin
	y(0) <= i and not s(0) and not s(1);
	y(1) <= i and s(0) and not s(1);
	y(2) <= i and not s(0) and s(1);
	y(3) <= i and s(0) and s(1);
end dataflow;
