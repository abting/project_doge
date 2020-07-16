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

    constant Clk_345600_Hz_Freq			: integer := 21600; -- 10,800 pulses/sec
    constant Clk_345600_Hz_Period		: time := 1000 ms / Clk_345600_Hz_Freq;

	constant Clk_576000_Hz_Freq			: integer := 36000; -- 18,000 puses/sec
    constant Clk_576000_Hz_Period		: time := 1000 ms / Clk_576000_Hz_Freq; 

    -- Signals
    signal in_A, in_B,in_Z	: std_logic := '0';
    signal global_clk 		: std_logic := '0';
    signal global_reset		: std_logic := '1';
    signal position			: std_logic_vector(12 downto 0);
    signal direction		: std_logic;
    signal speed			: integer;

    signal Clk_345600_Hz : std_logic := '0';
    signal Clk_576000_Hz : std_logic := '0';

    signal Clk_576000_Hz_inv : std_logic := '0';

    signal trigger : integer := 0;

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

	-- Global Reset
	global_reset <= '0' after ClockPeriod*4;

	-- Clocks to simulate encoder rotation
	Clk_345600_Hz <= not Clk_345600_Hz after Clk_345600_Hz_Period/2;
	Clk_576000_Hz <= not Clk_576000_Hz after Clk_576000_Hz_Period/2;

	Clk_576000_Hz_inv <= not Clk_576000_Hz;

	-- Trigger process: change of rotational parameters
	p_triggers : process is
	begin
		wait for 5000000 ns;
		trigger <= 1;
		wait;
	end process p_triggers;

	-- B channel signal generation
	p_channel_B : process(Clk_345600_Hz,Clk_576000_Hz_inv,in_B) is
	begin
		if(trigger = 0) then
			if(rising_edge(Clk_345600_Hz)) then
				in_B <= not in_B;
			end if;
		elsif(trigger = 1) then
			if(rising_edge(Clk_576000_Hz_inv)) then
				in_B <= not in_B;
			end if;
		end if;
	end process p_channel_B;

	-- A channel signal generation
	p_channel_A : process(Clk_345600_Hz,Clk_576000_Hz,in_A) is
	begin
		if(trigger = 0) then
			if(falling_edge(Clk_345600_Hz)) then
				in_A <= not in_A;
			end if;
		elsif(trigger = 1) then
			if(rising_edge(Clk_576000_Hz)) then
				in_A <= not in_A;
			end if;
		end if;
	end process p_channel_A;

	--p_channel_Z : process(position,in_A) is
	--begin
		--if(position'event and position = "0000000110000") then
		--	in_Z <= '1';
		--else
		--	in_Z <= '0';
		--end if;
	--end process p_channel_Z;

end tb_arch;