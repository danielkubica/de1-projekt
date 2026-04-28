-- Institution:     Brno University of Technology FEEC
-- Author(s):       Daniel Kubica, Adam Koutny
-- 
-- Last Modified:   2026-04-27
-- Entity Name:     config
-- Project:         PWM Breathing LED
-- Target Devices:  Nexys A7 50T
-- Project Page:    https://github.com/danielkubica/de1-projekt
--
-- License:                 MIT
-- SPDX-License-Identifier: MIT
-- Copyright (c) 2026 Daniel Kubica, Adam Koutny
--
-- Description: 
--      Global configuration file for some entities.
--      Needs to be modified for simulation/implementation.
--
-- Dependencies: 
--      ieee.std_logic_1164.all
--      ieee.numeric_std.all

library ieee;
use ieee.std_logic_1164.all;

package config is

    -- Uncomment for simulation via testbenches:
    -----------------------------------------------------------
    constant CLK_FREQ_HZ        : integer := 10_000;
    constant REFRESH_PERIOD_HZ  : integer := 100;

    -- Uncomment for implementation on Nexys A7 50T FPGA board:
    -----------------------------------------------------------
    -- constant CLK_FREQ_HZ        : integer := 100_000_000;
    -- constant REFRESH_PERIOD_HZ  : integer := 1_000_000;

end package config;