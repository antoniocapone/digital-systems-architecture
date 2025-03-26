library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Funzionamento del progetto:
-- Per l'inserimento dei 4 bit di indirizzo si utilizzano i 4 switches di sinistra,
-- in notazione posizionale; l'output verrà mostrato sui 4 led di sinistra, da
-- sinistra a destra.
-- Nota: la netlist mostra come nel design sintetizzato uno degli switch venga
-- ignorato. Questo poiché la ROM contiene dati duplicati, di conseguenza l'output
-- sarà lo stesso indipendentemente dal MSB, che viene dunque ignorato.

entity S_onboard is
	port(
		SW : in std_logic_vector (15 downto 12);
		LED : out std_logic_vector (15 downto 12)
	);
end S_onboard;

architecture structural of S_onboard is

	component S
	port(
		input : in std_logic_vector (0 to 3);
		output : out std_logic_vector(0 to 3)
	);
	end component;

begin
	S_onboard : S
	port map(
		input => SW,
		output => LED
	);

end structural;
