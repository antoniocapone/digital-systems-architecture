library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity handshaking is
	port(
		clock: in std_logic;
		reset: in std_logic;
		start: in std_logic
	);
end handshaking;

architecture structural of handshaking is

    signal read_rom : std_logic;
    signal address_A : std_logic_vector(0 to 3);
    signal rom_output : std_logic_vector(0 to 7);
    signal counter_enable_A : std_logic;
    signal counter_reset_A : std_logic;
    signal counter_Q_A : std_logic;
    
    signal req : std_logic;
    signal ack : std_logic;
    
    signal register_x_load : std_logic;
    signal register_x_output : std_logic_vector(7 downto 0);
    signal register_add_load : std_logic;
    signal register_add_output : std_logic_vector(7 downto 0);
    
    signal address_B : std_logic_vector(0 to 3);
    signal counter_enable_B : std_logic;
    signal counter_reset_B : std_logic;
    signal counter_Q_B : std_logic;
    
    signal mem_write : std_logic;
    signal mem_read : std_logic;
    
    signal adder_output : std_logic_vector(7 downto 0);
    signal adder_x : std_logic_vector(7 downto 0);
    signal adder_y : std_logic_vector(7 downto 0);

	component MEM
		port(
			clock: in std_logic;
            write : in std_logic;
            read : in std_logic;
            address : in std_logic_vector(3 downto 0);
            input : in std_logic_vector(0 to 7);
            output : out std_logic_vector(0 to 7)
		);
	end component;
	
	component ROM
		port(
			clock: in std_logic;
			read : in std_logic;
			address : in std_logic_vector(3 downto 0);
			output : out std_logic_vector(0 to 7)
		);
	end component;
	
	component register_8
		port(
			clock : in std_logic;
			reset : in std_logic;
			load : in std_logic;
			input : in std_logic_vector(7 downto 0);
			output : out std_logic_vector(7 downto 0)
		);
	end component;
	
	component counter
		port(
			clock : in std_logic;
			enable : in std_logic;
			reset : in std_logic;
			output : out std_logic_vector(0 to 3);
			Q : out std_logic
		);
	end component;
	
	component control_unitA
		port(
			clock: in std_logic;
			reset: in std_logic;
			start: in std_logic;
			counter_enable: out std_logic;
			counter_reset: out std_logic;
			counter_Q: in std_logic;
			read: out std_logic;
			req: out std_logic;
			ack: in std_logic
		);
	end component;
	
	component control_unitB
		port(
			clock: in std_logic;
			reset: in std_logic;
			start: in std_logic;
			counter_enable: out std_logic;
			counter_reset: out std_logic;
			counter_Q: in std_logic;
			read: out std_logic;
			write: out std_logic;
			load_rx: out std_logic;
			load_sum: out std_logic;
			req: in std_logic;
			ack: out std_logic
		);
	end component;
	
	component adder
        port (
            x: in std_logic_vector(7 downto 0);
            y: in std_logic_vector(7 downto 0);
            output: out std_logic_vector(7 downto 0)
        );
    end component;

begin
    
    rom_8: ROM
    port map(
        clock => clock,
        read => read_rom,
        address => address_A,
        output => rom_output
    );

    cnt_A: counter
    port map(
        clock => clock,
        enable => counter_enable_A,
        reset => counter_reset_A,
        output => address_A,
        Q => counter_Q_A
    );
    
    cu_A: control_unitA
    port map(
        clock => clock,
        reset => reset,
        start => start,
        counter_enable => counter_enable_A,
        counter_reset => counter_reset_A,
        counter_Q => counter_Q_A,
        read => read_rom,
        req => req,
        ack => ack
    );
    
    reg_x: register_8
    port map(
        clock => clock,
        reset => '0',
        load => register_x_load,
        input => rom_output,
        output => register_x_output
    );
    
    reg_add: register_8
    port map(
        clock => clock,
        reset => '0',
        load => register_add_load,
        input => adder_output,
        output => register_add_output
    );
    
    cnt_B: counter
    port map(
        clock => clock,
        enable => counter_enable_B,
        reset => counter_reset_B,
        output => address_B,
        Q => counter_Q_B
    );
    
    memB: MEM
    port map(
        clock => clock,
        write => mem_write,
        read => mem_read,
        address => address_B,
        input => register_add_output,
        output => adder_y
    );
    
    cu_B: control_unitB
    port map(
        clock => clock,
        reset => reset,
        start => start, -- TODO: cambiare
        counter_enable => counter_enable_B,
        counter_reset => counter_reset_B,
        counter_Q => counter_Q_B,
        read => mem_read,
        write => mem_write,
		load_rx => register_x_load,
		load_sum => register_add_load,
        req => req,
        ack => ack
    );
    
    adder_b: adder
    port map(
        x => adder_x,
        y => adder_y,
        output => adder_output
    );
   
end structural;
