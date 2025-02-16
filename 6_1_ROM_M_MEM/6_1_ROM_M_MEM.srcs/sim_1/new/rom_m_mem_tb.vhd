library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity rom_m_mem_tb is

end rom_m_mem_tb;

architecture behavioral of rom_m_mem_tb is
	
	constant N : integer := 8;
	constant CLK_period : time := 10 ns;
	
	component rom_m_mem
	generic(
		N : integer := N
	);
	port(
		clock : in std_logic;
		start : in std_logic;
		reset : in std_logic;
		output : out std_logic_vector(0 to 3)
	);
	end component;
	
	component M
	port (
		input : in std_logic_vector (0 to 7);
		output : out std_logic_vector (0 to 3)
	);
	end component;
	
	signal clock : std_logic := '0';
	signal start : std_logic := '0';
	signal reset : std_logic := '0';
	signal output : std_logic_vector(0 to 3) := (others => '0');
	signal test_input : std_logic_vector (0 to 7) := (others => '0');
	signal test_output : std_logic_vector (0 to 3) := "0000";
	type rom_N_8 is array (0 to N - 1) of std_logic_vector (0 to 7);
	signal data : rom_N_8 := (x"A8", x"BD", x"17", x"E0",
							  x"C2", x"03", x"FF", x"46");
	
begin
uut : rom_m_mem
	port map(
		clock => clock,
		start => start,
		reset => reset,
		output => output
	);
	
	reference_M : M 
	port map(
		input => test_input,
		output => test_output
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
		for i in 0 to N - 1 loop
			test_input <= data(i);
			wait for 30 ns;
			assert output = test_output
			report "Errore della macchina S per l'indirizzo " & integer'image(i)
			severity failure;
		end loop;
		wait;
	end process;
end behavioral;
