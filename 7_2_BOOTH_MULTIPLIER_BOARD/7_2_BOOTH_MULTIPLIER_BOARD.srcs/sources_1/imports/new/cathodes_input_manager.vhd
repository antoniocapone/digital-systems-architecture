library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity cathodes_input_manager is
	port(
		counter : in std_logic_vector(2 downto 0);
		value : in std_logic_vector(15 downto 0);
		digit_out : out std_logic_vector(3 downto 0)
	);
end cathodes_input_manager;

architecture behavioal of cathodes_input_manager is
	type int_list is array(0 to 5) of integer;
	-- LUT per l'esponenziale di 10 (non sintetizzabile altrimenti)
	constant exp10 : int_list := (1, 10, 100, 1000, 10000, 100000);
begin
	process(counter)
		variable value_integer : integer;
		variable count : integer range 0 to 7;
	begin
		value_integer := to_integer(signed(value));
		count := to_integer(unsigned(counter));
		if count > 5 then
			-- Cifre mai visualizzabili perché fuori range
			digit_out <= "1010";
		elsif value_integer = 0 and count = 0 then
			-- Caso particolare di risultato nullo (visualizza zero solo nel primo display)
			digit_out <= "0000";
		elsif abs(value_integer) > exp10(count) - 1 then
			-- Visualizza la cifra sul display appropriato
			digit_out <= std_logic_vector(to_unsigned(abs(value_integer / exp10(count)) mod 10, 4));
		elsif abs(value_integer) > exp10(count - 1) - 1 and value(15) = '1' then
			-- Visualizza il segno meno nel display successivo alla cifra più significativa
			digit_out <= "1111";
		else
			-- Spegni i display successivi alla cifra più significativa (e all'eventuale meno)
			digit_out <= "1010";
		end if;
	end process;
end behavioal;
