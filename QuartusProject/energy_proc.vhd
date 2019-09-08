library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_UNSIGNED.all;

entity energy_proc is -- processes the energy increment and decrement signals so that they are only on for enough time to increment the energy by 1
	port (
			pickedup, flap 				: in std_logic;
			energy_inc, energy_dec 		: out std_logic
			);
end entity energy_proc;

architecture behaviour of energy_proc is 
	signal energy_inc_s : std_logic := '0';
	signal energy_dec_s : std_logic := '0';
	signal count1 : std_logic := '0';
	signal count2 : std_logic := '0';
	signal counted1 : std_logic := '0';
	signal counted2 : std_logic := '0';
begin
	process(pickedup, counted1)
	begin
		if (pickedup'event and pickedup = '1') then
			energy_inc_s <= '1';
			count1 <= '1';
		end if;
		if (counted1 = '1') then
			count1 <= '0';
			energy_inc_s <= '0';
		end if;
	end process;
	
	process(count1)
	begin
		if (count1 = '1') then
			counted1 <= '1';
		else
			counted1 <= '0';
		end if;
	end process;
	
	process(count2)
	begin
		if (count2 = '1') then
			counted2 <= '1';
		else
			counted2 <= '0';
		end if;
	end process;
	
	process(flap, counted2)
	begin
		if (flap'event and flap = '1') then
			energy_dec_s <= '1';
			count2 <= '1';
		end if;
		if (counted2 = '1') then
			count2 <= '0';
			energy_dec_s <= '0';
		end if;
	end process;
	
	energy_dec <= energy_dec_s;
	energy_inc <= energy_inc_s;
end architecture;