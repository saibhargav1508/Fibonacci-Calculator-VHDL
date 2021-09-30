library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lte_comp_8 is
  generic (
		width :     positive := 8
	);
  port (
		in1       : in  std_logic_vector(width-1 downto 0);
		in2       : in  std_logic_vector(width-1 downto 0);
		status    : out std_logic
	);
end lte_comp_8;

architecture bhv of lte_comp_8 is
begin

	process(in1, in2)
	begin
		if (unsigned(in1) <= unsigned(in2)) then
			status <= '1';
		else
			status <= '0';
		end if;
	end process;
	
end bhv;
