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
	c(1) <= G(0) or
			(c(0) and P(0));
	c(2) <= G(1) or
			(G(0) and P(1)) or
			(c(0) and P(1) and P(0));
	c(3) <= G(2) or
			(G(1) and P(2)) or
			(G(0) and P(2) and P(1)) or
			(c(0) and P(2) and P(1) and P(0));
	c(4) <= G(3) or
			(G(2) and P(3)) or
			(G(1) and P(3) and P(2)) or
			(G(0) and P(3) and P(2) and P(1)) or
			(c(0) and P(3) and P(2) and P(1) and P(0));
	
	xor_array : for i in 0 to 3 generate
		s(i) <= x(i) xor y(i) xor c(i);
	end generate;
	s(4) <= c(4);
end dataflow;
