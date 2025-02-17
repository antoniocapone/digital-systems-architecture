library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity adder is
    port (
        x: in std_logic_vector(7 downto 0);
        y: in std_logic_vector(7 downto 0);
        output: out std_logic_vector(7 downto 0)
    );
end adder;

architecture behavioral of adder is

begin

    p: process(x, y)
    begin
        output <= std_logic_vector(UNSIGNED(x) + UNSIGNED(y));
    end process;

end behavioral;
