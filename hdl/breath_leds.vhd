-- Modul generujuci "nadych/vydych" pomocou viacerych LEDiek, ktore vyzeraju ako 
-- "progress bar", rastuc a klesajuc. Cas nadychu definovany inhale_time

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity breath_leds is
    port (
        clk          : in  std_logic;
        rst          : in  std_logic;
        inhale_time  : in  unsigned(2 downto 0);
        led          : out std_logic_vector(15 downto 0)
    );
end entity breath_leds;

architecture rtl of breath_leds is

    component constant_pwm is
        port (
            clk        : in  std_logic;
            rst        : in  std_logic;
            duty       : in  std_logic_vector(7 downto 0);
            pwm_signal : out std_logic
        );
    end component;

    constant CLK_FREQ       : integer := 100_000;
    -- Note: Since inhale_time is a port, you might want to multiply this 
    -- by inhale_time later, but for now we use the 1 second base.
    constant CYCLES_PER_LED : integer := CLK_FREQ / 16;
    
    type duty_array is array (0 to 15) of std_logic_vector(7 downto 0);
    
    signal count      : integer := 0;
    -- FIX 1: Declare pwm_resets
    signal pwm_resets : std_logic_vector(15 downto 0) := (others => '1');

    -- FIX 2: Only one declaration of duties. 
    -- We make it a constant since the values don't change in this version.
    constant duties : duty_array := (
        0  => x"10", 1  => x"20", 2  => x"30", 3  => x"40",
        4  => x"50", 5  => x"60", 6  => x"70", 7  => x"80",
        8  => x"90", 9  => x"A0", 10 => x"B0", 11 => x"C0",
        12 => x"D0", 13 => x"E0", 14 => x"F0", 15 => x"FF"
    );

    signal inhale : boolean := true;

begin

    gen_pwm: for i in 0 to 15 generate
        pwm_inst : constant_pwm
            port map (
                clk        => clk,
                -- FIX 3: Connect to the internal reset vector, not the global rst
                rst        => pwm_resets(i), 
                duty       => duties(i),
                pwm_signal => led(i)
            );
    end generate gen_pwm;

    process(clk, rst)
    begin
        if rst = '1' then
            count <= 0;
            pwm_resets <= (others => '1'); 
        elsif rising_edge(clk) then
            
            -- Increment the main timer
            if count < CLK_FREQ then
                count <= count + 1;
            else
                count <= 0;
                inhale <= not inhale; 
            end if;

            -- Logic to release resets one by one
            for i in 0 to 15 loop
                if inhale then
                    if count >= (i * CYCLES_PER_LED) then
                        pwm_resets(i) <= '0'; -- Turn PWM ON
                    else
                        pwm_resets(i) <= '1'; -- Keep PWM OFF
                    end if;
                else 
                    if count >= ((15 - i) * CYCLES_PER_LED) then
                        pwm_resets(i) <= '1'; -- PWM OFF
                    else
                        pwm_resets(i) <= '0'; -- PWM ON
                    end if;
                end if;
            end loop;

        end if;
    end process;

end architecture rtl;