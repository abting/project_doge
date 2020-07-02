library ieee;
use ieee.std_logic_1164.all;

entity previous_state_register is
	port(
		A 			: in std_logic;
		B 			: in std_logic;
		prev_state 	: out std_logic_vector(1 downto 0)
	);
end previous_state_register;

architecture behav_arch of previous_state_register is
begin
	process(A,B)
	begin
		if(B'event) then
			prev_state <= A & B;
		end if;
	end process;
end behav_arch;