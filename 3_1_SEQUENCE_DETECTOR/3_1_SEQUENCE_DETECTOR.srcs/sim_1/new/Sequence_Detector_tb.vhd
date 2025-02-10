library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Sequence_Detector_tb is

end Sequence_Detector_tb;

architecture behavioral of Sequence_Detector_tb is
	component Sequence_Detector
	port (
		input : in std_logic;
		M : in std_logic;
		reset : in std_logic;
		clock: in std_logic;
		A : in std_logic;
		state_output_led : out std_logic_vector(0 to 6);
		Y : out std_logic
	);
	end component;
	
	constant CLK_period : time := 10 ns;
	
	signal input : std_logic := '0';
	signal M : std_logic := '0';
	signal reset : std_logic := '1';
	signal clock : std_logic := '0';
	signal enable : std_logic := '0';
	signal output : std_logic := '0';
begin
	
	uut : Sequence_Detector
	port map(
		input => input,
		M => M,
		reset => reset,
		clock => clock,
		A => enable,
		Y => output
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
		wait for 100ns;
		enable <= '1';
		reset <= '0';
		input <= '0';
		wait for 10 ns;
		input <= '0';
		wait for 10 ns;
		input <= '0';
		wait for 10 ns;
		input <= '1';
		wait for 10 ns;
		input <= '0';
		wait for 10 ns;
		input <= '1';
		wait for 10 ns;
		assert output = '1'
		report "Errore del riconoscitore in modalità M = 0"
		severity failure;
		
		wait for 10 ns;
		M <= '1';
		input <= '0';
		wait for 10 ns;
		input <= '0';
		wait for 10 ns;
		input <= '0';
		wait for 10ns;
		input <= '1';
		wait for 10ns;
		input <= '1';
		wait for 10 ns;
		input <= '0';
		wait for 10 ns;
		input <= '1';
		wait for 10ns;
		assert output = '1'
		report "Errore del riconoscitore in modalità M = 0"
		severity failure;
		
		wait;
	end process;
end behavioral;
