library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

--  ROM sincrona 8 parole da 4 bit
entity SYNCH_ROM is
    port (
        clk: in std_logic;
        read: in std_logic;
        addr: in std_logic_vector(2 downto 0);
        data: out std_logic_vector(0 to 3)
    );
end SYNCH_ROM;

architecture dataflow of SYNCH_ROM is

    type rom_8_4 is array (0 to 7) of std_logic_vector (0 to 3);
    signal values: rom_8_4 := (x"D", x"A", x"C", x"4", x"6", x"9", x"F", x"B");

begin

    rom_proc: process(clk)
    begin
        if(rising_edge(clk)) then
            if (read = '1') then
                data <= values(to_integer(unsigned(addr)));
            end if;
        end if;
    end process;

end dataflow;
