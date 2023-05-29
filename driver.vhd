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
		from_pio_reg_out : in std_logic_vector(7 downto 0); -- Registre où sont enregistrés les 8 bits d'un caractère (provient du software)
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
						to_gpio_1_0_out <= '1';  --état par défaut d'attente
					if from_pio_reg_inout(0) = '1' then -- Quand la valeur de ce registre est mis à 1 par le software, l'hardware peut commencer à envoyer
						to_gpio_1_0_out <= '0'; -- bit start - On envoie à l'esclave un 0 pour leur dire qu'on va commencer à envoyer
						count := 0;
						index := 0;
						Tran <= from_pio_reg_out(7 downto 0);
						state <= s2;
					else
						state <= s0;
					end if;		
					
				--when s1=>
				--	if count = p2 then --cette été sert à attendre p2
				--		count := 0;
				--		index := 0;
				--		state <= s2;
				--	else
				--		count := count + 1;
				--		state <= s1;
				--	end if; -- On reste bloqué à l'état 1 jusqu'au moment où on aura attendu p2 
					
				when s2=>
					if index = 8 then -- Cela veut dire qu'on a envoyé tous nos bits d'informations 
						--to_gpio_1_0_out <= '1'; -- On envoie un 1 (0) à l'esclave pour lui dire que la transmission du premier caractère est terminée
						--count :=0;
						index := 0;
						state <= s3;
					else
						if count = p then                                        -- C'est dans cette partie que nos 8 bits d'informations seront envoyés un par un
							to_gpio_1_0_out <= Tran(7-index);        -- De cette manière, on envoie bit à bit
							count := 0;                                           -- On remet le count à 0 
							index := index + 1; 
						else
							count := count + 1;                                   -- On reste dans le s2 et on va augmenter le count jusqu'à atteindre à nouveau p pour renvoyer un bit
						end if;
						state <= s2;                                             -- exit state 2. (don't forget to put channel at '1' again before to leave)
					end if;
					
				when s3=>
					if count = p then --on attend p
					to_gpio_1_0_out <= '1';--un 1 pour dire
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