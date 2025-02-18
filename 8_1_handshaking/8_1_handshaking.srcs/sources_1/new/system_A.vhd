library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity system_A is
	port(
		clock: in std_logic;
		reset: in std_logic;
		start: in std_logic;
		req: out std_logic;
		data: out std_logic_vector(0 to 7);
		ack: in std_logic
	);
end system_A;

architecture structural of system_A is
	component control_unitA
		port(
			clock: in std_logic;
			reset: in std_logic;
			start: in std_logic;
			counter_enable: out std_logic;
			counter_reset: out std_logic;
			counter_Q: in std_logic;
			read: out std_logic;
			req: out std_logic;
			ack: in std_logic
		);
	end component;
	
	component ROM
		port(
			clock: in std_logic;
			read : in std_logic;
			address : in std_logic_vector(2 downto 0);
			output : out std_logic_vector(0 to 7)
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
	
	signal read_rom: std_logic := '0';
	signal address_A: std_logic_vector(2 downto 0) := (others => '0');
	signal counter_enable: std_logic := '0';
	signal counter_reset: std_logic := '0';
	signal counter_Q: std_logic := '0';
	
begin
	cu : control_unitA
	port map(
		clock => clock,
		reset => reset,
		start => start,
		counter_enable => counter_enable,
		counter_reset => counter_reset,
		counter_Q => counter_Q,
		read => read_rom,
		req => req,
		ack => ack
	);
	
	rom_8 : ROM
	port map(
		clock => clock,
		read => read_rom,
		address => address_A,
		output => data
	);

	cnt: counter
	port map(
		clock => clock,
		enable => counter_enable,
		reset => counter_reset,
		output => address_A,
		Q => counter_Q
	);
end structural;
