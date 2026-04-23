-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Fri, 17 Apr 2026 13:54:19 GMT
-- Request id : cfwk-fed377c2-69e23b8be4c62

library ieee;
use ieee.std_logic_1164.all;

entity tb_stars is
end tb_stars;

architecture tb of tb_stars is

    component stars
        port (clk : in std_logic;
              led : out std_logic_vector (15 downto 0));
    end component;

    signal clk : std_logic;
    signal led : std_logic_vector (15 downto 0);

    constant TbPeriod : time := 5 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

    signal led0, led1, led2, led3, led4, led5, led6, led7, led8   : std_logic;
    signal led9, led10, led11, led12, led13, led14, led15         : std_logic; 

begin

    dut : stars
    port map (clk => clk,
              led => led);

    -- Break out the bus into individual signals
    led0  <= led(0);
    led1  <= led(1);
    led2  <= led(2);
    led3  <= led(3);
    led4  <= led(4);
    led5  <= led(5);
    led6  <= led(6);
    led7  <= led(7);
    led8  <= led(8);
    led9  <= led(9);
    led10  <= led(10);
    led11  <= led(11);
    led12  <= led(12);
    led13  <= led(13);
    led14  <= led(14);
    led15 <= led(15);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- ***EDIT*** Adapt initialization as needed

        -- ***EDIT*** Add stimuli here
        wait for 50_000 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_stars of tb_stars is
    for tb
    end for;
end cfg_tb_stars;