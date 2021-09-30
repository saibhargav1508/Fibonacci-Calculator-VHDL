library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder_8 is
  generic (
    width  :     positive := 8);
  port (
    in1    : in  std_logic_vector(width-1 downto 0);
    in2    : in  std_logic_vector(width-1 downto 0);
    output : out std_logic_vector(width-1 downto 0));
end adder_8;

architecture BHV of adder_8 is
begin 
  output <= std_logic_vector(unsigned(in1)+unsigned(in2));
end BHV;
