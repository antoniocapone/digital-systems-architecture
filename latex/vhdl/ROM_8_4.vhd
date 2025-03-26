library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity ROM_8_4 is
	port(
		clock : in std_logic;
		read : in std_logic;
		address : in std_logic_vector(2 downto 0);
		output : out std_logic_vector(0 to 3)
	);
end ROM_8_4;

architecture behavioral of ROM_8_4 is

	type rom_8_4 is array (0 to 7) of std_logic_vector (0 to 3);
	signal rom : rom_8_4 := (x"A", x"D", x"7", x"E",
							 x"2", x"3", x"F", x"4");
	attribute rom_style : string;
	attribute rom_style of rom : signal is "block";
	
begin
	process(clock)
	begin
		if clock'event and clock = '1' then
			if read = '1' then
				output <= rom(to_integer(unsigned(address)));
			end if;
		end if;
	end process;
end behavioral;
