library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Division entera sin signo, combinacional.
-- Si b = 0: cociente = 0, residuo = a y division_por_cero = '1'.
entity divisor is
    port (
        a, b : in std_logic_vector(3 downto 0);
        cociente, residuo : out std_logic_vector(3 downto 0);
        division_por_cero : out std_logic
    );
end entity;

architecture rtl of divisor is
begin
    process(all)
    begin
        if unsigned(b) = 0 then
            cociente <= (others => '0');
            residuo <= a;
            division_por_cero <= '1';
        else
            cociente <= std_logic_vector(unsigned(a) / unsigned(b));
            residuo <= std_logic_vector(unsigned(a) mod unsigned(b));
            division_por_cero <= '0';
        end if;
    end process;
end architecture;
