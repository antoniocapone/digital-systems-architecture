library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity adder is
	generic(
		M : in integer := 8
	);
	port(
		x : in std_logic_vector(M - 1 downto 0);
		y : in std_logic_vector(M - 1 downto 0);
		output : out std_logic_vector(M - 1 downto 0)
	);
end adder;

architecture dataflow of adder is
begin
	output <= std_logic_vector(unsigned(x) + unsigned(y));
end dataflow;
