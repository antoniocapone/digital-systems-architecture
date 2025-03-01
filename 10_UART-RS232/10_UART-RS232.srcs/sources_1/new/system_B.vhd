library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.MATH_REAL.ALL;


entity system_B is
	port(
		clock : in std_logic;
		reset : in std_logic;
		RX : in std_logic;
		TX : out std_logic;
        error : out std_logic
	);
end system_B;

architecture structural of system_B is

	component control_unit_B
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
    end component;
	
	component MEM_8_8
    port(
        clock : in std_logic;
		write : in std_logic;
		address : in std_logic_vector(2 downto 0);
		input : in std_logic_vector(0 to 7)
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
	
	component RS232RefComp
	port( 
		TXD : out std_logic := '1';
		RXD : in  std_logic;
		CLK : in  std_logic;
		DBIN : in  std_logic_vector (7 downto 0);
		DBOUT : out std_logic_vector (7 downto 0);
		RDA : inout std_logic;
		TBE : inout std_logic := '1';
		RD : in  std_logic;
		WR : in  std_logic;
		PE : out std_logic;
		FE : out std_logic;
		OE : out std_logic;
		RST : in  std_logic := '0'
	);
	end component;
	
	signal counter_reset : std_logic;
	signal counter_enable : std_logic;
	signal mem_address : std_logic_vector(2 downto 0);
	signal mem_write : std_logic;
	signal RD : std_logic;
	signal RDA : std_logic;
	signal DBOUT : std_logic_vector(7 downto 0);
    signal PE : std_logic;
    signal FE : std_logic;
    signal OE : std_logic;

begin
	control_unit : control_unit_B
    port map(
        clock => clock,
        reset => reset,
        counter_reset => counter_reset,
        counter_enable => counter_enable,
        mem_write => mem_write,
        RD => RD,
        RDA => RDA,
        PE => PE,
        FE => FE,
        OE => OE,
        error => error
    );
	
	mem : MEM_8_8
    port map(
        clock => clock,
        write => mem_write,
        address => mem_address,
        input => DBOUT
    );

	cnt : counter
	generic map(
		max_count => 8
	)
	port map(
		clock => clock,
		enable => counter_enable,
		reset => counter_reset,
		load => '0',
		input => (others => '0'),
		output => mem_address,
		Q => open
	);

	serial : RS232RefComp
	port map(
        TXD => TX,
        RXD => RX,
        CLK => clock,
        DBIN => (others => '0'),
        DBOUT => DBOUT,
        RDA => RDA,
        TBE => open,
        RD => RD,
        WR => '0',
        PE => PE,
        FE => FE,
        OE => OE,
        RST => reset
    );
end structural;
