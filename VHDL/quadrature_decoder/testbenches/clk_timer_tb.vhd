library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity clk_timer_tb is
end entity;
 
architecture tb_arch of clk_timer_tb is

	component clk_timer is
		generic(timer_threshold_cycles : integer);
		port(
		    clk 		: in std_logic;
		    reset		: in std_logic;
		    timer 		: out std_logic
	    );
	end component;
 
    constant ClockFrequencyHz 			: integer := 16000000; -- 16 MHz
    constant ClockPeriod      			: time := 1000 ms / ClockFrequencyHz;
    constant timer_threshold_cycles		: integer := ClockFrequencyHz / 1000; -- Clk cycles per mili-second (10^-3)
 
    signal clk     	: std_logic := '1';
    signal reset    : std_logic := '1';
    signal timer 	: std_logic := '0';
 
begin
 
    -- The Device Under Test (DUT)
    test_unit : entity work.clk_timer(rtl)
    generic map(timer_threshold_cycles => timer_threshold_cycles)
    port map (
        clk     => clk,
        reset   => reset,
        timer 	=> timer
    );
 
    -- Process for generating the clock
    clk <= not clk after ClockPeriod / 2;
 
    -- Testbench sequence
    process is
    begin
        wait until rising_edge(clk);
        wait until rising_edge(clk);
 
        -- Take the DUT out of reset
        reset <= '0';
 
        wait;
    end process;
 
end architecture;