library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity M is
	port(
		input : in std_logic_vector (0 to 7);
		output : out std_logic_vector (0 to 3)
	);
end M;

architecture dataflow of M is

begin
	output(0) <= input(0) and input(1);
	output(1) <= input(2) and input(3);
	output(2) <= input(4) and input(5);
	output(3) <= input(6) and input(7);
end dataflow;