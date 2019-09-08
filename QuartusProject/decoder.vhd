library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_UNSIGNED.all;

entity decoder is -- this component inputs our predecided digits into the sevenseg component
	port (
			clk, SW : in std_logic;
			Digit0 : out std_logic_vector(3 downto 0);
			Digit1 : out std_logic_vector(3 downto 0);
			Digit2 : out std_logic_vector(3 downto 0);
			Digit3 : out std_logic_vector(3 downto 0)
			);
end entity decoder;

architecture behaviour of decoder is
begin
	process(clk, SW)
	begin
		if (clk'event and clk = '1') then
			if (SW = '1') then -- H I G H
				Digit3 <= "1010"; 
				Digit2 <= "1011";
				Digit1 <= "1100";
				Digit0 <= "1010";
			else
				Digit0 <= "1111"; -- L O
				Digit1 <= "1111";
				Digit2 <= "0000";
				Digit3 <= "1101";
			end if;
		end if;
	end process;
end architecture;