library ieee;
use ieee.std_logic_1164.all;

entity counter_tb is
end entity counter_tb;

architecture testbench of counter_tb is
    signal clk   : std_logic := '0';
    signal pwm_signal : std_logic := '0';
    signal rst : std_logic := '1';
begin

    -- Clock generation: 100MHz (10ns period)
    clk <= not clk after 5 ns;

    -- Instantiate the Unit Under Test (UUT)
    uut: entity work.pwm_counter
        port map (
            clk   => clk,
            pwm_signal => pwm_signal,
            rst => rst
        );

    -- Stimulus process
    p_stim : process
    begin
        rst <= '1';
        wait for 20 ns;
        rst <= '0';
        
        wait for 100_000 ns;
        assert false report "End of Simulation" severity failure;
    end process;

end architecture testbench;