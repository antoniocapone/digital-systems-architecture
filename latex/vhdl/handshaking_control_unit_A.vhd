library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity control_unit_A is
	port(
		clock : in std_logic;
		reset : in std_logic;
		start : in std_logic;
		ack : in std_logic;
		req : out std_logic;
		counter_Q : in std_logic;
		counter_enable : out std_logic;
		counter_reset : out std_logic;
		rom_read : out std_logic
	);
end control_unit_A;

architecture behavioral of control_unit_A is

	type state is (IDLE, DATA_READ, DATA_WAIT, START_TX, END_TX, CHECK_COUNT);
	signal current_state : state := IDLE;
	attribute fsm_encoding : string;
	attribute fsm_encoding of current_state : signal is "one_hot";

begin
	process(clock)
	begin
		if clock'event and clock = '1' then
			if reset = '1' then
				req <= '0';
				counter_enable <= '0';
				rom_read <= '0';
				current_state <= IDLE;
			else
				case current_state is
					when IDLE =>
						counter_reset <= '1';
						if start = '1' then
							current_state <= DATA_READ;
						end if;
					when DATA_READ =>
						counter_reset <= '0';
						rom_read <= '1';
						current_state <= DATA_WAIT;
					when DATA_WAIT =>
						counter_enable <= '1';
						rom_read <= '0'; 
						current_state <= START_TX;
					when START_TX =>
						req <= '1';
						counter_enable <= '0';
						if ack = '1' then
							current_state <= END_TX;
						end if;
					when END_TX =>
						req <= '0';
						if ack = '0' then
							current_state <= CHECK_COUNT;
						end if;
					when CHECK_COUNT =>
						if counter_Q = '1' then
							current_state <= IDLE;
						else
							current_state <= DATA_READ;
						end if;
				end case;
			end if;
		end if;
	end process;
end behavioral;
