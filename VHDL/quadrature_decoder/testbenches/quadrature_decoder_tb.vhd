library ieee;
use ieee.std_logic_1164.all;

entity quadrature_decoder_tb is
end quadrature_decoder_tb;

architecture tb_arch of quadrature_decoder_tb is

	component quadrature_decoder is
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
	end component;

	constant ClockFrequencyHz 			: integer := 16000000; -- 16 MHz
    constant ClockPeriod      			: time := 1000 ms / ClockFrequencyHz;
    constant timer_threshold_cycles		: integer := ClockFrequencyHz / 1000; -- Clk cycles per mili-second (10^-3)

    -- Signals
    signal in_A, in_B, in_Z : std_logic := '0';
    signal global_clk 		: std_logic := '0';
    signal global_reset		: std_logic := '1';
    signal position			: std_logic_vector(12 downto 0);
    signal direction		: std_logic;
    signal speed			: integer;

    signal clkgen1,clkgen2,clkgen3,clkgen2_inv : std_logic := '0';
    signal trigger			: integer := 0;

begin

	-- DUT
	test_unit : entity WORK.quadrature_decoder(struct_arch)
	generic map(timer_threshold_cycles => timer_threshold_cycles)
	port map(
		A 			=> in_A,
		B 			=> in_B,
		Z 			=> in_Z,
		clk 		=> global_clk,
		reset 		=> global_reset,
		position	=> position,
		direction	=> direction,
		speed		=> speed
	);

	-- Global clock process
	global_clk <= not global_clk after ClockPeriod/2;

	-- ASSUMPTIONS
	-- Encoder has a resolution of 2048 PPR
	-- Global clock frequency is 16MHz

	-- TEST 1: DIRECTION, POSITION, AND SPEED

	global_reset <= '0' after ClockPeriod*4;

	clkgen1 <= not clkgen1 after ClockPeriod*200;
	clkgen2 <= not clkgen2 after ClockPeriod*50;
	clkgen3 <= not clkgen3 after ClockPeriod*100;

	clkgen2_inv <= not clkgen2;

	-- Trigger used for different rotations
	process
	begin
		wait for ClockPeriod*20000;
		trigger <= 1;
		wait for ClockPeriod*5000;
		trigger <= 2;
		wait for ClockPeriod*10000;
		trigger <= 3;
	end process;

	p_channel_B : process(clkgen1,clkgen2,clkgen3,in_B) is
	begin
		-- Rotate CW for 1/4 revolutions at 10dps
		if(trigger = 0) then
			if(rising_edge(clkgen1)) then
				in_B <= not in_B;
			end if;
		-- Rotate CCW for 1/2 revolutions at 50dps
		elsif(trigger = 1) then
			if(rising_edge(clkgen2)) then
				in_B <= not in_B;
			end if;
		-- Rotate CW for 1/4 revolutions at 5dps
		elsif(trigger = 2) then
			if(rising_edge(clkgen3)) then
				in_B <= not in_B;
			end if;
		else
		end if;
	end process p_channel_B;

	p_channel_A : process(clkgen1,clkgen2,clkgen3,clkgen2_inv,in_A) is
	begin
		-- Rotate CW for 1/4 revolutions at 10dps
		if(trigger = 0) then
			if(falling_edge(clkgen1)) then
				in_A <= not in_A;
			end if;
		-- Rotate CCW for 1/2 revolutions at 50dps
		elsif(trigger = 1) then
			if(rising_edge(clkgen2_inv)) then
				in_A <= not in_A;
			end if;
		-- Rotate CW for 1/4 revolutions at 5dps
		elsif(trigger = 2) then
			if(falling_edge(clkgen3)) then
				in_A <= not in_A;
			end if;
		else
		end if;
	end process p_channel_A;

	p_channel_Z : process(position,in_A) is
	begin
		if(position'event and position = "0000000110000") then
			in_Z <= '1';
		else
			in_Z <= '0';
		end if;
	end process p_channel_Z;

end tb_arch;