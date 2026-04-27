-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Sat, 18 Apr 2026 14:19:27 GMT
-- Request id : cfwk-fed377c2-69e392efc467a

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_display_driver is
end tb_display_driver;

architecture tb of tb_display_driver is

    component display_driver
        port (clk          : in std_logic;
              time_display : in std_logic_vector (6 downto 0);
              mode_display : in std_logic_vector (6 downto 0);
              seg_out      : out std_logic_vector (6 downto 0);
              anode_out    : out std_logic_vector (7 downto 0));
    end component;

    signal clk          : std_logic;
    signal time_display : std_logic_vector (6 downto 0);
    signal mode_display : std_logic_vector (6 downto 0);
    signal seg_out      : std_logic_vector (6 downto 0);
    signal anode_out    : std_logic_vector (7 downto 0);

    constant TbPeriod : time := 5 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : display_driver
    port map (clk          => clk,
              time_display => time_display,
              mode_display => mode_display,
              seg_out      => seg_out,
              anode_out    => anode_out);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- ***EDIT*** Adapt initialization as needed
        time_display <= b"010_0000";
        mode_display <= b"000_1111";

        -- ***EDIT*** Add stimuli here
        wait for 10_000 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_display_driver of tb_display_driver is
    for tb
    end for;
end cfg_tb_display_driver;