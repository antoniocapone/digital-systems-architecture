library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity CARRY_LOOK_AHEAD_4 is
    port (
        op1: in std_logic_vector(3 downto 0);
        op2: in std_logic_vector(3 downto 0);
        c_in: in std_logic;
        sum: out std_logic_vector(3 downto 0)
    );
end CARRY_LOOK_AHEAD_4;

-- TODO: farlo carry look ahead
architecture structural of CARRY_LOOK_AHEAD_4 is

begin

    add_proc: process(op1, op2, c_in)
    begin
        sum <= op1 + op2 + c_in;
    end process;

end structural;
