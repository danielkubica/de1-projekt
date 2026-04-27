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
--      Entity generating "progress bar" breathing effect on it's "led" output
--      with modifiable 2-bit (max 7 seconds) "inhale_time" input. Uses a bus of 16 LEDs.
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

entity progress_bar is
    port (
        clk          : in  std_logic;
        inhale_time  : in  unsigned(2 downto 0);
        led          : out std_logic_vector(15 downto 0)
    );
end entity progress_bar;

architecture rtl of progress_bar is

    component constant_pwm is
        port (
            clk         : in    std_logic;
            rst         : in    std_logic; 
            inhale_time : in    unsigned(2 downto 0);
            duty        : in    std_logic_vector(7 downto 0);
            pwm_signal  : out   std_logic
        );
    end component;

    constant CLK_FREQ       : integer := CLK_FREQ_HZ;
    -- Note: Since inhale_time is a port, you might want to multiply this 
    -- by inhale_time later, but for now we use the 1 second base.
    -- constant CYCLES_PER_LED : integer := CLK_FREQ / 16;
    
    type duty_array is array (0 to 15) of std_logic_vector(7 downto 0);

    signal cycles_per_led   : integer := 0;
    signal count      : integer := 0;
    -- FIX 1: Declare pwm_resets
    signal pwm_resets : std_logic_vector(15 downto 0) := (others => '1');

    -- FIX 2: Only one declaration of duties. 
    -- We make it a constant since the values don't change in this version.
    constant duties : duty_array := (
        0  => x"10", 1  => x"20", 2  => x"30", 3  => x"40",
        4  => x"50", 5  => x"60", 6  => x"70", 7  => x"80",
        8  => x"90", 9  => x"A0", 10 => x"B0", 11 => x"C0",
        12 => x"D0", 13 => x"E0", 14 => x"F0", 15 => x"FF"
    );

    signal inhale : boolean := true;

begin

    cycles_per_led <= to_integer(inhale_time) * (CLK_FREQ / 16);

    gen_pwm: for i in 0 to 15 generate
        pwm_inst : constant_pwm
            port map (
                clk             => clk,
                -- FIX 3: Connect to the internal reset vector, not the global rst
                rst             => pwm_resets(i),
                inhale_time     => inhale_time, 
                duty            => duties(i),
                pwm_signal      => led(i)
            );
    end generate gen_pwm;

    process(clk)
    begin
        if rising_edge(clk) then
            if inhale_time = 0 then
                count <= 0;
                pwm_resets <= (others => '1');
                inhale <= true;
            else
                -- Timer Logic
                if count < (CLK_FREQ * to_integer(inhale_time)) then
                    count <= count + 1;
                else
                    count <= 0;
                    inhale <= not inhale;
                end if;

                -- LED Reset Logic
                for i in 0 to 15 loop
                    if inhale then
                        -- Turning ON one by one
                        if count >= (i * cycles_per_led) then
                            pwm_resets(i) <= '0';
                        end if;
                    else
                        -- Turning OFF one by one (Reverse order)
                        if count >= (i * cycles_per_led) then
                            pwm_resets(15 - i) <= '1';
                        end if;
                    end if;
                end loop;
            end if;
        end if;
    end process;

end architecture rtl;