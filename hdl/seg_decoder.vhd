-- School:  Brno University of Technology FEEC
-- Author(s):  Daniel Kubica, Adam Koutny
-- 
-- Last Modified:   2026-04-27
-- Entity Name:     progress_bar
-- Project:         PWM Breathing LED
-- Target Devices:  Nexys A7 50T
-- Project Page:    https://github.com/danielkubica/de1-projekt
--
-- License:                 MIT
-- SPDX-License-Identifier: MIT
-- Copyright (c) 2026 Daniel Kubica
--
-- Description: 
--      Simple 3-bit number to 7-segment display decoder.
--
-- Dependencies: 
--      ieee.std_logic_1164.all
--      ieee.numeric_std.all

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity seg_decoder is
    port (
        bin     : in std_logic_vector(2 downto 0);
        seg     : out std_logic_vector(6 downto 0)
    );
end entity seg_decoder; 

architecture rtl of seg_decoder is

begin

    p_7seg_decoder : process (bin) is
    begin
        case bin is
            when b"001" =>
                seg <= b"100_1111";
            when b"010" =>
                seg <= b"001_0010";
            when b"011" =>
                seg <= b"000_0110";
            when b"100" =>
                seg <= b"100_1100";
            when b"101" =>
                seg <= b"010_0100";
            when b"110" =>
                seg <= b"010_0000";
            when b"111" =>
                seg <= b"000_1111";

            -- Default case (e.g., for undefined values)
            when others =>
                seg <= b"000_0001";  -- All segments off
        end case;
    end process p_7seg_decoder;

end architecture rtl;