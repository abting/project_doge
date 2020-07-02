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

for test_unit : previous_state_register use entity WORK.previous_state_register(behav_arch);

signal in_A, in_B : std_logic := '1';
signal output : std_logic_vector(1 downto 0);
signal clkgen : std_logic := '1';

begin

	test_unit : previous_state_register port map(
		A => in_A,
		B => in_B,
		prev_state => output
	);

	-- CW signal process with T = 20 ns
	in_A <= not in_A after 10 ns;
	clkgen <= not clkgen after 5 ns;
	
	process(clkgen,in_B)
	begin
		if(clkgen'event and clkgen = '0') then
			in_B <= not in_B;
		end if;
	end process;

end tb_arch;