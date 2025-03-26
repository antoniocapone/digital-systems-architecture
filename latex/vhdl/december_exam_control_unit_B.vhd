library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity control_unit_B is
	port(
		clock : in std_logic;
		reset : in std_logic;
		buffer_load : out std_logic;
		register_load : out std_logic;
		req : in std_logic;
		ack : out std_logic
	);
end control_unit_B;

architecture behavioral of control_unit_B is

	type state is (WAIT_REQ, ACK_TX, WAIT_NO_REQ, STORE_SUM);
	signal current_state : state := WAIT_REQ;
	attribute fsm_encoding : string;
	attribute fsm_encoding of current_state : signal is "one_hot";

begin
	process(clock)
	begin
		if clock'event and clock = '1' then
			if reset = '1' then
				buffer_load <= '0';
				register_load <= '0';
				ack <= '0';
				current_state <= WAIT_REQ;
			else
				case current_state is
					when WAIT_REQ =>
						register_load <= '0';
						if req = '1' then
							current_state <= ACK_TX;
						end if;
					when ACK_TX =>
						ack <= '1';
						buffer_load <= '1';
						current_state <= WAIT_NO_REQ;
					when WAIT_NO_REQ =>
						buffer_load <= '0';
						if req = '0' then
							current_state <= STORE_SUM;
						end if;
					when STORE_SUM =>
						register_load <= '1';
						ack <= '0';
						current_state <= WAIT_REQ;
				end case;
			end if;
		end if;
	end process;
end behavioral;
