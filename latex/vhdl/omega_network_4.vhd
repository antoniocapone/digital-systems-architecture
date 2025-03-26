library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity omega_network_4 is
	port(
		x0 : in std_logic_vector(0 to 1);
		x1 : in std_logic_vector(0 to 1);
		x2 : in std_logic_vector(0 to 1);
		x3 : in std_logic_vector(0 to 1);
		s_i : in std_logic_vector(1 downto 0);
		s_o : in std_logic_vector(1 downto 0);
		y0 : out std_logic_vector(0 to 1);
		y1 : out std_logic_vector(0 to 1);
		y2 : out std_logic_vector(0 to 1);
		y3 : out std_logic_vector(0 to 1)
	);
end omega_network_4;

architecture structural of omega_network_4 is
	component switch_2_2_2bit
	port(
		x0 : in std_logic_vector(0 to 1);
		x1 : in std_logic_vector(0 to 1);
		s_i : in std_logic;
		s_o : in std_logic;
		y0 : out std_logic_vector(0 to 1);
		y1 : out std_logic_vector(0 to 1)
	);
	end component;
	
	signal interconnection_0_1 : std_logic_vector(0 to 1);
	signal interconnection_0_3 : std_logic_vector(0 to 1);
	signal interconnection_2_1 : std_logic_vector(0 to 1);
	signal interconnection_2_3 : std_logic_vector(0 to 1);
begin
	sw_0 : switch_2_2_2bit
	port map(
		x0 => x0,
		x1 => x2,
		s_i => s_i(1),
		s_o => s_o(1),
		y0 => interconnection_0_1,
		y1 => interconnection_0_3
	);
	
	sw_1 : switch_2_2_2bit
	port map(
		x0 => interconnection_0_1,
		x1 => interconnection_2_1,
		s_i => s_i(0),
		s_o => s_o(0),
		y0 => y0,
		y1 => y1
	);
	
	sw_2 : switch_2_2_2bit
	port map(
		x0 => x1,
		x1 => x3,
		s_i => s_i(1),
		s_o => s_o(1),
		y0 => interconnection_2_1,
		y1 => interconnection_2_3
	);
	
	sw_3 : switch_2_2_2bit
	port map(
		x0 => interconnection_0_3,
		x1 => interconnection_2_3,
		s_i => s_i(0),
		s_o => s_o(0),
		y0 => y2,
		y1 => y3
	);
end structural;
