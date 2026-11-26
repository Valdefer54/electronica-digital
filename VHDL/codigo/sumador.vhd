library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Suma sin signo: acarreo & suma representa el resultado de 5 bits.
entity sumador is
    port (
        a, b : in std_logic_vector(3 downto 0);
        suma : out std_logic_vector(3 downto 0);
        acarreo : out std_logic
    );
end entity;

architecture rtl of sumador is
    signal resultado : unsigned(4 downto 0);
begin
    resultado <= resize(unsigned(a), 5) + resize(unsigned(b), 5);
    suma <= std_logic_vector(resultado(3 downto 0));
    acarreo <= resultado(4);
end architecture;
