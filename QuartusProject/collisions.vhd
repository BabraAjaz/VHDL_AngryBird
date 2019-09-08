library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_UNSIGNED.all;

entity collisions is -- processes the collisions between the ball and the pipes or the pickup
	port (
			clk : in std_logic;
			random1, random2	: in std_logic_vector(8 downto 0);
			Ball_X_Pos, Ball_Y_Pos, Obstacle_X_Pos, Obstacle_Y_Pos, Ball_Size, Obstacle_X_Size, Obstacle_Y_Size, Gap_size,  Obstacle2_X_Pos,  Obstacle2_Y_Pos, Obstacle2_X_Size,  Obstacle2_Y_Size, Gap2_size, pickup_x_pos, pickup_y_pos, pickup_size: in std_logic_vector(9 downto 0);
			collided : out std_logic;
			pickedup : out std_logic;
			score_inc : out std_logic
			);
end entity collisions;

architecture behaviour of collisions is
	signal collision_s : std_logic;
	signal dead_s : std_logic;
	signal pickedup_s : std_logic;
begin
	obstacles: process(clk)
	begin
		if (clk'event and clk = '1') then
			if (Ball_X_Pos + ball_size >= Obstacle_X_Pos - Obstacle_X_Size and Ball_X_Pos - ball_size <= Obstacle_X_Pos + Obstacle_X_Size -- x collisions
				and (Ball_Y_Pos - Ball_Size <= Obstacle_Y_Pos + random1 or Ball_Y_Pos + Ball_Size >= Obstacle_Y_Pos + random1 + Gap_size)  -- excludes gap
				) then
				collision_s <= '1';
			elsif (Ball_X_Pos + ball_size >=  Obstacle2_X_Pos -  Obstacle2_X_Size and Ball_X_Pos - ball_size <=  Obstacle2_X_Pos +  Obstacle2_X_Size -- x collisions
				and (Ball_Y_Pos - Ball_Size <=  Obstacle2_Y_Pos + random2 or Ball_Y_Pos + Ball_Size >=  Obstacle2_Y_Pos + random2 + Gap2_size)  -- excludes gap
				) then
				collision_s <= '1';
			else
				collision_s <= '0';
			end if;
			
			-- same as above but for second pipe
			if (Ball_X_Pos - ball_size >= Obstacle_X_Pos - Obstacle_X_Size and Ball_X_Pos - ball_size <= Obstacle_X_Pos + Obstacle_X_Size) 
			and (Ball_Y_Pos - Ball_Size >= Obstacle_Y_Pos + random1 and Ball_Y_Pos + Ball_Size <= Obstacle_Y_Pos + random1 + Gap_size) then
				score_inc <= '1';
			elsif (Ball_X_Pos - ball_size >=  Obstacle2_X_Pos -  Obstacle2_X_Size and Ball_X_Pos - ball_size <=  Obstacle2_X_Pos +  Obstacle2_X_Size) 
			and (Ball_Y_Pos - Ball_Size >=  Obstacle2_Y_Pos + random2 and Ball_Y_Pos + Ball_Size <=  Obstacle2_Y_Pos + random2 + Gap2_size) then
				score_inc <= '1';
			else
				score_inc <= '0';
			end if;
		end if;
	end process;
	collided <= collision_s;
	
	pickups: process(clk)
	begin
		if (clk'event and clk = '1') then
			if (Ball_X_Pos + ball_size >= pickup_x_pos - pickup_size and Ball_X_Pos - ball_size <= pickup_x_pos + pickup_size -- x collisions
				and Ball_Y_Pos - Ball_Size <= pickup_y_pos + pickup_size and Ball_Y_Pos + Ball_Size >= pickup_y_pos - pickup_size  -- y collisions
				) then
				pickedup_s <= '1';
			else
				pickedup_s <= '0';
			end if;
		end if;
	end process;
	pickedup <= pickedup_s;
end architecture;

-- Ball left side: x position - size
-- Ball right side: x position + size
-- Ball top: y position - size
-- Ball bottom: y position + size

-- pickup is same as ball

-- Obs left: x position - xsize
-- Obs right: x position + xsize
-- Top Pipe Bottom: random
-- Bottom Pipe Top: random + gap size