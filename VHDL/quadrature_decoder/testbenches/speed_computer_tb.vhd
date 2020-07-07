library ieee;
use ieee.std_logic_1164.all;

entity speed_computer_tb is
end speed_computer_tb;

architecture tb_arch of speed_computer_tb is

	component speed_computer is
		generic(timer_threshold_cycles : integer);
		port(
			clk 			: in std_logic;
			position_change : in std_logic;
			global_reset	: in std_logic;
			speed 			: out integer
		);
	end component;

	constant ClockFrequencyHz 			: integer := 16000000; -- 16 MHz
    constant ClockPeriod      			: time := 1000 ms / ClockFrequencyHz;
    constant timer_threshold_cycles		: integer := ClockFrequencyHz / 1000; -- Clk cycles per mili-second (10^-3)

	signal global_reset 	: std_logic := '1';
	signal global_clk		: std_logic := '0';
	signal position_change	: std_logic := '0';
	signal speed 			: integer;

begin

	-- DUT: speed_computer
	test_unit : entity WORK.speed_computer(struct_arch)
	generic map(timer_threshold_cycles => timer_threshold_cycles)
	port map(
		clk 			=> global_clk,
		position_change => position_change,
		global_reset 	=> global_reset,
		speed 			=> speed
	);

	-- Clock process
	global_clk <= not global_clk after ClockPeriod / 2;

	-- Reset DUT
	process is
	begin
		-- Wait for 2 clk cycles
		wait until rising_edge(global_clk);
		wait until rising_edge(global_clk);
		-- Unset the global reset
		global_reset <= '0';
		wait;
	end process;

	process is
		variable speed1 : integer 	:= 10; 	-- 10 cycles/ms
		variable speed2 : integer 	:= 100; 	-- 100 cycles/ms
		variable speed3 : integer 	:= 2; 	-- 2 cycles/ms
	begin
		for index in speed1 downto 0 loop
			position_change <= '1';
			wait for 5 ns;
			position_change <= '0';
			wait for 99995 ns;
		end loop;

		for index in speed2 downto 0 loop
			position_change <= '1';
			wait for 5 ns;
			position_change <= '0';
			wait for 9995 ns;
		end loop;

		for index in speed3 downto 0 loop
			position_change <= '1';
			wait for 5 ns;
			position_change <= '0';
			wait for 499995 ns;
		end loop;

		wait;
	end process;

end tb_arch;