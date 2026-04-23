-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Fri, 17 Apr 2026 11:26:22 GMT
-- Request id : cfwk-fed377c2-69e218dea5de9

library ieee;
use ieee.std_logic_1164.all;

entity tb_breathing_led_top is
end tb_breathing_led_top;

architecture tb of tb_breathing_led_top is

    component breathing_led_top
        port (
            clk : in std_logic;
            sw  : in std_logic_vector (15 downto 0);
            led : out std_logic_vector (15 downto 0);
            seg : out std_logic_vector (6 downto 0);
            an  : out std_logic_vector (7 downto 0)
        );
    end component;

    signal clk : std_logic := '0';
    signal sw  : std_logic_vector (15 downto 0) := (others => '0');
    signal led : std_logic_vector (15 downto 0) := (others => '0');
    signal seg : std_logic_vector(6 downto 0) := (others => '0');
    signal an  : std_logic_vector(7 downto 0) := (others => '0');

    constant TbPeriod : time := 5 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';
    
    signal led0, led1, led2, led3, led4, led5, led6, led7, led8   : std_logic;
    signal led9, led10, led11, led12, led13, led14, led15         : std_logic; 

begin

    dut : breathing_led_top
    port map (clk => clk,
              sw  => sw,
              led => led,
              seg => seg,
              an  => an);

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
        sw <= (others => '0');        -- Reset switchov, vsetko na nule
        wait for 10_000 * TbPeriod;

        sw <= b"0000_0000_0000_0001"; -- 0. mod "Dychajuca LEDka" 1s nadych
        wait for 50_000 * TbPeriod;

        sw <= b"0000_0000_0000_0010"; -- 0. mod "Dychajuca LEDka" 2s nadych
        wait for 50_000 * TbPeriod;

        sw <= b"0010_0000_0000_0001"; -- 1. mod "Progress bar" 1s nadych
        wait for 50_000 * TbPeriod;

        sw <= b"0010_0000_0000_0010"; -- 1. mod "Progress bar" 2s nadych
        wait for 50_000 * TbPeriod;

        sw <= b"0100_0000_0000_0001"; -- 2. mod "Pyramida" 1s nadych
        wait for 50_000 * TbPeriod;

        sw <= b"0100_0000_0000_0010"; -- 2. mod "Pyramida" 2s nadych
        wait for 50_000 * TbPeriod;

        sw <= b"0110_0000_0000_0001"; -- 3. mod "Hviezdy"
        wait for 50_000 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_breathing_led_top of tb_breathing_led_top is
    for tb
    end for;
end cfg_tb_breathing_led_top;