library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity breathing_led_top is
    Port ( 
        clk : in  STD_LOGIC;
        onoff_switch  : in std_logic;
        my_led : out STD_LOGIC
    );
end breathing_led_top;

architecture Behavioral of breathing_led_top is
    
    component pwm_counter
        port (
            clk : in  std_logic;
--            rst : in std_logic;
            sw: in std_logic;
            pwm_signal : out std_logic
        );
    end component;
        
begin

    PWM1 : pwm_counter
        port map (
            clk => clk,
            sw  => onoff_switch,
            pwm_signal => my_led
        );

end Behavioral;