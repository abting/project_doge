library ieee;
use ieee.std_logic_1164.all;

entity pulse_counter_tb is
end pulse_counter_tb;

architecture tb_arch of pulse_counter_tb is

component pulse_counter is
	port(
		position_change : in std_logic;
		reset 			: in std_logic;
		count			: out integer
	);
end component;

signal position_change, reset : std_logic := '0';
signal count : integer;

begin

	test_unit : entity WORK.pulse_counter(behav_arch)
	port map(
		position_change => position_change,
		reset 			=> reset,
		count 			=> count
	);

	-- Position changing every 20 ns
	position_change <= not position_change after 20 ns;

	process
	begin
		wait until rising_edge(position_change);
		reset <= '1';
		wait until rising_edge(position_change);
		reset <= '0';
		wait;
	end process;

end tb_arch;