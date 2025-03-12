library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity system_B is
	port(
		clock : in std_logic;
		reset : in std_logic;
		req : in std_logic;
		data : in std_logic_vector(0 to 3);
		ack : out std_logic
	);
end system_B;

architecture structural of system_B is

	component control_unit_B
	port(
		clock : in std_logic;
		reset : in std_logic;
		buffer_load : out std_logic;
		register_load : out std_logic;
		req : in std_logic;
		ack : out std_logic
	);
	end component;

	component register_M
	generic(
		M : in integer := 8
	);
	port(
		clock : in std_logic;
		reset : in std_logic;
		load : in std_logic;
		input : in std_logic_vector (M - 1 downto 0);
		output : out std_logic_vector(M - 1 downto 0)
	);
	end component;
	
	component carry_look_ahead_adder_4
	port(
		x : in std_logic_vector(3 downto 0);
		y : in std_logic_vector(3 downto 0);
		s : out std_logic_vector(4 downto 0)
	);
	end component;
	
	signal buffer_load : std_logic;
	signal buffer_output : std_logic_vector(0 to 3);
	signal register_load : std_logic;
	signal cla_output : std_logic_vector(4 downto 0);
	signal register_output : std_logic_vector(0 to 3);

begin
	control_unit : control_unit_B
	port map(
		clock => clock,
		reset => reset,
		buffer_load => buffer_load,
		register_load => register_load,
		req => req,
		ack => ack
	);
	
	buff : register_M
	generic map(
		M => 4
	)
	port map(
		clock => clock,
		reset => reset,
		load => buffer_load,
		input => data,
		output => buffer_output
	);
	
	cla : carry_look_ahead_adder_4
	port map(
		x => buffer_output,
		y => register_output,
		s => cla_output
	);
	
	reg : register_M
	generic map(
		M => 4
	)
	port map(
		clock => clock,
		reset => reset,
		load => register_load,
		input => cla_output(3 downto 0),
		output => register_output
	); 
end structural;
