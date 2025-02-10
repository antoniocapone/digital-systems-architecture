library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Descrizione delle connessioni:
-- i: vettore delle 16 connessioni in ingresso;
-- s_i: vettore di selezione della linea di ingresso;
-- y: vettore delle 4 connessioni in uscita;
-- s_y: vettore di selezione della linea di uscita.

entity interconnection16_4 is
	port(
		i : in std_logic_vector(0 to 15);
		s_i : in std_logic_vector(3 downto 0);
		y : out std_logic_vector(0 to 3);
		s_y : in std_logic_vector(1 downto 0)
	);
end interconnection16_4;

architecture strucutral of interconnection16_4 is
	signal interconnection : std_logic := '0';
	
	component mux16_1
	port(
		a : in std_logic_vector(0 to 15);
		s : in std_logic_vector(3 downto 0);
		y : out std_logic 
	);
	end component;
	
	component dmux1_4
	port(
		i : in std_logic;
		s : in std_logic_vector(1 downto 0);
		y : out std_logic_vector(0 to 3)
	);
	end component;
	
begin
	mux_in : mux16_1
	port map(
		a => i,
		s => s_i,
		y => interconnection
	);
	
	dmux_out : dmux1_4
	port map(
		i => interconnection,
		s => s_y,
		y => y
	);
end strucutral;
