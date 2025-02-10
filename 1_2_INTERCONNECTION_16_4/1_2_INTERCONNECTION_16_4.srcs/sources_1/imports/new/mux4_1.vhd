library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity mux4_1 is
	port(
		a : in std_logic_vector(0 to 3);
		s : in std_logic_vector(1 downto 0);
		y : out std_logic 
	);
end mux4_1;

architecture dataflow of mux4_1 is
begin
	with s select
		y <=	a(0) when "00",
				a(1) when "01",
				a(2) when "10",
				a(3) when "11",
				'-' when others;
end dataflow;
