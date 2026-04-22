library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pyramid is
    port (
        clk          : in  std_logic;
        inhale_time  : in  unsigned(2 downto 0);
        led          : out std_logic_vector(15 downto 0)
    );
end entity pyramid;

architecture behavioral of pyramid is

    component constant_pwm is
        port (
            clk         : in    std_logic;
            rst         : in    std_logic; 
            inhale_time : in    unsigned(2 downto 0);
            duty        : in    std_logic_vector(7 downto 0);
            pwm_signal  : out   std_logic
        );
    end component;

    constant CLK_FREQ       : integer := 10_000;

    type duty_array is array (0 to 7) of std_logic_vector(7 downto 0);

    signal leds_left        : std_logic_vector(7 downto 0); 
    signal leds_right       : std_logic_vector(7 downto 0); 

    signal cycles_per_led   : integer := 0;
    signal count            : integer := 0;

    -- FIX 1: Declare pwm_resets
    signal pwm_resets       : std_logic_vector(7 downto 0) := (others => '1');

    constant duties : duty_array := (
        0  => x"20", 1  => x"40", 2  => x"60", 3  => x"80",
        4  => x"A0", 5  => x"C0", 6  => x"E0", 7  => x"FF"
    );

    signal inhale : boolean := true;

begin

    led(15 downto 8) <= leds_left;
    led(7 downto 0)  <= leds_right;

    cycles_per_led <= to_integer(inhale_time) * (CLK_FREQ / 8);

    gen_pwm1: for i in 0 to 7 generate
        pwm_inst : constant_pwm
            port map (
                clk             => clk,
                -- FIX 3: Connect to the internal reset vector, not the global rst
                rst             => pwm_resets(i),
                inhale_time     => inhale_time, 
                duty            => duties(i),
                pwm_signal      => leds_left(7 - i)
            );
    end generate gen_pwm1;

    gen_pwm2: for i in 0 to 7 generate
        pwm_inst : constant_pwm
            port map (
                clk             => clk,
                -- FIX 3: Connect to the internal reset vector, not the global rst
                rst             => pwm_resets(i),
                inhale_time     => inhale_time, 
                duty            => duties(i),
                pwm_signal      => leds_right(i)
            );
    end generate gen_pwm2;

    process(clk)
    begin
        if rising_edge(clk) then
            if inhale_time = 0 then
                count <= 0;
                pwm_resets <= (others => '1');
                inhale <= true;
            else
                -- Timer Logic
                if count < (CLK_FREQ * to_integer(inhale_time)) then
                    count <= count + 1;
                else
                    count <= 0;
                    inhale <= not inhale;
                end if;

                -- LED Reset Logic
                for i in 0 to 7 loop
                    if inhale then
                        -- Turning ON one by one
                        if count >= (i * cycles_per_led) then
                            pwm_resets(i) <= '0';
                        end if;
                    else
                        -- Turning OFF one by one (Reverse order)
                        if count >= (i * cycles_per_led) then
                            pwm_resets(7 - i) <= '1';
                        end if;
                    end if;
                end loop;
            end if;
        end if;
    end process;

end architecture;

