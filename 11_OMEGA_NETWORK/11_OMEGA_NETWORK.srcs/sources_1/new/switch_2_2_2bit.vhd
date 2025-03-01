library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity switch_2_2_2bit is
	port(
		x0 : in std_logic_vector(0 to 1);
		x1 : in std_logic_vector(0 to 1);
		s_i : in std_logic;
		s_o : in std_logic;
		y0 : out std_logic_vector(0 to 1);
		y1 : out std_logic_vector(0 to 1)
	);
end switch_2_2_2bit;

architecture structural of switch_2_2_2bit is
	component mux_2_1_2bit
	port(
		a0 : in std_logic_vector(0 to 1);
		a1 : in std_logic_vector(0 to 1);
		s : in std_logic;
		y : out std_logic_vector(0 to 1)
	);
	end component;
	
	component dmux_1_2_2bit
	port(
		i : in std_logic_vector(0 to 1);
		s : in std_logic;
		y0 : out std_logic_vector(0 to 1);
		y1 : out std_logic_vector(0 to 1)
	);
	end component;
	
	signal interconnection : std_logic_vector(0 to 1);
begin
	mux : mux_2_1_2bit
	port map(
		a0 => x0,
		a1 => x1,
		s => s_i,
		y => interconnection
	);
	
	dmux : dmux_1_2_2bit
	port map(
		i => interconnection,
		s => s_o,
		y0 => y0,
		y1 => y1
	);
end structural;
