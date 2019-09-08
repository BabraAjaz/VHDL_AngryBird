library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
USE IEEE.STD_LOGIC_UNSIGNED.all;

entity counter is -- this component is used to count a delay, to allow a mouse event to trigger a flap
	port (
			clk, enable, reset : in std_logic;
			counted_out              : out std_logic
			);
end entity counter;

architecture behaviour of counter is
	signal Q : unsigned(23 downto 0); 
	signal counted : std_logic;
begin
	process(clk, reset, enable)
	begin
		if (enable = '1') then
			if (clk'event and clk = '1') then
				if (Q < 3777215) then
					Q <= Q + "000000000000000000000001";
					counted <= '0';
				else
					Q <= "000000000000000000000000";
					counted <= '1';
				end if;
			end if;
		end if;
		if (reset = '1') then
			Q <= "000000000000000000000000";
			counted <= '0';
		end if;
	end process;
	counted_out <= counted;
end architecture;