library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.MATH_REAL.ALL;


entity system_A is
	generic(
		N : in integer := 8;
		M : in integer := 8
	);
	port(
		clock : in std_logic;
		reset : in std_logic;
		start : in std_logic;
		req : out std_logic;
		data : out std_logic_vector(0 to M - 1);
		ack : in std_logic
	);
end system_A;

architecture structural of system_A is

	component control_unit_A
	port(
		clock : in std_logic;
		reset : in std_logic;
		start : in std_logic;
		ack : in std_logic;
		req : out std_logic;
		counter_Q : in std_logic;
		counter_enable : out std_logic;
		counter_reset : out std_logic;
		rom_read : out std_logic
	);
	end component;
	
	component ROM_N_M
	generic(
		N : in integer := 8;
		M : in integer := 8
	);
	port(
		clock: in std_logic;
		read : in std_logic;
		address : in std_logic_vector(integer(ceil(log2(real(N)))) - 1 downto 0);
		output : out std_logic_vector(0 to M - 1)
	);
	end component;
	
	component counter
	generic(
		max_count : integer := 10
	);
	port(
		clock : in std_logic;
		enable : in std_logic;
		reset : in std_logic;
		load : in std_logic;
		input : in std_logic_vector(0 to integer(ceil(log2(real(max_count)))) - 1);
		output : out std_logic_vector(0 to integer(ceil(log2(real(max_count)))) - 1);
		Q : out std_logic
	);
	end component;
	
	signal rom_read: std_logic := '0';
	signal rom_address: std_logic_vector(integer(ceil(log2(real(N)))) - 1 downto 0) := (others => '0');
	signal counter_enable: std_logic := '0';
	signal counter_reset: std_logic := '0';
	signal counter_Q: std_logic := '0';
	
begin
	control_unit : control_unit_A
	port map(
		clock => clock,
		reset => reset,
		start => start,
		ack => ack,
		req => req,
		counter_Q => counter_Q,
		counter_enable => counter_enable,
		counter_reset => counter_reset,
		rom_read => rom_read
	);
	
	rom : ROM_N_M
	generic map(
		N => N,
		M => M
	)
	port map(
		clock => clock,
		read => rom_read,
		address => rom_address,
		output => data
	);
	
	cnt : counter
	generic map(
		max_count => N
	)
	port map(
		clock => clock,
		enable => counter_enable,
		reset => counter_reset,
		load => '0',
		input => (others => '0'),
		output => rom_address,
		Q => counter_Q
	);
end structural;
