library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Sequence_Detector is
port (
	input : in std_logic;
	M : in std_logic;
	reset : in std_logic;
	clock: in std_logic;
	A : in std_logic;
	state_output_led : out std_logic_vector(0 to 6);
	Y : out std_logic
);
end Sequence_Detector;

architecture behavioral of Sequence_Detector is
	signal current_mode : std_logic := '0';
	type stato is (S0, S1, S2, S3, S4, S5, S6);
	signal current_state : stato := S0;
	attribute fsm_encoding : string;
	attribute fsm_encoding of current_state : signal is "one_hot";
begin
	sequence_detector : process(clock)
	begin
		if clock'event and clock = '1' then
			if reset = '1' or current_mode /= M then
				state_output_led <= "0000001";
				current_state <= S0;
				Y <= '0';
				current_mode <= M;
			elsif A = '1' then
				case current_state is
					when S0 =>
						if current_mode = '0' then
							if input = '0' then
								state_output_led <= "0000100";
								current_state <= S2;
							else
								state_output_led <= "0000010";
								current_state <= S1;
							end if;
						else
							if input = '0' then
								state_output_led <= "0000001";
								current_state <= S0;
							else
								state_output_led <= "0100000";
								current_state <= S5;
							end if;
						end if;
						Y <= '0';
					when S1 =>
						if input = '0' then
							state_output_led <= "0001000";
							current_state <= S3;
						else
							state_output_led <= "0010000";
							current_state <= S4;
						end if;
						Y <= '0';
					when S2 =>
						state_output_led <= "0010000";
						current_state <= S4;
						Y <= '0';
					when S3 =>
						state_output_led <= "0000001";
						current_state <= S0;
						Y <= input;
					when S4 =>
						state_output_led <= "0000001";
						current_state <= S0;
						Y <= '0';
					when S5 =>
						if input = '0' then
							state_output_led <= "1000000";
							current_state <= S6;
						else
							state_output_led <= "0100000";
							current_state <= S5;
						end if;
						Y <= '0';
					when S6 =>
						state_output_led <= "0000001";
						current_state <= S0;
						Y <= input;
				end case;
			end if;
		end if;
	end process;
end behavioral;
