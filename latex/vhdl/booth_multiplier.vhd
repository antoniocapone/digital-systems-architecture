library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.MATH_REAL.ALL;


entity booth_multiplier is
	port(
		clock: in std_logic;
		reset: in std_logic;
		start: in std_logic;
		x: in std_logic_vector(7 downto 0);
		y: in std_logic_vector(7 downto 0);
		output : out std_logic_vector(15 downto 0);
		done : out std_logic
	);
end booth_multiplier;

architecture structural of booth_multiplier is

	component register_8
	port(
		clock : in std_logic;
		reset : in std_logic;
		load : in std_logic;
		input : in std_logic_vector (7 downto 0);
		output : out std_logic_vector(7 downto 0)
	);
	end component;

	component adder_subtractor
	port(
		a : in std_logic_vector(7 downto 0);
		b : in std_logic_vector(7 downto 0);
		cin : in std_logic;
		s : out std_logic_vector(7 downto 0);
		cout : out std_logic
	);
	end component;

	component shiftregister
	port(
		clock : in std_logic;
		reset : in std_logic;
		load : in std_logic;
		shift : in std_logic;
		input : in std_logic_vector(15 downto 0);
		output : out std_logic_vector(15 downto 0);
		serial_output : out std_logic
	);
	end component;
	
	component counter
	generic(
		max_count : integer := 10
	);
	port(
		clock : in std_logic;
		enable : in std_logic;
		reset : in std_logic;
		load : in std_logic;
		input : in std_logic_vector(0 to integer(ceil(log2(real(max_count)))) - 1);
		output : out std_logic_vector(0 to integer(ceil(log2(real(max_count)))) - 1);
		Q : out std_logic
	);
	end component;

	component control_unit
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
	end component;

	signal M : std_logic_vector(7 downto 0);
	signal m_load : std_logic;
	signal counter_Q : std_logic;
	signal counter_enable : std_logic;
	signal counter_reset : std_logic;
	signal adder_subtractor_s : std_logic_vector(7 downto 0);
	signal adder_subtractor_cin : std_logic;
	signal shiftregister_shift : std_logic;
	signal shiftregister_load : std_logic := '0';
	signal shiftregister_input : std_logic_vector(15 downto 0);
	signal shiftregister_serial_output : std_logic := '0';
	signal booth_eval : std_logic_vector(1 downto 0);
	signal shiftr_mux_s : std_logic;
	signal output_sig : std_logic_vector(15 downto 0) := (others => '0');

begin
	shiftregister_input <= "00000000" & x when shiftr_mux_s = '1' else adder_subtractor_s & output_sig(7 downto 0);
	booth_eval <= output_sig(0) & shiftregister_serial_output;
	output <= output_sig;
	
	reg_8 : register_8
	port map(
		clock => clock,
		reset => reset,
		load => m_load,
		input => y,
		output => M
	);

	shift_reg : shiftregister
	port map(
		clock => clock,
		reset => reset,
		load => shiftregister_load,
		shift => shiftregister_shift,
		input => shiftregister_input,
		output => output_sig,
		serial_output => shiftregister_serial_output
	);

	add_sub : adder_subtractor
	port map(
		a => output_sig(15 downto 8),
		b => M,
		cin => adder_subtractor_cin,
		s => adder_subtractor_s,
		cout => open
	);

	counter_8 : counter
	generic map(
		max_count => 8
	)
	port map(
		clock => clock,
		enable => counter_enable,
		reset => counter_reset,
		load => '0',
		input => (others => '0'),
		output => open,
		Q => counter_Q
	);

	ctrl_unit : control_unit
	port map(
		clock => clock,
		reset => reset,
		start => start,
		booth_eval => booth_eval,
		counter_Q => counter_Q,
		counter_enable => counter_enable,
		counter_reset => counter_reset,
		shiftregister_shift => shiftregister_shift,
		shiftregister_load => shiftregister_load,
		shiftr_mux_s => shiftr_mux_s,
		m_load => m_load,
		add_sub_cin => adder_subtractor_cin,
		done_sig => done
	);

end structural;
