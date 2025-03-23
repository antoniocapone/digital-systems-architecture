library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity COUNT_8 is
    port (
        clock: in std_logic;
        reset: in std_logic;
        enable: in std_logic;
        q: out std_logic := '0';
        output: out std_logic_vector(2 downto 0)
    );
end COUNT_8;

architecture behavioral of COUNT_8 is

begin

    count_proc: process(clock, reset)
        variable count : integer range 0 to 7 := 0;
    begin
        if (reset = '1') then
            output <= "000";
        elsif (clock'EVENT and clock = '1' and enable = '1') then
            q <= '0';
            if (count = 7) then
                q <= '1';
            end if;
            count := count + 1;
            output <= std_logic_vector(to_unsigned(count, 3));
        end if;
        
    end process;

end behavioral;
