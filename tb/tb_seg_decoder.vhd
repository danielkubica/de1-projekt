-- Institution:     Brno University of Technology FEEC
-- Author(s):       Daniel Kubica, Adam Koutny
-- 
-- Last Modified:   2026-04-28
-- Entity Name:     tb_seg_decoder
-- Project:         PWM Breathing LED
-- Target Devices:  Nexys A7 50T
-- Project Page:    https://github.com/danielkubica/de1-projekt
--
-- License:                 MIT
-- SPDX-License-Identifier: MIT
-- Copyright (c) 2026 Daniel Kubica, Adam Koutny
--
-- Description: 
--      Testbench file for the entity seg_decoder. Checks for correct decoding of
--      binary inputs into 7-segment display format.
--
-- Dependencies: 
--      ieee.std_logic_1164.all
--      ieee.numeric_std.all

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_seg_decoder is
end tb_seg_decoder;

architecture tb of tb_seg_decoder is

    component seg_decoder
        port (bin : in std_logic_vector (2 downto 0);
              seg : out std_logic_vector (6 downto 0));
    end component;

    signal bin : std_logic_vector (2 downto 0);
    signal seg : std_logic_vector (6 downto 0);

begin

    dut : seg_decoder
    port map (bin => bin,
              seg => seg);

    p_stimulus : process is
    begin
        -- Loop through all hexadecimal values (0 to 15)
        for i in 0 to 7 loop

            -- Convert integer i to 4-bit std_logic_vector
            bin <= std_logic_vector(to_unsigned(i, 3));
            wait for 10 ns;

        end loop;
        wait;
    end process p_stimulus; 

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_seg_decoder of tb_seg_decoder is
    for tb
    end for;
end cfg_tb_seg_decoder;
