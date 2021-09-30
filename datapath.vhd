library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity datapath is
  generic (
    width  :     positive := 8);
  port (
    clk    : in  std_logic;
    rst    : in  std_logic;
    n      : in  std_logic_vector(width-1 downto 0);
    result : out std_logic_vector(width-1 downto 0);

    -- ports between datapath and controller

    i_sel  : in  std_logic;
    x_sel  : in  std_logic;
    y_sel  : in  std_logic;
    i_ld   : in  std_logic;
    x_ld   : in std_logic;
    y_ld   : in  std_logic;
    n_ld   : in  std_logic;
    result_ld  : in  std_logic;
	i_le_n : out std_logic
	);
end datapath;

architecture STR of datapath is

	-- signals used in datapath to connect entitites
	-- naming convention followed for signals is:
	-- in for input to i, x or y register from their respective mux
	-- out for output from the registers
	-- add_out based on input to the adder
	signal mux_i_in, mux_x_in, mux_y_in               : std_logic_vector(width-1 downto 0);
	signal i_reg_out, x_reg_out, y_reg_out, n_reg_out : std_logic_vector(width-1 downto 0);
	signal i_add_out, x_y_add_out                     : std_logic_vector(width-1 downto 0);
	
begin
	
	U_MUX_I : entity work.mux21(bhv)
		generic map (width => width)
		port map(
			in1 => std_logic_vector(to_unsigned(3, width)),
			in2 => i_add_out,
			sel => i_sel,
			output => mux_i_in
		);
	
	U_MUX_X : entity work.mux21(bhv)
		generic map (width => width)
		port map(
			in1 => std_logic_vector(to_unsigned(1, width)),
			in2 => y_reg_out,
			sel => x_sel,
			output => mux_x_in
		);
	
	U_MUX_Y : entity work.mux21(bhv)
		generic map (width => width)
		port map(
			in1 => std_logic_vector(to_unsigned(1, width)),
			in2 => x_y_add_out,
			sel => y_sel,
			output => mux_y_in
		);
	
	U_REG_I : entity work.load_reg_8(BHV)
		generic map (width => width)
		port map(
			clk => clk,
			rst => rst,
			load => i_ld,
			input => mux_i_in,
			output => i_reg_out
		);
		
	U_REG_X : entity work.load_reg_8(BHV)
		generic map (width => width)
		port map(
			clk => clk,
			rst => rst,
			load => x_ld,
			input => mux_x_in,
			output => x_reg_out
		);	
		
	U_REG_Y : entity work.load_reg_8(BHV)
		generic map (width => width)
		port map(
			clk => clk,
			rst => rst,
			load => y_ld,
			input => mux_y_in,
			output => y_reg_out
		);
	
	U_REG_N : entity work.load_reg_8(BHV)
		generic map (width => width)
		port map(
			clk => clk,
			rst => rst,
			load => n_ld,
			input => n,
			output => n_reg_out
		);
	
	U_LTE_COMP : entity work.lte_comp_8(bhv)
		generic map (width => width)
		port map(
			in1 => i_reg_out,
			in2 => n_reg_out,
			status => i_le_n
		);
	
	U_ADD_I : entity work.adder_8(BHV)
		generic map (width => width)
		port map(
			in1 => i_reg_out,
			in2 => std_logic_vector(to_unsigned(1, width)),
			output => i_add_out
		);
		
	U_ADD_X_Y : entity work.adder_8(BHV)
		generic map (width => width)
		port map(
			in1 => x_reg_out,
			in2 => y_reg_out,
			output => x_y_add_out
		);
	U_REG_RES : entity work.load_reg_8(BHV)
		generic map (width => width)
		port map(
			clk => clk,
			rst => rst,
			load => result_ld,
			input => y_reg_out,
			output => result
		);
	
end STR;
