LIBRARY IEEE;
USE  IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_UNSIGNED.all;

entity character_disp is
	port (
			pixel_row, pixel_col		: in std_logic_vector(9 DOWNTO 0);
			character_address			: out std_logic_vector(5 DOWNTO 0));

end entity character_disp;

architecture beh of character_disp is

	
begin
	process(pixel_row, pixel_col)
	begin

		if (pixel_row >= 239 - 16*12 and pixel_row <= 255 - 16*12) then
			if (pixel_col <= 224 and pixel_col >= 224 - 16) then
				character_address <= "000001"; -- "A"
			elsif (pixel_col <= 224 + 16 and pixel_col >= 224) then
				character_address <= "001110"; -- "N"
			elsif (pixel_col <= 224 + 16*2 and pixel_col >= 224 + 16) then
				character_address <= "000111"; -- "G"
			elsif (pixel_col <= 224 + 16*3 and pixel_col >= 224 + 16*2) then
				character_address <= "010010"; -- "R"
			elsif (pixel_col <= 224 + 16*4 and pixel_col >= 224 + 16*3) then
				character_address <= "011001"; -- "Y"
			elsif (pixel_col <= 224 + 16*5 and pixel_col >= 224 + 16*4) then
				character_address <= "000000"; -- " "
			elsif (pixel_col <= 224 + 16*6 and pixel_col >= 224 + 16*5) then
				character_address <= "000010"; -- "B"
			elsif (pixel_col <= 224 + 16*7 and pixel_col >= 224 + 16*6) then
				character_address <= "001001"; -- "I"
			elsif (pixel_col <= 224 + 16*8 and pixel_col >= 224 + 16*7) then
				character_address <= "010010"; -- "R"
			elsif (pixel_col <= 224 + 16*9 and pixel_col >= 224 + 16*8) then
				character_address <= "000100"; -- "D"			
			

			
			else
				character_address <= "000000"; -- " "
			end if;
		
		
		
		
		
--			if (pixel_col <= 304 and pixel_col >= 304 - 16) then
--				character_address <= "001101"; -- "M"
--			elsif (pixel_col <= 304 + 16 and pixel_col >= 304) then
--				character_address <= "001001"; -- "I"
--			elsif (pixel_col <= 304 + 16*2 and pixel_col >= 304 + 16) then
--				character_address <= "001100"; -- "L"
--			elsif (pixel_col <= 304 + 16*3 and pixel_col >= 304 + 16*2) then
--				character_address <= "000101"; -- "E"
--			elsif (pixel_col <= 304 + 16*4 and pixel_col >= 304 + 16*3) then
--				character_address <= "010011"; -- "S"
--			else
--				character_address <= "000000"; -- " "
--			end if;
		else
			character_address <= "000000";
		end if;
			
	end process;
end architecture beh;
