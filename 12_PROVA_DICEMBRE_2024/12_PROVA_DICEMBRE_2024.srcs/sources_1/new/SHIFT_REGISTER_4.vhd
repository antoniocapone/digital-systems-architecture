library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity REGISTER_4 is
    port (
        clk: in std_logic := '0';
        load: in std_logic := '0';
        data_in: in std_logic_vector(3 downto 0) := "0000";
        data_out: out std_logic_vector(3 downto 0) := "0000"
    );
end REGISTER_4;

architecture behavioral of REGISTER_4 is

begin

    reg_proc: process(clk)
    begin
        if (rising_edge(clk)) then
            if (load = '1') then
                data_out <= data_in;
            end if;
        end if;
    end process;

end behavioral;
