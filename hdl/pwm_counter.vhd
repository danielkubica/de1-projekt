library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pwm_counter is
    port (
        clk : in  std_logic;
        rst : in std_logic;
        pwm_signal : out std_logic
    );
end entity pwm_counter;

architecture behavioral of pwm_counter is
    constant CLOCK_FREQ             : integer := 1000; -- Frekvencia hodin v nasom FPGAcku (Treba neskor zmenit na 100_000_000)
    constant INHALE_TIME            : integer := 1; -- Doba "nadychu"    
    constant TOTAL_LIGHT_LEVELS     : integer := 64; -- Pocet roznych levelov jasu
    constant CYCLES                 : integer := INHALE_TIME * CLOCK_FREQ; -- Poces cyklov v jednom "nadychu"  
    constant LIGHT_LEVEL_PERIOD     : integer := CYCLES / TOTAL_LIGHT_LEVELS; -- Kolko cyklov vychadza na jeden level jasu 


    signal current_light_level      : integer := 1;
    signal duty_period              : integer := 0;
    signal duty_count               : integer := 0; 
    signal count                    : integer := 0;
    signal inhale                   : boolean := true;
    signal first_run                : boolean := true;
begin

    p_count : process(clk)
    begin        

        if rising_edge(clk) then

            -- Reset/inicializacia internych signalov
            if rst = '1' then
                current_light_level     <= 1;
                duty_period             <= (current_light_level * LIGHT_LEVEL_PERIOD) / TOTAL_LIGHT_LEVELS;
                duty_count              <= 0;
                count                   <= 0;
                inhale                  <= true;
                first_run               <= true;
                pwm_signal              <= '0';
                 
            else
                
                -- if first_run then
                --     report "Initial state of variables/constants:";
                --     report "CLOCK_FREQ: " & integer'image(CLOCK_FREQ);
                --     report "INHALE_TIME: " & integer'image(INHALE_TIME);
                --     report "TOTAL_LIGHT_LEVELS: " & integer'image(TOTAL_LIGHT_LEVELS);
                --     report "CYCLES: " & integer'image(CYCLES);
                --     report "LIGHT_LEVEL_PERIOD: " & integer'image(LIGHT_LEVEL_PERIOD);

                --     report "current_light_level: " & integer'image(current_light_level);
                --     report "duty_period: " & integer'image(duty_period);
                --     report "duty_count: " & integer'image(duty_count);
                --     report "count: " & integer'image(count);

                --     first_run <= false;
                -- end if;

                if current_light_level >= TOTAL_LIGHT_LEVELS then
                    inhale <= false;
                elsif current_light_level < 1 then
                    inhale <= true;
                end if;

                if duty_count >= duty_period then
                    pwm_signal <= '0';
                else
                    pwm_signal <= '1';
                end if;

                if count = LIGHT_LEVEL_PERIOD then
                    count       <= 0;
                    duty_count  <= 0;

                    if inhale then
                        current_light_level <= current_light_level + 1;
                    else
                        current_light_level <= current_light_level - 1; 
                    end if;

                    duty_period <= (current_light_level * LIGHT_LEVEL_PERIOD) / TOTAL_LIGHT_LEVELS;
                else
                    duty_count  <= duty_count + 1;
                    count       <= count + 1;
                end if;
            end if;
        end if;
    end process p_count;

end architecture behavioral;