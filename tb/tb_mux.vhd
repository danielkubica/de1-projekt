library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_mux is
end tb_mux;

architecture bench of tb_mux is

    -- Component Declaration
    component mux
        port (
            mode            : in std_logic_vector(2 downto 0);
            breathing_led   : in std_logic; 
            progress_bar    : in std_logic_vector(15 downto 0);
            pyramid         : in std_logic_vector(15 downto 0);
            stars           : in std_logic_vector(15 downto 0);
            mux_output      : out std_logic_vector(15 downto 0)
        );
    end component;

    -- Local Signals
    signal mode          : std_logic_vector(2 downto 0) := (others => '0');
    signal breathing_led : std_logic := '0';
    signal progress_bar  : std_logic_vector(15 downto 0) := (others => '0');
    signal mux_output    : std_logic_vector(15 downto 0);

begin

    -- Instantiate the Device Under Test (DUT)
    dut : mux
        port map (
            mode          => mode,
            breathing_led => breathing_led,
            progress_bar  => progress_bar,
            pyramid       => (others => '0'),
            stars         => (others => '0'),
            mux_output    => mux_output
        );

    -- Stimulus Process
    stim_proc: process
    begin
        -- Wait for simulator to settle
        wait for 10 ns;

        -----------------------------------------------------------
        -- Test Case 1: Mode "000" (Breathing LED)
        -----------------------------------------------------------
        mode <= "000";
        breathing_led <= '1';
        wait for 10 ns;
        -- Now toggle it while in the same mode
        breathing_led <= '0';
        wait for 10 ns;
        breathing_led <= '1';
        wait for 10 ns;

        -----------------------------------------------------------
        -- Test Case 2: Mode "001" (Progress Bar)
        -----------------------------------------------------------
        mode <= "001";
        progress_bar <= x"AAAA";
        wait for 10 ns;
        progress_bar <= x"5555";
        wait for 10 ns;

        -----------------------------------------------------------
        -- Test Case 3: Mode "111" (Others / Default)
        -----------------------------------------------------------
        mode <= "111";
        breathing_led <= '0';
        wait for 10 ns;
        breathing_led <= '1';
        wait for 10 ns;

        -- End of simulation
        report "Simulation Finished Successfully!";
        wait;
    end process;

end architecture;