library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu_fetch_tb is
end alu_fetch_tb;

architecture behavior of alu_fetch_tb is


component alu is port(
	clk: in std_logic;
	A,B: in std_logic_vector(15 downto 0);
	control: in std_logic_vector(3 downto 0);
	result: out std_logic_vector(15 downto 0);
	C,Z,S,V: out std_logic
);
end component;

signal clk_t: std_logic := '0';
signal A_t: std_logic_vector(15 downto 0) := "0000000000000000";
signal B_t: std_logic_vector(15 downto 0) := "0000000000000000";
signal control_t: std_logic_vector(3 downto 0) := "0000";
signal result_t: std_logic_vector(15 downto 0) := "0000000000000000";
signal C_t: std_logic := '0';
signal Z_t: std_logic := '0';
signal S_t: std_logic := '0';
signal V_t: std_logic := '0';
signal registroA : std_logic_vector(15 downto 0) := "0000000000000000";
signal registroBandera : std_logic := '0';
signal registroBanderaZ : std_logic := '0';
signal T: std_logic_vector (2 downto 0):= "000";
begin

alu_prueba : alu port map (clk_t,A_t,B_t,control_t,result_t,C_t,Z_t,S_t,V_t);

clk_process: process
    begin
        while true loop
            clk_t <= not clk_t;  -- Cambio de clock
            wait for 5 ns;        -- Período de clock de 10 ns (cada 5 ns cambia de estado)
        end loop;
end process clk_process;

prueba : process 
begin 
report "inicia prueba" severity Note;
wait for 100 ns; 
--generar 17X cuando x es 1

A_t <= "0000000000000001";
B_t <= "0000000000010001";
control_t <= "1101";
wait for 100 ns;

--generar 25Y donde y es 2
registroA <= result_t;
A_t <= "0000000000000010";
B_t <= "0000000000011001";
control_t <= "1101";

wait for 100 ns;

--generar la suma de esos dos y registrarlo en otro 

A_t <= result_t;
B_T <= registroA;
control_t <= "0110";

wait for 100 ns;

--generar la division w/4 donde W es 40
registroA <= result_t; --67

A_t <= "0000000000101000";
B_t <= "0000000000000100";
control_t <= "1110";
wait for 100 ns;
--genrar la resta  de los dos valores
A_T <= registroA;
B_t <= result_t;
control_t <= "0111";

report  "termina prueba de alu" severity Note;
wait for 50 ns;

registroA <= result_t;
wait for 10 ns;
--comenzamos el chequeo del las banderas
--cehcar si es mayor a 100
--probar valores, funciona bien para mayores a 100 
--probar valores, funciona bien para mayores el rango mayores o iguales  a 60 menores a 100 
--probar valores, funciona bien para mayores el rango mayores 25  menores a 60--probar valores, funciona bien para mayores el rango mayores 0 o iguales  a menores de 25
--funciona bien pa todos


registroA <= "0000000000000001";
wait for 10 ns;
--


A_t <= registroA;
B_t <= "0000000001100100";
control_t <= "0111";
wait for 50 ns;

if(S_t = '1')then
	--hay signo negativo entonces es menor a 100
	--ahora vamos a confirmar entre 60 y 100
	A_t <= registroA;
	B_t <= "0000000000111100";
	control_t <= "0111";
	wait for 50 ns;
	registroBandera <= s_t; -- si es mayor o igual a 6, mayor a 60 es signo 0 o 
	registroBanderaZ <= z_t; 
	A_t <= registroA;
	B_t <= "0000000001100100";
	control_t <= "0111";
	wait for 50ns;
	--para que el valor estee n 60 y 100. deberia registroBandera ser 0 y s_t (valor de s_t con la ultima resta) deberia ser 1
	if((((not registroBandera) and s_t) = '1') or (registroBanderaZ = '1') ) then
		--valor entre 60 y 100
		report "valor entre 60 y 100" severity Note;
		T<= "011";
	else
		report "valor menor a 60" severity Note;
		--ahora vamos aconfirma valor entre 60 y 25
		A_t <= registroA;
		B_t <= "0000000000011001";
		control_t <= "0111";
		wait for 50 ns;
		registroBandera <= s_t; --tiene el valor de si es mayor a 25 		 
		A_t <= registroA;
		B_t <= "0000000000111100";
		control_t <= "0111";
		wait for 50ns;
		--para que sea mayo a 25 pero menor a 60, registroBandera debe ser 0 y s_t debe ser 1
		if((not registroBandera and s_t) = '1')then
			report "valor mayor a 25 menor a 60" severity Note;
			T<= "100";
		else
			report "valor menor  a 25 menor a 60" severity Note;
			--ahora vamos a confirmar que el valor este mayor o igual a 25 0 mayor o igual a 0
			A_t <= registroA;
			B_t <= "0000000000000000";
			control_t <= "0111";
			wait for 50 ns;
			registroBandera <= s_t; -- si es mayor o igual a 0, mayor a 60 es signo 0 o 
			registroBanderaZ <= z_t; --si es igual a 25 Z tiene que ser 0
			A_t <= registroA;
			B_t <= "0000000000011001";
			control_t <= "0111";
			wait for 50ns;
			--para que sea mayor o igual a 25, RBandera debe ser 0 y st debe ser 1 oo RBanderaZ debe ser 1 o z_t tiene que ser 1 
			if((((not registroBandera) and s_t) = '1') or (registroBanderaZ = '1') or (z_t = '1')) then
				report "valor menor igual a 25 y mayor o igual a 0" severity Note;
				T<= "001";
			else
				report "valor menor a 0 " severity Note;
				T<= "101";
			end if;
		end if;
	end if;
else
	report "valor mayor a 100" severity Note;
	T<= "010";
end if;
wait;
end process prueba;
end architecture;
