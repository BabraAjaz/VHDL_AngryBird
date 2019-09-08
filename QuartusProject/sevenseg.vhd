library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sevenseg is -- seven segment decoder
	port (
		digit		: in std_logic_vector(3 downto 0);
		led_out 	: out std_logic_vector(6 downto 0)
		);
		
end entity;

architecture rtl of sevenseg is 

signal tmp : std_logic_vector(6 downto 0);
		
begin
	tmp <=  "1111001" when digit = "0001" else -- 1
		"0100100" when digit = "0010" else -- 2
		"0110000" when digit = "0011" else -- 3
		"0011001" when digit = "0100" else -- 4
		"0010010" when digit = "0101" else -- 5
		"0000010" when digit = "0110" else -- 6
		"1111000" when digit = "0111" else -- 7
		"0000000" when digit = "1000" else -- 8
		"0010000" when digit = "1001" else -- 9
		"0001001" when digit = "1010" else -- H
		"1111001" when digit = "1011" else -- I
		"1000010" when digit = "1100" else -- G
		"1000111" when digit = "1101" else -- L
		"1000000" when digit = "0000" else -- 0
		"1111111"; -- off
	LED_out <= tmp;
end architecture;