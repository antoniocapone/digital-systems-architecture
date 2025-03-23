library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity UNIT_A is
    port (
        clock: in std_logic;
        start: in std_logic;
        reset: in std_logic;
        req: out std_logic;
        ack: in std_logic;
        data: out std_logic_vector(0 to 3)
    );
end UNIT_A;

architecture structural of UNIT_A is

    signal q_counter: std_logic;
    signal reset_counter: std_logic;
    signal enable_counter: std_logic;
    signal enable_rom: std_logic;
    
    signal address_rom: std_logic_vector(2 downto 0);

    component CU_A
        port (
            clock: in std_logic;
            reset: in std_logic;
            start: in std_logic;
            q_counter: in std_logic;
            reset_counter: out std_logic := '0';
            enable_counter: out std_logic := '0';
            enable_rom: out std_logic := '0';
            req: out std_logic;
            ack: in std_logic
        );
    end component;
    
    component ROM_8_4
        port (
            clock: in std_logic;
            read: in std_logic;
            address: in std_logic_vector(2 downto 0);
            output: out std_logic_vector(0 to 3)
        );
    end component;
    
    component COUNT_8
        port (
            clock: in std_logic;
            reset: in std_logic;
            enable: in std_logic;
            q: out std_logic := '0';
            output: out std_logic_vector(2 downto 0)
        );
    end component;

begin

    control_unit: CU_A
    port map (
        clock => clock,
        reset => reset,
        start => start,
        q_counter => q_counter,
        reset_counter => reset_counter,
        enable_counter => enable_counter,
        enable_rom => enable_rom,
        req => req,
        ack => ack
    );

    rom: ROM_8_4
    port map (
        clock => clock,
        read => enable_rom,
        address => address_rom,
        output => data
    );
    
    counter: COUNT_8
    port map (
        clock => clock,
        reset => reset_counter,
        enable => enable_counter,
        q => q_counter,
        output => address_rom
    );

end structural;
