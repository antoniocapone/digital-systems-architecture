library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity CL_ADDER_4 is
    port (
        op1: in std_logic_vector(0 to 3);
        op2: in std_logic_vector(0 to 3);
        carry_in: in std_logic;
        output: out std_logic_vector(0 to 3);
        carry_out: out std_logic
    );
end CL_ADDER_4;

architecture structural of CL_ADDER_4 is

begin

    adder_proc: process(op1, op2)
    begin
        output <= op1 + op2 + carry_in;
    end process;

end structural;
