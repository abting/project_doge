library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pulse_counter is
	port(
		position_change : in std_logic;
		reset 			: in std_logic;
		count			: inout integer
	);
end pulse_counter;

architecture behav_arch of pulse_counter is 

	signal r_reg, r_next : integer;

begin

	process(position_change,reset)
	begin
		-- Register
		if(reset = '1') then
			r_reg <= 0;
		elsif(rising_edge(position_change)) then
			r_reg <= r_next;
		end if;
	end process;

	-- Next sate logic
	r_next <= r_reg + 1;
			
	-- Output logic
	count <= r_reg;

end behav_arch;