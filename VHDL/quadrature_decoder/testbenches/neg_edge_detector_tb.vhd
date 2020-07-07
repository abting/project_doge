library ieee;
use ieee.std_logic_1164.all;

entity neg_edge_detector_tb is
end neg_edge_detector_tb;

architecture tb_arch of neg_edge_detector_tb is

	component neg_edge_detector is
		port (
			i_clk	: in  std_logic;
			i_rstb	: in  std_logic;
			i_input	: in  std_logic;
			o_pulse	: out std_logic
		);
	end component;

	signal clk, i_pulse : std_logic := '0';
	signal o_pulse : std_logic;
	signal reset : std_logic := '1';

	constant ClockFrequencyHz 	: integer := 16000000; -- 16 MHz
    constant ClockPeriod		: time := 1000 ms / ClockFrequencyHz;

begin

	-- DUT
	DUT : entity WORK.neg_edge_detector(rtl)
	port map(
		i_clk	=> clk,
		i_rstb	=> reset,
		i_input	=> i_pulse,
		o_pulse	=> o_pulse
	);

    clk <= not clk after ClockPeriod/2;
	reset <= '0' after ClockPeriod*2;

	process
	begin
		wait for 4.5*ClockPeriod;
		i_pulse <= '1';
		wait for ClockPeriod/2;
		i_pulse <= '0';
		wait;
	end process;

end tb_arch;