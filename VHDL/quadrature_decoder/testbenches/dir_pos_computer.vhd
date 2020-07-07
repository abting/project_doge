library ieee;
use ieee.std_logic_1164.all;

entity position_computer_tb is
end position_computer_tb;

architecture tb_arch of position_computer_tb is

component position_computer is
	port(
		A 				: in std_logic;
		B 				: in std_logic;
		reset			: in std_logic;
		direction		: out std_logic;
		position		: out std_logic_vector(12 downto 0)
	);
end component;

for test_unit : position_computer use entity WORK.position_computer(behav_arch);

signal in_A, in_B : std_logic := '1';
signal Z : std_logic := '0';
signal direction : std_logic;
signal position : std_logic_vector(12 downto 0);

signal clk : std_logic := '0';
signal clkgen : std_logic := '1';

begin

	test_unit : position_computer port map(
		A => in_A,
		B => in_B,
		reset => Z,
		direction => direction,
		position => position
	);

	-- Time of rotations are in micro-seconds.

	process
	begin
		wait for 5000 ns;
		Z <= '1';
		wait for 5000 ns;
		Z <= '0';
		wait;
	end process;

	clk <= not clk after 62.5 ns; -- 16 MHz clock

	-- Let T = 20us for a continuous constant speed rotation.
	process
	begin
		in_A <= '0'; wait for 10000 ns;
		in_A <= '1'; wait for 10000 ns; -- -1 	cycle
		in_A <= '0'; wait for 10000 ns;
		in_A <= '1'; wait for 10000 ns; -- -1 	cycle
		in_A <= '0'; wait for 10000 ns;
		in_A <= '1'; wait for 10000 ns; -- -1 	cycle
		in_A <= '0'; wait for 10000 ns;
		in_A <= '1'; wait for 10000 ns; -- -1 	cycle
		in_A <= '0'; wait for 10000 ns;
		in_A <= '1'; wait for 10000 ns; -- -1 	cycle
		-- Direction change
		in_A <= '1'; wait for 10000 ns;
		in_A <= '0'; wait for 10000 ns; -- +1 	cycle
		in_A <= '1'; wait for 10000 ns;
		in_A <= '0'; wait for 10000 ns; -- +1 	cycle
		in_A <= '1'; wait for 10000 ns;
		in_A <= '0'; wait for 10000 ns; -- +1 	cycle
		in_A <= '1'; wait for 10000 ns;
		in_A <= '0'; wait for 10000 ns; -- +1 	cycle
		in_A <= 'U';
		
	end process;

	-- Clk used to produced signal B as a 90 deg shifted version of signal A
	clkgen <= not clkgen after 5000 ns;
	-- Signal B
	process(clkgen,in_B)
	begin
		if(clkgen'event and clkgen = '0') then
			in_B <= not in_B;
		end if;
	end process;

end tb_arch;