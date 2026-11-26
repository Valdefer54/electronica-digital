library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Contador ascendente de 4 bits, modulo 16.
-- Reset sincrono activo en '1', con prioridad sobre habilitar.
entity contador is
    port (
        clk, reset, habilitar : in std_logic;
        cuenta : out std_logic_vector(3 downto 0)
    );
end entity;

architecture rtl of contador is
    signal valor : unsigned(3 downto 0);
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                valor <= (others => '0');
            elsif habilitar = '1' then
                valor <= valor + 1;
            end if;
        end if;
    end process;
    cuenta <= std_logic_vector(valor);
end architecture;
