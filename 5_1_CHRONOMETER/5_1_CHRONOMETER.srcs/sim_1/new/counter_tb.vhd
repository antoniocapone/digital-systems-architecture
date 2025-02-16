library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.MATH_REAL.ALL;


entity counter_tb is
	
end counter_tb;

architecture behavioral of counter_tb is
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
	
	constant CLK_period : time := 10 ns;
	constant max_count : integer := 10;
	signal clock : std_logic := '0';
	signal enable : std_logic := '0';
	signal reset : std_logic:= '0';
	signal load : std_logic := '0';
	signal input : std_logic_vector(0 to integer(ceil(log2(real(max_count)))) - 1) := (others => '0');
	signal output : std_logic_vector(0 to integer(ceil(log2(real(max_count)))) - 1) := (others => '0');
	signal Q : std_logic := '0';
begin
	uut : counter
	generic map(
		max_count => max_count
	)
	port map(
		clock => clock,
		enable => enable,
		reset => reset,
		load => load,
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
		wait for 100 ns;
		input <= "0011";
		load <= '1';
		wait for 10 ns;
		load <= '0';
		wait for 30 ns;
		wait for 100 ns;
		reset <= '1';
		wait for 40 ns;
		wait;
	end process;
end behavioral;
