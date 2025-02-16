library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity ripple_carry_adder_8 is
	port(
		a : in std_logic_vector(7 downto 0);
		b : in std_logic_vector(7 downto 0);
		cin : in std_logic;
		s : out std_logic_vector(7 downto 0);
		cout : out std_logic
	);
end ripple_carry_adder_8;

architecture structural of ripple_carry_adder_8 is
	component full_adder
		port(
			a : in std_logic;
			b : in std_logic;
			cin : in std_logic;
			s : out std_logic;
			cout : out std_logic
		);
	end component;
	
	signal c : std_logic_vector(8 downto 0);
begin
	c(0) <= cin;
	cout <= c(8);

	fa_array : for i in 0 to 7 generate
		f_adder : full_adder
		port map(
			a => a(i),
			b => b(i),
			cin => c(i),
			s => s(i),
			cout => c(i+1)
		);
	end generate;
end structural;
