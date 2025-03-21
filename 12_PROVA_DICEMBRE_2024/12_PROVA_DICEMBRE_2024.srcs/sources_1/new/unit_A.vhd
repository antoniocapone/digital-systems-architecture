library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity unit_A is
    port (
        clk: in std_logic := '0';
        rst: in std_logic := '0';
        start: in std_logic := '0';
        req: out std_logic := '0';
        ack: in std_logic := '0';
        data: out std_logic_vector(0 to 3)
    );
end unit_A;

architecture behavioral of unit_A is

    type state is (IDLE, READ, START_TX, WAIT_ACK, END_TX, CHECK); -- READ coincide con READ_ROM
    signal current_state : state := IDLE;

    signal read_rom: std_logic;
    signal addr_rom: std_logic_vector(2 downto 0);
    signal data_rom: std_logic_vector(3 downto 0);
    
    signal en_counter: std_logic;
    signal rst_counter: std_logic;
    signal output_counter: std_logic_vector(2 downto 0);
    signal q_counter: std_logic;
    
    component SYNCH_ROM
        port (
            clk: in std_logic;
            read: in std_logic;
            addr: in std_logic_vector(2 downto 0);
            data: out std_logic_vector(0 to 3)
        );
    end component;
    
    component COUNTER_MOD_8
        port (
            clk: in std_logic;
            en: in std_logic;
            rst: in std_logic;
            output: out std_logic_vector(2 downto 0) := "000";
            q: out std_logic
        );
    end component;

begin

    rom: SYNCH_ROM
    port map (
        clk => clk,
        read => read_rom,
        addr => addr_rom,
        data => data_rom
    );
    
    counter: COUNTER_MOD_8
    port map (
        clk => clk,
        en => en_counter,
        rst => rst_counter,
        output => output_counter,
        q => q_counter
    );
    
    proc_a: process(clk)
    begin
        if (clk'EVENT and clk = '1') then -- rising edge

            case current_state is
                when IDLE =>
                    rst_counter <= '1';
                    if (start = '1') then
                        current_state <= READ;
                    end if;
                when READ =>
                    rst_counter <= '0';
                    read_rom <= '1';
                    current_state <= START_TX;
                when START_TX =>
                    read_rom <= '0';
                    en_counter <= '1';
                    req <= '1';
                    current_state <= WAIT_ACK;
                when WAIT_ACK =>
                    en_counter <= '0';
                    if (ack = '1') then
                        current_state <= END_TX;
                    end if;
                when END_TX =>
                    req <= '0';
                    if (ack = '0') then
                        current_state <= CHECK;
                    end if;
                when CHECK =>
                    if (q_counter = '1') then
                        current_state <= IDLE;
                    else
                        current_state <= READ;
                    end if;
            end case;

        end if;
    end process;


end behavioral;
