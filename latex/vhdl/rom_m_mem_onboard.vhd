library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Funzionamento del progetto:
-- Il pulsante centrale fornisce il segnale di start alla macchina, che effettua la
-- scansione delle locazioni della ROM. L'uscita di M è fornita attraverso i quattro
-- LED di sinistra. Per consentire la visione delle uscite, il clock dell'unità di
-- contollo è rallentato ad una frequenza di 1 Hz. Il pulsante in alto è di reset.

entity rom_m_mem_onboard is
	port(
		CLK100MHZ : in std_logic;
		BTNC : in std_logic;
		BTNU : in std_logic;
		LED : out std_logic_vector(15 downto 12)
	);
end rom_m_mem_onboard;

architecture structural of rom_m_mem_onboard is

	component rom_m_mem
	generic(
		N : integer := 8
	);
	port(
		clock : in std_logic;
		start : in std_logic;
		reset : in std_logic;
		output : out std_logic_vector(0 to 3)
	);
	end component;
	
	component clock_divider
	generic(
		clock_frequency_in : integer := 100000000;	--100MHz
		clock_frequency_out : integer := 500 		--500 Hz
	);
	port(
		clock : in  std_logic;
		reset : in std_logic;
		clock_divided : out  std_logic
	);
	end component;
	
	signal clock_divided : std_logic;

begin
	clk_divider : clock_divider
	generic map(
		clock_frequency_out => 1
	)
	port map(
		clock => CLK100MHZ,
		reset => '0',
		clock_divided => clock_divided
	);
	
	rom_m_mem_inst : rom_m_mem
	port map(
		clock => clock_divided,
		start => BTNC,
		reset => BTNU,
		output => LED
	);
end structural;
