library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Multiplicacion sin signo de 4 x 4 bits; producto completo de 8 bits.
entity multiplicador is
    port (
        a, b : in std_logic_vector(3 downto 0);
        producto : out std_logic_vector(7 downto 0)
    );
end entity;

architecture rtl of multiplicador is
begin
    producto <= std_logic_vector(unsigned(a) * unsigned(b));
end architecture;
