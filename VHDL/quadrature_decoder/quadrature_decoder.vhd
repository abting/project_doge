library ieee;
use ieee.std_logic_1164.all;

entity quadrature_decoder is
	generic(timer_threshold_cycles : integer);
	port(
		A 			: in 	std_logic;
		B 			: in 	std_logic;
		Z 			: in 	std_logic;
		clk 		: in 	std_logic;
		reset 		: in 	std_logic;
		position	: inout	std_logic_vector(12 downto 0);
		direction	: out 	std_logic;
		speed		: out	integer
	);
end quadrature_decoder;

architecture struct_arch of quadrature_decoder is

	-- Direction and position Computer
	component dir_pos_computer is
		port(
			A 				: in std_logic;
			B 				: in std_logic;
			reset			: in std_logic;
			direction		: out std_logic;
			position		: out std_logic_vector(12 downto 0)
		);
	end component;

	-- Change in position detector
	component change_detector is
		port(
			position			: in std_logic_vector(12 downto 0);
			clk					: in std_logic;
			reset 				: in std_logic;
			position_change 	: out std_logic
		);
	end component;

	-- Speed computer
	component speed_computer is
		generic(timer_threshold_cycles : integer);
		port(
			clk 			: in std_logic;
			position_change : in std_logic;
			global_reset	: in std_logic;
			speed 			: out integer
		);
	end component;

	-- Signals
	signal position_change : std_logic;
	signal dir_pos_computer_reset : std_logic;

begin

	-- Direction and Position computer
	U1 : entity WORK.dir_pos_computer(behav_arch)
	port map(
		A => A,
		B => B,
		reset => reset,
		direction => direction,
		position => position
	);

	-- Speed computer
	U2 : entity WORK.speed_computer(struct_arch)
	generic map(timer_threshold_cycles => timer_threshold_cycles)
	port map(
		clk => clk,
		position_change => position_change,
		global_reset => reset,
		speed => speed
	);

		-- Change in position detector
	U3 : entity WORK.change_detector(two_stage_arch)
	port map(
		position => position,
		clk => clk,
		reset => reset,
		position_change => position_change
	);

end struct_arch;