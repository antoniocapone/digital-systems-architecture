library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity control_unit_B is
	port(
		clock : in std_logic;
		reset : in std_logic;
		req : in std_logic;
		ack : out std_logic;
		counter_enable : out std_logic;
		mem_read : out std_logic;
		mem_write : out std_logic;
		reg_read : out std_logic
	);
end control_unit_B;

architecture behavioral of control_unit_B is

	type state is (WAIT_TX, ACK_TX, WAIT_END_REQ, END_TX);
	signal current_state : state := WAIT_TX;
	attribute fsm_encoding : string;
	attribute fsm_encoding of current_state : signal is "one_hot";

begin
	process(clock)
	begin
		if clock'event and clock = '1' then
			if reset = '1' then
				ack <= '0';
				counter_enable <= '0';
				mem_read <= '0';
				mem_write <= '0';
				reg_read <= '0';
				current_state <= WAIT_TX;
			else
				case current_state is
					when WAIT_TX =>
						counter_enable <= '0';
						mem_write <= '0';
						if req = '1' then
							current_state <= ACK_TX;
						end if;
					when ACK_TX =>
						ack <= '1';
						reg_read <= '1';
						mem_read <= '1';
						current_state <= WAIT_END_REQ;
					when WAIT_END_REQ =>
						reg_read <= '0';
						mem_read <= '0';
						if req = '0' then
							current_state <= END_TX;
						end if;
					when END_TX =>
						ack <= '0';
						mem_write <= '1';
						counter_enable <= '1';
						current_state <= WAIT_TX;
				end case;
			end if;
		end if;
	end process;
end behavioral;
