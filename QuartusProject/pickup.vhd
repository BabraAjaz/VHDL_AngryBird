LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_SIGNED.all;

ENTITY pickup IS -- processes the movement and display of the pickup

   PORT(signal mode, paused, startscreen, stop, reset					: IN std_LOGIC;
        signal Red,Green,Blue 									: OUT std_logic_vector(3 downto 0);
        signal Vert_sync											: IN std_logic;
		  signal pixel_column, pixel_row 						: IN std_logic_vector(9 downto 0);
		  signal             random 								: in std_logic_vector(7 downto 0);
		  signal X_Pos, Y_Pos, Size_out				 			: out std_logic_vector(9 downto 0);
		  signal new_pickup 											: out std_logic;
		  signal pickup_en 											: in std_logic;
		  signal pickedup 											: in std_logic;
		  signal level													: in std_logic_vector(1 downto 0));
end pickup;

architecture behavior of pickup is

			-- Video Display signals   
	signal Red_Data, Green_Data, Blue_Data : std_logic_vector(3 downto 0);
	signal vert_sync_int, pickup_on, Direction			: std_logic;
	signal Size									: std_logic_vector(9 downto 0);  
	signal pickup_X_motion 								: std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(2,10);
	signal pickup_Y_motion									: std_logic_vector(9 downto 0);
	signal pickup_Y_pos								: std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(200,10);
	signal pickup_X_pos								: std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(100,10);
	signal colour_set 							: std_logic_vector(2 downto 0);
	signal new_pickup_s	: std_logic := '0';
	signal disp_pickups : std_logic := '1';

	begin           

	Size <= CONV_STD_LOGIC_VECTOR(6,10);
	
	-- red + blue = magenta
	Red <=  pickup_on & pickup_on & pickup_on & pickup_on;
	Green <=  "0000";
	Blue <=   pickup_on & pickup_on & pickup_on & pickup_on;
	

	RGB_Display: Process (pickup_X_pos, pickup_Y_pos, pixel_column, pixel_row, Size, pickup_en, disp_pickups, pickup_on)
	BEGIN
	-- processes when to display the pickup
	if (disp_pickups = '1') then
		IF ('0' & pickup_X_pos <= '0' & pixel_column + Size) AND
			('0' & pickup_X_pos + Size >= '0' & pixel_column) AND
			('0' & pickup_Y_pos <= '0' & pixel_row + Size) AND
			('0' & pickup_Y_pos + Size >= '0' & pixel_row ) THEN
			pickup_on <= '1';
		ELSE
			pickup_on <= '0';
		END IF;
	end if;
	END process RGB_Display;


	Move_pickup: process -- processes pickup movement. dependent on the game state and the level
	begin
				-- Move pickup once every vertical sync
		wait until vert_sync'event and vert_sync = '1';
				if (paused = '0' and startscreen = '0' and stop = '0') then
					if (mode = '1') then
						if (level = "01") then
							pickup_X_motion <= - CONV_STD_LOGIC_VECTOR(2,10);
						elsif (level = "10") then
							pickup_X_motion <= - CONV_STD_LOGIC_VECTOR(3,10);
						elsif (level = "11") then
							pickup_X_motion <= - CONV_STD_LOGIC_VECTOR(4,10);
						end if;
						disp_pickups <= '1';
					else
						disp_pickups <= '0';
					end if;
					if ('0' & pickup_X_pos) <= Size - Size or pickedup = '1' then
						pickup_X_pos <= CONV_STD_LOGIC_VECTOR(630,10);
						new_pickup_s <= '1';
					else
						pickup_X_pos <= pickup_X_pos + pickup_X_motion;
						new_pickup_s <= '0';
					end if;
				end if;
				if (reset = '1') then
					pickup_X_pos <= CONV_STD_LOGIC_VECTOR(550,10);
				end if;
					
	end process Move_pickup;
	X_Pos <= pickup_X_pos;
	Y_Pos <= pickup_Y_pos;
	Size_out <= Size;
	new_pickup <= new_pickup_s;
end behavior;

