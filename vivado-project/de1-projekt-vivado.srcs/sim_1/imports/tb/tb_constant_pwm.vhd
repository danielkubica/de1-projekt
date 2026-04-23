library ieee;
use ieee.std_logic_1164.all;

entity tb_constant_pwm is
end entity tb_constant_pwm;

architecture testbench of tb_constant_pwm is
    signal clk   : std_logic := '0';
    signal pwm_signal : std_logic := '0';
    signal rst : std_logic := '0';
    signal duty : std_logic_vector(7 downto 0) := x"00";

    signal run_sim : boolean := true;
begin

    -- Clock generation: 100MHz (10ns period)
    clk <= not clk after 5 ns when run_sim else '0';

    -- Instantiate the Unit Under Test (UUT)
    uut: entity work.constant_pwm
        port map (
            clk             => clk,
            rst             => rst,
            inhale_time     => "001", 
            duty            => duty,
            pwm_signal      => pwm_signal
        );

    -- Stimulus process
    p_stim : process
    begin
        rst <= '1';
        wait for 20 ns;
        rst <= '0';
        
        duty <= x"40";
        wait for 100_000 ns;

        duty <= x"80";
        wait for 100_000 ns;

        run_sim <= false;
        wait;
        -- assert false report "End of Simulation" severity failure;
    end process;

end architecture testbench;