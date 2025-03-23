library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity REG_4_PIPO is
    port (
        clock: in std_logic;
        load: in std_logic;
        input: in std_logic_vector(0 to 3);
        output: out std_logic_vector(0 to 3)
    );
end REG_4_PIPO;

architecture behavioral of REG_4_PIPO is

begin

    reg_proc: process(clock)
    begin
        if (clock'EVENT and clock = '1') then
            if (load = '1') then
                output <= input;
            end if;
        end if;
    end process;

end behavioral;
