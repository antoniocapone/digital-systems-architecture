library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity carry_look_ahead_adder_4 is
	port(
		x : in std_logic_vector(3 downto 0);
		y : in std_logic_vector(3 downto 0);
		s : out std_logic_vector(4 downto 0)
	);
end carry_look_ahead_adder_4;

architecture dataflow of carry_look_ahead_adder_4 is
	signal G : std_logic_vector(3 downto 0);
	signal P : std_logic_vector(3 downto 0);
	signal c : std_logic_vector(4 downto 0);
begin
	gen_prop_block: for i in 0 to 3 generate
		G(i) <= x(i) and y(i);
		P(i) <= x(i) or y(i);
	end generate;
	
	c(0) <= '0';
	
	carry_look_ahead : for i in 1 to 4 generate
		c(i) <= G(i - 1) or (c(i - 1) and P(i - 1));
	end generate;
	
	xor_array : for i in 0 to 3 generate
		s(i) <= x(i) xor y(i) xor c(i);
	end generate;
	s(4) <= c(4);
end dataflow;
