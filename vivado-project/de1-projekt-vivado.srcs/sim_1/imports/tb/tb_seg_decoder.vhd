library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_seg_decoder is
end tb_seg_decoder;

architecture tb of tb_seg_decoder is

    component seg_decoder
        port (bin : in std_logic_vector (2 downto 0);
              seg : out std_logic_vector (6 downto 0));
    end component;

    signal bin : std_logic_vector (2 downto 0);
    signal seg : std_logic_vector (6 downto 0);

begin

    dut : seg_decoder
    port map (bin => bin,
              seg => seg);

    p_stimulus : process is
    begin
        -- Loop through all hexadecimal values (0 to 15)
        for i in 0 to 7 loop

            -- Convert integer i to 4-bit std_logic_vector
            bin <= std_logic_vector(to_unsigned(i, 3));
            wait for 10 ns;

        end loop;
        wait;
    end process p_stimulus; 

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_seg_decoder of tb_seg_decoder is
    for tb
    end for;
end cfg_tb_seg_decoder;