library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;


entity MEM_N is
	generic(
		N : in integer := 8
	);
	port(
		clock : in std_logic;
		write : in std_logic;
		address : in std_logic_vector(integer(ceil(log2(real(N)))) - 1 downto 0);
		input : in std_logic_vector(0 to 3)
	);
end MEM_N;

architecture behavioral of MEM_N is

	type mem_N_4 is array (0 to N - 1) of std_logic_vector (0 to 3);
	signal mem : mem_N_4 := (others => (x"0"));
	attribute rom_style : string;
	attribute rom_style of mem : signal is "block";
	
begin
	process(clock)
	begin
		if clock'event and clock = '1' then
			if write = '1' then
				mem(to_integer(unsigned(address))) <= input;
			end if;
		end if ;
	end process;
end behavioral;
