library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Funzionamento del progetto:
-- Gli operandi vengono forniti in notazione binaria posizionale attraverso i 16 switches,
-- gli 8 di sinistra per il moltiplicando e gli 8 di destra per il moltiplicatore. Il pul-
-- sante centrale fornisce il segnale di START alla macchina, che effettua la moltiplica-
-- zione e mostra il risultato in decimale sul display a sette segmenti. Dato il funziona-
-- mento del moltiplicatore di Booth, i risultati transitori vengono anch'essi mostrati sul
-- display, ed il risultato definitivo sarà indicato dall'accensione del primo LED di destra.
-- Il pulsante in alto è di reset.

entity booth_multiplier_onboard is
	port(
		CLK100MHZ : in std_logic;
		X : in std_logic_vector(7 downto 0);
		Y : in std_logic_vector(7 downto 0);
		BTNU : in std_logic;
		BTNC : in std_logic;
		LED : out std_logic_vector(0 downto 0);
		CATHODES : out std_logic_vector(7 downto 0);
		ANODES : out std_logic_vector(7 downto 0)
	);
end booth_multiplier_onboard;

architecture structural of booth_multiplier_onboard is

	component booth_multiplier
	port(
		clock: in std_logic;
		reset: in std_logic;
		start: in std_logic;
		x: in std_logic_vector(7 downto 0);
		y: in std_logic_vector(7 downto 0);
		output : out std_logic_vector(15 downto 0);
		done : out std_logic
	);
	end component;
	
	component button_debouncer
	generic (
		clock_period: integer := 10000;
		noise_time: integer := 10000000
	);
	port (
		reset : in std_logic;
		clock : in std_logic;
		button : in std_logic;
		button_debounced : out std_logic
	);
	end component;
	
	component seven_segments_display is
	generic( 
		clock_frequency_in : integer := 100000000; 
		clock_frequency_out : integer := 500
	);
    port(
		clock : in  std_logic;
		reset : in  std_logic;
		input : in  std_logic_vector (15 downto 0);
		enable : in  std_logic_vector (7 downto 0);
		anodes : out  std_logic_vector (7 downto 0);
		cathodes : out  std_logic_vector (7 downto 0)
	);
	end component;
	
	alias clock : std_logic is CLK100MHZ;
	signal start : std_logic := '0';
	signal booth_product : std_logic_vector(15 downto 0);
	signal booth_done : std_logic;

begin
	start_button : button_debouncer
	port map(
		reset => BTNU,
		clock => clock,
		button => BTNC,
		button_debounced => start
	);
	
	booth_mult : booth_multiplier
	port map(
		clock => clock,
		reset => BTNU,
		start => start,
		x => X,
		y => Y,
		output => booth_product,
		done => booth_done
	);
	
	ssd : seven_segments_display
	port map(
		clock => clock,
		reset => BTNU,
		input => booth_product,
		enable => "00111111",
		anodes => ANODES,
		cathodes => CATHODES
	);
	
	led_mgr : process(clock)
	begin
		if clock'event and clock = '1' then
			if BTNU = '1' or start = '1' then
				LED <= "0";
			elsif booth_done = '1' then
				LED <= "1";
			end if;
		end if;
	end process;
end structural;
