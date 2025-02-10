library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity cathodes_manager is
	port(
		value : in  std_logic_vector (3 downto 0);
		dot : in  std_logic;
		cathodes_dot : out  std_logic_vector (7 downto 0)
	);
end cathodes_manager;

architecture behavioral of cathodes_manager is

	constant zero   : std_logic_vector(6 downto 0) := "1000000";
	constant one    : std_logic_vector(6 downto 0) := "1111001";
	constant two    : std_logic_vector(6 downto 0) := "0100100";
	constant three  : std_logic_vector(6 downto 0) := "0110000";
	constant four   : std_logic_vector(6 downto 0) := "0011001";
	constant five   : std_logic_vector(6 downto 0) := "0010010";
	constant six    : std_logic_vector(6 downto 0) := "0000010";
	constant seven  : std_logic_vector(6 downto 0) := "1111000";
	constant eight  : std_logic_vector(6 downto 0) := "0000000";
	constant nine   : std_logic_vector(6 downto 0) := "0010000";
	
	signal cathodes : std_logic_vector(6 downto 0);	

begin
	with value select
		cathodes <=	zero			when "0000",
					one 			when "0001",
					two				when "0010",
					three			when "0011",
					four			when "0100",
					five			when "0101",
					six				when "0110",
					seven			when "0111",
					eight			when "1000",
					nine			when "1001",
					(others => '0')	when others;

	cathodes_dot <= (not dot) & cathodes;
end behavioral;
