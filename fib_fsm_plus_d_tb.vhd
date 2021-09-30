library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fib_fsmd_plus_d_tb is
end fib_fsmd_plus_d_tb ;


architecture tb of fib_fsmd_plus_d_tb is

    constant width   : positive := 8;
    constant TIMEOUT : time     := 1 ms;

    signal clkEn  : std_logic                          := '1';
    signal clk    : std_logic                          := '0';
    signal rst    : std_logic                          := '1';
    signal go     : std_logic                          := '0';
    signal done   : std_logic;
    signal n      : std_logic_vector(width-1 downto 0);
    signal result : std_logic_vector(width-1 downto 0);
	
begin

	UUT : entity work.fib_fsmd_plus_d(STR)
		generic map(
			width => width
		)
		port map(
			clk    => clk,
			rst    => rst,
			go     => go,
			n      => n,
			result => result,
			done   => done
		);
			
    clk <= not clk and clkEn after 20 ns;

    process

        function fibo (n : integer)
            return std_logic_vector is

            variable x, y, i,regN,temp : integer;

        begin
			regN := n;
            i := 3;
            x := 1;
			y := 1;
			
            while (i <= regN) loop
                temp := x+y;
				x    := y;
				y    := temp;
				i    := i+1;
			end loop;

            return std_logic_vector(to_unsigned(y, width));

        end fibo;

    begin

        clkEn <= '1';
        rst   <= '1';
        go    <= '0';
        n     <= std_logic_vector(to_unsigned(0, width));
        wait for 200 ns;

        rst <= '0';
        for i in 0 to 5 loop
            wait until rising_edge(clk);
        end loop;

        for i in 1 to 2**width-1 loop

            go <= '1';
            n  <= std_logic_vector(to_unsigned(i, width));
            wait until done = '1' for TIMEOUT;
            assert(done = '1') report "Done never asserted." severity failure;
            assert(result = fibo(i)) report "Incorrect fibonacci result" severity failure;
            go <= '0';
            wait until rising_edge(clk);

        end loop;

        clkEn <= '0';
        report "DONE!!!!!!" severity note;

        wait;

    end process;

end tb;