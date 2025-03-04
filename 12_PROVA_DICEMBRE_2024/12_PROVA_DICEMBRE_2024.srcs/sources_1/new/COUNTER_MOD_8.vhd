library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity COUNTER_MOD_8 is
    port (
        clk: in std_logic;
        en: in std_logic;
        rst: in std_logic;
        output: out std_logic_vector(2 downto 0) := "000"; -- counter exit
        q: out std_logic -- EOC bit
    );
end COUNTER_MOD_8;

architecture dataflow of COUNTER_MOD_8 is

    constant max_count: integer := 7;

begin

    counter_proc: process(clk)
    variable count : integer range 0 to max_count - 1 := 0;
    begin
        if (rising_edge(clk)) then

            q <= '0';

            if (rst = '1') then
                count := 0;
            elsif (en = '1') then
                if (count = max_count) then
                    count := 0;
                    q <= '1';
                else
                    count := count + 1;
                end if;
            end if;

            output <= std_logic_vector(to_unsigned(count, 3));

        end if;
    end process;

end dataflow;
