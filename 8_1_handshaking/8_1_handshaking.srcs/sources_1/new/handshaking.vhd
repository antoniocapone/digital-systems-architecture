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
	component MEM
		port(
			clock: in std_logic;
			write : in std_logic;
			address : in std_logic_vector(3 downto 0);
			input : in std_logic_vector(0 to 7)
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
			load : in std_logic;
			input : in std_logic_vector(0 to 3);
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
	
	component control_unitB is
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
begin


end structural;
