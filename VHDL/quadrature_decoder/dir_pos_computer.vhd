library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dir_pos_computer is
	port(
		A 				: in std_logic;
		B 				: in std_logic;
		reset			: in std_logic;
		direction		: out std_logic;
		position		: out std_logic_vector(12 downto 0)
	);
end dir_pos_computer;

architecture behav_arch of dir_pos_computer is

type state_type is (S0,S1,S2,S3); -- machine states
signal state : state_type;
signal dir : std_logic;
signal count : signed(12 downto 0);

begin
	process(A,B) -- State Machine Process
		variable wave : std_logic_vector(1 downto 0);
	begin
		if (reset = '1') then
			state <= S0;
			dir <= '1';
			count <= (others => '0');
		elsif (A'event or B'event) then
			wave := A&B;

			case state is
				when S0 =>
					if (wave = "01") then
						State <= S1;
						dir <= '1';
						count <= count + 1;
					elsif (wave = "10") then
						State <= S2;
						dir <= '0';
						count <= count - 1;
					end if;

				when S1 =>
					if (wave = "11") then
						State <= S3;
						dir <= '1';
						count <= count + 1;
					elsif (wave = "00") then
						State <= S0;
						dir <= '0';
						count <= count - 1;
					end if;

				when S2 =>
					if (wave = "00") then
						State <= S0;
						dir <= '1';
						count <= count + 1;
					elsif (wave = "11") then
						State <= S3;
						dir <= '0';
						count <= count - 1;
					end if;

				when S3 =>
					if (wave = "10") then
						State <= S2;
						dir <= '1';
						count <= count + 1;
					elsif (wave = "01") then
						State <= S1;
						dir <= '0';
						count <= count - 1;
					end if;
			end case;
		end if;
	end process;

	-- Output logic
	position <= std_logic_vector(count);
	direction <= dir;

end behav_arch;