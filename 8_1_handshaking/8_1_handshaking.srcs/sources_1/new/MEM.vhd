library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;


entity MEM is
	port(
		clock: in std_logic;
		write : in std_logic;
		read : in std_logic;
		address : in std_logic_vector(2 downto 0);
		input : in std_logic_vector(0 to 7);
		output : out std_logic_vector(0 to 7)
	);
end MEM;

architecture behavioral of MEM is

	type mem_8_8 is array (0 to 7) of std_logic_vector (0 to 7);
	signal mem : mem_8_8 := (others => (x"00"));
	attribute rom_style : string;
	attribute rom_style of mem : signal is "block";
	
begin
	process(clock)
	begin
		if clock'event and clock = '1' then
			if write = '1' then
				mem(to_integer(unsigned(address))) <= input;
			end if;
			if read = '1' then
				output <= mem(to_integer(unsigned(address)));
			end if;
		end if ;
	end process;
end behavioral;