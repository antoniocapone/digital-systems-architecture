library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity control_unit_B is
	port(
		clock : in std_logic;
		reset : in std_logic ;
		counter_reset : out std_logic;
		counter_enable : out std_logic;
		mem_write : out std_logic;
		RD : out std_logic;
		RDA : in std_logic;
		PE : in std_logic;
		FE : in std_logic;
		OE : in std_logic;
		error : out std_logic
	);
end control_unit_B;

architecture behavioral of control_unit_B is
	type state is (WAIT_RDA, READ_DATA, CHECK_ERR);
	signal current_state : state := WAIT_RDA;
	attribute fsm_encoding : string;
	attribute fsm_encoding of current_state : signal is "one_hot";
begin
	process(clock)
		variable error_var : std_logic := '0';
	begin
		if clock'event and clock = '1' then
			if reset = '1' then
				counter_reset <= '1';
				counter_enable <= '0';
				mem_write <= '0';
				RD <= '0';
				error_var := '0';
				error <= '0';
			else
				case current_state is
					when WAIT_RDA =>
						counter_reset <= '0';
						if RDA = '1' then
							current_state <= READ_DATA;
						end if;
					when READ_DATA =>
						counter_enable <= '1';
						mem_write <= '1';
						RD <= '1';
						current_state <= CHECK_ERR;
					when CHECK_ERR =>
						counter_enable <= '0';
						mem_write <= '0';
						RD <= '0';
						error_var := error_var or PE or FE or OE;
						error <= error_var;
						current_state <= WAIT_RDA;
				end case;
			end if;
		end if;
	end process;
end behavioral;
