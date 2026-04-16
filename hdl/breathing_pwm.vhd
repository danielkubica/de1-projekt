-- Modul generujuci "breathing" efekt PWM signal, ktoreho dlzka zavisi od inhale_time

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity breathing_pwm is
    port (
        clk                     : in  std_logic;
        rst                     : in std_logic;
        inhale_time             : in unsigned(2 downto 0); -- 3bit, maximalny inhale_time 8 sekund     
        pwm_signal : out std_logic := '0'
    );
end entity breathing_pwm;

architecture behavioral of breathing_pwm is
    constant CLOCK_FREQ          : integer := 1000; -- treba zmenit na 100_000_000 pre FPGAcko
    constant TOTAL_LIGHT_LEVELS  : integer := 64; 

    signal cycles                : integer := 0;
    signal light_level_period    : integer := 0; -- 1_562_500 pre 64 levlov
    signal current_light_level   : unsigned(5 downto 0) := (others => '0');
    signal count                 : integer := 0;
    signal inhale                : std_logic := '1';
begin

    p_count : process(clk)
        variable v_cycles : integer;
    begin        
        if rising_edge(clk) then
            v_cycles := to_integer(inhale_time) * CLOCK_FREQ;
            cycles   <= v_cycles;
            light_level_period <= v_cycles / TOTAL_LIGHT_LEVELS;

            if rst = '1' then
                count <= 0;
                pwm_signal <= '0';
                current_light_level <= (others => '0');
            else

                -- 1. Main counter for the duration of one brightness level
                if count < light_level_period - 1 then
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
                
                -- Sled operacii v tomto riadku je podstatny! Pre simulaciu s nizsim CLOCK_FREQ najprv musime nasobit
                -- (current_light_level * LIGHT_LEVEL_PERIOD) a az potom vydelit TOTAL_LIGHT_LEVELS.
                -- inac pri napr. CLOCK_FREQ = 1000, by to davalo furt nulu a pwm_signal by bol furt nula.
                if count < ((to_integer(current_light_level) * light_level_period) / TOTAL_LIGHT_LEVELS) then
                    pwm_signal <= '1';
                else
                    pwm_signal <= '0';
                end if;    
            end if;
        end if;
    end process p_count;

end architecture;