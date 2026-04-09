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

-- TESTED KOD

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pwm_counter is
    port (
        clk : in  std_logic;
--        rst : in std_logic;
        sw: in std_logic ;
        pwm_signal : out std_logic
    );
end entity pwm_counter;

--architecture behavioral of pwm_counter is
--    constant CLOCK_FREQ             : integer := 100_000_000; -- Frekvencia hodin v nasom FPGAcku (Treba neskor zmenit na 100_000_000)
--    constant INHALE_TIME            : integer := 1; -- Doba "nadychu"    
--    constant TOTAL_LIGHT_LEVELS     : integer := 64; -- Pocet roznych levelov jasu
--    constant CYCLES                 : integer := INHALE_TIME * CLOCK_FREQ; -- Poces cyklov v jednom "nadychu"  
--    constant LIGHT_LEVEL_PERIOD     : integer := CYCLES / TOTAL_LIGHT_LEVELS; -- Kolko cyklov vychadza na jeden level jasu 

--    signal rst                      : boolean := true;
--    signal current_light_level      : integer := 1;
--    signal duty_period              : integer := 0;
--    signal duty_count               : integer := 0; 
--    signal count                    : integer := 0;
--    signal inhale                   : boolean := true;
--    signal first_run                : boolean := true;
--begin

--    p_count : process(clk)
--    begin        
    
--        if rising_edge(clk) then
--            if sw = '1' then
--                    -- Reset/inicializacia internych signalov
--                if rst then
--                    current_light_level     <= 1;
--                    duty_period             <= (current_light_level * LIGHT_LEVEL_PERIOD) / TOTAL_LIGHT_LEVELS;
--                    duty_count              <= 0;
--                    count                   <= 0;
--                    inhale                  <= true;
--                    first_run               <= true;
--                    pwm_signal              <= '0';
--                    rst                     <= false;
                     
--                else
                    
--                    -- if first_run then
--                    --     report "Initial state of variables/constants:";
--                    --     report "CLOCK_FREQ: " & integer'image(CLOCK_FREQ);
--                    --     report "INHALE_TIME: " & integer'image(INHALE_TIME);
--                    --     report "TOTAL_LIGHT_LEVELS: " & integer'image(TOTAL_LIGHT_LEVELS);
--                    --     report "CYCLES: " & integer'image(CYCLES);
--                    --     report "LIGHT_LEVEL_PERIOD: " & integer'image(LIGHT_LEVEL_PERIOD);
    
--                    --     report "current_light_level: " & integer'image(current_light_level);
--                    --     report "duty_period: " & integer'image(duty_period);
--                    --     report "duty_count: " & integer'image(duty_count);
--                    --     report "count: " & integer'image(count);
    
--                    --     first_run <= false;
--                    -- end if;
    
--                    if current_light_level >= TOTAL_LIGHT_LEVELS then
--                        inhale <= false;
--                    elsif current_light_level < 1 then
--                        inhale <= true;
--                    end if;
    
--                    if duty_count >= duty_period then
--                        pwm_signal <= '0';
--                    else
--                        pwm_signal <= '1';
--                    end if;
    
--                    if count = LIGHT_LEVEL_PERIOD then
--                        count       <= 0;
--                        duty_count  <= 0;
    
--                        if inhale then
--                            current_light_level <= current_light_level + 1;
--                        else
--                            current_light_level <= current_light_level - 1; 
--                        end if;
    
--                        duty_period <= (current_light_level * LIGHT_LEVEL_PERIOD) / TOTAL_LIGHT_LEVELS;
--                    else
--                        duty_count  <= duty_count + 1;
--                        count       <= count + 1;
--                    end if;
--                end if;
--            elsif sw = '0' then
--                current_light_level <= 1;
--                count               <= 0;
--                duty_count          <= 0;
--                pwm_signal          <= '0';
--                inhale              <= true;
--            end if;
--        end if;
--    end process p_count;

--end architecture behavioral;

architecture behavioral of pwm_counter is
    constant CLOCK_FREQ          : integer := 100_000_000;
    constant TOTAL_LIGHT_LEVELS  : integer := 64;     
    constant INHALE_TIME         : integer := 1;
    constant CYCLES              : integer := INHALE_TIME * CLOCK_FREQ;
    constant LIGHT_LEVEL_PERIOD  : integer := CYCLES / TOTAL_LIGHT_LEVELS; 

    signal current_light_level   : unsigned(5 downto 0) := (others => '0'); -- 0 to 63
    signal count                 : integer range 0 to LIGHT_LEVEL_PERIOD := 0;
    signal pwm_timer             : integer range 0 to LIGHT_LEVEL_PERIOD := 0;
    signal inhale                : std_logic := '1';
begin

    p_count : process(clk)
    begin        
        if rising_edge(clk) then
            if sw = '0' then
                count <= 0;
                pwm_signal <= '0';
                current_light_level <= (others => '0');
            else
                -- 1. Main counter for the duration of one brightness level
                if count < LIGHT_LEVEL_PERIOD - 1 then
                    count <= count + 1;
                else
                    count <= 0;
                    -- 2. Update brightness level
                    if inhale = '1' then
                        if current_light_level = 63 then
                            inhale <= '0';
                        else
                            current_light_level <= current_light_level + 1;
                        end if;
                    else
                        if current_light_level = 0 then
                            inhale <= '1';
                        else
                            current_light_level <= current_light_level - 1;
                        end if;
                    end if;
                end if;

                -- 3. PWM Generation
                -- Instead of doing complex math, we use current_light_level 
                -- to determine the "threshold" within the current period.
                if pwm_timer < (to_integer(current_light_level) * (LIGHT_LEVEL_PERIOD / 64)) then
                    pwm_signal <= '1';
                else
                    pwm_signal <= '0';
                end if;
                
                -- Internal PWM ramp
                if pwm_timer < LIGHT_LEVEL_PERIOD - 1 then
                    pwm_timer <= pwm_timer + 1;
                else
                    pwm_timer <= 0;
                end if;
            end if;
        end if;
    end process p_count;
end architecture;