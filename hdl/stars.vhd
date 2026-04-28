-- Institution:     Brno University of Technology FEEC
-- Author(s):       Daniel Kubica, Adam Koutny
-- 
-- Last Modified:   2026-04-27
-- Entity Name:     stars
-- Project:         PWM Breathing LED
-- Target Devices:  Nexys A7 50T
-- Project Page:    https://github.com/danielkubica/de1-projekt
--
-- License:                 MIT
-- SPDX-License-Identifier: MIT
-- Copyright (c) 2026 Daniel Kubica, Adam Koutny
--
-- Description: 
--      Enity generating "stars" effect, or slowly breathing LEDs with different time offsets.
--
-- Dependencies: 
--      ieee.std_logic_1164.all
--      ieee.numeric_std.all

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity stars is
    port (
        clk                     : in  std_logic;
        led                     : out std_logic_vector(15 downto 0)
    );
end entity stars;

architecture rtl of stars is
    -- Create an array type to hold the speeds for 16 stars
    type speed_array is array (0 to 15) of unsigned(2 downto 0);
    signal star_speeds : speed_array := (others => "001");
    signal random_reg : std_logic_vector(15 downto 0) := x"D721"; -- Seed pre generator randomnosti, ak chceme iny pattern, treba modifikovat

    signal initialized : boolean := false;
    signal init_counter : integer range 0 to 16 := 0;                
begin

    -- 1. The Generate Loop now uses STATIC connections to the array
    gen_stars: for i in 0 to 15 generate
        star_inst : entity work.breathing_pwm
            port map (
                clk         => clk,
                inhale_time => star_speeds(i), -- This is now a static connection to a signal
                pwm_signal  => led(i)
            );
    end generate;

    -- 2. The Process handles the "dynamic" part
    process(clk)
    begin
        if rising_edge(clk) then
            if not initialized then
                -- 1. Shift the LFSR to get new entropy
                random_reg <= random_reg(14 downto 0) & (random_reg(15) xor random_reg(14) xor random_reg(12) xor random_reg(3));
                
                -- 2. Use the current LFSR state to set ONE star's speed
                star_speeds(init_counter) <= unsigned(random_reg(2 downto 0));
                
                -- 3. Move to the next star
                if init_counter < 15 then
                    init_counter <= init_counter + 1;
                else
                    initialized <= true; -- Lock the values forever
                end if;
            end if;
        end if;
    end process;

end architecture rtl;