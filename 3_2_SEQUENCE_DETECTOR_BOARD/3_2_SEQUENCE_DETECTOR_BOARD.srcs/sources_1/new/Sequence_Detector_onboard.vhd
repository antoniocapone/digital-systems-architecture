library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Funzionamento del progetto:
-- Per l'inserimento del bit di ingresso si utilizza il primo switch da sinistra e si
-- preme il pulsante di sinistra. Per la scelta della modalità si utilizza il secondo
-- switch da sinistra e si preme il pulsante di destra. Un cambio di modalità riporterà
-- allo stato iniziale. Il primo led da sinistra si illumina al riconoscimento della
-- sequenza. I sette led di destra rappresentano lo stato in cui si trova il riconosci-
-- tore, in riferimento all'automa descritto nella tesina. Il pulsante in alto è di
-- reset.

entity Sequence_Detector_onboard is
	port (
		CLK100MHZ : in std_logic;
		SW : in std_logic_vector (15 downto 14);
		BTNU : in std_logic;
		BTNR : in std_logic;
		BTNL : in std_logic;
		LED_STATE : out std_logic_vector (0 to 6);
		LED_OUTPUT : out std_logic
	);
end Sequence_Detector_onboard;

architecture structural of Sequence_Detector_onboard is
	component Sequence_Detector
	port(
		input : in std_logic;
		M : in std_logic;
		reset : in std_logic;
		clock: in std_logic;
		A : in std_logic;
		state_output_led : out std_logic_vector(0 to 6);
		Y : out std_logic
	);
	end component;
	
	component Input_Manager
	port(
		clock : in std_logic;
		input : in std_logic_vector (0 to 1);
		load_next : in std_logic;
		change_mode : in std_logic;
		detector_input : out std_logic;
		detector_M : out std_logic;
		detector_enable : out std_logic
	);
	end component;

	component Button_Debouncer
	generic (
		clock_period: integer := 10;
		noise_time: integer := 10000000
	);
	port (
		reset : in std_logic;
		clock : in std_logic;
		button : in std_logic;
		button_debounced : out std_logic
	);
	end component;
	
	signal detector_input : std_logic := '0';
	signal detector_M : std_logic := '0';
	signal detector_enable : std_logic := '0';
	signal button_left : std_logic := '0';
	signal button_right : std_logic := '0';
begin
	seq_detector : Sequence_Detector
	port map(
		input => detector_input,
		M => detector_M,
		reset => BTNU,
		clock => CLK100MHZ,
		A => detector_enable,
		state_output_led => LED_STATE,
		Y => LED_OUTPUT
	);
	
	input_mgr : Input_Manager
	port map(
		clock => CLK100MHZ,
		input => SW,
		load_next => button_left,
		change_mode => button_right,
		detector_input => detector_input,
		detector_M => detector_M,
		detector_enable => detector_enable
	);

	btn_debouncer_left : Button_Debouncer
	port map(
		reset => BTNU,
		clock => CLK100MHZ,
		button => BTNL,
		button_debounced => button_left
	);

	btn_debouncer_right : Button_Debouncer
	port map(
		reset => BTNU,
		clock => CLK100MHZ,
		button => BTNR,
		button_debounced => button_right
	);
end structural;
