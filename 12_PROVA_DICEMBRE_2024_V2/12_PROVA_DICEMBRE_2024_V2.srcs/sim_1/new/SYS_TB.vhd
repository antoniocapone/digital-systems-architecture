library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity SYS_TB is
end SYS_TB;

architecture behavioral of SYS_TB is

    signal clockA: std_logic;
    signal clockB: std_logic;
    
    constant periodA: time := 2ns;
    constant periodB: time := 3ns;
    
    signal startA: std_logic;
    signal reset_both: std_logic;
    signal req: std_logic;
    signal ack: std_logic;
    signal data: std_logic_vector(0 to 3);

    component UNIT_A
        port (
            clock: in std_logic;
            start: in std_logic;
            reset: in std_logic;
            req: out std_logic;
            ack: in std_logic;
            data: out std_logic_vector(0 to 3)
        );
    end component;
    
    component UNIT_B
        port (
            clock: in std_logic;
            reset: in std_logic;
            req: in std_logic;
            ack: out std_logic;
            data: in std_logic_vector(0 to 3)
        );
    end component;

begin

    uutA: UNIT_A
    port map (
        clock => clockA,
        start => startA,
        reset => reset_both,
        req => req,
        ack => ack,
        data => data
    );
    
    uutB: UNIT_B
    port map (
        clock => clockB,
        reset => reset_both,
        req => req,
        ack => ack,
        data => data
    );

    clock_A_proc: process
    begin
        clockA <= '1';
        wait for periodA;
        clockA <= '0';
        wait for periodA;
    end process;
    
    clock_B_proc: process
    begin
        clockB <= '1';
        wait for periodA;
        clockB <= '0';
        wait for periodB;
    end process;

    stim_proc: process
    begin
        wait for 10ns;
        startA <= '1';
        wait for 10ns;
        startA <= '0';
        wait for 1500ns;
        wait;
    end process;

end behavioral;
