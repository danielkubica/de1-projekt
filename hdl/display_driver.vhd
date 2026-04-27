-- School:  Brno University of Technology FEEC
-- Author(s):  Daniel Kubica, Adam Koutny
-- 
-- Last Modified:   2026-04-27
-- Entity Name:     display_driver
-- Project:         PWM Breathing LED
-- Target Devices:  Nexys A7 50T
-- Project Page:    https://github.com/danielkubica/de1-projekt
--
-- License:                 MIT
-- SPDX-License-Identifier: MIT
-- Copyright (c) 2026 Daniel Kubica
--
-- Description: 
--      Display driver controls the output of cathodes/anodes of the 7-segment display
--      on the Nexys A7 50T board. It's used to create the "illusion" of two different
--      numbers being displayed simultaniously on two of the eight 7-segment displays.
--
-- Dependencies: 
--      ieee.std_logic_1164.all
--      ieee.numeric_std.all
--      work.config.all

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.config.all;

entity display_driver is
    port (
        clk                 : in std_logic;
        time_display        : in std_logic_vector(6 downto 0);
        mode_display        : in std_logic_vector(6 downto 0);

        seg_out             : out std_logic_vector(6 downto 0);
        anode_out           : out std_logic_vector(7 downto 0)
    );
end entity display_driver; 

architecture rtl of display_driver is

    constant CLOCK_FREQ     : integer := CLK_FREQ_HZ;
    constant REFRESH_PERIOD : integer := REFRESH_PERIOD_HZ;

    signal count            : integer := 0;

    signal display_state    : boolean := false; -- If false -> time_display, if true -> mode_display (switching each REFRESH_PERIOD)

begin

    process(clk, time_display, mode_display)
    begin
        if rising_edge(clk) then
            if count > REFRESH_PERIOD then
                count <= 0;
                display_state   <= not display_state;
            else
                count <= count + 1;
                if display_state then
                    seg_out     <= mode_display;
                    anode_out   <= b"0111_1111";
                else
                    seg_out     <= time_display;
                    anode_out   <= b"1111_1110";
                end if;
            end if;
        end if;
    end process;

end architecture rtl;