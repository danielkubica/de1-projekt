library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_breathing_pwm is
end entity tb_breathing_pwm;

architecture testbench of tb_breathing_pwm is
    signal clk   : std_logic := '0';
    signal inhale_time : unsigned(2 downto 0);
    signal pwm_signal : std_logic := '0';
    -- signal rst : std_logic := '0';

    signal run_sim : boolean := true;
begin

    -- Clock generation: 100MHz (10ns period)
    clk <= not clk after 5 ns when run_sim else '0';

    -- Instantiate the Unit Under Test (UUT)
    uut: entity work.breathing_pwm
        port map (
            clk             => clk,
            inhale_time     => inhale_time,
            pwm_signal      => pwm_signal
        );

    -- Stimulus process
    p_stim : process
    begin
        inhale_time <= b"000";
        wait for 1000 ns;

        inhale_time <= b"001"; 
        wait for 100_000 ns;

        run_sim <= false;
        wait;
        -- assert false report "End of Simulation" severity failure;
    end process;

end architecture testbench;