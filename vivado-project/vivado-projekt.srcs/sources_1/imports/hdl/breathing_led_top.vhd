-- Institution:     Brno University of Technology FEEC
-- Author(s):       Daniel Kubica, Adam Koutny
-- 
-- Last Modified:   2026-04-27
-- Entity Name:     breathing_pwm 
-- Project:         PWM Breathing LED
-- Target Devices:  Nexys A7 50T
-- Project Page:    https://github.com/danielkubica/de1-projekt
--
-- License:                 MIT
-- SPDX-License-Identifier: MIT
-- Copyright (c) 2026 Daniel Kubica, Adam Koutny
--
-- Description: 
--      Top level entity for the project PWM Breathing LED. Synthesizeable on Nexys A7 50T FPGA board.
--      User inputs via the bottom row of switches two 3-bit numbers (first and last three switches).
--      One number setting the "mode" (breathing led, progress bar, pyramid, stars, or single led)
--      and the other setting the "inhale time" (speed at which the various modes operate).
--
-- Dependencies: 
--      ieee.std_logic_1164.all
--      ieee.numeric_std.all

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity breathing_led_top is
    Port ( 
        clk     : in std_logic;                      -- Clock signal from the board: 100MHz
        sw      : in std_logic_vector(15 downto 0);  -- Bus of switches on the board, in architecture we map only the ones we care about.
        led     : out std_logic_vector(15 downto 0); -- Output bus of LEDs
        seg     : out std_logic_vector(6 downto 0);  -- 7-segment display cathodes
        an      : out std_logic_vector(7 downto 0)   -- 7-seg display anodes
    );
end breathing_led_top;

architecture rtl of breathing_led_top is

    signal mode_sw              : std_logic_vector(2 downto 0) := (others => '0'); -- Switches controlling the "mode"
    signal inhale_time_sw       : std_logic_vector(2 downto 0) := (others => '0'); -- Switches controlling the "inhale time"

    signal i_breathing_led      : std_logic;        
    signal i_progress_bar       : std_logic_vector(15 downto 0);
    signal i_stars              : std_logic_vector(15 downto 0);
    signal i_pyramid            : std_logic_vector(15 downto 0);
    signal i_mode_seg_decoder   : std_logic_vector(6 downto 0);
    signal i_time_seg_decoder   : std_logic_vector(6 downto 0);

    component breathing_pwm is
        port (
        clk                     : in  std_logic;
        inhale_time             : in unsigned(2 downto 0); 
        pwm_signal              : out std_logic := '0'
        );
    end component;

    component progress_bar is
        port (
            clk                 : in  std_logic;
            inhale_time         : in  unsigned(2 downto 0);
            led                 : out std_logic_vector(15 downto 0)
        );
    end component;

    component stars is
        port (
            clk                 : in  std_logic;
            led                 : out std_logic_vector(15 downto 0)
        );
    end component;

    component pyramid is
        port (
            clk                 : in std_logic;            
            inhale_time         : in  unsigned(2 downto 0);
            led                 : out std_logic_vector(15 downto 0)
        );
    end component;

    component seg_decoder is
        port (
            bin                 : in std_logic_vector(2 downto 0);
            seg                 : out std_logic_vector(6 downto 0)
        );
    end component;

    component display_driver is
        port (
            clk                 : in std_logic;
            time_display        : in std_logic_vector(6 downto 0);
            mode_display        : in std_logic_vector(6 downto 0);

            seg_out             : out std_logic_vector(6 downto 0);
            anode_out           : out std_logic_vector(7 downto 0)
        );
    end component;

    component mux is
        port (
            mode                : in std_logic_vector(2 downto 0);
            breathing_led       : in std_logic; 
            progress_bar        : in std_logic_vector(15 downto 0);
            pyramid             : in std_logic_vector(15 downto 0);
            stars               : in std_logic_vector(15 downto 0);
            mux_output          : out std_logic_vector(15 downto 0)
        );
    end component;

begin

    mode_sw <= sw(15 downto 13);
    inhale_time_sw <= sw(2 downto 0);

    breathing_led1 : breathing_pwm
        port map (
            clk             => clk,
            inhale_time     => unsigned(inhale_time_sw),
            pwm_signal      => i_breathing_led
        );

    progress_bar1 : progress_bar 
        port map (
            clk             => clk,
            inhale_time     => unsigned(inhale_time_sw),
            led             => i_progress_bar
        );
    
    pyramid1 : pyramid
        port map (
            clk             => clk,
            inhale_time     => unsigned(inhale_time_sw),
            led             => i_pyramid
        );

    stars1 : stars
        port map (
            clk             => clk,
            led             => i_stars
        );

    mode_seg_decoder : seg_decoder
        port map (
            bin             => mode_sw,
            seg             => i_mode_seg_decoder
        );

    time_seg_decoder : seg_decoder
        port map (
            bin             => inhale_time_sw,
            seg             => i_time_seg_decoder 
        );
    
    display_driver1 : display_driver
        port map (
            clk             => clk,
            time_display    => i_time_seg_decoder, 
            mode_display    => i_mode_seg_decoder,

            seg_out         => seg, 
            anode_out       => an 
        );

    mux1 : mux
        port map (
            mode            => mode_sw,
            breathing_led   => i_breathing_led,
            progress_bar    => i_progress_bar,
            pyramid         => i_pyramid,
            stars           => i_stars,
            mux_output      => led
        );
     
end architecture rtl;