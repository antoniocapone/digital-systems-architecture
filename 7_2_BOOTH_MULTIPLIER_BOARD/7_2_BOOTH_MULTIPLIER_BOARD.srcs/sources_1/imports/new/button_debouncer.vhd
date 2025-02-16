library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity button_debouncer is
	generic (
		clock_period: integer := 10;
		noise_time: integer := 10000000
	);
	port (
		reset : in std_logic;
		clock : in std_logic;
		button : in std_logic;
		button_debounced : out std_logic
	);
end button_debouncer;

architecture behavioral of button_debouncer is

type stato is (NOT_PRESSED, CHK_PRESSED, PRESSED, CHK_NOT_PRESSED);
signal button_state : stato := NOT_PRESSED;

constant max_count : integer := noise_time/clock_period;

begin
	process (clock)
		variable count: integer := 0;
	begin
		if clock'event and clock = '1' then
			if reset = '1' then
				button_state <= NOT_PRESSED;
				button_debounced <= '0';
			else
				case button_state is
					when NOT_PRESSED =>
						if button = '1' then
							button_state <= CHK_PRESSED;
						else 
							button_state <= NOT_PRESSED;
						end if;
					
					when CHK_PRESSED =>
						if count = max_count -1 then
							if button = '1' then
								count:=0;
								button_debounced <= '1';
								button_state <= PRESSED;
							else
								count:=0;
								button_state <= NOT_PRESSED;
							end if;
						else 
							count:= count+1;
							button_state <= CHK_PRESSED;
						end if;
					
					when PRESSED =>
						button_debounced<= '0';
						if button = '0' then
							button_state <= CHK_NOT_PRESSED;
						else
							button_state <= PRESSED;
						end if;
					
					when CHK_NOT_PRESSED =>
						if count = max_count -1 then
							if button = '0' then
								count:=0;
								button_state <= NOT_PRESSED;
							else
								count:=0;
								button_state <= PRESSED;
							end if;
						else 
							count:= count+1;
							button_state <= CHK_NOT_PRESSED;
						end if;
					
					when others => 
						button_state <= NOT_PRESSED;
				end case;
			end if;  
		end if;  
	end process;
end behavioral;
