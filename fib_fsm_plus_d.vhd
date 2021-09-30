library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fib_fsmd_plus_d is
	generic(
		width : positive := 8
	);
	port(
		clk    : in  std_logic;
		rst    : in  std_logic;
		go     : in  std_logic;
		n      : in  std_logic_vector(width-1 downto 0);
		result : out std_logic_vector(width-1 downto 0);
		done   : out std_logic
	);
end fib_fsmd_plus_d ;

architecture STR of fib_fsmd_plus_d  is

	signal i_sel, x_sel, y_sel : std_logic;
	signal i_ld, x_ld, y_ld, n_ld, result_ld : std_logic;
	signal i_le_n : std_logic;
	
	
begin
	
	U_CONTROLLER : entity work.controller(bhv)
		port map(
			clk    => clk,
            rst    => rst,
			go 	   => go,
			done => done,
            i_sel  => i_sel,   
            x_sel  => x_sel,  
			y_sel  => y_sel,  
			i_ld   => i_ld,  
			x_ld   => x_ld,  
			y_ld   => y_ld,  
			n_ld   => n_ld,  
			result_ld => result_ld,
			i_le_n => i_le_n
		);
		
	U_DATAPATH : entity work.datapath(STR)
		generic map(width => width)
		port map (
            clk    => clk,
            rst    => rst,
			n 	   => n,
			result => result,
			i_sel  => i_sel,   
            x_sel  => x_sel,  
			y_sel  => y_sel,
            i_ld   => i_ld,  
			x_ld   => x_ld,  
			y_ld   => y_ld,  
			n_ld   => n_ld,    
			result_ld => result_ld,
			i_le_n => i_le_n
        );

end STR;