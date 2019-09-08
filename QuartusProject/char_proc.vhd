LIBRARY IEEE;
USE  IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_UNSIGNED.all;

entity char_proc is -- this process processes the lives, score, and energy, as well as the characters to display on the HUD
	port (
			clk, reset 																		: in std_logic; -- classic inputs
			score_inc, lives_inc, lives_dec, energy_inc, energy_dec			: in std_logic; -- incrementer/decrementer enables
			menu, start, gameover, mode															: in std_logic; -- state signals
			pixel_row, pixel_col															: in std_logic_vector(9 DOWNTO 0);
			character_address																: out std_logic_vector(5 DOWNTO 0);
			dead																				: out std_logic;
			level_out																		: out std_logic_vector(1 downto 0));

end entity char_proc;

architecture beh of char_proc is

signal score0 : unsigned(5 downto 0) := "110000"; -- score starts at 0
signal score1 : unsigned(5 downto 0) := "110000"; 
signal score2 : unsigned(5 downto 0) := "110000"; 
signal score3 : unsigned(5 downto 0) := "110000";

signal lives  : unsigned(5 downto 0) := "110011"; -- lives start at 3 
signal dead_s : std_logic := '0';
signal deadE_s : std_logic := '0';
signal level_inc : std_logic:= '0';
signal level : unsigned(5 downto 0) := "110001";
signal level_signal_out : std_logic_vector(1 downto 0);
signal energy1 : unsigned(5 downto 0) := "110101";
signal energy0 : unsigned(5 downto 0) := "110000";

begin
	score_proc : process(clk, score_inc, reset, score0, score1, score2, score3)
	begin
			if (score_inc'event and score_inc = '1') then
				if (score0 = 57) then
					score0 <= "110000";
					if (score1 = 57) then
						score1 <= "110000";
						if (score2 = 57) then
							score2 <= "110000";
							if (score3 = 57) then
								score3 <= "110000";
							else
								score3 <= score3 + 1;
							end if;
						else
							score2 <= score2 + 1;
						end if;
					else
						score1 <= score1 + 1;
					end if;
				else
					score0 <= score0 + 1;
				end if;
			end if;
			if (reset = '1') then
				score3 <= "110000";
				score2 <= "110000";
				score1 <= "110000";
				score0 <= "110000";
			end if;
			if (score3 = 48 and score2 = 48 and score1 = 48 and score0 = 53) then
				level_inc <= '1';
			elsif (score3 = 48 and score2 = 48 and score1 = 49 and score0 = 48) then
				level_inc <= '1';
			else
				level_inc <= '0';
			end if;
	end process;
	
	decrease_lives : process(clk, lives_inc, lives_dec, reset) -- obstacle collisions
	begin
		if (lives_dec'event and lives_dec = '1') then
			if (lives /= 48) then
				lives <= lives - 1;
			end if;
			if (lives = 49) then -- must be separate if condition so that it can happen straight away when lives goes from 1 to 0
				dead_s <= '1';
			end if;
		end if;
		if (reset = '1') then
			lives <= "110011"; -- reset to 3 lives
			dead_s <= '0';
		end if;
	end process;
	
	increase_level : process(clk, level_inc, reset)
	begin
		if (level_inc'event and level_inc = '1') then
			if (level /= 51) then
				level <= level + 1;
				level_signal_out <= level_signal_out + "01";
			end if;
		end if;
		if (reset = '1') then
			level <= "110001";
			level_signal_out <= "01";
		end if;
	end process;
	
	change_energy : process(energy_inc, energy_dec, reset, gameover, menu, energy0, energy1)
	begin
		if (gameover = '0' and menu = '0') then
			if (energy_inc = '1') then
				if (energy0 >= 57) then
					energy0 <= "110000";
					if (energy1 = 57) then
						energy1 <= "110000";
					else
						energy1 <= energy1 + 1;
					end if;
				else
					energy0 <= energy0 + 1;
				end if;
			elsif (energy_dec = '1') then
				if (energy0 <= 48) then
					energy0 <= "111001";
					if (energy1 <= 48) then
						energy1 <= "110000";
						energy0 <= "110000";
					else
						energy1 <= energy1 - 1;
					end if;
				else
					energy0 <= energy0 - 1;
				end if;
			end if;
			if (energy1 = 48 and energy0 = 48) then
					deadE_s <= '1';
			else 
					deadE_s <= '0';
			end if;
		end if;
		if (reset = '1') then
			energy1 <= "110101";
			energy0 <= "110000";
		end if;
	end process;
	
	dead <= dead_s or deadE_s;
	level_out <= level_signal_out;
	
	character_proc : process(pixel_row, pixel_col, mode, score3, score2, score1, score0, lives, gameover, menu, level, energy1, energy0)
	begin
		if (pixel_row >= 47 and pixel_row <= 63) then  -- TOP ROW HUD
			if (pixel_col <= 32 and pixel_col >= 16) then
				character_address <= "010011"; -- "S"
			elsif (pixel_col <= 48 and pixel_col >= 32) then
				character_address <= "000011"; -- "C"
			elsif (pixel_col <= 64 and pixel_col >= 48) then
				character_address <= "001111"; -- "O"
			elsif (pixel_col <= 80 and pixel_col >= 64) then
				character_address <= "010010"; -- "R"
			elsif (pixel_col <= 96 and pixel_col >= 80) then      --           SCORE
				character_address <= "000101"; -- "E"
			elsif (pixel_col <= 112 and pixel_col >= 96) then
				character_address <= "000000"; -- " "
			elsif (pixel_col <= 128 and pixel_col >= 112) then
				character_address <= std_logic_vector(score3);
			elsif (pixel_col <= 144 and pixel_col >= 128) then
				character_address <= std_logic_vector(score2);
			elsif (pixel_col <= 160 and pixel_col >= 144) then
				character_address <= std_logic_vector(score1);
			elsif (pixel_col <= 176 and pixel_col >= 160) then
				character_address <= std_logic_vector(score0);		
			
			elsif (pixel_col <= 224 and pixel_col >= 208) then
				character_address <= "001100"; -- "L"
			elsif (pixel_col <= 240 and pixel_col >= 224) then
				character_address <= "001001"; -- "I"
			elsif (pixel_col <= 256 and pixel_col >= 240) then
				character_address <= "010110"; -- "V"
			elsif (pixel_col <= 272 and pixel_col >= 256) then
				character_address <= "000101"; -- "E"
			elsif (pixel_col <= 288 and pixel_col >= 272) then
				character_address <= "010011"; -- "S"
			elsif (pixel_col <= 304 and pixel_col >= 288) then     --          LIVES
				character_address <= "000000"; -- " "
			elsif (pixel_col <= 320 and pixel_col >= 304) then
				character_address <= std_logic_vector(lives);		
		
			elsif (pixel_col >= 544 + 16*2 and pixel_col <= 560 + 16*2) then
				if (mode = '1') then 
					character_address <= "001110"; -- "N"				-- 			MODE
				else 
					character_address <= "010100"; -- "T"
				end if;
			else
				character_address <= "000000"; -- " "
			end if;
			
			if (start = '1') then
				if (pixel_col >= 352 + 16 and pixel_col <= 352 + 16*2) then
					character_address <= "000011"; -- "C"
				elsif (pixel_col >= 352 + 16*2 and pixel_col <= 352 + 16*3) then
					character_address <= "001000"; -- "H"
				elsif (pixel_col >= 352 + 16*3 and pixel_col <= 352 + 16*4) then				-- CHANGE MODE (continued from previous row)
					character_address <= "000001"; -- "A"		
				elsif (pixel_col >= 352 + 16*4 and pixel_col <= 352 + 16*5) then				
					character_address <= "001110"; -- "N"		
				elsif (pixel_col >= 352 + 16*5 and pixel_col <= 352 + 16*6) then
					character_address <= "000111"; -- "G"
				elsif (pixel_col >= 352 + 16*6 and pixel_col <= 352 + 16*7) then
					character_address <= "000101"; -- "E"
					
				elsif (pixel_col >= 352 + 16*8 and pixel_col <= 352 + 16*9) then
					character_address <= "001101"; -- "M"
				elsif (pixel_col >= 352 + 16*9 and pixel_col <= 352 + 16*10) then			
					character_address <= "001111"; -- "O"
				elsif (pixel_col >= 352 + 16*10 and pixel_col <= 352 + 16*11) then			
					character_address <= "000100"; -- "D"
				elsif (pixel_col >= 352 + 16*11 and pixel_col <= 352 + 16*12) then			
					character_address <= "000101"; -- "E"
				end if;
			end if;
			
		elsif (pixel_row >= 15 and pixel_row <= 31) then  -- OTHER TOP ROW HUD
			if (pixel_col <= 32 and pixel_col >= 16) then
				character_address <= "001100"; -- "L"
			elsif (pixel_col <= 48 and pixel_col >= 32) then
				character_address <= "000101"; -- "E"
			elsif (pixel_col <= 64 and pixel_col >= 48) then
				character_address <= "010110"; -- "V"
			elsif (pixel_col <= 80 and pixel_col >= 64) then
				character_address <= "000101"; -- "E"
			elsif (pixel_col <= 96 and pixel_col >= 80) then      --           LEVEL
				character_address <= "001100"; -- "L"
			elsif (pixel_col <= 112 and pixel_col >= 96) then
				character_address <= "000000"; -- " "
			elsif (pixel_col <= 128 and pixel_col >= 112) then
				character_address <= std_logic_vector(level);
			
			elsif (pixel_col <= 224 and pixel_col >= 208) then
				character_address <= "000101"; -- "E"
			elsif (pixel_col <= 240 and pixel_col >= 224) then
				character_address <= "001110"; -- "N"
			elsif (pixel_col <= 256 and pixel_col >= 240) then
				character_address <= "000101"; -- "E"
			elsif (pixel_col <= 272 and pixel_col >= 256) then
				character_address <= "010010"; -- "R"
			elsif (pixel_col <= 288 and pixel_col >= 272) then
				character_address <= "000111"; -- "G"
			elsif (pixel_col <= 304 and pixel_col >= 288) then     --          ENERGY
				character_address <= "011001"; -- "Y"
			elsif (pixel_col <= 320 and pixel_col >= 304) then
				character_address <= "000000"; -- " "
			elsif (pixel_col <= 336 and pixel_col >= 320) then
				character_address <= std_logic_vector(energy1);	
			elsif (pixel_col <= 352 and pixel_col >= 336) then
				character_address <= std_logic_vector(energy0);	
				
			else
				character_address <= "000000"; -- " "
			end if;
			
			if (start = '1') then
				if (pixel_col >= 352 + 16*2 and pixel_col <= 352 + 16*3) then
					character_address <= "010011"; -- "S"
				elsif (pixel_col >= 352 + 16*3 and pixel_col <= 352 + 16*4) then
					character_address <= "010111"; -- "W"
				elsif (pixel_col >= 352 + 16*4 and pixel_col <= 352 + 16*5) then				-- SW1 TO (continued on next row)
					character_address <= "110001"; -- "1"			
				
				elsif (pixel_col >= 352 + 16*7 and pixel_col <= 352 + 16*8) then
					character_address <= "010100"; -- "T"
				elsif (pixel_col >= 352 + 16*8 and pixel_col <= 352 + 16*9) then
					character_address <= "001111"; -- "O"
				end if;
			end if;
		else
			character_address <= "000000";
		end if;
			
	end process;
end architecture beh;
