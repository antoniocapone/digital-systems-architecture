library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity shiftregister_structural is
	generic(
		bit_number : integer := 8
	);
	port(
		clock : in std_logic;
		reset : in std_logic;
		load : in std_logic;
		Y : in std_logic;
		shift_left : in std_logic;
		input : in std_logic_vector(0 to bit_number - 1);
		output : out std_logic_vector(0 to bit_number - 1)
	);
end shiftregister_structural;

architecture structural of shiftregister_structural is
	signal bit_array : std_logic_vector(0 to bit_number - 1) := (others => '0');
	signal bit_array_shifted: std_logic_vector(0 to bit_number - 1) := (others => '0');
	signal flipflop_input : std_logic_vector(0 to bit_number - 1) := (others => '0');
	
	component flipflop_D
	port(
		clock : in std_logic;
		reset : in std_logic;
		d : in std_logic;
		y : out std_logic
	);
	end component;
	
	component mux_2_1
	port(
		a : in std_logic_vector(0 to 1);
		s : in std_logic;
		y : out std_logic
	);
	end component;
	
	component mux_4_1
	port(
		a : in std_logic_vector(0 to 3);
        s : in std_logic_vector(1 downto 0);
        y : out std_logic
	);
	end component;
begin
	output <= bit_array;
	ffd_gen: for i in 0 to bit_number - 1 generate
		mux_shift_bit_array_i : mux_4_1
		port map(
			a(0) => bit_array((i - 1) mod bit_number),
			a(1) => bit_array((i - 2) mod bit_number),
			a(2) => bit_array((i + 1) mod bit_number),
			a(3) => bit_array((i + 2) mod bit_number),
			s(0) => Y,
			s(1) => shift_left,
			y => bit_array_shifted(i)
		);
		mux_load_i : mux_2_1
		port map(
			a(0) => bit_array_shifted(i),
			a(1) => input(i),
			s => load,
			y => flipflop_input(i)
		);
		ffd_i : flipflop_D
		port map(
			clock => clock,
			reset => reset,
			d => flipflop_input(i),
			y => bit_array(i)
		);
	end generate;	
end structural;
