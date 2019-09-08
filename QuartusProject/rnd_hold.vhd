library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_UNSIGNED.all;

entity rnd_hold is -- this component takes in the random number from the LFSR and holds it until the new_num signal is high
	port (
				clk : in std_logic;
				Q_in : in std_logic_vector(7 downto 0);
				new_num: in std_logic;
				Q_out : out std_logic_vector(8 downto 0)
			);
end entity rnd_hold;

architecture behaviour of rnd_hold is
	signal Q : std_logic_vector(8 downto 0); 
begin
	Q(8) <= '0';
	process(new_num, clk)
	begin
		if (clk'event and clk = '1') then
			if (new_num = '1') then
				Q(7 downto 0) <= Q_in;
			end if;
		end if;
	end process;
	Q_out <= Q;
end architecture;