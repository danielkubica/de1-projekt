library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_pyramid is
end entity tb_pyramid;

architecture testbench of tb_pyramid is
    signal clk          : std_logic := '0';
    signal rst          : std_logic := '0';
    signal led_bus      : std_logic_vector(15 downto 0);
    
    -- Individual signals for GTKWave
    signal led0, led1, led2, led3, led4, led5, led6, led7, led8   : std_logic;
    signal led9, led10, led11, led12, led13, led14, led15         : std_logic; 

    -- Changed to unsigned to match the entity (assuming 16-bit)
    signal inhale_val   : unsigned(2 downto 0) := "001"; 
    signal run_sim      : boolean := true;
begin

    clk <= not clk after 5 ns when run_sim else '0';

    -- Break out the bus into individual signals
    led0  <= led_bus(0);
    led1  <= led_bus(1);
    led2  <= led_bus(2);
    led3  <= led_bus(3);
    led4  <= led_bus(4);
    led5  <= led_bus(5);
    led6  <= led_bus(6);
    led7  <= led_bus(7);
    led8  <= led_bus(8);
    led9  <= led_bus(9);
    led10  <= led_bus(10);
    led11  <= led_bus(11);
    led12  <= led_bus(12);
    led13  <= led_bus(13);
    led14  <= led_bus(14);
    led15 <= led_bus(15);

    uut: entity work.pyramid
        port map (
            clk          => clk,
            inhale_time  => inhale_val,
            led          => led_bus
        );

    p_stim : process
    begin
        inhale_val <= b"000";
        wait for 2 ns;
        inhale_val <= b"001";
        
        -- Wait long enough to see at least a few LEDs turn on
        wait for 1 ms; 
        run_sim <= false;
        wait;
    end process;

end architecture testbench;