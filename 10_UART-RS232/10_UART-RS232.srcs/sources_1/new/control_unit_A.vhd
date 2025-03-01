library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity control_unit_A is
	port(
		clock : in std_logic;
		reset : in std_logic ;
		start : in std_logic ;
		counter_reset : out std_logic;
		counter_enable : out std_logic;
		counter_Q : in std_logic;
		rom_read : out std_logic;
		WR : out std_logic;
		TBE : in std_logic
	);
end control_unit_A;

architecture behavioral of control_unit_A is
	type state is (IDLE, READ_DATA, TX_DATA, WAIT_TX, WAIT_SERIAL, CHECK_COUNT);
	signal current_state : state := IDLE;
	attribute fsm_encoding : string;
	attribute fsm_encoding of current_state : signal is "one_hot";
begin
	process(clock)
	begin
		if clock'event and clock = '1' then
			if reset = '1' then
				counter_enable <= '0';
				rom_read <= '0';
				WR <= '0';
			else
				case current_state is
					when IDLE =>
						counter_reset <= '1';
						if start = '1' then
							current_state <= READ_DATA;
						end if;
					when READ_DATA =>
						counter_reset <= '0';
						rom_read <= '1';
						current_state <= TX_DATA;
					when TX_DATA =>
						rom_read <= '0';
						counter_enable <= '1';
						WR <= '1';
						current_state <= WAIT_TX;
					when WAIT_TX =>
						WR <= '0';
						counter_enable <= '0';
						current_state <= WAIT_SERIAL;
					when WAIT_SERIAL =>
						if TBE = '1' then
							current_state <= CHECK_COUNT;
						end if;
					when CHECK_COUNT =>
						if counter_Q = '1' then
							current_state <= IDLE;
						else
							current_state <= READ_DATA;
						end if;
				end case;
			end if;
		end if;
	end process;
end behavioral;
