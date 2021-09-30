library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controller is
	port(
		clk    : in  std_logic;
		rst    : in  std_logic;
		go     : in  std_logic;
		done   : out std_logic;

		-- ports between datapath and controller
		-- input and ouput for ports are opposite of what was defined in datapath.vhd

		i_sel  : out  std_logic;
		x_sel  : out  std_logic;
		y_sel  : out  std_logic;
		i_ld   : out  std_logic;
		x_ld   : out std_logic;
		y_ld   : out  std_logic;
		n_ld   : out  std_logic;
		result_ld  : out  std_logic;
		i_le_n : in std_logic
	);
end controller;

architecture bhv of controller is
	
	type STATE_TYPE is (WAIT_FOR_GO, INIT, LOOP_CONDITION, LOOP_BODY, S_DONE);
	signal state, next_state : STATE_TYPE;
	
begin
	
	process(clk, rst)
	begin 
		if (rst = '1') then 
			state <= WAIT_FOR_GO;
		elsif rising_edge(clk) then
			state <= next_state;
		end if;
	end process;
	
	process(state, go, i_le_n)
	begin
		
		-- assigning default value to all ports before defining
		-- combinational logic to avoid latch warning during synthesis
		done <= '0';
		i_sel <= '1';
		x_sel <= '1';
		y_sel <= '1';
		i_ld <= '0';
		x_ld <= '0';
		y_ld <= '0';
		n_ld <= '0';
		result_ld <= '0';
		next_state <= state;
	
		case state is
			when WAIT_FOR_GO =>
				if (go = '1') then
					next_state <= INIT;
					done <= '0';
				end if;
			
			when INIT =>
				i_sel <= '1';
				x_sel <= '1';
				y_sel <= '1';
				i_ld  <= '1';
				x_ld  <= '1';
				y_ld  <= '1';
				n_ld  <= '1';
				next_state <= LOOP_CONDITION;
			
			when LOOP_CONDITION =>
				if (i_le_n = '1') then
					next_state <= LOOP_BODY;
				else
					next_state <= S_DONE;
					result_ld <= '1';
				end if;
				i_ld  <= '0';
				x_ld  <= '0';
				y_ld  <= '0';
				n_ld  <= '0';
			
			when LOOP_BODY =>
				i_sel <= '0';
				x_sel <= '0';
				y_sel <= '0';
				i_ld  <= '1';
				x_ld  <= '1';
				y_ld  <= '1';
				n_ld  <= '1';
				next_state <= LOOP_CONDITION;
				
			when S_DONE =>
				done <= '1';
				result_ld <= '0';
				if (go = '0') then
					next_state <= WAIT_FOR_GO;
				end if;
				
			when others => null;

		end case;
		
	end process;

end bhv;