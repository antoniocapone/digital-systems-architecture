library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;


entity S_tb is

end S_tb;

architecture behavioral of S_tb is
	component S
	port(
		input : in std_logic_vector (0 to 3);
		output: out std_logic_vector (0 to 3)
	);
	end component;
	
	component M
	port(
		input : in std_logic_vector (0 to 7);
		output : out std_logic_vector (0 to 3)
	);
	end component;
	
	signal input : std_logic_vector (0 to 3) := "0000";
	signal output : std_logic_vector (0 to 3) := "0000";
	signal test_input : std_logic_vector (0 to 7) := (others => '0');
	signal test_output : std_logic_vector (0 to 3) := "0000";
	type rom_16_8 is array (0 to 15) of std_logic_vector (0 to 7);
	signal data : rom_16_8 := (x"A8", x"BD", x"17", x"E0",
							   x"C2", x"03", x"FF", x"46",
							   x"A8", x"BD", x"17", x"E0",
							   x"C2", x"03", x"FF", x"46");
begin

	uut : S
	port map(
		input => input,
		output => output
	);
	
	reference_M : M 
	port map(
		input => test_input,
		output => test_output
	);
	
	stim_proc : process
	begin
		wait for 100 ns;
		for i in 0 to 15 loop
			input <= std_logic_vector(to_unsigned(i, 4));
			test_input <= data(i);
			wait for 10 ns;
			assert output = test_output
			report "Errore della macchina S per l'indirizzo " & integer'image(i)
			severity failure;
		end loop;
		wait;
	end process;
end behavioral;
