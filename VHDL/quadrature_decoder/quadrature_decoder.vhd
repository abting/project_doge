library ieee;
use ieee.std_logic_1164.all;

entity quadrature_decoder is
	port(
		A 			: in 	std_logic;
		B 			: in 	std_logic;
		Z 			: in 	std_logic;
		clk 		: in 	std_logic;
		dir			: out 	std_logic;
		pulse_count : out 	std_logic_vector(13 downto 0);
		speed		: out	std_logic_vector(7 downto 0)
	);
end quadrature_decoder;