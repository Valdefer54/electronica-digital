library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Diferencia modulo 16; prestamo = '1' cuando a < b.
entity restador is
    port (
        a, b : in std_logic_vector(3 downto 0);
        diferencia : out std_logic_vector(3 downto 0);
        prestamo : out std_logic
    );
end entity;

architecture rtl of restador is
begin
    diferencia <= std_logic_vector(unsigned(a) - unsigned(b));
    prestamo <= '1' when unsigned(a) < unsigned(b) else '0';
end architecture;
