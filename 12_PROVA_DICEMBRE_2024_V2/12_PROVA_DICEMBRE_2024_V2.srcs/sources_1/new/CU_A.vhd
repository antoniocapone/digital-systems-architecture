library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CU_A is
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
end CU_A;

architecture behavioral of CU_A is

    type state is (IDLE, READ_ROM, START_TX, WAIT_ACK, END_TX, CHECK);
    signal current_state: state := IDLE;

begin

    cu_A_proc: process(clock)
    begin
        if (clock'EVENT and clock = '1') then
            case current_state is
                when IDLE =>
                    reset_counter <= '1';
                    if (start = '1') then
                        current_state <= READ_ROM;
                    end if;
                when READ_ROM =>
                    reset_counter <= '0';
                    enable_rom <= '1';
                    current_state <= START_TX;
                when START_TX =>
                    enable_rom <= '0';
                    enable_counter <= '1';
                    req <= '1';
                    current_state <= WAIT_ACK;
                when WAIT_ACK =>
                    enable_counter <= '0';
                    if (ack = '1') then
                        current_state <= END_TX;
                    end if;
                when END_TX =>
                    req <= '0';
                    if (ack = '0') then
                        current_state <= CHECK;
                    end if;
                when CHECK =>
                    if (q_counter = '0') then
                        current_state <= READ_ROM;
                    else
                        current_state <= IDLE;
                    end if;
            end case;
         end if;
    end process;

end behavioral;
