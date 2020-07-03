library ieee;
use ieee.std_logic_1164.all;

entity previous_state_register_tb is
end previous_state_register_tb;

architecture tb_arch of previous_state_register_tb is

component previous_state_register is
	port(
		A 			: in std_logic;
		B 			: in std_logic;
		prev_state 	: out std_logic_vector(1 downto 0)
	);
end component;

for test_unit_cw : previous_state_register use entity WORK.previous_state_register(behav_arch);
for test_unit_ccw : previous_state_register use entity WORK.previous_state_register(behav_arch);

signal in_A_cw, in_B_cw, in_B_ccw : std_logic := '1';
signal in_A_ccw : std_logic := '0';
signal output_cw, output_ccw : std_logic_vector(1 downto 0);
signal clkgen : std_logic := '1';

begin

	test_unit_cw : previous_state_register port map(
		A => in_A_cw,
		B => in_B_cw,
		prev_state => output_cw
	);

	test_unit_ccw : previous_state_register port map(
		A => in_A_ccw,
		B => in_B_ccw,
		prev_state => output_ccw
	);

	-- CW signal process with T = 20 ns
	in_A_cw <= not in_A_cw after 10 ns;
	-- CCW signal process with T = 20 ns
	in_A_ccw <= not in_A_ccw after 10 ns; 
	
	clkgen <= not clkgen after 5 ns;
	process(clkgen,in_B_cw,in_B_ccw)
	begin
		if(clkgen'event and clkgen = '0') then
			in_B_cw <= not in_B_cw;
			in_B_ccw <= not in_B_ccw;
		end if;
	end process;

end tb_arch;