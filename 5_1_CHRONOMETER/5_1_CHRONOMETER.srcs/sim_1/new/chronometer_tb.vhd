library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Simulare per 250 us

entity chronometer_tb is

end chronometer_tb;

architecture behavioral of chronometer_tb is
	component chronometer
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
	end component;
	
	constant CLK_period : time := 10 ns;
	constant max_count : integer := 10;
	signal clock : std_logic := '0';
	signal enable : std_logic := '0';
	signal reset : std_logic:= '0';
	signal load : std_logic := '0';
	signal input : std_logic_vector(0 to 16) := (others => '0');
	signal output : std_logic_vector(0 to 16) := (others => '0');
	signal Q : std_logic := '0';
begin
	uut : chronometer
	generic map(
		clock_time => CLK_period,
		clock_divider_period => 1 us -- Tempo utile per la simulazione
	)
	port map(
		clock => clock,
		enable => enable,
		reset => reset,
		set => load,
		input => input,
		output => output,
		Q => Q
	);
	
	CLK_process :process
	begin
		clock <= '0';
		wait for CLK_period/2;
		clock <= '1';
		wait for CLK_period/2;
	end process;
	
	stim_process : process
	begin
		wait for 100 ns;
		enable <= '1';
		wait for 100 us;
		input <= "00111" & "111011" & "111011"; -- 7h 59m 59s
		load <= '1';
		wait for 10 ns;
		load <= '0';
		wait for 100 us;
		reset <= '1';
		wait for 40 us;
		wait;
	end process;
end behavioral;
