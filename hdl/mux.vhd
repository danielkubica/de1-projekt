library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux is
    port (
        mode                : in std_logic_vector(2 downto 0);
        breathing_led       : in std_logic; 
        progress_bar        : in std_logic_vector(15 downto 0);
        pyramid             : in std_logic_vector(15 downto 0);
        stars               : in std_logic_vector(15 downto 0);
        mux_output          : out std_logic_vector(15 downto 0)
    );
end entity mux;

architecture rtl of mux is
begin 

    p_mux : process(mode, breathing_led, progress_bar) is
    begin
        case mode is
            when b"000" =>
                mux_output <= (others => breathing_led);
            when b"001" =>
                mux_output <= progress_bar;
            when b"010" =>
                mux_output <= pyramid;
            when b"011" =>
                mux_output <= stars;
            -- when b"100" =>
            -- when b"101" =>
            -- when b"110" =>
            -- when b"111" =>

            when others =>
                mux_output <= b"0000_0000_0000_000" & breathing_led;
        end case;
    end process p_mux;

end architecture rtl;