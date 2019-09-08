LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_UNSIGNED.all;

LIBRARY altera_mf;
USE altera_mf.all;

ENTITY flappy_image IS
	PORT
	(
		font_row, font_col	:	IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		clock				: 	IN STD_LOGIC;
		rom_output	:	OUT STD_LOGIC_VECTOR (11 DOWNTO 0)
	);
END flappy_image;

ARCHITECTURE behaviour OF flappy_image IS

	SIGNAL rom_data		: STD_LOGIC_VECTOR (11 DOWNTO 0);
	SIGNAL rom_address	: STD_LOGIC_VECTOR (14 DOWNTO 0);

	COMPONENT imagerom
	PORT (
		clock		: IN STD_LOGIC ;
		address	: IN STD_LOGIC_VECTOR (14 DOWNTO 0);
		q			: OUT STD_LOGIC_VECTOR (11 DOWNTO 0)
	);
	END COMPONENT;

BEGIN

	image_component : imagerom
	
	PORT MAP (
		clock => clock,
		address => rom_address,
		q => rom_data
	);

	rom_address <= font_col(9 downto 2) + conv_std_logic_vector((CONV_INTEGER(font_row(9 downto 2))*160),15);
	rom_output <= rom_data;

END behaviour;