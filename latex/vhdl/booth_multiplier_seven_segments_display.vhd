library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.MATH_REAL.ALL;


entity seven_segments_display is
	generic( 
		clock_frequency_in : integer := 100000000; 
		clock_frequency_out : integer := 500
	);
    port(
		clock : in  std_logic;
		reset : in  std_logic;
		input : in  std_logic_vector (15 downto 0);
		enable : in  std_logic_vector (7 downto 0);
		anodes : out  std_logic_vector (7 downto 0);
		cathodes : out  std_logic_vector (7 downto 0)
	);
end seven_segments_display;

architecture structural of seven_segments_display is
	component anodes_manager
	port(
		counter : in  std_logic_vector (2 downto 0);
		enable_digit : in  std_logic_vector (7 downto 0);
		anodes : out  std_logic_vector (7 downto 0)
	);
	end component;
	
	component cathodes_manager
	port(
		value : in  std_logic_vector (3 downto 0);
		dot : in  std_logic;
		cathodes_dot : out  std_logic_vector (7 downto 0)
	);
	end component;
	
	component cathodes_input_manager
	port(
		counter : in std_logic_vector(2 downto 0);
		value : in std_logic_vector(15 downto 0);
		digit_out : out std_logic_vector(3 downto 0)
	);
	end component;
	
	component clock_divider
	generic(
		clock_frequency_in : integer := 100000000;
		clock_frequency_out : integer := 500
	);
	port(
		clock : in  std_logic;
		reset : in std_logic;
		clock_divided : out  std_logic
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
	
	signal counter_output : std_logic_vector(2 downto 0);
	signal clock_divided : std_logic := '0';
	signal value_digit : std_logic_vector(3 downto 0);
begin
	clk_divider : clock_divider
	generic map(
		clock_frequency_in => clock_frequency_in,
		clock_frequency_out => clock_frequency_out
	)
	port map(
		clock => clock,
		reset => reset,
		clock_divided => clock_divided
	);
	
	counter_mod8 : counter
	generic map(
		max_count => 8
	)
	port map(
		clock => clock,
		enable => clock_divided,
		reset => reset,
		load => '0',
		input => (others => '0'),
		output => counter_output,
		Q => open
	);
	
	anodes_mgr : anodes_manager
	port map(
		counter => counter_output,
		enable_digit => enable,
		anodes => anodes
	);

	cathodes_mgr : cathodes_manager
	port map(
		value => value_digit,
		dot => '0',
		cathodes_dot => cathodes
	);
	
	cathodes_input_mgr : cathodes_input_manager
	port map(
		counter => counter_output,
		value => input,
		digit_out => value_digit
	);
end structural;
