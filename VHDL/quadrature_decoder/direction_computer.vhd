library ieee;
use ieee.std_logic_1164.all;

entity direction_computer is
	port(
		A : in std_logic; -- Channel A of the incremental encoder.
		B : in std_logic; -- Channel B of the incremental encoder.
		prev_state : in std_logic_vector(1 downto 0); -- The state of channel A and B respectively just before a change in state of channel A.
		dir : out std_logic -- When the bit is asserted, the direction is CW, otherwise it is CCW.
	);
end direction_computer;

architecture behav_arch of direction_computer is
begin
	process(A,B,prev_state)
		variable test : std_logic_vector(3 downto 0);
		variable current_state : std_logic_vector(1 downto 0);
	begin
		-- On the rising OR falling edge of the A signal, the direction can be computed.
		-- The conditions to compute the direction are different for the rising and falling edge of A.
		-- The conditions to determine CW and CCW rotation are:
		--		Rising edge of A:
		--			CW:
		-- 				previous state -> A = '0', B = '1'
		-- 				current state  -> A = '1', B = '1'
		--			CCW:
		-- 				previous state -> A = '0', B = '0'
		-- 				current state  -> A = '1', B = '0'
		-- 		Falling adge of A:
		--			CW:
		-- 				previous state -> A = '1', B = '0'
		-- 				current state  -> A = '0', B = '0'
		--			CCW:
		-- 				previous state -> A = '1', B = '1'
		-- 				current state  -> A = '0', B = '1'
		--
		if(A'event) then
			current_state := A & B;
			test := prev_state & current_state;
			-- Rising edge of A
			if(A = '1' and A'last_value = '0') then
				if(test = "0111") then
					dir <= '1'; -- CW
				else
					dir <= '0'; -- CCW
				end if;
			-- Falling edge of A
			elsif(A = '0' and A'last_value = '1') then
				if(test = "1000") then
					dir <= '1'; -- CW
				else
					dir <= '0'; -- CCW
				end if;
			end if;
		end if;
	end process;
end behav_arch;