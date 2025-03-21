library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity unit_B is
    port (
        clk: in std_logic := '0';
        rst: in std_logic := '0';
        req: in std_logic := '0';
        ack: out std_logic := '0';
        data: in std_logic_vector(0 to 3)
    );
end unit_B;

architecture behavioral of unit_B is

    type state is (WAIT_REQ, ACK_TX, END_TX, STORE_SUM);
    
    signal current_state: state := WAIT_REQ;

    signal buf_load: std_logic;
    signal buf_out: std_logic_vector(0 to 3);
    
    signal r_load: std_logic;
    
    signal adder_out: std_logic_vector(3 downto 0);
    signal adder_op2: std_logic_vector(3 downto 0);

    component REGISTER_4
        port (
            clk: in std_logic := '0';
            load: in std_logic := '0';
            data_in: in std_logic_vector(3 downto 0) := "0000";
            data_out: out std_logic_vector(3 downto 0) := "0000"
        );
    end component;
    
    component CARRY_LOOK_AHEAD_4
        port (
            op1: in std_logic_vector(3 downto 0);
            op2: in std_logic_vector(3 downto 0);
            c_in: in std_logic;
            sum: out std_logic_vector(3 downto 0)
        );
    end component;

begin

    buf: REGISTER_4
    port map (
        clk => clk,
        load => buf_load,
        data_in => data,
        data_out => buf_out
    );
    
    R: REGISTER_4
    port map (
        clk => clk,
        load => r_load,
        data_in => adder_out,
        data_out => adder_op2
    );
    
    adder: CARRY_LOOK_AHEAD_4
    port map (
        op1 => buf_out,
        op2 => adder_op2,
        c_in => '0',
        sum => adder_out
    );
    
    unitB_proc: process(clk)
    begin
        if (clk'EVENT and clk = '1') then
            case current_state is
                when WAIT_REQ =>
                    r_load <= '0';
                    if (req = '1') then
                        current_state <= ACK_TX;
                    end if;
                when ACK_TX =>
                    buf_load <= '1';
                    ack <= '1';
                    current_state <= END_TX;
                when END_TX =>
                    buf_load <= '0';
                    if (req = '0') then
                        current_state <= STORE_SUM;
                    end if;
                when STORE_SUM =>
                    ack <= '0';
                    r_load <= '1';
             end case;
        end if;
    end process;


end behavioral;
