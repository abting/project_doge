library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity clk_timer is
	generic(timer_threshold_cycles : integer);
	port(
	    clk 		: in std_logic;
	    reset		: in std_logic;
	    timer 		: out std_logic
    );
end entity;
 
architecture rtl of clk_timer is
 
    -- Signal for counting clock periods
    signal r_reg, r_next : integer;
 
begin

    -- Register
    process(clk) is
    begin
        if(reset = '1') then
            r_reg <= 0;
        elsif(rising_edge(clk)) then
            r_reg <= r_next;
        end if;
    end process;

    -- Next state logic
    r_next <= 0 when (r_reg = timer_threshold_cycles - 1)
                else r_reg + 1;

    -- Output logic
    timer <= '1' when (r_reg = timer_threshold_cycles - 1)
                else '0';
 
end architecture;