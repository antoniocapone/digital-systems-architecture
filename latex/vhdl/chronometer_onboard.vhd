library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Funzionamento del progetto:
-- Il cronometro partirà automaticamente, mostrando l'output sul display a sette seg-
-- menti nel formato HH.MM.SS. L'intervallo supportato + [00.00.00; 23.59.59]. Arriva-
-- to all'estremo superiore, il cronometro ripartirà dall'inizio. 
-- Per impostare un valore personalizzato, si utilizzano gli switches e i pulsanti.
-- Precisamente, si inserisce il valore in notazione binaria posizionale, su sei bit
-- per i minuti e i secondi e su cinque bit per le ore, utilizzando gli switches par-
-- tendo da destra. Per memorizzare il valore dei secondi si preme il pulsante di de-
-- stra, per i minuti quello centrale, e quello di sinistra per le ore. I valori non
-- validi (e.g. 63 secondi) verranno azzerati. Per visualizzare il valore memorizzato
-- si preme il tasto in basso. Il pulsante in alto è di reset.

entity chronometer_onboard is
	port(
		CLK100MHZ : in std_logic;
		CATHODES: out std_logic_vector(7 downto 0);
		ANODES: out std_logic_vector(7 downto 0);
		BTNU : in std_logic;
		BTNL : in std_logic;
		BTNC : in std_logic;
		BTNR : in std_logic;
		BTND : in std_logic;
		SW : in std_logic_vector(5 downto 0)
	);
end chronometer_onboard;

architecture structural of chronometer_onboard is
	component chronometer
	generic(
		clock_time : time := 10 ns;
		clock_divider_period : time := 1 sec
	);
	port(
		clock : in std_logic;
		enable : in std_logic;
		reset : in std_logic;
		set : in std_logic;
		input : in std_logic_vector(0 to 16);
		output : out std_logic_vector (0 to 16);
		Q : out std_logic
	);
	end component;

	component seven_segments_display
	generic(
		clock_frequency_in : integer := 100000000; 
		clock_frequency_out : integer := 500
	);
	port(
		clock : in  std_logic;
		reset : in  std_logic;
		input : in  std_logic_vector (0 to 16);
		enable : in  std_logic_vector (7 downto 0);
		anodes : out  std_logic_vector (7 downto 0);
		cathodes : out  std_logic_vector (7 downto 0)
	);
	end component;
	
	component input_manager
	port(
		clock : in std_logic;
		button_hours : in std_logic;
		button_minutes : in std_logic;
		button_seconds : in std_logic;
		switches : in std_logic_vector(5 downto 0);
		value: out std_logic_vector(0 to 16)
	);
	end component;
	
	signal chronometer_time: std_logic_vector(0 to 16);
	signal input_time : std_logic_vector(0 to 16);
	constant clock_time : time := 10 ns;
	
begin
	chronometer_onboard: chronometer
	generic map(
		clock_time => clock_time,
		clock_divider_period => 1 sec
	)
	port map(
		clock => CLK100MHz,
		enable => '1',
		reset => BTNU,
		set => BTND,
		input => input_time,
		output => chronometer_time,
		Q => open
	);

	display: seven_segments_display
	generic map(
		clock_frequency_in => 1 sec / clock_time,
		clock_frequency_out => 500
	)
	port map(
		clock => CLK100MHZ,
		reset => BTNU,
		input => chronometer_time,
		enable => "00111111",
		anodes => anodes,
		cathodes => cathodes
	);
	
	input_mgr : input_manager
	port map(
		clock =>CLK100MHZ,
		button_hours => BTNL,
		button_minutes => BTNC,
		button_seconds => BTNR,
		switches => SW,
		value =>input_time
	);
end structural;
