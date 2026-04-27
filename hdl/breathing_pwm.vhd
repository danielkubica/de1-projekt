-- School:  Brno University of Technology FEEC
-- Author(s):  Daniel Kubica, Adam Koutny
-- 
-- Last Modified:   2026-04-27
-- Entity Name:     breathing_pwm 
-- Project:         PWM Breathing LED
-- Target Devices:  Nexys A7 50T
-- Project Page:    https://github.com/danielkubica/de1-projekt
--
-- License:                 MIT
-- SPDX-License-Identifier: MIT
-- Copyright (c) 2026 Daniel Kubica
--
-- Description: 
--      Entity generating a changing PWM signal, going through different levels of
--      brightness if hooked up to an LED.
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

entity breathing_pwm is
    port (
        clk          : in  std_logic;
        inhale_time  : in  unsigned(2 downto 0); 
        pwm_signal   : out std_logic := '0'
    );
end entity breathing_pwm;

architecture rtl of breathing_pwm is
    constant CLOCK_FREQ         : integer := CLK_FREQ_HZ; 
    constant PWM_RESOLUTION     : integer := 100; -- Can be modified for more/less brightness levels

    -- PWM signals
    signal pwm_cnt              : integer range 0 to PWM_RESOLUTION - 1 := 0;
    
    -- Breathing signals
    signal breath_tick_cnt      : integer := 0;
    signal current_duty         : integer range 0 to PWM_RESOLUTION := 0;
    signal inhale               : std_logic := '1';

begin

    -- 1. FAST PWM GENERATOR
    -- This runs at CLOCK_FREQ / 100. 
    -- With 10kHz clock, PWM freq = 100Hz (perfectly smooth).
    p_pwm : process(clk)
    begin
        if rising_edge(clk) then
            -- Counter always loops 0-99
            if pwm_cnt < PWM_RESOLUTION - 1 then
                pwm_cnt <= pwm_cnt + 1;
            else
                pwm_cnt <= 0;
            end if;

            -- PWM Output logic
            if pwm_cnt < current_duty then
                pwm_signal <= '1';
            else
                pwm_signal <= '0';
            end if;
        end if;
    end process p_pwm;

    -- 2. SLOW DUTY CYCLE UPDATER
    p_breath : process(clk)
        variable v_total_cycles_per_half_breath : integer;
        variable v_cycles_per_step              : integer;
    begin
        if rising_edge(clk) then
            if inhale_time = "000" then
                current_duty <= 0;
                breath_tick_cnt <= 0;
            else
                -- Math to figure out how many clock cycles to wait before changing 1% of duty
                v_total_cycles_per_half_breath := to_integer(inhale_time) * CLOCK_FREQ;
                v_cycles_per_step              := v_total_cycles_per_half_breath / PWM_RESOLUTION;

                if breath_tick_cnt < v_cycles_per_step then
                    breath_tick_cnt <= breath_tick_cnt + 1;
                else
                    breath_tick_cnt <= 0;
                    
                    -- Change the brightness level
                    if inhale = '1' then
                        if current_duty >= PWM_RESOLUTION then
                            inhale <= '0';
                        else
                            current_duty <= current_duty + 1;
                        end if;
                    else
                        if current_duty <= 0 then
                            inhale <= '1';
                        else
                            current_duty <= current_duty - 1;
                        end if;
                    end if;
                end if;
            end if;
        end if;
    end process p_breath;

end architecture rtl;