library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.MATH_REAL.ALL;


entity system_B is
	generic(
		N : in integer := 8;
		M : in integer := 8
	);
	port(
		clock : in std_logic;
		reset : in std_logic;
		req : in std_logic;
		data : in std_logic_vector(0 to M - 1);
		ack : out std_logic
	);
end system_B;

architecture behavioral of system_B is

	component control_unit_B
	port(
		clock : in std_logic;
		reset : in std_logic;
		req : in std_logic;
		ack : out std_logic;
		counter_enable : out std_logic;
		mem_read : out std_logic;
		mem_write : out std_logic;
		reg_read : out std_logic
	);
	end component;
	
	component MEM_N_M
	generic(
		N : in integer := 8;
		M : in integer := 8
	);
	port(
		clock : in std_logic;
		reset : in std_logic;
		read : in std_logic;
		write : in std_logic;
		address : in std_logic_vector(integer(ceil(log2(real(N)))) - 1 downto 0);
		input : in std_logic_vector(0 to M - 1);
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
	
	component adder
	generic(
		M : in integer := 8
	);
	port(
		x : in std_logic_vector(M - 1 downto 0);
		y : in std_logic_vector(M - 1 downto 0);
		output : out std_logic_vector(M - 1 downto 0)
	);
	end component;
	
	signal counter_enable : std_logic := '0';
	signal mem_read : std_logic := '0';
	signal mem_write : std_logic := '0';
	signal mem_address : std_logic_vector(integer(ceil(log2(real(N)))) - 1 downto 0) := (others => '0');
	signal mem_input : std_logic_vector(0 to M - 1) := (others => '0');
	signal mem_output : std_logic_vector(0 to M - 1) := (others => '0');
	signal reg_read : std_logic := '0';
	signal reg_output : std_logic_vector(0 to M - 1) := (others => '0');

begin
	control_unit : control_unit_B
	port map(
		clock => clock,
		reset => reset,
		req => req,
		ack => ack,
		counter_enable => counter_enable,
		mem_read => mem_read,
		mem_write => mem_write,
		reg_read => reg_read
	);
	
	mem : MEM_N_M
	generic map(
		N => N,
		M => M
	)
	port map(
		clock => clock,
		reset => reset,
		read => mem_read,
		write => mem_write,
		address => mem_address,
		input => mem_input,
		output => mem_output
	);
	
	cnt : counter
	generic map(
		max_count => N
	)
	port map(
		clock => clock,
		enable => counter_enable,
		reset => reset,
		load => '0',
		input => (others => '0'),
		output => mem_address,
		Q => open
	);
	
	sum : adder
	generic map(
		M => M
	)
	port map(
		x => reg_output,
		y => mem_output,
		output => mem_input
	);
	
	buffr : register_M
	generic map(
		M => M
	)
	port map(
		clock => clock,
		reset => reset,
		load => reg_read,
		input => data,
		output => reg_output
	);
end behavioral;
