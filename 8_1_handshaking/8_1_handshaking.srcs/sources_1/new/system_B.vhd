library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity system_B is
	port(
		clock: in std_logic;
		reset: in std_logic;
		start: in std_logic;
		req: in std_logic;
		data: in std_logic_vector(0 to 7);
		ack: out std_logic
	);
end system_B;

architecture structural of system_B is

	signal register_x_load : std_logic;
	signal register_x_output : std_logic_vector(7 downto 0);
	signal register_add_load : std_logic;
	signal register_add_output : std_logic_vector(7 downto 0);
	
	signal address: std_logic_vector(2 downto 0);
	signal counter_enable: std_logic;
	signal counter_reset: std_logic;
	signal counter_Q: std_logic;
	
	signal mem_write : std_logic;
	signal mem_read : std_logic;
	
	signal adder_output : std_logic_vector(7 downto 0);
	signal adder_x : std_logic_vector(7 downto 0);
	signal adder_y : std_logic_vector(7 downto 0);

	component MEM
		port(
			clock: in std_logic;
			write : in std_logic;
			read : in std_logic;
			address : in std_logic_vector(2 downto 0);
			input : in std_logic_vector(0 to 7);
			output : out std_logic_vector(0 to 7)
		);
	end component;

	
	component register_8
		port(
			clock : in std_logic;
			reset : in std_logic;
			load : in std_logic;
			input : in std_logic_vector(7 downto 0);
			output : out std_logic_vector(7 downto 0)
		);
	end component;
	
	component counter
		port(
			clock : in std_logic;
			enable : in std_logic;
			reset : in std_logic;
			output : out std_logic_vector(0 to 2);
			Q : out std_logic
		);
	end component;

	
	component control_unitB
		port(
			clock: in std_logic;
			reset: in std_logic;
			start: in std_logic;
			counter_enable: out std_logic;
			counter_reset: out std_logic;
			counter_Q: in std_logic;
			read: out std_logic;
			write: out std_logic;
			load_rx: out std_logic;
			load_sum: out std_logic;
			req: in std_logic;
			ack: out std_logic
		);
	end component;
	
	component adder
		port (
			x: in std_logic_vector(7 downto 0);
			y: in std_logic_vector(7 downto 0);
			output: out std_logic_vector(7 downto 0)
		);
	end component;
begin

	cu_B: control_unitB
	port map(
		clock => clock,
		reset => reset,
		start => start,
		counter_enable => counter_enable,
		counter_reset => counter_reset,
		counter_Q => counter_Q,
		read => mem_read,
		write => mem_write,
		load_rx => register_x_load,
		load_sum => register_add_load,
		req => req,
		ack => ack
	);
	
	reg_x: register_8
	port map(
		clock => clock,
		reset => '0',
		load => register_x_load,
		input => data,
		output => register_x_output
	);
	
	reg_add: register_8
	port map(
		clock => clock,
		reset => '0',
		load => register_add_load,
		input => adder_output,
		output => register_add_output
	);
	
	cnt_B: counter
	port map(
		clock => clock,
		enable => counter_enable,
		reset => counter_reset,
		output => address,
		Q => counter_Q
	);
	
	memB: MEM
	port map(
		clock => clock,
		write => mem_write,
		read => mem_read,
		address => address,
		input => register_add_output,
		output => adder_y
	);
	
	adder_b: adder
	port map(
		x => register_x_output,
		y => adder_y,
		output => adder_output
	);
end structural;
