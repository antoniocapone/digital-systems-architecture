library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity S is
	port(
		input : in std_logic_vector (0 to 3);
		output: out std_logic_vector (0 to 3)
	);
end S;

architecture structural of S is
	signal data : std_logic_vector (0 to 7) := (others => '0');

	component ROM
	port(
		address : in std_logic_vector(3 downto 0);
		data : out std_logic_vector(7 downto 0)
	);
	end component;
	
	component M
	port(
		input : in std_logic_vector (0 to 7);
		output : out std_logic_vector (0 to 3)
	);
	end component;
	
begin
	rom_16_8 : ROM
	port map(
		address => input,
		data => data
	);
	
	m_comb : M
	port map(
		input => data,
		output => output
	);
end structural;
