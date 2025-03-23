library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity UNIT_B is
    port (
        clock: in std_logic;
        reset: in std_logic;
        req: in std_logic;
        ack: out std_logic;
        data: in std_logic_vector(0 to 3)
    );
end UNIT_B;

architecture structural of UNIT_B is

    signal buf_load: std_logic;
    signal buf_out: std_logic_vector(0 to 3);
    
    signal reg_in: std_logic_vector(0 to 3);
    signal reg_out: std_logic_vector(0 to 3);
    signal reg_load: std_logic;

    component REG_4_PIPO
        port (
            clock: in std_logic;
            load: in std_logic;
            input: in std_logic_vector(0 to 3);
            output: out std_logic_vector(0 to 3)
        );
    end component;
    
    component CL_ADDER_4
        port (
            op1: in std_logic_vector(0 to 3);
            op2: in std_logic_vector(0 to 3);
            carry_in: in std_logic;
            output: out std_logic_vector(0 to 3);
            carry_out: out std_logic
        );
    end component;
    
    component CU_B
        port (
            clock: in std_logic;
            reset: in std_logic;
            load_buf: out std_logic;
            load_r: out std_logic;
            req: in std_logic;
            ack: out std_logic
        );
    end component;

begin

    buf: REG_4_PIPO
    port map (
        clock => clock,
        load => buf_load,
        input => data,
        output => buf_out
    );
    
    adder: CL_ADDER_4
    port map (
        op1 => buf_out,
        op2 => reg_out,
        carry_in => '0',
        output => reg_in
    );
    
    reg: REG_4_PIPO
    port map (
        clock => clock,
        load => reg_load,
        input => reg_in,
        output => reg_out
    );
    
    control_unit: CU_B
    port map (
        clock => clock,
        reset => reset,
        load_buf => buf_load,
        load_r => reg_load,
        req => req,
        ack => ack
    );

end structural;
