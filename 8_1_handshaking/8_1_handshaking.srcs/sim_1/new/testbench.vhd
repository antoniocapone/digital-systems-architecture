library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity testbench is
--  Port ( );
end testbench;

architecture behavioral of testbench is
	
	component system_A
		port(
			clock: in std_logic;
			reset: in std_logic;
			start: in std_logic;
			req: out std_logic;
			data: out std_logic_vector(0 to 7);
			ack: in std_logic
		);
	end component;
	
	component system_B
		port(
			clock: in std_logic;
			reset: in std_logic;
			start: in std_logic;
			req: in std_logic;
			data: in std_logic_vector(0 to 7);
			ack: out std_logic
		);
	end component;
	
	signal req : std_logic := '0';
	signal data : std_logic_vector(0 to 7) := (others => '0');
	signal ack : std_logic := '0';
	signal clock_A : std_logic := '0';
	signal clock_B : std_logic := '0';
	signal start : std_logic := '0';
	signal reset : std_logic := '0';
	
	constant CLK_PERIOD_A : time := 10 ns;
	constant CLK_PERIOD_B : time := 13 ns;

begin

	sys_A: system_A
	port map(
		clock => clock_A,
		reset => reset,
		start => start,
		req => req,
		data => data,
		ack => ack
	);
	
	sys_B: system_B
	port map(
		clock => clock_B,
		reset => reset,
		start => start,
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
	
	wait for 15ns;
	
	reset <= '0';
	
	wait for 15ns;
	
	start <= '1';
	
	wait for 15ns;
	
	start <= '0';
	
	wait for 1200 ns;
	start <= '1';
	wait for 15ns;
	start <= '0';
	wait;
	
	end process;


end behavioral;
