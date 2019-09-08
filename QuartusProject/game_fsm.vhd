library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity game_fsm is

		port
			(
				clk, reset																: in std_logic; -- classic inputs
				left_click, right_click, middle_click, switch_1				: in std_logic; -- user inputs
				dead																		: in std_logic; -- other inputs
				
				menu, start, pause, gameover, mode								: out std_logic -- control signal outputs
			);
			
end entity;
architecture rtl of game_fsm is

			-- Build an enumerated type for the state machine
			type state_type is (s_menu, s_start, s_normal, s_pause, s_training, s_gameover);
			
			signal state, next_state: state_type := s_menu;
			
begin
			state_reg: process (clk, reset)
			begin
				if reset = '1' then 
					state <= s_menu;
			
				elsif (rising_edge(clk)) then 
					state <= next_state;
				end if;
			end process;
			
			next_state_fn: process(state, left_click, right_click, middle_click, switch_1, dead) -- next state logic
			begin
				case state is
					when s_menu =>
						if (right_click = '1') then
							next_state <= s_start;
						else 
							next_state <= s_menu;
						end if;
						
					when s_start =>
						if (left_click = '1') then
							if (switch_1 = '1') then
								next_state <= s_normal;
							else
								next_state <= s_training;
							end if;
						else
							next_state <= s_start;
						end if;
						
					when s_normal =>
						if (right_click = '1') then
							next_state <= s_pause;
						elsif (dead = '1') then
							next_state <= s_gameover;
						else
							next_state <= s_normal;
						end if;
						
					when s_training =>
						if (right_click = '1') then
							next_state <= s_pause;
						elsif (dead = '1') then
							next_state <= s_gameover;
						else
							next_state <= s_training;
						end if;
					
					when s_pause =>
						if (left_click = '1') then
							if (switch_1 = '1') then
								next_state <= s_normal;
							elsif (switch_1 = '0') then
								next_state <= s_training;
							end if;
						elsif (middle_click = '1') then
							next_state <= s_start;
						else
							next_state <= s_pause;
						end if;
						
					when s_gameover =>
						if (middle_click = '1') then
							next_state <= s_start;
						else
							next_state <= s_gameover;
						end if;
						
				end case;
			end process;
			
			output_fn: process (state) -- output logic
			begin

				menu <= '0';
				pause <= '0';
				gameover <= '0';
				start <= '0';
				
				case state is
					when s_menu =>
						menu <= '1';
						
					when s_start =>
						start <= '1';
						if (switch_1 = '1') then
							mode <= '1';
						else
							mode <= '0';
						end if;
						
					when s_normal =>
						mode <= '1';
						
					when s_training =>
						mode <= '0';

					when s_pause =>
						pause <= '1';
					
					when s_gameover =>
						gameover <= '1';
					
				end case;
			end process;
end rtl;
			
			
	
