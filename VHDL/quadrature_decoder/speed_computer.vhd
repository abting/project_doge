library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity speed_computer is
	generic(timer_threshold_cycles : integer);
	port(
		clk 			: in std_logic;
		position_change : in std_logic;
		global_reset	: in std_logic;
		speed 			: out integer
	);
end speed_computer;

architecture struct_arch of speed_computer is

-- Clock Timer
component clk_timer is
	generic(timer_threshold_cycles : integer);
	port(
	    clk 		: in std_logic;
	    reset		: in std_logic;
	    timer 		: out std_logic
    );
end component;

-- Pulse Counter
component pulse_counter is
	port(
		position_change : in std_logic;
		reset 			: in std_logic;
		count			: inout integer
	);
end component;

-- Negative Edge Detector
component neg_edge_detector is
	port (
		i_clk	: in  std_logic;
		i_rstb	: in  std_logic;
		i_input	: in  std_logic;
		o_pulse	: out std_logic
	);
end component;

signal timer_pulse, timer_pulse_neg_edge : std_logic;
signal count : integer;
signal clk_timer_reset, pulse_counter_reset : std_logic;
signal r_reg, r_next : integer;

begin

	U1 : entity WORK.clk_timer(rtl)
	generic map (timer_threshold_cycles => timer_threshold_cycles)
	port map(
	    clk 	=> clk,
	    reset	=> clk_timer_reset,
	    timer 	=> timer_pulse
	);

	U2 : entity WORK.neg_edge_detector(rtl)
	port map(
		i_clk	=> clk,
		i_rstb	=> global_reset,
		i_input	=> timer_pulse,
		o_pulse	=> timer_pulse_neg_edge
	);

	U3 : entity WORK.pulse_counter(behav_arch)
	port map(
		position_change => position_change,
		reset 			=> pulse_counter_reset,
		count			=> count
	);

	-- Resets to clk_timer and pulse_counter.
	clk_timer_reset <= global_reset or timer_pulse;
	pulse_counter_reset <= global_reset or timer_pulse_neg_edge;

	-- Register
	process(global_reset,timer_pulse)
	begin
		if(global_reset = '1') then
			r_reg <= 0;
		elsif(rising_edge(timer_pulse)) then
			r_reg <= r_next;
		else
		end if;
	end process;

	-- Next State Logic
	r_next <= count;

	-- Output Logic
	speed <= r_reg;


end struct_arch;