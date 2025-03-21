library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PROVA_DICEMBRE is
    port (
        clkA: in std_logic;
        clkB: in std_logic;
        startA: in std_logic
    );
end PROVA_DICEMBRE;

architecture structural of PROVA_DICEMBRE is

    signal req: std_logic;
    signal ack: std_logic;
    signal data: std_logic_vector(0 to 3);

    component unit_A
        port (
            clk: in std_logic := '0';
            rst: in std_logic := '0';
            start: in std_logic := '0';
            req: out std_logic := '0';
            ack: in std_logic := '0';
            data: out std_logic_vector(0 to 3)
        );
    end component;
    
    component unit_B
        port (
            clk: in std_logic := '0';
            rst: in std_logic := '0';
            req: in std_logic := '0';
            ack: out std_logic := '0';
            data: in std_logic_vector(0 to 3)
        );
    end component;

begin

    uA: unit_A
    port map (
        clk => clkA,
        start => startA,
        req => req,
        ack => ack,
        data => data
    );
    
    uB: unit_B
    port map (
        clk => clkB,
        req => req,
        ack => ack,
        data => data
    );


end structural;
