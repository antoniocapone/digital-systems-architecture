library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity system_tb is

end system_tb;

architecture behavioral of system_tb is

	component system
	port(
		x0 : in std_logic_vector(0 to 3);
		x1 : in std_logic_vector(0 to 3);
		x2 : in std_logic_vector(0 to 3);
		x3 : in std_logic_vector(0 to 3);
		enable : in std_logic_vector(0 to 3);
		y0 : out std_logic_vector(0 to 1);
		y1 : out std_logic_vector(0 to 1);
		y2 : out std_logic_vector(0 to 1);
		y3 : out std_logic_vector(0 to 1)
	);
	end component;
	
	signal x0 : std_logic_vector(0 to 3) := "1010";
	signal x1 : std_logic_vector(0 to 3) := "0101";
	signal x2 : std_logic_vector(0 to 3) := "1111";
	signal x3 : std_logic_vector(0 to 3) := "1000";
	signal enable : std_logic_vector(0 to 3) := "0000";
	signal y0 : std_logic_vector(0 to 1);
	signal y1 : std_logic_vector(0 to 1);
	signal y2 : std_logic_vector(0 to 1);
	signal y3 : std_logic_vector(0 to 1);

begin
	uut : system
	port map(
		x0 => x0,
		x1 => x1,
		x2 => x2,
		x3 => x3,
		enable => enable,
		y0 => y0,
		y1 => y1,
		y2 => y2,
		y3 => y3
	);
	
	stim_proc : process
	begin
		wait for 100 ns;
		enable <= "1111";
		wait for 10 ns;
		assert y0 = "00" and y1 = "00" and y2 = "10" and y3 = "00"
		report "Errore nell'interconnessione 0-2" severity failure;
		wait for 10ns;
		
		enable <= "0111";
		wait for 10 ns;
		assert y0 = "00" and y1 = "01" and y2 = "00" and y3 = "00"
		report "Errore nell'interconnessione 1-1" severity failure;
		wait for 10ns;
		
		enable <= "0011";
		wait for 10 ns;
		assert y0 = "00" and y1 = "00" and y2 = "00" and y3 = "11"
		report "Errore nell'interconnessione 2-3" severity failure;
		wait for 10ns;
		
		enable <= "1001";
		wait for 10 ns;
		assert y0 = "00" and y1 = "00" and y2 = "10" and y3 = "00"
		report "Errore nell'interconnessione 0-2" severity failure;
		wait for 10ns;
		
		enable <= "0001";
		wait for 10 ns;
		assert y0 = "10" and y1 = "00" and y2 = "00" and y3 = "00"
		report "Errore nell'interconnessione 3-0" severity failure;
		wait for 10ns;
		
		enable <= "0000";
		wait;
	end process;
end behavioral;
