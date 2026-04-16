library ieee;
use ieee.std_logic_1164.all;

entity tb_breathing_pwm is
end entity tb_breathing_pwm;

architecture testbench of tb_breathing_pwm is
    signal clk   : std_logic := '0';
    signal pwm_signal : std_logic := '0';
    signal rst : std_logic := '0';

    signal run_sim : boolean := true;
begin

    -- Clock generation: 100MHz (10ns period)
    clk <= not clk after 5 ns when run_sim else '0';

    -- Instantiate the Unit Under Test (UUT)
    uut: entity work.breathing_pwm
        port map (
            clk             => clk,
            rst             => rst,
            inhale_time     => "001",
            pwm_signal      => pwm_signal
        );

    -- Stimulus process
    p_stim : process
    begin
        rst <= '1';
        wait for 20 ns;
        rst <= '0';
        
        wait for 100_000 ns;
        run_sim <= false;
        wait;
        -- assert false report "End of Simulation" severity failure;
    end process;

end architecture testbench;