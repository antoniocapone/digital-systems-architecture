library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity interconnection16_4_tb is

end interconnection16_4_tb;

architecture behavioral of interconnection16_4_tb is
	component interconnection16_4
	port(
		i : in std_logic_vector(0 to 15);
		s_i : in std_logic_vector(3 downto 0);
		y : out std_logic_vector(0 to 3);
		s_y : in std_logic_vector(1 downto 0)
	); 
	end component; 

	signal input : std_logic_vector (0 to 15) := (others => '0');
	signal control_input : std_logic_vector (3 downto 0) := (others => '0');
	signal output : std_logic_vector(0 to 3) := (others => '0');
	signal control_output : std_logic_vector (1 downto 0):= (others => '0');

begin
	uut: interconnection16_4 
		port map(
			i => input,
			s_i => control_input,
			y => output,
			s_y => control_output
		);

	stim_proc: process
	begin
	-- Si è gia testato il funzionamento del mux16_1, si procede al testing del solo dmux1_4 e dell'interconnessione
		wait for 100 ns;
		input 	<= "1010110111100011";
		
		control_input <= "0000"; 
		control_output <= "00";
		wait for 10 ns;
		assert output = "1000" report "Errore nell'interconnessione 0-0" severity failure;
		
		control_input <= "0000"; 
		control_output <= "01";
		wait for 10 ns;
		assert output = "0100" report "Errore nell'interconnessione 0-1" severity failure;
		
		control_input <= "0000"; 
		control_output <= "10";
		wait for 10 ns;
		assert output = "0010" report "Errore nell'interconnessione 0-2" severity failure;
		
		control_input <= "0000"; 
		control_output <= "11";
		wait for 10 ns;
		assert output = "0001" report "Errore nell'interconnessione 0-3" severity failure;
		
		control_input <= "0001"; 
		control_output <= "00";
		wait for 10 ns;
		assert output = "0000" report "Errore nell'interconnessione 1-0" severity failure;

		wait;
	end process;
end; 

