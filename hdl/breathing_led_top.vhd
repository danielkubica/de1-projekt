library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity breathing_led_top is
    Port ( 
        clk                 : in std_logic;                     -- Hodinovy signal z dosky, 100MHz
        sw                  : in std_logic_vector(15 downto 0); -- Vektor switchov na doske, v architekture ich mapujeme na interne signali, iba tie ktore potrebujeme
        led                 : out std_logic_vector(15 downto 0) -- Vystupna rada LEDiek
    );
end breathing_led_top;

architecture Behavioral of breathing_led_top is

    signal mode_sw              : std_logic_vector(2 downto 0) := (others => '0'); -- Switche ktore ovladaju "mod" LEDiek
    signal inhale_time_sw       : std_logic_vector(2 downto 0) := (others => '0'); -- Switche ktore ovladaju "cas nadychu" LEDiek

    signal i_breathing_led      : std_logic;        
    signal i_progress_bar       : std_logic_vector(15 downto 0);

    component breathing_pwm is
        port (
        clk                     : in  std_logic;
        inhale_time             : in unsigned(2 downto 0); 
        pwm_signal : out std_logic := '0'
        );
    end component;

    component progress_bar is
        port (
            clk          : in  std_logic;
            inhale_time  : in  unsigned(2 downto 0);
            led          : out std_logic_vector(15 downto 0)
        );
    end component;

    component mux is
        port (
            mode                : in std_logic_vector(2 downto 0);
            breathing_led       : in std_logic; 
            progress_bar        : in std_logic_vector(15 downto 0);
            -- pyramid             : in std_logic_vector(15 downto 0);
            -- stars               : in std_logic_vector(15 downto 0);
            mux_output          : out std_logic_vector(15 downto 0)
        );
    end component;

begin

    mode_sw <= sw(15 downto 13);
    inhale_time_sw <= sw(2 downto 0);

    breathing_led1 : breathing_pwm
        port map (
            clk             => clk,
            inhale_time     => unsigned(inhale_time_sw),
            pwm_signal      => i_breathing_led
        );

    progress_bar1 : progress_bar 
        port map (
            clk             => clk,
            inhale_time     => unsigned(inhale_time_sw),
            led             => i_progress_bar
        );

    mux1 : mux
        port map (
            mode            => mode_sw,
            breathing_led   => i_breathing_led,
            progress_bar    => i_progress_bar,
            mux_output      => led
        );
     
end Behavioral;