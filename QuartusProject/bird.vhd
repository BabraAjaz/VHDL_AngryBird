LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_SIGNED.all;

ENTITY bird IS -- processes the birds movement and display

   PORT(SIGNAL mode, LC, colour_change, v_sync, paused, startscreen, stop, gameover, reset	: IN std_logic;
			SIGNAL pixel_column, pixel_row : IN std_logic_vector(9 downto 0);
        SIGNAL Red,Green,Blue 			: OUT std_logic_vector(3 downto 0);
		  SIGNAL X_Pos, Y_Pos, Size_out : OUT std_logic_vector(9 downto 0);
		  SIGNAL bird_en 						: IN std_logic;
		  SIGNAL cnt_enable : out std_logic;
		  SIGNAL counted : in std_logic;
		  SIGNAL cnt_reset, dead : out std_logic;
		  SIGNAL flap_out : out std_logic);
END bird;

architecture behavior of bird is

			-- Video Display Signals   
SIGNAL bird_on													: std_logic;
SIGNAL Size, Size1X, Size1Y, Size2X, Size2Y			: std_logic_vector(9 DOWNTO 0);  
SIGNAL bird_X_motion 										: std_logic_vector(9 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(2,10);
SIGNAL bird_Y_motion											: std_logic_vector(9 DOWNTO 0);
SIGNAL bird_Y_pos												: std_logic_vector(9 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(240,10);
SIGNAL bird_X_pos												: std_logic_vector(9 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(300,10);
SIGNAL colour_set 											: std_logic_vector(1 downto 0) := "00";
SIGNAL count_enable, count_reset : std_logic;
SIGNAL flap : std_logic;
SIGNAL dead_s : std_logic := '0';

BEGIN           

	Size <= CONV_STD_LOGIC_VECTOR(8,10);
	
	Size1X <= CONV_STD_LOGIC_VECTOR(5,10);
	Size1Y <= CONV_STD_LOGIC_VECTOR(8,10);
	Size2X <= CONV_STD_LOGIC_VECTOR(8,10);
	Size2Y <= CONV_STD_LOGIC_VECTOR(5,10);
	
	-- changes colour
	-- 00 : yellow
	-- 01 : orange
	-- 10 : red
	with colour_set select
		Red(3 downto 0) <= bird_on&bird_on&bird_on&bird_on when "00",
					 bird_on&bird_on&bird_on&bird_on when "01",
					 bird_on&bird_on&bird_on&bird_on when "10",
						"0000" when others;
	with colour_set select
		Green(3) <= bird_on when "00",
						bird_on when "01",
							'0' when others;
	with colour_set select
		Green(2) <= bird_on when "00",
							'0' when others;
	with colour_set select
		Green(1) <= 	bird_on when "00",
							'0' when others;
	with colour_set select
		Green(0) <= bird_on when "00",
							'0' when others;

		Blue <= "0000";



	process(colour_change, reset)
	begin
		if (colour_change'event and colour_change = '1') then
			if (colour_set = "00") then -- yellow (3 lives) to orange (2 lives)
				colour_set <= "01";
			elsif (colour_set = "01") then -- orange (2 lives) to red (1 life)
				colour_set <= "10";
			elsif (colour_set = "11") then
				colour_set <= "00";
			end if;
		end if;
		if (reset = '1') then
			colour_set <= "00";
		end if;
	end process;

	RGB_Display: Process (bird_X_pos, bird_Y_pos, pixel_column, pixel_row, Size, bird_en)
	BEGIN
		-- processes when to display the bird
		IF ('0' & bird_X_pos <= '0' & pixel_column + Size1X) AND
			('0' & bird_X_pos + Size1X >= '0' & pixel_column) AND
			('0' & bird_Y_pos <= '0' & pixel_row + Size1Y) AND
			('0' & bird_Y_pos + Size1Y >= '0' & pixel_row ) THEN
				bird_on <= '1';
		ELSIF ('0' & bird_X_pos <= '0' & pixel_column + Size2X) AND
			('0' & bird_X_pos + Size2X >= '0' & pixel_column) AND
			('0' & bird_Y_pos <= '0' & pixel_row + Size2Y) AND
			('0' & bird_Y_pos + Size2Y >= '0' & pixel_row ) THEN
				bird_on <= '1';
		ELSE
				bird_on <= '0';
		END IF;
	END process RGB_Display;
	
	Click_Counter: Process (LC,counted) -- tried to make it only flap once when you click but its not working
	BEGIN
		-- processes the mouse input (uses "counter.vhd")
		IF (LC'event and LC = '1') THEN
			count_enable <= '1';
			flap <= '1';
			count_reset <= '0';
		END IF;
		IF (counted = '1') THEN
			flap <= '0';
			count_enable <= '0';
			count_reset <= '1';
		END IF;
	END PROCESS;
	
	flap_out <= flap;
	
	cnt_enable <= count_enable;
	cnt_reset <= count_reset;

	Move_bird: process -- processes the bird's movement. dependent on the game state and the mouse click
	BEGIN
				-- Move bird once every vertical sync
		WAIT UNTIL v_sync'event and v_sync = '1';
			IF (paused = '0' and startscreen = '0' and gameover = '0' and stop = '0' and reset = '0') then -- normal behaviour
					IF FLAP = '1' THEN
						bird_Y_motion <= - CONV_STD_LOGIC_VECTOR(7,10);
					ELSIF FLAP = '0' THEN
						bird_Y_motion <= CONV_STD_LOGIC_VECTOR(3,10);
					END IF;
				-- Compute next bird Y position
					IF (bird_Y_pos <= CONV_STD_LOGIC_VECTOR(6,10)) THEN
						bird_Y_pos <= CONV_STD_LOGIC_VECTOR(7,10);
						bird_Y_motion <= CONV_STD_LOGIC_VECTOR(2,10);
					ELSIF ('0' & bird_Y_pos) >= CONV_STD_LOGIC_VECTOR(480,10) - Size THEN
						dead_s <= '1';
					ELSE 
						bird_Y_pos <= bird_Y_pos + bird_Y_motion;
					END IF;
			ELSIF (gameover = '1') then -- GAME OVER behaviour
						bird_Y_pos <= CONV_STD_LOGIC_VECTOR(240,10) - Size;
						bird_Y_motion <= CONV_STD_LOGIC_VECTOR(0,10);
			elsif (startscreen = '1') then -- start menu behaviour
				if (bird_y_pos <= CONV_STD_LOGIC_VECTOR(220,10)) then -- move down
					bird_Y_motion <= CONV_STD_LOGIC_VECTOR(1,10);
				elsif (bird_y_pos >= CONV_STD_LOGIC_VECTOR(260,10)) then -- move up
					bird_Y_motion <= -CONV_STD_LOGIC_VECTOR(5,10);
				else
					bird_Y_motion <= -CONV_STD_LOGIC_VECTOR(4,10);
				end if;
				bird_Y_pos <= bird_Y_pos + bird_Y_motion;
			end if;
			if (reset = '1') then
				dead_s <= '0';
			END IF;
	END process Move_bird;
	
	dead <= dead_s;
	X_Pos <= bird_X_pos;
	Y_Pos <= bird_Y_pos;
	Size_out <= Size;
	
END behavior;

