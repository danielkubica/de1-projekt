-- Modul generujuci konstantny PWM signal podla intenzity zadanej v duty (0 - 255 bitov)

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity constant_pwm is
    port (
        clk             : in    std_logic;
        rst             : in    std_logic;
        inhale_time     : in    unsigned(2 downto 0);
        duty            : in    std_logic_vector(7 downto 0);
        pwm_signal      : out   std_logic
    );
end entity constant_pwm;

architecture rtl of constant_pwm is

    signal counter : unsigned(7 downto 0) := (others => '0');

begin
    pwm_proc : process(clk)
    begin
        if rising_edge(clk) then
            if inhale_time = b"000" or rst = '1' then
                counter    <= (others => '0');
                pwm_signal <= '0';
            else
                counter <= counter + 1;

                if counter < unsigned(duty) then
                    pwm_signal <= '1';
                else
                    pwm_signal <= '0';
                end if;
            end if;
        end if;
    end process pwm_proc;

end architecture rtl;