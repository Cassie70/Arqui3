library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity divi6 is
    port(
        clk: in std_logic;
        A, B: in std_logic_vector(15 downto 0);
		iniciar : in std_logic;
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
    signal Temp_result : std_logic_vector(15 downto 0) := (others => '0');
    signal Count : std_logic_vector(15 downto 0) := (others => '0');
	signal Temp_count : std_logic_vector(15 downto 0) := (others => '0');
    signal unused_signal : std_logic;
    signal wait_for_result : std_logic := '0';  -- Señal para esperar el resultado de la resta
	
	signal espera : std_logic := '0';
	signal op : std_logic := '1';
	signal termino_proceso : std_logic :='0';
	signal suma_1 : std_logic_vector(15 downto 0) := "0000000000000001";

begin
    -- Component instances
    Resta: SumRest16Bits port map (Remainder, B_mod, '0', op, Temp_result, unused_signal);
	Suma : SumRest16Bits port map (Count, suma_1, '0', '0', Temp_count, unused_signal);

process(clk)
begin
    if rising_edge(clk) then
		if(iniciar = '0') then --todavia no comienza, todo en 0 
			Remainder <= A;
			B_mod <= "0000000000000000";
			op <= '1';
			Count <= "0000000000000000";
			termino_proceso <= '0';
			suma_1<= "0000000000000000";
		else 
		--comienza la division
			if(termino_proceso = '0') then 
				if(espera = '0')then
					Remainder <= A;
					B_mod <= B;
					Count <= "0000000000000000";
					suma_1 <= "0000000000000001";
					op <= '1';
					espera <= '1';
					
				else 
				--ya paso un ciclo y temp result tiene el valor de la primer resta						
					if(Remainder < B) then
					--termino 
					termino_proceso <= '1';
					else
					Remainder <= Temp_result;
					Count <= Temp_Count;
					end if;
				end if;
				
			else
				Remainder <= Remainder;
			end if;
		end if;
    end if;
end process;

	
    -- Asignar el valor del contador como salida result
    result <= Count;

end architecture;
