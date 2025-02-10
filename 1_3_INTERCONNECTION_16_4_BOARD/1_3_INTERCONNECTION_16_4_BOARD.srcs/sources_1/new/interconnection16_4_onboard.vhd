library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Funzionamento del progetto:
-- (1) Per l'inserimento dei primi 8 bit, corrispondenti agli ingressi da a_0 ad a_7
-- della rete, si utilizzano gli 8 switches di sinistra e si preme BTNL;
-- (2) Per l'inserimento degli ultimi 8 bit, corrispondenti agli ingressi da a_8 ad 
-- a_15 della rete, si utilizzano gli 8 switches di sinistra e si preme BTNR;
-- (3) Per codificare la selezione si utilizzano i 6 switches di destra: da sinistra
-- a destra, i primi 4 selezionano la linea d'ingresso, gli ultimi due la linea di
-- uscita. La selezione va specificata in notazione posizionale.

entity interconnection16_4_onboard is
	port(
		CLK100MHZ : in std_logic;
		BTNL : in  std_logic;
		BTNR :in  std_logic;
		SW_DATA : in std_logic_vector(15 downto 8);
		SW_SEL : in std_logic_vector(5 downto 0);
		LED : out std_logic_vector(15 downto 12)
	);
end interconnection16_4_onboard;

architecture structural of interconnection16_4_onboard is
	signal input : std_logic_vector (0 to 15) := (others => '0');

	component interconnection16_4
	port(
		i : in std_logic_vector(0 to 15);
		s_i : in std_logic_vector(3 downto 0);
		y : out std_logic_vector(0 to 3);
		s_y : in std_logic_vector(1 downto 0)
	);
	end component;
	
	component control_unit
	port(
		clock : in  std_logic;
		load_first_part : in  std_logic;
		load_second_part :in  std_logic;
		bits_in : in std_logic_vector (0 to 7);
		bits_out : out std_logic_vector (0 to 15)
	);
	end component;

begin
	cu : control_unit
	port map (
		clock => CLK100MHZ,
		load_first_part => BTNL,
		load_second_part => BTNR,
		bits_in => SW_DATA,
		bits_out => input
	);
	
	interconnection : interconnection16_4
	port map(
		i => input,
		s_i => SW_SEL(5 downto 2),
		y => LED(15 downto 12),
		s_y => SW_SEL(1 downto 0)
	);
end structural;
