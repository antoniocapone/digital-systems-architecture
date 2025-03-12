library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Simulare per 3000 ns

entity system_tb is

end system_tb;

architecture behavioral of system_tb is

	component system_A
	port(
        clock : in std_logic;
        reset : in std_logic;
        start : in std_logic;
        req : out std_logic;
        data : out std_logic_vector(0 to 3);
        ack : in std_logic
    );
	end component;

	component system_B
	port(
		clock : in std_logic;
		reset : in std_logic;
		req : in std_logic;
		data : in std_logic_vector(0 to 3);
		ack : out std_logic
	);
	end component;
	
	signal CLK_PERIOD_A : time := 10 ns;
	signal CLK_PERIOD_B : time := 23 ns;
	signal clock_A : std_logic;
	signal clock_b : std_logic;
	signal reset : std_logic;
	signal start : std_logic;
	signal req : std_logic;
	signal data : std_logic_vector(0 to 3);
	signal ack : std_logic;

begin
	sys_A : system_A
	port map(
		clock => clock_A,
		reset => reset,
		start => start,
		req => req,
		data => data,
		ack => ack
	);
	
	sys_B : system_B
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
	
	CLK_period_A <= 23 ns;
	CLK_period_B <= 10 ns;
	
	start <= '1';
	wait for 20ns;
	start <= '0';
	
	wait for 400ns;
	
	reset <= '1';
	wait for 20ns;
	reset <= '0';
	wait for 100ns;
	start <= '1';
	wait for 20ns;
	start <= '0';
	
	wait;
	end process;
end behavioral;
