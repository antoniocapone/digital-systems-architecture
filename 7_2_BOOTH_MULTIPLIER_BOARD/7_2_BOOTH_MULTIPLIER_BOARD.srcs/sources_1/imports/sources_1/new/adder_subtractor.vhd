library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity adder_subtractor is
    port(
        a : in std_logic_vector(7 downto 0);
        b : in std_logic_vector(7 downto 0);
        cin : in std_logic;
        s : out std_logic_vector(7 downto 0);
        cout : out std_logic
    );
end adder_subtractor;

architecture structural of adder_subtractor is
    component ripple_carry_adder_8
    port(
        a : in std_logic_vector(7 downto 0);
        b : in std_logic_vector(7 downto 0);
        cin : in std_logic;
        s : out std_logic_vector(7 downto 0);
        cout : out std_logic
    );
    end component;

    signal b_complemented : std_logic_vector(7 downto 0);
begin

    xor8 : for i in 0 to 7 generate
        b_complemented(i) <= b(i) xor cin;
    end generate;

    rca8 : ripple_carry_adder_8
    port map(
        a => a,
        b => b_complemented,
        cin => cin,
        s => s,
        cout => cout
    );
    
end structural;
