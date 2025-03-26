library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;


entity ROM_N_M is
	generic(
		N : in integer := 8;
		M : in integer := 8
	);
	port(
		clock : in std_logic;
		read : in std_logic;
		address : in std_logic_vector(integer(ceil(log2(real(N)))) - 1 downto 0);
		output : out std_logic_vector(0 to M - 1)
	);
end ROM_N_M;

architecture behavioral of ROM_N_M is

	type rom_N_8 is array (0 to N - 1) of std_logic_vector (0 to M - 1);
	signal rom : rom_N_8 := (x"A8", x"BD", x"17", x"E0",
							 x"C2", x"03", x"FF", x"46",
							 others => (x"00"));
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