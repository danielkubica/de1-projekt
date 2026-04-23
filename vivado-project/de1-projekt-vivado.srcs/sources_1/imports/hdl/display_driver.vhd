library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity display_driver is
    port (
        clk                 : in std_logic;
        time_display        : in std_logic_vector(6 downto 0);
        mode_display        : in std_logic_vector(6 downto 0);

        seg_out             : out std_logic_vector(6 downto 0);
        anode_out           : out std_logic_vector(7 downto 0)
    );
end entity display_driver; 

architecture behavioral of display_driver is

    constant CLOCK_FREQ     : integer := 100_000_000; -- Zmenit na 100_000_000 pri nahravani do dosky
    constant REFRESH_PERIOD : integer := 1_000_000; -- Zmenit na 1_000_000 pri 100MHz frekvencii, ak cheme 10ms periodu (1ms je 100_000 cyklov pri 100MHz)

    signal count            : integer := 0;
    signal display_state    : boolean := false; -- Ak je false zobrazime time_display, ak je true zobrazime mode_display (bude oscilovat kazdu refresh periodu)

begin

    process(clk, time_display, mode_display)
    begin
        if rising_edge(clk) then
            if count > REFRESH_PERIOD then
                count <= 0;
                display_state <= not display_state;
            else
                count <= count + 1;
                if display_state then
                    seg_out     <= mode_display;
                    anode_out   <= b"0111_1111";
                else
                    seg_out     <= time_display;
                    anode_out   <= b"1111_1110";
                end if;
            end if;
        end if;
    end process;
end architecture;