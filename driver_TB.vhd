
library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_logic_arith.ALL;
use IEEE.std_logic_unsigned.ALL;
use IEEE.numeric_std.all;

entity driver_TB is
end driver_TB;

architecture behavior of driver_TB is

	constant PERIOD : time := 20 ns;
	constant PERIODin : time := 104.2 us;-- Equivalent à 104.2us mais plus précis

	component driver
		port (
			CLK	: in  std_logic;
			RST	: in  std_logic;
			from_pio_reg_out : in std_logic_vector(7 downto 0); -- Registre où sont enregistrés les 8 bits d'un caractère (provient du software)
			--from_pio_reg_inout	: in std_logic_vector(7 downto 0);
			from_pio_reg_inout	: in std_logic_vector(7 downto 0);
			--from_GPIO_0_0_inout : in std_logic; --lien
			to_gpio_1_0_out : out std_logic -- Tx
		);
	end component;

	for DUT: driver use entity work.driver(RTL);
	
	signal sCLK	  : std_logic := '0';
	signal sCLKin	  : std_logic := '0';
	signal sRST	  : std_logic := '1';
	
	signal REG: std_logic_vector(7 downto 0);

	signal to_from_GPIO_0_0_inout : std_logic_vector(7 downto 0);
	signal VAL : std_logic_vector(7 downto 0);
	--signal TEST : std_logic_vector(9 downto 0); -- Registre dans lequel on va stocker les informations reçues
	signal Tx: std_logic := '1';  --:= '1';
	
	--constant p: natural := PERIOD/PERIODin; -- we count p times at 50MHz to make 9600bps
	--constant p2: natural := p/2; 
	
	--Build an enumerated type for the state machine
	type state_type is (s0, s1, s2, s3);
	-- Register to hold the current state
	signal state : state_type;

begin

	DUT: driver
		port map (
			RST => sRST,
			CLK => sCLK,
			from_pio_reg_inout => to_from_GPIO_0_0_inout,
			from_pio_reg_out => VAL,
			to_gpio_1_0_out => Tx
		);
		
	P_sCLK: process
	begin -- 50MHz clock
		sCLK <= not sCLK;
		wait for PERIOD/2;
	end process;
	
	P_sCLKin: process
	begin -- 9600Hz clock
		sCLKin <= not sCLKin;
		wait for PERIODin/2;
	end process;
	
	P_sRST: process
	begin -- generate active 1 reset
		sRST <= '1';
		wait for 3*PERIOD;
		sRST <= '0';
		wait;
	end process;
	

	P_stimuli : process
	variable i : natural := 0;
	
	begin

		VAL <= std_logic_vector(to_unsigned(i,8));
		to_from_GPIO_0_0_inout(0) <= '0';
		
		
		
		--Start Bit
		wait for PERIODin*15;
		to_from_GPIO_0_0_inout(0) <= '1';
		
		wait for PERIODin;
		to_from_GPIO_0_0_inout(0) <= '0';
		
		REG(7) <= Tx;
		wait for PERIODin;                                      
		REG(6) <= Tx;  
		wait for PERIODin;                                      
		REG(5) <= Tx;  
		wait for PERIODin;                                      
		REG(4) <= Tx;  
		wait for PERIODin;                                      
		REG(3) <= Tx;  
		wait for PERIODin;                                     
		REG(2) <= Tx;  
		wait for PERIODin;                                      
		REG(1) <= Tx;  
		wait for PERIODin;                                      
		REG(0) <= Tx;  
		
		--wait until Tx = '0';
		--wait for PERIODin/2;
		i := i + 1;
		--to_from_GPIO_0_0_inout <= '0';
		assert REG /= VAL report "Assertion REG /= VAL." severity error;

	end process;
end behavior;