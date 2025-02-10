library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;


entity mux16_1_tb is

end mux16_1_tb;

architecture behavioral of mux16_1_tb is
	
	component mux16_1
	port(
		a : in std_logic_vector(0 to 15);
		s : in std_logic_vector(3 downto 0);
		y : out std_logic
	); 
	end component; 

	signal input 	: std_logic_vector (0 to 15) := (others => '0');
	signal control 	: std_logic_vector (3 downto 0) := (others => '0');
	signal output 	: STD_LOGIC := '0';

begin
	uut: mux16_1 
		port map(
			a => input,
			s => control,
			y => output
		);

	stim_proc: process
	begin
		wait for 100 ns;
		input 	<= "1010110111100011";
		
		for i in 0 to 15 loop
			control <= std_logic_vector(to_unsigned(i, 4));
			wait for 10 ns;
			assert output = input(i) report "Errore nella selezione dell'ingresso " & integer'image(i) severity failure;
		end loop;
		wait;
	end process;
end behavioral; 
