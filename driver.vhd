library IEEE; 
use IEEE.std_logic_1164.ALL;
use IEEE.std_logic_arith.ALL;
use IEEE.std_logic_unsigned.ALL;
use IEEE.numeric_std.all;

entity driver is
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
		from_pio_reg_out : in std_logic_vector(7 downto 0); -- Registre où sont enregistres les 8 bits d'un caractere (provient du software)
		--from_pio_reg_inout	: in std_logic_vector(7 downto 0);
		from_pio_reg_inout	: in std_logic_vector(7 downto 0);
		--from_GPIO_0_0_inout	: in std_logic;
	   -- lien
		-- Inout ports
		to_gpio_1_0_out : out std_logic := '1' -- to_gpio_1_0_out

	);
end driver;

architecture rtl of driver is
	constant p: natural := freqcore/baudrate; 
	constant p2: natural := freqcore/(baudrate*2);
	--signal to_gpio_1_0_out: std_logic := '1';
	
	--Build an enumerated type for the state machine
	--type state_type is (s0, s1, s2, s3);
	type state_type is (s0, s2, s3);
	-- Register to hold the current state
	signal state : state_type;
	signal Tran : std_logic_vector(7 downto 0);
	

begin

process (CLK, RST)

variable count : natural;
variable index : natural;

begin
	if (RST = '1') then
		count := 0;
		index := 0;
		state <= s0;
		
		elsif (rising_edge(CLK)) then -- count increases at CLK Hz (50MHz)
		
		-- Determine the next state synchronously, based on
			-- the current state and the input
			case state is
			
				when s0=>
						to_gpio_1_0_out <= '1';  -- Waiting state
					if from_pio_reg_inout(0) = '1' then -- When this value is put to 1 by the software, the hardware begins to send the bits
						to_gpio_1_0_out <= '0'; -- bit start - We send a 0 to the slave to let them know that we begin to send the bits
						count := 0;
						index := 0;
						Tran <= from_pio_reg_out(7 downto 0);
						state <= s2;
					else
						state <= s0;
					end if;		
					
				--when s1=>
				--	if count = p2 then -- This state waits for p2
				--		count := 0;
				--		index := 0;
				--		state <= s2;
				--	else
				--		count := count + 1;
				--		state <= s1;
				--	end if; -- The state is blocked to state 1 until we have waited p2
					
				when s2=>
					if index = 8 then -- It means that we have sent all the bits of information 
						--to_gpio_1_0_out <= '1'; -- We send a 1 to the slave to let him know that the transmission of the first character is done
						--count :=0;
						index := 0;
						state <= s3;
					else
						if count = p then                                        -- Here we send the eight bits of information
							to_gpio_1_0_out <= Tran(7-index);        -- We send bit to bit
							count := 0;                                           -- We put the count to 0 
							index := index + 1; 
						else
							count := count + 1;                                   
						end if;
						state <= s2;                                             -- exit state 2
					end if;
					
				when s3=>
					if count = p then 
					to_gpio_1_0_out <= '1';
					state <= s0;
					else
					--to_gpio_1_0_out <= '1';
					count := count + 1;
					state <= s3;
					end if;
				when others=>
					count := 0;
					state <= s0;
					index := 0;
			end case;
		end if;

end process;
end rtl;
