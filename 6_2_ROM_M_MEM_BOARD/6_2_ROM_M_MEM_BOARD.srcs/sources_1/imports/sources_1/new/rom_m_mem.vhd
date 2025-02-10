library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.MATH_REAL.ALL;


entity rom_m_mem is
	generic(
		N : integer := 8
	);
	port(
		clock : in std_logic;
		start : in std_logic;
		reset : in std_logic;
		output : out std_logic_vector(0 to 3)
	);
end rom_m_mem;

architecture structural of rom_m_mem is
	component control_unit
	port(
		clock : in std_logic;
		start : in std_logic;
		reset : in std_logic;
		Q_counter : in std_logic;
		read_rom : out std_logic;
		write_mem : out std_logic;
		enable_counter : out std_logic;
		reset_counter : out std_logic
	);
	end component;
	
	component ROM_N
	generic(
		N : in integer := 8
	);
	port(
		clock: in std_logic;
		read : in std_logic;
		address : in std_logic_vector(integer(ceil(log2(real(N)))) - 1 downto 0);
		output : out std_logic_vector(0 to 7)
	);
	end component;
	
	component M
	port (
		input : in std_logic_vector (0 to 7);
		output : out std_logic_vector (0 to 3)
	);
	end component;
	
	component MEM_N
	generic(
		N : in integer := 8
	);
	port(
		clock: in std_logic;
		write : in std_logic;
		address : in std_logic_vector(integer(ceil(log2(real(N)))) - 1 downto 0);
		input : in std_logic_vector(0 to 3)
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
	
	signal Q_counter : std_logic;
	signal output_counter : std_logic_vector(0 to integer(ceil(log2(real(N)))) - 1);
	signal read_rom : std_logic;
	signal write_mem : std_logic;
	signal output_rom : std_logic_vector(0 to 7);
	signal input_mem : std_logic_vector(0 to 3);
	signal enable_counter : std_logic;
	signal reset_counter : std_logic;
begin
	output <= input_mem;
	
	ctrl_unit : control_unit
	port map(
		clock => clock,
		start => start,
		reset => reset,
		Q_counter => Q_counter,
		read_rom => read_rom,
		write_mem => write_mem,
		enable_counter => enable_counter,
		reset_counter => reset_counter
	);

	rom : ROM_N
	generic map(
		N => N
	)
	port map(
		clock => clock,
		read => read_rom,
		address => output_counter,
		output => output_rom
	);

	m_comb : M
	port map(
		input => output_rom,
		output => input_mem
	);

	mem : MEM_N
	generic map(
		N => N
	)
	port map(
		clock => clock,
		write => write_mem,
		address => output_counter,
		input => input_mem
	);

	count : counter
	generic map(
		max_count => N
	)
	port map(
		clock => clock,
		enable => enable_counter,
		reset => reset_counter,
		load => '0',
		input => (others => '0'),
		output => output_counter,
		Q => Q_counter
	);
end structural;
