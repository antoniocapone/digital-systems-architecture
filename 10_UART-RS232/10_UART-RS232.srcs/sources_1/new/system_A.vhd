library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.MATH_REAL.ALL;


entity system_A is
	port(
		clock : in std_logic;
		reset : in std_logic;
		start : in std_logic;
		RX : in std_logic;
		TX : out std_logic
	);
end system_A;

architecture structural of system_A is

	component control_unit_A
	port(
		clock : in std_logic;
		reset : in std_logic ;
		start : in std_logic ;
		counter_reset : out std_logic;
		counter_enable : out std_logic;
		counter_Q : in std_logic;
		rom_read : out std_logic;
		WR : out std_logic;
		TBE : in std_logic
	);
	end component;
	
	component ROM_8_8
	port(
		clock : in std_logic;
		read : in std_logic;
		address : in std_logic_vector(2 downto 0);
		output : out std_logic_vector(0 to 7)
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
	
	component RS232RefComp
	port( 
		TXD : out std_logic := '1';
		RXD : in  std_logic;
		CLK : in  std_logic;
		DBIN : in  std_logic_vector (7 downto 0);
		DBOUT : out std_logic_vector (7 downto 0);
		RDA : inout std_logic;
		TBE : inout std_logic := '1';
		RD : in  std_logic;
		WR : in  std_logic;
		PE : out std_logic;
		FE : out std_logic;
		OE : out std_logic;
		RST : in  std_logic := '0'
	);
	end component;
	
	signal counter_reset : std_logic;
	signal counter_enable : std_logic;
	signal counter_Q : std_logic;
	signal rom_address : std_logic_vector(2 downto 0);
	signal rom_read : std_logic;
	signal WR : std_logic;
	signal TBE : std_logic;
	signal DBIN : std_logic_vector(7 downto 0);

begin
	control_unit : control_unit_A
	port map(
		clock => clock,
		reset => reset,
		start => start,
		counter_reset => counter_reset,
		counter_enable => counter_enable,
		counter_Q => counter_Q,
		rom_read => rom_read,
		WR => WR,
		TBE => TBE
	);
	
	rom : ROM_8_8
	port map(
		clock => clock,
		read => rom_read,
		address => rom_address,
		output => DBIN
	);

	cnt : counter
	generic map(
		max_count => 8
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

	serial : RS232RefComp
	port map(
		TXD => TX,
		RXD => RX,
		CLK => clock,
		DBIN => DBIN,
		DBOUT => open,
		RDA => open,
		TBE => TBE,
		RD => '0',
		WR => WR,
		PE => open,
		FE => open,
		OE => open,
		RST => reset
	);
end structural;
