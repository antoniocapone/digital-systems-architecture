library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CU_B is
    port (
        clock: in std_logic;
        reset: in std_logic;
        load_buf: out std_logic;
        load_r: out std_logic;
        req: in std_logic;
        ack: out std_logic
    );
end CU_B;

architecture behavioral of CU_B is

    type state is (WAIT_REQ, ACK_TX, END_TX, STORE_SUM);
    signal current_state: state := WAIT_REQ;

begin

    cu_proc: process(clock)
    begin
        if (clock'EVENT and clock = '1') then
            case current_state is
                when WAIT_REQ =>
                    load_r <= '0';
                    if (req = '1') then
                        current_state <= ACK_TX;
                    end if;
                when ACK_TX =>
                    load_buf <= '1';
                    ack <= '1';
                    current_state <= END_TX;
                when END_TX =>
                    load_buf <= '0';
                    if (req = '0') then
                        current_state <= STORE_SUM;
                    end if;
                when STORE_SUM =>
                    ack <= '0';
                    load_r <= '1';
                    current_state <= WAIT_REQ;
            end case;
        end if;
    end process;

end behavioral;
