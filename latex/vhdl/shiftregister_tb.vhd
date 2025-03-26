library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Sequence_Detector_tb is

end Sequence_Detector_tb;

architecture behavioral of Sequence_Detector_tb is
	component shiftregister_structural
	generic(
		bit_number : integer := 8
	);
	port (
		clock : in std_logic;
		reset : in std_logic;
		load : in std_logic;
		Y : in std_logic;
		shift_left : in std_logic;
		input : in std_logic_vector(0 to bit_number - 1);
		output : out std_logic_vector(0 to bit_number - 1)
	);
	end component;
	
	component shiftregister_behavioral
	generic(
		bit_number : integer := 8
	);
	port (
		clock : in std_logic;
		reset : in std_logic;
		load : in std_logic;
		Y : in std_logic;
		shift_left : in std_logic;
		input : in std_logic_vector(0 to bit_number - 1);
		output : out std_logic_vector(0 to bit_number - 1)
	);
	end component;
	
	constant CLK_period : time := 10 ns;
	constant bit_number : integer := 16;
	
	signal reset : std_logic := '1';
	signal clock : std_logic := '0';
	signal load : std_logic := '0';
	signal input : std_logic_vector(0 to bit_number - 1) := (others => '0');
	signal Y : std_logic := '0';
	signal shift_left : std_logic := '0';
	signal output_structural : std_logic_vector(0 to bit_number - 1) := (others => '0');
	signal output_behavioral : std_logic_vector(0 to bit_number - 1) := (others => '0');
begin
	
	uut_structural : shiftregister_structural
	generic map(
		bit_number => bit_number
	)
	port map(
		clock => clock,
		reset => reset,
		load => load,
		Y => Y,
		shift_left => shift_left,
		input => input,
		output => output_structural
	);
	
	uut_behavioral : shiftregister_behavioral
	generic map(
		bit_number => bit_number
	)
	port map(
		clock => clock,
		reset => reset,
		load => load,
		Y => Y,
		shift_left => shift_left,
		input => input,
		output => output_behavioral
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
		input <= x"6F5D";
		reset <= '0';
		load <= '1';
		wait for 10 ns;
		load <= '0';
		wait for 10 ns;
		assert output_structural = x"B7AE" and output_behavioral = x"B7AE"
		report "Errore nella configurazione (Y = 0; shift_left = 0)"
		severity failure;
		shift_left <= '1';
		wait for 10 ns;
		assert output_structural = x"6F5D" and output_behavioral = x"6F5D"
		report "Errore nella configurazione (Y = 0; shift_left = 1)"
		severity failure;
		Y <= '1';
		wait for 10 ns;
		assert output_structural = x"BD75" and output_behavioral = x"BD75"
		report "Errore nella configurazione (Y = 1; shift_left = 1)"
		severity failure;
		shift_left <= '0';
		wait for 10 ns;
		assert output_structural = x"6F5D" and output_behavioral = x"6F5D"
		report "Errore nella configurazione (Y = 1; shift_left = 0)"
		severity failure;

		wait;
	end process;
end behavioral;
