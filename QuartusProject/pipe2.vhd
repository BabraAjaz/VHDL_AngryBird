
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_SIGNED.all;

ENTITY pipe2 IS -- processes the movement and display of the second pipe

   PORT(signal mode, paused, startscreen, stop, reset							: IN std_LOGIC;
        signal Red,Green,Blue 											: OUT std_logic_vector(3 downto 0);
        signal Vert_sync													: IN std_logic;
		  signal pixel_column, pixel_row 								: IN std_logic_vector(9 downto 0);
		  signal             random 										: in std_logic_vector(8 downto 0);
		  signal X_Pos, Y_Pos, SizeX_out, SizeY_out, Gap_Size 	: out std_logic_vector(9 downto 0);
		  signal new_pipe 													: out std_logic;
		  signal pipe_en 														: in std_logic;
		  signal level															: in std_logic_vector(1 downto 0));
end pipe2;

architecture behavior of pipe2 is

			-- Video Display signals   
	signal Red_Data, Green_Data, Blue_Data : std_logic_vector(3 downto 0);
	signal pipe_on			: std_logic;
	signal SizeX, SizeY									: std_logic_vector(9 downto 0);  
	signal pipe_X_motion 								: std_logic_vector(9 downto 0) := - CONV_STD_LOGIC_VECTOR(2,10);
	signal pipe_Y_motion									: std_logic_vector(9 downto 0);
	signal pipe_Y_pos								: std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(50,10);
	signal pipe_X_pos								: std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(250,10);
	signal colour_set 							: std_logic_vector(2 downto 0);
	signal new_pipe_s	: std_logic := '0';

	begin           

	SizeX <= CONV_STD_LOGIC_VECTOR(32,10);
	SizeY <= CONV_STD_LOGIC_VECTOR(150,10);
	pipe_Y_pos <= CONV_STD_LOGIC_VECTOR(50,10);

	-- 1111 green plus 1011 blue = ~cyan
	Red <= "0000";
	Green <=   pipe_on & pipe_on & pipe_on & pipe_on;
	Blue <=    pipe_on & '0' & pipe_on & pipe_on;


	RGB_Display: Process (pipe_X_pos, pipe_Y_pos, pixel_column, pixel_row, SizeX, random, pipe_en) -- processes when to display the pipe
	begin
		-- top pipe
		if ('0' & pipe_X_pos <= '0' & pixel_column + SizeX) AND -- Obs left: x position - xsize
			('0' & pipe_X_pos + SizeX >= '0' & pixel_column) AND -- Obs right: x position + xsize
			("0000000000" <= '0' & pixel_row) AND -- Top Pipe Top: y position
			('0' & pipe_Y_pos + random >= '0' & pixel_row ) then -- Top Pipe Bottom: y position + random
			pipe_on <= '1';
		-- bottom pipe
		elsif('0' & pipe_X_pos <= '0' & pixel_column + SizeX) AND
			('0' & pipe_X_pos + SizeX >= '0' & pixel_column) AND
			('0' & pipe_Y_pos + random + CONV_STD_LOGIC_VECTOR(120,11) <= '0' & pixel_row) AND
			("0111100000" >= '0' & pixel_row) then -- bottom of screen
			pipe_on <= '1';
		else
			pipe_on <= '0';
		end if;
	end process RGB_Display;


	Move_pipe: process -- processes the movement of the pipe. dependent on the game state and the level
	begin
				-- Move pipe once every vertical sync
		wait until vert_sync'event and vert_sync = '1';
			if (paused = '0' and startscreen = '0' and stop = '0') then
				if (mode = '0') then
					pipe_X_motion <= - CONV_STD_LOGIC_VECTOR(1,10);
				else
					if (level = "01") then
						pipe_X_motion <= - CONV_STD_LOGIC_VECTOR(2,10);
					elsif (level = "10") then
						pipe_X_motion <= - CONV_STD_LOGIC_VECTOR(3,10);
					elsif (level = "11") then
						pipe_X_motion <= - CONV_STD_LOGIC_VECTOR(4,10);
					end if;
				end if;	
				if ('0' & pipe_X_pos) <= SizeX then -- goes to left edge of screen
					pipe_X_pos <= CONV_STD_LOGIC_VECTOR(600,10);
					new_pipe_s <= '1';
				else
					pipe_X_pos <= pipe_X_pos + pipe_X_motion;
					new_pipe_s <= '0';
				end if;
			end if;
			if (reset = '1') then
				pipe_X_pos <= CONV_STD_LOGIC_VECTOR(250,10);
			end if;
					
	end process Move_pipe;
	X_Pos <= pipe_X_pos;
	Y_Pos <= pipe_y_pos;
	SizeX_out <= SizeX;
	SizeY_out <= SizeY;
	Gap_Size <= '0' & CONV_STD_LOGIC_VECTOR(120,9);
	new_pipe <= new_pipe_s;
end behavior;

