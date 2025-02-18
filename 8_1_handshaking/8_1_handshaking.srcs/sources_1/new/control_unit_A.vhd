library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity control_unitA is
	port(
		clock: in std_logic;
		reset: in std_logic;
		start: in std_logic;
		counter_enable: out std_logic;
		counter_reset: out std_logic;
		counter_Q: in std_logic;
		read: out std_logic;
		req: out std_logic;
		ack: in std_logic
	);
end control_unitA;

architecture behavioral of control_unitA is
	type state is (IDLE, START_TX, WAIT_ACK, END_TX, COUNT);--, CHECK, CHECK1);
	signal current_state : state := IDLE;

	attribute fsm_encoding : string;
	attribute fsm_encoding of current_state : signal is "one_hot";
begin
	process(clock)
	begin
		if clock'event and clock = '1' then
			if reset = '1' then
				current_state <= IDLE;
			else
				case current_state is
					when IDLE =>
						counter_reset <= '1';
						if start = '1' then
							current_state <= START_TX;
						end if;
					when START_TX =>
						counter_reset <= '0';
						counter_enable <= '1';
						req <= '1';
						read <= '1';
						current_state <= WAIT_ACK;
					when WAIT_ACK =>
						read <= '0';
						counter_enable <= '0';
						if ack = '1' then
							current_state <= END_TX;
						end if;
					when END_TX =>
						req <= '0';
						if ack = '0' then
							current_state <= COUNT;
						end if;
					when COUNT =>
						if counter_Q = '1' then
							current_state <= IDLE;
						else
							current_state <= START_TX;
						end if;
				end case;
			end if;
		end if;
	end process;
end behavioral;
