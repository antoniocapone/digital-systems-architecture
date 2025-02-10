library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity control_unit is
	port(
		clock : in std_logic;
		start : in std_logic;
		reset : in std_logic;
		Q_counter : in std_logic;
		read_rom : out std_logic;
		write_mem : out std_logic;
		enable_counter : out std_logic;
		reset_counter : out std_logic
	);
end control_unit;

architecture behavioral of control_unit is
	type stato is (S0, S1, S2, S3);
	signal current_state : stato := S0;
	attribute fsm_encoding : string;
	attribute fsm_encoding of current_state : signal is "one_hot";
begin
	process(clock)
	begin
		if clock'event and clock = '1' then
			if reset = '1' then
				read_rom <= '0';
				write_mem <= '0';
				enable_counter <= '0';
				reset_counter <= '1';
				current_state <= S0;
			else
				case current_state is
					when S0 =>
						enable_counter <= '0';
						reset_counter <= '1';
						read_rom <= '0';
						write_mem <= '0';
						if start = '1' then
							current_state <= S1;
						end if;
					when S1 =>
						enable_counter <= '1';
						reset_counter <= '0';
						read_rom <= '1';
						current_state <= S2;
					when S2 =>
						enable_counter <= '0';
						read_rom <= '0';
						write_mem <= '1';
						current_state <= S3;
					when S3 =>
						write_mem <= '0';
						if Q_counter = '1' then
							current_state <= S0;
						else
							current_state <= S1;
						end if;
				end case;
			end if;
		end if;
	end process;
end behavioral;
