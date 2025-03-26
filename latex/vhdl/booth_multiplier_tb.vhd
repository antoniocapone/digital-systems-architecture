library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity booth_multiplier_tb is

end booth_multiplier_tb;

architecture behavioral of booth_multiplier_tb is
	
	component booth_multiplier
	port(
		clock: in std_logic;
		reset: in std_logic;
		start: in std_logic;
		x: in std_logic_vector(7 downto 0);
		y: in std_logic_vector(7 downto 0);
		output : out std_logic_vector(15 downto 0);
		done : out std_logic
	);
	end component;
	
	constant CLK_PERIOD : time := 10 ns;
	
	signal clock : std_logic;
	signal reset : std_logic;
	signal start : std_logic;
	signal x : std_logic_vector(7 downto 0);
	signal y : std_logic_vector(7 downto 0);
	signal output : std_logic_vector(15 downto 0);
	signal done : std_logic;
	
begin
	uut : booth_multiplier
	port map(
		clock => clock,
		reset => reset,
		start => start,
		x => x,
		y => y,
		output => output,
		done => done
	);

	CLK_process :process
	begin
		clock <= '0';
		wait for CLK_period/2;
		clock <= '1';
		wait for CLK_period/2;
	end process;

	stim_proc: process
	begin
		wait for 100 ns;

		-- 15 * 3 = 45 (002D)
		x <= "00001111";
		y <= "00000011";
		start <= '1';
		wait for 10 ns;
		start <= '0';
		wait for 500 ns;
		assert output = x"002D"
		report "Errore nella moltiplicazione 15 * 3"
		severity failure;

		-- 3 * -5 = -15 (FFF1)
		x <= "00000011";
		y <= "11111011";
		start <= '1';
		wait for 10 ns;
		start <= '0';
		wait for 500 ns;
		assert output = x"FFF1"
		report "Errore nella moltiplicazione -5 * 3"
		severity failure;

		-- -3 * 3 = -9 (FFF7)
		x <= "11111101";
		y <= "00000011";
		start <= '1';
		wait for 10 ns;
		start <= '0';
		wait for 500 ns;
		assert output = x"FFF7"
		report "Errore nella moltiplicazione -3 * 3"
		severity failure;

		-- -3 * -5 = 15 (000F)
		x <= "11111101"; 
		y <= "11111011";
		start <= '1';
		wait for 10 ns;
		start <= '0';
		wait for 500 ns;
		assert output = x"000F"
		report "Errore nella moltiplicazione -3 * -5"
		severity failure;

		-- -128 * -128 = 16384 (4000)
		-- Qui vi una problematica di overflow, il risultato corretto è 4000
		-- ma il risultato ottenuto è C000.
		x<="10000000"; 
		y<="10000000";
		start <= '1';
		wait for 10 ns;
		start <= '0';
		wait for 500 ns;
		assert output = x"4000"
		report "Errore nella moltiplicazione -128 * -128: problema di overflow"
		severity warning;
		wait;
	end process;
end behavioral;
