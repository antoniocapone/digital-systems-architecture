library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;


entity MEM_N_M is
	generic(
		N : in integer := 8;
		M : in integer := 8
	);
	port(
		clock : in std_logic;
		reset : in std_logic;
		read : in std_logic;
		write : in std_logic;
		address : in std_logic_vector(integer(ceil(log2(real(N)))) - 1 downto 0);
		input : in std_logic_vector(0 to M - 1);
		output : out std_logic_vector(0 to M - 1)
	);
end MEM_N_M;

architecture behavioral of MEM_N_M is

	type mem_N_4 is array (0 to N - 1) of std_logic_vector (0 to M - 1);
	signal mem : mem_N_4 := (others => (others => '0'));
	attribute rom_style : string;
	attribute rom_style of mem : signal is "block";
	
begin
	process(clock)
	begin
		if clock'event and clock = '1' then
			if reset = '1' then
				mem <= (others => (others => '0'));
			else
				if read = '1' then
					output <= mem(to_integer(unsigned(address)));
				end if;
				if write = '1' then
					mem(to_integer(unsigned(address))) <= input;
				end if;
			end if;
		end if ;
	end process;
end behavioral;
