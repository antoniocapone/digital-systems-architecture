library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity control_unit is
	port(
		clock : in std_logic;
		reset : in std_logic;
		start : in std_logic;
		booth_eval : in std_logic_vector(1 downto 0);
		counter_Q : in std_logic;
		counter_enable : out std_logic;
		counter_reset : out std_logic;
		shiftregister_shift : out std_logic;
		shiftregister_load : out std_logic;
		shiftr_mux_s : out std_logic;
		m_load : out std_logic;
		add_sub_cin : out std_logic;
		done_sig : out std_logic
	);
end control_unit;

architecture behavioral of control_unit is

	type state is (IDLE, LOAD_OPERANDS, BOOTH, TEST, SUM, SUB, SHIFT, DONE);
	signal current_state : state := IDLE;
	attribute fsm_encoding : string;
	attribute fsm_encoding of current_state : signal is "one_hot";

begin
	state_mgr : process(clock)
	begin
		if clock'event and clock = '1' then
			if reset = '1' then
				current_state <= IDLE;
			else
				counter_enable <= '0';
				counter_reset <= '0';
				shiftregister_shift <= '0';
				shiftregister_load <= '0';
				shiftr_mux_s <= '0';
				m_load <= '0';
				add_sub_cin <= '0';
				done_sig <= '0';
				
				case current_state is
					when IDLE =>
						if start = '1' then
							current_state <= LOAD_OPERANDS;
						end if;
					when LOAD_OPERANDS =>
						m_load <= '1';
						shiftregister_load <= '1';
						shiftr_mux_s <= '1';
						counter_reset <= '1';
						current_state <= TEST;
					when TEST =>
						if counter_Q = '1' then
							current_state <= DONE;
						else
							current_state <= BOOTH;
						end if;
						-- Si incrementa il contatore per il TEST successivo
						counter_enable <= '1';
					when BOOTH =>
						if booth_eval = "01" then
							current_state <= SUM;
						elsif booth_eval = "10" then
							current_state <= SUB;
						else
							current_state <= SHIFT;
						end if;
					when SUM =>
						add_sub_cin <= '0';
						shiftregister_load <= '1';
						current_state <= SHIFT;
					when SUB =>
						add_sub_cin <= '1';
						shiftregister_load <= '1';
						current_state <= SHIFT;
					when SHIFT =>
						shiftregister_shift <= '1';
						current_state <= TEST;
					when DONE =>
						done_sig <= '1';
						current_state <= IDLE;
				end case;
			end if;
		end if;
	end process;
end behavioral;
