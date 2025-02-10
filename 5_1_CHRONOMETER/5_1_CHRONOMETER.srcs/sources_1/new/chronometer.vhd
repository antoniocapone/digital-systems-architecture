library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.MATH_REAL.ALL;


entity chronometer is
	generic(
		clock_time : time := 10 ns;
		clock_divider_period : time := 1 sec
	);
	port(
		clock : in std_logic;
		enable : in std_logic;
		reset : in std_logic;
		set : in std_logic;
		input : in std_logic_vector(0 to 16);
		output : out std_logic_vector (0 to 16);
		Q : out std_logic
	);
end chronometer;

architecture structural of chronometer is
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
	
	component clock_divider
	generic(
		clock_frequency_in : integer := 100000000;	--100MHz
		clock_frequency_out : integer := 500 		--500 Hz
	);
	port(
		clock : in  std_logic;
		reset : in std_logic;
		clock_divided : out  std_logic
	);
	end component;
	
	signal enable_seconds : std_logic := '0';
	signal enable_minutes : std_logic := '0';
	signal enable_hours : std_logic := '0';
	signal clock_divided : std_logic := '0';
	signal Q_seconds : std_logic := '0';
	signal Q_minutes : std_logic := '0';
	signal reset_clkdiv : std_logic := '0';
begin
	reset_clkdiv <= not enable or set or reset;
	enable_seconds <= clock_divided and enable;
	enable_minutes <= enable_seconds and Q_seconds;
	enable_hours <= enable_seconds and Q_seconds and Q_minutes;
	
	clk_divider : clock_divider
	generic map(
		clock_frequency_in => 1 sec /clock_time,
		clock_frequency_out => 1 sec /clock_divider_period
	)
	port map(
		clock => clock,
		reset => reset_clkdiv,
		clock_divided => clock_divided
	);
	
	seconds_counter : counter
	generic map(
		max_count => 60
	)
	port map(
		clock => clock,
		enable => enable_seconds,
		reset => reset,
		load => set,
		input => input(11 to 16),
		output => output(11 to 16),
		Q => Q_seconds
	);
	
	minutes_counter : counter
	generic map(
		max_count => 60
	)
	port map(
		clock => clock,
		enable => enable_minutes,
		reset => reset,
		load => set,
		input => input(5 to 10),
		output => output(5 to 10),
		Q => Q_minutes
	);
	
	hours_counter : counter
	generic map(
		max_count => 24
	)
	port map(
		clock => clock,
		enable => enable_hours,
		reset => reset,
		load => set,
		input => input(0 to 4),
		output => output(0 to 4),
		Q => Q
	);
end structural;
