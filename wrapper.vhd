-- wrapper

-- architectures:
-- RTL_test: example testing HPS inout register used as control signals
-- structure_driver_out_example_3: example using a driver output to generate variable width pulses
-- structure_driver_in_example_3: example using a driver input to read the width of an input pulse
-- structure_driver_example_3: example using both drivers in/out 

-- configuration:
-- use the configuration at the end of the file to select the architecture to implement.
-- Just change the architecture name.

library ieee;
use ieee.std_logic_1164.all;

entity wrapper is
	port (		
		CLK					: in std_logic;
		RST					: in std_logic;
		LED					: out std_logic_vector(7 downto 0);
		SW					: in std_logic_vector(3 downto 0);
		KEY					: in std_logic_vector(1 downto 0);
		from_GPIO_0_1_in	: in std_logic; -- peripheral input (RX)
		from_GPIO_0_0_inout	: in std_logic;	-- bidirectional peripheral input (S2C data)
		to_GPIO_0_0_inout	: out std_logic; -- bidirectional peripheral output (S2C data) 
		to_gpio_1_0_out		: out std_logic; -- peripheral output (TX)
		from_pio_reg_out	: in std_logic_vector(7 downto 0);
		from_pio_reg_inout	: in std_logic_vector(7 downto 0);
		to_pio_reg_in		: out std_logic_vector(7 downto 0);
		to_pio_reg_inout	: out std_logic_vector(7 downto 0) 
	);
end wrapper;

architecture driver of wrapper is
	
	component driver is
	generic
	(
	baudrate : natural := 9600;
	freqcore : natural := 50000000
	);
		port
	(
	   -- Input ports
		CLK	: in  std_logic;
		RST	: in  std_logic;
		from_pio_reg_out : in std_logic_vector(7 downto 0); -- Registre où sont enregistrés les 8 bits d'un caractère (provient du software)
		--from_pio_reg_inout	: in std_logic_vector(7 downto 0);
		from_pio_reg_inout	: in std_logic_vector(7 downto 0);
		--from_GPIO_0_0_inout	: in std_logic;
	   -- lien
		-- Inout ports
		to_gpio_1_0_out : out std_logic := '1' -- to_gpio_1_0_out

	);
	end component;
	for I_driver: driver use entity work.driver(RTL);
	
	signal LED_0 : std_logic; -- state s0
	signal LED_1 : std_logic; -- state s1
	
	signal WRn_from_pio_reg_inout_0	: std_logic;
	signal ACKn_to_pio_reg_inout_1	: std_logic; -- ACKn 
	signal RDY_to_pio_reg_inout_2	: std_logic; -- ready	
			
begin	
	WRn_from_pio_reg_inout_0 	<= from_pio_reg_inout(0);
	to_pio_reg_inout(0) 		<= 'Z';
	to_pio_reg_inout(1) 		<= ACKn_to_pio_reg_inout_1;
	to_pio_reg_inout(2) 		<= RDY_to_pio_reg_inout_2;
	
	I_driver: driver 
		port map ( 					
			CLK							=> CLK,
			RST							=> RST,
			from_pio_reg_out => from_pio_reg_out,
			from_pio_reg_inout => from_pio_reg_inout,
			to_gpio_1_0_out => to_gpio_1_0_out
	);
end driver;