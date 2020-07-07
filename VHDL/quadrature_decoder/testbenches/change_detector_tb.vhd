library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity change_detector_tb is
end change_detector_tb;

architecture tb_arch of change_detector_tb is

component change_detector is
	port(
		position			: in std_logic_vector(12 downto 0);
		clk					: in std_logic;
		reset 				: in std_logic;
		position_change 	: out std_logic
	);
end component;

for test_unit : change_detector use entity WORK.change_detector(two_stage_arch);

signal position : std_logic_vector(12 downto 0) := (others => '0');
signal clk : std_logic := '0';
signal reset : std_logic := '1';
signal position_change : std_logic;
	
begin

	test_unit : change_detector port map(
		position 			=> position,
		clk					=> clk,
		reset				=> reset,
		position_change 	=> position_change
	);

	reset <= '0' after 5 ns;
	clk <= not clk after 62.5 ns; -- F = 16MHz

	process
	begin
		wait for 10 us;
		position <= std_logic_vector(signed(position) + 1);
		wait for 10 us;
		position <= std_logic_vector(signed(position) + 2);
		wait for 10 us;
		position <= std_logic_vector(signed(position) - 4);
		wait for 10 us;
		position <= std_logic_vector(signed(position) + 1);
		wait for 10 us;
		position <= (others => 'U');
	end process;

end tb_arch;