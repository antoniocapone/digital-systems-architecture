library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity system is
	port(
		x0 : in std_logic_vector(0 to 3);
		x1 : in std_logic_vector(0 to 3);
		x2 : in std_logic_vector(0 to 3);
		x3 : in std_logic_vector(0 to 3);
		enable : in std_logic_vector(0 to 3);
		y0 : out std_logic_vector(0 to 1);
		y1 : out std_logic_vector(0 to 1);
		y2 : out std_logic_vector(0 to 1);
		y3 : out std_logic_vector(0 to 1)
	);
end system;

architecture structural of system is

	component omega_network_4
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
	end component;
	
	component priority_manager
	port(
		enable : in std_logic_vector(0 to 3);
		dest_0 : in std_logic_vector(1 downto 0);
		dest_1 : in std_logic_vector(1 downto 0);
		dest_2 : in std_logic_vector(1 downto 0);
		dest_3 : in std_logic_vector(1 downto 0);
		s_i : out std_logic_vector(1 downto 0);
		s_o : out std_logic_vector(1 downto 0)
	);
	end component;
	
	signal s_i : std_logic_vector(1 downto 0);
	signal s_o : std_logic_vector(1 downto 0);

begin
	omega_network : omega_network_4
	port map(
		x0 => x0(0 to 1),
		x1 => x1(0 to 1),
		x2 => x2(0 to 1),
		x3 => x3(0 to 1),
		s_i => s_i,
		s_o => s_o,
		y0 => y0,
		y1 => y1,
		y2 => y2,
		y3 => y3
	);
	
	priority_mgr : priority_manager
	port map(
		enable => enable,
		dest_0 => x0(2 to 3),
		dest_1 => x1(2 to 3),
		dest_2 => x2(2 to 3),
		dest_3 => x3(2 to 3),
		s_i => s_i,
		s_o => s_o
	);
end structural;
