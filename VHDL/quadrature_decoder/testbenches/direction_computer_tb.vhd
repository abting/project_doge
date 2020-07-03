library ieee;
use ieee.std_logic_1164.all;

entity direction_computer_tb is
end direction_computer_tb;

architecture tb_arch of direction_computer_tb is

component direction_computer is
	port(
		A : in std_logic; -- Channel A of the incremental encoder.
		B : in std_logic; -- Channel B of the incremental encoder.
		prev_state : in std_logic_vector(1 downto 0); -- The state of channel A and B respectively just before a change in state of channel A.
		dir : out std_logic -- When the bit is asserted, the direction is CW, otherwise it is CCW.
	);
end component;

component previous_state_register is
	port(
		A 			: in std_logic;
		B 			: in std_logic;
		prev_state 	: out std_logic_vector(1 downto 0)
	);
end component;

for test_unit : direction_computer use entity WORK.direction_computer(behav_arch);
for prev_state_comp : previous_state_register use entity WORK.previous_state_register(behav_arch); 

signal in_A, in_B : std_logic := '1';
signal p_state : std_logic_vector(1 downto 0);
signal direction : std_logic;

signal clkgen : std_logic := '1';

begin

	prev_state_comp : previous_state_register port map(
		A => in_A,
		B => in_B,
		prev_state => p_state
	);

	test_unit : direction_computer port map(
		A => in_A,
		B => in_B,
		prev_state => p_state,
		dir => direction
	);

	-- Let T = 20ns for a continuous constant speed rotation.
	process
		variable T : integer := 20;
	begin
		in_A <= '1'; wait for 10 ns;
		in_A <= '0'; wait for 20 ns; wait for 10 ns;
		in_A <= '1'; wait for 10 ns;
		in_A <= '0'; wait for 10 ns;
		in_A <= '1'; wait for 20 ns;
		in_A <= '0'; wait for 10 ns;
		in_A <= '1'; wait for 10 ns;
		in_A <= '0'; wait for 20 ns;
		in_A <= '1'; wait for 10 ns;
		in_A <= 'X';
	end process;

	-- Clk used to produced signal B as a 90 deg shifted version of signal A
	clkgen <= not clkgen after 5 ns;
	-- Signal B
	process(clkgen,in_B)
	begin
		if(clkgen'event and clkgen = '0') then
			in_B <= not in_B;
		end if;
	end process;

end tb_arch;