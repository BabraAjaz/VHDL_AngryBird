library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_UNSIGNED.all;

-- 1 = pipe
-- 2 = bird
-- 3 = HUD text
-- 4 = pickup
-- 5 = image
-- 6 = pipe2
-- 7 = title text

entity disp_proc is
	port (
			red1, green1, blue1, red2, green2, blue2, red3, green3, blue3, red4, green4, blue4, red5, green5, blue5, red6, green6, blue6, red7, green7, blue7 : in std_logic_vector(3 downto 0);
			collision_red : in std_logic;
			red_out, green_out, blue_out : out std_logic_vector(3 downto 0)
			);
end entity disp_proc;

architecture behaviour of disp_proc is
	signal s_red, s_blue, s_green : std_logic_vector(3 downto 0);
	signal collision : std_logic_vector(3 downto 0) := collision_red & collision_red & collision_red & collision_red;
begin
	
	process(red1, green1, blue1, red2, green2, blue2, red3, green3, blue3, red4, green4, blue4, red5, green5, blue5, red6, green6, blue6, collision_red, collision, s_red, s_green, s_blue)
	begin
		
		-- both types of text are on top, then the bird, then the pipes, then the pickup, then the background image is on the bottom
		
		if(red3 > "0000") then -- hud text
			s_red <= red3;
			s_blue <= blue3;
			s_green <= green3;
		elsif(red7 > "0000") then -- title text
			s_red <= "0000";
			s_blue <= "0000";
			s_green <= "0000";
		elsif(red2 > "0000") then -- bird
			s_red <= red2;
			s_blue <= blue2;
			s_green <= green2;
		elsif(green1 > "0000" ) then -- pipe
			s_red <= red1;
			s_blue <= blue1;
			s_green <= green1;
		elsif(green6 > "0000") then -- second pipe
			s_red <= red6;
			s_blue <= blue6;
			s_green <= green6;
		elsif(red4 > "0000") then -- pickup
			s_red <= red4;
			s_blue <= blue4;
			s_green <= green4;
		elsif(blue5 > "0000" or red5 > "0000" or green5 > "0000") then -- bg image
			s_red <= red5;
			s_blue <= blue5;
			s_green <= green5;
		else
			s_red <= "0000";
			s_blue <= "0000";
			s_green <= "0000";
		end if; 
		-- if a collision occurs, the screen flashes red
		if (collision_red = '1') then
			s_red <= collision;
		end if;
		
	red_out <= s_red;
	green_out <= s_green;
	blue_out <= s_blue;
	end process;
	
	
end architecture;