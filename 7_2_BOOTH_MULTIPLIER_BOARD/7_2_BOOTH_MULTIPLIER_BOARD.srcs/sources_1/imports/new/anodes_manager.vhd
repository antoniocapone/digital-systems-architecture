library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity anodes_manager is
	port(
		counter : in  std_logic_vector (2 downto 0);
		enable_digit : in  std_logic_vector (7 downto 0);
		anodes : out  std_logic_vector (7 downto 0)
	);
end anodes_manager;

architecture behavioral of anodes_manager is

	signal anodes_switching : std_logic_vector(7 downto 0) := (others => '0');

begin
	anodes <= not anodes_switching or not enable_digit;
	anodes_process: process(counter)
	begin
		case counter is
			when "000" =>
				anodes_switching <= "00000001";
			when "001" =>
				anodes_switching <= "00000010";
			when "010" =>
				anodes_switching <= "00000100";
			when "011" =>
				anodes_switching <= "00001000";
			when "100" =>
				anodes_switching <= "00010000";
			when "101" =>
				anodes_switching <= "00100000";
			when "110" =>
				anodes_switching <= "01000000";
			when "111" =>
				anodes_switching <= "10000000";
			when others =>
				anodes_switching <= (others => '0');
		end case;
	end process;
end behavioral;
