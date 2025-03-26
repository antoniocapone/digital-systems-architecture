library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Simulare per 3 us

entity handshaking_tb is

end handshaking_tb;

architecture behavioral of handshaking_tb is
	
	component system_A
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
	end component;
	
	component system_B
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
	end component;
	
	constant CLK_PERIOD_A : time := 13 ns;
	constant CLK_PERIOD_B : time := 17 ns;
	constant N : integer := 8;
	constant M : integer := 8;
	
	signal req : std_logic := '0';
	signal data : std_logic_vector(0 to M - 1) := (others => '0');
	signal ack : std_logic := '0';
	signal clock_A : std_logic := '0';
	signal clock_B : std_logic := '0';
	signal start : std_logic := '0';
	signal reset : std_logic := '0';

begin
	sys_A: system_A
	generic map(
		N => N,
		M => M
	)
	port map(
		clock => clock_A,
		reset => reset,
		start => start,
		req => req,
		data => data,
		ack => ack
	);
	
	sys_B: system_B
	generic map(
		N => N,
		M => M
	)
	port map(
		clock => clock_B,
		reset => reset,
		req => req,
		data => data,
		ack => ack
	);

	CLK_A_process :process
	begin
		clock_A <= '0';
		wait for CLK_period_A/2;
		clock_A <= '1';
		wait for CLK_period_A/2;
	end process;
	
	CLK_B_process :process
	begin
		clock_B <= '0';
		wait for CLK_period_B/2;
		clock_B <= '1';
		wait for CLK_period_B/2;
	end process;
	
	test_process: process
	begin
	
	wait for 100ns;
	
	reset <= '1';
	wait for 20ns;
	reset <= '0';
	wait for 20ns;
	start <= '1';
	wait for 20ns;
	start <= '0';
	
	wait for 1200 ns;
	
	start <= '1';
	wait for 20ns;
	start <= '0';
	
	wait for 400ns;
	
	reset <= '1';
	wait for 20ns;
	reset <= '0';
	wait for 20ns;
	start <= '1';
	wait for 20ns;
	start <= '0';
	
	wait;
	end process;


end behavioral;
