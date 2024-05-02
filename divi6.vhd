library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity divi6 is
    port(
        clk: in std_logic;
        A, B: in std_logic_vector(15 downto 0);
        result: out std_logic_vector(15 downto 0)
    );
end entity;

architecture a_divi6 of divi6 is
    component SumRest16Bits is
        Port (
            A : in std_logic_vector(15 downto 0);
            B : in std_logic_vector(15 downto 0);
            Cin : in std_logic;
            Op : in std_logic;
            Res : out std_logic_vector(15 downto 0);
            Cout : out std_logic
        );
    end component;

    signal B_mod : std_logic_vector(15 downto 0);
    signal intermediate_carry : std_logic_vector(16 downto 0);
    signal Quotient : std_logic_vector(15 downto 0) := (others => '0');
    signal Remainder : std_logic_vector(15 downto 0) := (others => '0');
    signal Temp_result : std_logic_vector(15 downto 0) := (others => '0'); -- Inicializar Temp_result
    signal Count : std_logic_vector(15 downto 0) := (others => '0');
    signal unused_signal : std_logic;

begin
    -- Component instances
    Resta: SumRest16Bits port map (Remainder, B_mod, intermediate_carry(0), '1', Temp_result, unused_signal);
    Suma : SumRest16Bits port map (Count, "0000000000000001", '0', '0', Count, unused_signal); -- Utilizando Suma como contador

    -- Process for division logic
    process(clk)
    begin
        if rising_edge(clk) then
            -- Inicialización de la división
            if Remainder = "0000000000000000" then
                Remainder <= A;
            end if;

            -- Comprobación si la división ha finalizado
            if Remainder >= B then
                -- Realizar la división
                B_mod <=  B;
                intermediate_carry(0) <= '1';
                Remainder <= Temp_result;
            else
                -- No se puede dividir más, finalizar proceso
                Remainder <= Remainder;
                B_mod <= B;
                intermediate_carry(0) <= '0';
                Quotient <= Count;
            end if;
        end if;
    end process;

    -- Asignar el valor del contador como salida result
    result <= Quotient;

end architecture;