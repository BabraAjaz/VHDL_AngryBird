LIBRARY IEEE;
USE  IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_UNSIGNED.all;

entity title_proc is -- this component processes the (larger) extra characters which display in any of the non-game states
	port (
			clk, reset 																		: in std_logic; -- classic inputs
			menu, gameover, start, pause												: in std_logic; -- state signals
			pixel_row, pixel_col															: in std_logic_vector(9 DOWNTO 0);
			character_address																: out std_logic_vector(5 DOWNTO 0)
);

end entity title_proc;

architecture beh of title_proc is

begin
	
	character_proc : process(pixel_row, pixel_col, gameover, menu)
	begin
		if (gameover = '1') then
			if (pixel_row >= 223 and pixel_row <= 255) then
				if (pixel_col >= 192 and pixel_col <= 224) then -- GAME OVER
					character_address <= "000111"; -- "G"
				elsif (pixel_col >= 224 and pixel_col <= 256) then
					character_address <= "000001"; -- "A"
				elsif (pixel_col >= 256 and pixel_col <= 288) then
					character_address <= "001101"; -- "M"
				elsif (pixel_col >= 288 and pixel_col <= 320) then
					character_address <= "000101"; -- "E"
				elsif (pixel_col >= 320 and pixel_col <= 352) then
					character_address <= "000000"; -- " "
				elsif (pixel_col >= 352 and pixel_col <= 384) then
					character_address <= "001111"; -- "O"
				elsif (pixel_col >= 384 and pixel_col <= 416) then
					character_address <= "010110"; -- "V"
				elsif (pixel_col >= 416 and pixel_col <= 448) then
					character_address <= "000101"; -- "E"
				elsif (pixel_col >= 448 and pixel_col <= 480) then
					character_address <= "010010"; -- "R"
				else
					character_address <= "000000"; -- " "
				end if;
			elsif (pixel_row >= 287 and pixel_row <= 319) then -- MIDDLE CLICK
				if (pixel_col >= 128 and pixel_col <= 160) then
					character_address <= "001101"; -- "M"
				elsif (pixel_col >= 160 and pixel_col <= 192) then
					character_address <= "001001"; -- "I"
				elsif (pixel_col >= 192 and pixel_col <= 224) then
					character_address <= "000100"; -- "D"
				elsif (pixel_col >= 224 and pixel_col <= 256) then
					character_address <= "000100"; -- "D"
				elsif (pixel_col >= 256 and pixel_col <= 288) then
					character_address <= "001100"; -- "L"
				elsif (pixel_col >= 288 and pixel_col <= 320) then
					character_address <= "000101"; -- "E"
				elsif (pixel_col >= 320 and pixel_col <= 352) then
					character_address <= "000000"; -- " "
				elsif (pixel_col >= 352 and pixel_col <= 384) then
					character_address <= "000011"; -- "C"
				elsif (pixel_col >= 384 and pixel_col <= 416) then
					character_address <= "001100"; -- "L"
				elsif (pixel_col >= 416 and pixel_col <= 448) then
					character_address <= "001001"; -- "I"
				elsif (pixel_col >= 448 and pixel_col <= 480) then
					character_address <= "000011"; -- "C"
				elsif (pixel_col >= 480 and pixel_col <= 512) then
					character_address <= "001011"; -- "K"
				else
					character_address <= "000000"; -- " "
				end if;
			elsif (pixel_row >= 351 and pixel_row <= 383) then -- TO RESET
				if (pixel_col >= 192 and pixel_col <= 224) then
					character_address <= "010100"; -- "T"
				elsif (pixel_col >= 224 and pixel_col <= 256) then
					character_address <= "001111"; -- "O"
				elsif (pixel_col >= 256 and pixel_col <= 288) then
					character_address <= "000000"; -- " "
				elsif (pixel_col >= 288 and pixel_col <= 320) then
					character_address <= "010010"; -- "R"
				elsif (pixel_col >= 320 and pixel_col <= 352) then
					character_address <= "000101"; -- "E"
				elsif (pixel_col >= 352 and pixel_col <= 384) then
					character_address <= "010011"; -- "S"
				elsif (pixel_col >= 384 and pixel_col <= 416) then
					character_address <= "000101"; -- "E"
				elsif (pixel_col >= 416 and pixel_col <= 448) then
					character_address <= "010100"; -- "T"
				else
					character_address <= "000000"; -- " "
				end if;
			else
				character_address <= "000000";
			end if;
			
		elsif (menu = '1') then
			if (pixel_row >= 223 and pixel_row <= 255) then -- ANGRY BIRD
				if (pixel_col <= 192 and pixel_col >= 192 - 32) then
					character_address <= "000001"; -- "A"
				elsif (pixel_col <= 224 and pixel_col >= 192) then
					character_address <= "001110"; -- "N"
				elsif (pixel_col <= 256 and pixel_col >= 224) then
					character_address <= "000111"; -- "G"
				elsif (pixel_col <= 288 and pixel_col >= 256) then
					character_address <= "010010"; -- "R"
				elsif (pixel_col <= 320 and pixel_col >= 288) then
					character_address <= "011001"; -- "Y"
				elsif (pixel_col <= 352 and pixel_col >= 320) then
					character_address <= "000000"; -- " "
				elsif (pixel_col <= 384 and pixel_col >= 352) then
					character_address <= "000010"; -- "B"
				elsif (pixel_col <= 416 and pixel_col >= 384) then
					character_address <= "001001"; -- "I"
				elsif (pixel_col <= 448 and pixel_col >= 416) then
					character_address <= "010010"; -- "R"
				elsif (pixel_col <= 480 and pixel_col >= 448) then
					character_address <= "000100"; -- "D"	
				else
					character_address <= "000000"; -- " "
				end if;
			elsif (pixel_row >= 287 and pixel_row <= 319) then -- RIGHT CLICK
				if (pixel_col >= 160 and pixel_col <= 192) then
					character_address <= "010010"; -- "R"
				elsif (pixel_col >= 192 and pixel_col <= 224) then
					character_address <= "001001"; -- "I"
				elsif (pixel_col >= 224 and pixel_col <= 256) then
					character_address <= "000111"; -- "G"
				elsif (pixel_col >= 256 and pixel_col <= 288) then
					character_address <= "001000"; -- "H"
				elsif (pixel_col >= 288 and pixel_col <= 320) then
					character_address <= "010100"; -- "T"
				elsif (pixel_col >= 320 and pixel_col <= 352) then
					character_address <= "000000"; -- " "
				elsif (pixel_col >= 352 and pixel_col <= 384) then
					character_address <= "000011"; -- "C"
				elsif (pixel_col >= 384 and pixel_col <= 416) then
					character_address <= "001100"; -- "L"
				elsif (pixel_col >= 416 and pixel_col <= 448) then
					character_address <= "001001"; -- "I"
				elsif (pixel_col >= 448 and pixel_col <= 480) then
					character_address <= "000011"; -- "C"
				elsif (pixel_col >= 480 and pixel_col <= 512) then
					character_address <= "001011"; -- "K"
				else
					character_address <= "000000"; -- " "
				end if;
			elsif (pixel_row >= 351 and pixel_row <= 383) then -- TO START
				if (pixel_col >= 192 and pixel_col <= 224) then
					character_address <= "010100"; -- "T"
				elsif (pixel_col >= 224 and pixel_col <= 256) then
					character_address <= "001111"; -- "O"
				elsif (pixel_col >= 256 and pixel_col <= 288) then
					character_address <= "000000"; -- " "
				elsif (pixel_col >= 288 and pixel_col <= 320) then
					character_address <= "010011"; -- "S"
				elsif (pixel_col >= 320 and pixel_col <= 352) then
					character_address <= "010100"; -- "T"
				elsif (pixel_col >= 352 and pixel_col <= 384) then
					character_address <= "000001"; -- "A"
				elsif (pixel_col >= 384 and pixel_col <= 416) then
					character_address <= "010010"; -- "R"
				elsif (pixel_col >= 416 and pixel_col <= 448) then
					character_address <= "010100"; -- "T"
				else
					character_address <= "000000"; -- " "
				end if;
			else
				character_address <= "000000";				
			end if;
		elsif (start = '1') then
			if (pixel_row >= 160 and pixel_row <= 191) then -- LEFT CLICK
				if (pixel_col >= 160 and pixel_col <= 192) then
					character_address <= "001100"; -- "L"
				elsif (pixel_col >= 192 and pixel_col <= 224) then
					character_address <= "000101"; -- "E"
				elsif (pixel_col >= 224 and pixel_col <= 256) then
					character_address <= "000110"; -- "F"
				elsif (pixel_col >= 256 and pixel_col <= 288) then
					character_address <= "010100"; -- "T"
				elsif (pixel_col >= 288 and pixel_col <= 320) then
					character_address <= "000000"; -- " "
				elsif (pixel_col >= 320 and pixel_col <= 352) then
					character_address <= "000011"; -- "C"
				elsif (pixel_col >= 352 and pixel_col <= 384) then
					character_address <= "001100"; -- "L"
				elsif (pixel_col >= 384 and pixel_col <= 416) then
					character_address <= "001001"; -- "I"
				elsif (pixel_col >= 416 and pixel_col <= 448) then
					character_address <= "000011"; -- "C"
				elsif (pixel_col >= 448 and pixel_col <= 480) then
					character_address <= "001011"; -- "K"
				else
					character_address <= "000000"; -- " "
				end if;	
			elsif (pixel_row >= 224 and pixel_row <= 255) then -- TO RESUME
				if (pixel_col >= 192 and pixel_col <= 224) then
					character_address <= "010100"; -- "T"
				elsif (pixel_col >= 224 and pixel_col <= 256) then
					character_address <= "001111"; -- "O"
				elsif (pixel_col >= 256 and pixel_col <= 288) then
					character_address <= "000000"; -- " "
				elsif (pixel_col >= 288 and pixel_col <= 320) then
					character_address <= "000110"; -- "F"
				elsif (pixel_col >= 320 and pixel_col <= 352) then
					character_address <= "001100"; -- "L"
				elsif (pixel_col >= 352 and pixel_col <= 384) then
					character_address <= "000001"; -- "A"
				elsif (pixel_col >= 384 and pixel_col <= 416) then
					character_address <= "010000"; -- "P"
				elsif (pixel_col >= 416 and pixel_col <= 448) then
					character_address <= "101100"; -- ","
				else
					character_address <= "000000"; -- " "
				end if;
			elsif (pixel_row >= 288 and pixel_row <= 319) then -- RIGHT CLICK
				if (pixel_col >= 160 and pixel_col <= 192) then
					character_address <= "010010"; -- "R"
				elsif (pixel_col >= 192 and pixel_col <= 224) then
					character_address <= "001001"; -- "I"
				elsif (pixel_col >= 224 and pixel_col <= 256) then
					character_address <= "000111"; -- "G"
				elsif (pixel_col >= 256 and pixel_col <= 288) then
					character_address <= "001000"; -- "H"
				elsif (pixel_col >= 288 and pixel_col <= 320) then
					character_address <= "010100"; -- "T"
				elsif (pixel_col >= 320 and pixel_col <= 352) then
					character_address <= "000000"; -- " "
				elsif (pixel_col >= 352 and pixel_col <= 384) then
					character_address <= "000011"; -- "C"
				elsif (pixel_col >= 384 and pixel_col <= 416) then
					character_address <= "001100"; -- "L"
				elsif (pixel_col >= 416 and pixel_col <= 448) then
					character_address <= "001001"; -- "I"
				elsif (pixel_col >= 448 and pixel_col <= 480) then
					character_address <= "000011"; -- "C"
				elsif (pixel_col >= 480 and pixel_col <= 512) then
					character_address <= "001011"; -- "K"
				else
					character_address <= "000000"; -- " "
				end if;
			elsif (pixel_row >= 352 and pixel_row <= 383) then -- TO RESET
				if (pixel_col >= 192 and pixel_col <= 224) then
					character_address <= "010100"; -- "T"
				elsif (pixel_col >= 224 and pixel_col <= 256) then
					character_address <= "001111"; -- "O"
				elsif (pixel_col >= 256 and pixel_col <= 288) then
					character_address <= "000000"; -- " "
				elsif (pixel_col >= 288 and pixel_col <= 320) then
					character_address <= "010000"; -- "P"
				elsif (pixel_col >= 320 and pixel_col <= 352) then
					character_address <= "000001"; -- "A"
				elsif (pixel_col >= 352 and pixel_col <= 384) then
					character_address <= "010101"; -- "U"
				elsif (pixel_col >= 384 and pixel_col <= 416) then
					character_address <= "010011"; -- "S"
				elsif (pixel_col >= 416 and pixel_col <= 448) then
					character_address <= "000101"; -- "E"
				else
					character_address <= "000000"; -- " "
				end if;
			else
				character_address <= "000000";				
			end if;
		elsif (pause = '1') then
			if (pixel_row >= 96 and pixel_row <= 127) then -- LEFT CLICK
				if (pixel_col >= 192 and pixel_col <= 224) then
					character_address <= "010000"; -- "P"
				elsif (pixel_col >= 224 and pixel_col <= 256) then
					character_address <= "000001"; -- "A"
				elsif (pixel_col >= 256 and pixel_col <= 288) then
					character_address <= "010101"; -- "U"
				elsif (pixel_col >= 288 and pixel_col <= 320) then
					character_address <= "010011"; -- "S"
				elsif (pixel_col >= 320 and pixel_col <= 352) then
					character_address <= "000101"; -- "E"
				elsif (pixel_col >= 352 and pixel_col <= 384) then
					character_address <= "000100"; -- "D"
				else
					character_address <= "000000"; -- " "
				end if;
			elsif (pixel_row >= 160 and pixel_row <= 191) then -- LEFT CLICK
				if (pixel_col >= 160 and pixel_col <= 192) then
					character_address <= "001100"; -- "L"
				elsif (pixel_col >= 192 and pixel_col <= 224) then
					character_address <= "000101"; -- "E"
				elsif (pixel_col >= 224 and pixel_col <= 256) then
					character_address <= "000110"; -- "F"
				elsif (pixel_col >= 256 and pixel_col <= 288) then
					character_address <= "010100"; -- "T"
				elsif (pixel_col >= 288 and pixel_col <= 320) then
					character_address <= "000000"; -- " "
				elsif (pixel_col >= 320 and pixel_col <= 352) then
					character_address <= "000011"; -- "C"
				elsif (pixel_col >= 352 and pixel_col <= 384) then
					character_address <= "001100"; -- "L"
				elsif (pixel_col >= 384 and pixel_col <= 416) then
					character_address <= "001001"; -- "I"
				elsif (pixel_col >= 416 and pixel_col <= 448) then
					character_address <= "000011"; -- "C"
				elsif (pixel_col >= 448 and pixel_col <= 480) then
					character_address <= "001011"; -- "K"
				else
					character_address <= "000000"; -- " "
				end if;	
			elsif (pixel_row >= 224 and pixel_row <= 255) then -- TO FLAP
				if (pixel_col >= 160 and pixel_col <= 192) then
					character_address <= "010100"; -- "T"
				elsif (pixel_col >= 192 and pixel_col <= 224) then
					character_address <= "001111"; -- "O"
				elsif (pixel_col >= 224 and pixel_col <= 256) then
					character_address <= "000000"; -- " "
				elsif (pixel_col >= 256 and pixel_col <= 288) then
					character_address <= "010010"; -- "R"
				elsif (pixel_col >= 288 and pixel_col <= 320) then
					character_address <= "000101"; -- "E"
				elsif (pixel_col >= 320 and pixel_col <= 352) then
					character_address <= "010011"; -- "S"
				elsif (pixel_col >= 352 and pixel_col <= 384) then
					character_address <= "010101"; -- "U"
				elsif (pixel_col >= 384 and pixel_col <= 416) then
					character_address <= "001101"; -- "M"
				elsif (pixel_col >= 416 and pixel_col <= 448) then
					character_address <= "000101"; -- "E"
				elsif (pixel_col >= 448 and pixel_col <= 480) then
					character_address <= "101100"; -- ","
				else
					character_address <= "000000"; -- " "
				end if;
			elsif (pixel_row >= 288 and pixel_row <= 319) then -- RIGHT CLICK
				if (pixel_col >= 128 and pixel_col <= 160) then
					character_address <= "001101"; -- "M"
				elsif (pixel_col >= 160 and pixel_col <= 192) then
					character_address <= "001001"; -- "I"
				elsif (pixel_col >= 192 and pixel_col <= 224) then
					character_address <= "000100"; -- "D"
				elsif (pixel_col >= 224 and pixel_col <= 256) then
					character_address <= "000100"; -- "D"
				elsif (pixel_col >= 256 and pixel_col <= 288) then
					character_address <= "001100"; -- "L"
				elsif (pixel_col >= 288 and pixel_col <= 320) then
					character_address <= "000101"; -- "E"
				elsif (pixel_col >= 320 and pixel_col <= 352) then
					character_address <= "000000"; -- " "
				elsif (pixel_col >= 352 and pixel_col <= 384) then
					character_address <= "000011"; -- "C"
				elsif (pixel_col >= 384 and pixel_col <= 416) then
					character_address <= "001100"; -- "L"
				elsif (pixel_col >= 416 and pixel_col <= 448) then
					character_address <= "001001"; -- "I"
				elsif (pixel_col >= 448 and pixel_col <= 480) then
					character_address <= "000011"; -- "C"
				elsif (pixel_col >= 480 and pixel_col <= 512) then
					character_address <= "001011"; -- "K"
				else
					character_address <= "000000"; -- " "
				end if;
			elsif (pixel_row >= 352 and pixel_row <= 383) then -- TO RESET
				if (pixel_col >= 192 and pixel_col <= 224) then
					character_address <= "010100"; -- "T"
				elsif (pixel_col >= 224 and pixel_col <= 256) then
					character_address <= "001111"; -- "O"
				elsif (pixel_col >= 256 and pixel_col <= 288) then
					character_address <= "000000"; -- " "
				elsif (pixel_col >= 288 and pixel_col <= 320) then
					character_address <= "010010"; -- "R"
				elsif (pixel_col >= 320 and pixel_col <= 352) then
					character_address <= "000101"; -- "E"
				elsif (pixel_col >= 352 and pixel_col <= 384) then
					character_address <= "010011"; -- "S"
				elsif (pixel_col >= 384 and pixel_col <= 416) then
					character_address <= "000101"; -- "E"
				elsif (pixel_col >= 416 and pixel_col <= 448) then
					character_address <= "010100"; -- "T"
				else
					character_address <= "000000"; -- " "
				end if;
			else
				character_address <= "000000";				
			end if;
		else
			character_address <= "000000";
		end if;
			
	end process;
end architecture beh;
