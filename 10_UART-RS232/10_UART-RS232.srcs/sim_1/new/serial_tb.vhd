library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Simulare per 1200 us

entity serial_tb is
	
end serial_tb;

architecture behavioral of serial_tb is

	component system_A
	port(
		clock : in std_logic;
		reset : in std_logic;
		start : in std_logic;
		RX : in std_logic;
		TX : out std_logic
	);
	end component;

	component system_B
	port(
		clock : in std_logic;
		reset : in std_logic;
		RX : in std_logic;
		TX : out std_logic;
		error : out std_logic
	);
	end component;

	constant CLK_period : time := 20 ns;

	signal clock : std_logic := '0';
	signal reset : std_logic := '1';
	signal start : std_logic := '0';
	signal uart_line : std_logic := '1';
	signal error : std_logic := '0';

begin
	system_A_inst : system_A
	port map(
		clock => clock,
		reset => reset,
		start => start,
		RX => '1',
		TX => uart_line
	);

	system_B_inst : system_B
	port map(
		clock => clock,
		reset => reset,
		RX => uart_line,
		TX => open,
		error => error
	);

	CLK_process :process
	begin
		clock <= '0';
		wait for CLK_period/2;
		clock <= '1';
		wait for CLK_period/2;
	end process;

	stim_proc : process
	begin
		wait for 100 ns;
		reset <= '0';
		start <= '1';
		wait for 20 ns;
		start <= '0';
		wait;
	end process;

end behavioral;
