library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity test is
end test;

architecture behavior of test is

component SumRest16Bits is Port (
		A : in std_logic_vector(15 downto 0);
		B : in std_logic_vector(15 downto 0);
		Cin : in std_logic;
		Op : in std_logic;
		Res : out std_logic_vector(15 downto 0);
		Cout : out std_logic
	);
end component;

component divi6 is
    port(
        clk: in std_logic;
        A, B: in std_logic_vector(15 downto 0); -- a de 8 bits
        result: out std_logic_vector(15 downto 0) -- b de 8 bits
    );
end component;

signal A_t : std_logic_vector(15 downto 0) := "0000000000000000";
signal B_t : std_logic_vector(15 downto 0):= "0000000000000000";
signal Cin_t :std_logic := '0';
signal Op_t : std_logic := '0';
signal Res_t : std_logic_vector(15 downto 0) := "0000000000000000";
signal Cout_t : std_logic := '0';
signal clk_t : std_logic := '0';
signal result_t: std_logic_vector(15 downto 0) :=  "0000000000000000";-- b de 8 bits
begin

sumador_t : SumRest16Bits port map (A_t, B_t,Cin_t,Op_t,Res_t,Cout_t);
divisor : divi6 port map (clk_t,A_t,B_t,result_t);

clk_process: process
    begin
        while true loop
            clk_t <= not clk_t;  -- Cambio de clock
            wait for 5 ns;        -- Período de clock de 10 ns (cada 5 ns cambia de estado)
        end loop;
end process clk_process;


prueba : process 
begin 
report "comienza simualcion " severity note;

assert Res_t = "0000000000000000" report "salida  de 0" severity note; --rest es diferente de 3
assert result_t = "0000000000000000" report "salida de 0 divisor" severity note; --rest es diferente de 3

wait for 100 ns; 

A_t <= "0000000000000011";
B_t <= "0000000000000001";
--deberia salir 4 100
assert Res_t = "0000000000000100" report "salida diferente de 4" severity note;
assert result_t = "0000000000000011" report "salida de 3 o diferente de 3 vemos de la division" severity note;

wait for 100 ns;

A_t <= "0000000000000110";
B_t <= "0000000000000110";
assert Res_t = "0000000000001100" report "salida diferente de 6 " severity note;
assert result_t = "0000000000000001" report "salida de 1 o diferente de 1 divisor  " severity note;
wait for 100 ns;
end process prueba;
end architecture;
