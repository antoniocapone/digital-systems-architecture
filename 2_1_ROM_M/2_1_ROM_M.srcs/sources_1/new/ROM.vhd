library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;


entity ROM is
	port(
		address : in std_logic_vector(3 downto 0);
		data : out std_logic_vector(7 downto 0)
	);
end ROM;

architecture behavioral of ROM is

	type rom_16_8 is array (0 to 15) of std_logic_vector (0 to 7);
	signal rom : rom_16_8 := (x"A8", x"BD", x"17", x"E0",
							  x"C2", x"03", x"FF", x"46",
							  x"A8", x"BD", x"17", x"E0",
							  x"C2", x"03", x"FF", x"46");
	attribute rom_style : string;
	attribute rom_style of rom : signal is "block";
	
begin
	process(address)
	begin
		data <= ROM(to_integer(unsigned(address)));
	end process;
end behavioral;
