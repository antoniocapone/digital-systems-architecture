library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity control_unitB is
	port(
		clock: in std_logic;
		reset: in std_logic;
		start: in std_logic;
		counter_enable: out std_logic;
		counter_reset: out std_logic;
		counter_Q: in std_logic;
		read: out std_logic;
		write: out std_logic;
		load_rx: out std_logic;
		load_sum: out std_logic;
		req: in std_logic;
		ack: out std_logic
	);
end control_unitB;

architecture behavioral of control_unitB is
	type state is (IDLE, WAIT_TX, ACK_TX, WAIT_END_REQ, END_TX, STORE_SUM, COUNT);
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
						counter_enable <= '0';
						counter_reset <= '1';
						write <= '0';
						if start = '1' then
							current_state <= WAIT_TX;
						end if;
					when WAIT_TX =>
						counter_enable <= '0';
						counter_reset <= '0';
						write <= '0';
						if req = '1' then
							current_state <= ACK_TX;
						end if;
					when ACK_TX =>
						ack <= '1';
						load_rx <= '1';
						current_state <= WAIT_END_REQ;
					when WAIT_END_REQ =>
						load_rx <= '0';
						if req = '0' then
							current_state <= END_TX;
						end if;
					when END_TX =>
						ack <= '0';
						read <= '1';
						current_state <= STORE_SUM;
					when STORE_SUM =>
						load_sum <= '1';
						read <= '0';
						current_state <= COUNT;
					when COUNT =>
						write <= '1';
						load_sum <= '0';
						counter_enable <= '1';	-- aggiorna il contatore per il prossimo ciclo
						if counter_Q = '1' then
							current_state <= IDLE;
						else
							current_state <= WAIT_TX;
						end if;
				end case;
			end if;
		end if;
	end process;
end behavioral;
