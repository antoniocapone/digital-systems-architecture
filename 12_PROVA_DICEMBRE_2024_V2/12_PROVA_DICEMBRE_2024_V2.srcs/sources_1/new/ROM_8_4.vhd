library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- ROM 8 parole da 4 bit
entity ROM_8_4 is
    port (
        clock: in std_logic;
        read: in std_logic;
        address: in std_logic_vector(2 downto 0);
        output: out std_logic_vector(0 to 3)
    );
end ROM_8_4;

architecture behavioral of ROM_8_4 is

    type rom is array(0 to 7) of std_logic_vector(0 to 3); -- array di 8 elementi da 4 bit
    signal values: rom := (x"A", x"B", x"C", x"D", x"E", x"F", x"1", x"2");

begin

    rom_proc: process(clock)
    begin
        if (clock'EVENT and clock = '1' and read = '1') then
            output <= values(to_integer(unsigned(address)));
        end if;
    end process;

end behavioral;
