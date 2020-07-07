library ieee;
use ieee.std_logic_1164.all;

entity change_detector is
	port(
		position			: in std_logic_vector(12 downto 0);
		clk					: in std_logic;
		reset 				: in std_logic;
		position_change 	: out std_logic
	);
end change_detector;

architecture two_stage_arch of change_detector is

signal r_reg, r_next : std_logic_vector(position'high downto 0);

begin
	-- Register
	process(reset,clk)
	begin
		if (reset = '1') then
			r_reg <= (others => '0');
		elsif(rising_edge(clk)) then
			r_reg <= r_next;
		end if;
	end process;

	-- Next state logic
	r_next <= position;

	-- Output Logic
	position_change <= '1' when (position /= r_reg) else '0';
end two_stage_arch;