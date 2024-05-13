library ieee;
use ieee.std_logic_1164.all;

entity alu_fetch_tb is
end alu_fetch_tb;

architecture test of alu_fetch_tb is

	component alu_fetch is port(
		clk : in std_logic;
		reset,S0,S1: in std_logic;
		stop_run: in std_logic;
		display: out std_logic_vector(6 downto 0);
		signo: out std_logic;
		sel: out std_logic_vector(3 downto 0)
	);
	end component;

    -- Señales de prueba
	signal clk_t: std_logic := '0';  -- Señal de reloj agregada
    signal reset_t: std_logic := '0';
	signal signo_t: std_logic := '0';
	signal S0_t: std_logic := '1';
	signal S1_t: std_logic := '0';
    signal stop_run_t: std_logic := '0';
    signal display_t: std_logic_vector(6 downto 0) := "0000000";
    signal sel_t: std_logic_vector(3 downto 0) := "0000";
begin

    -- Instancia del componente alu_fetch
    prueba: alu_fetch port map(clk_t,reset_t,S0_t,S1_t,stop_run_t,display_t,signo_t,sel_t);

    -- Proceso para generar la señal de reloj
    clk_process: process
    begin
        for i in 1 to 5000 loop  -- Limita el número de ciclos a 50
            clk_t <= '0';
            wait for 50 ps;
            clk_t <= '1';
            wait for 50 ps;
        end loop;
        wait;  -- Detiene la simulación después de 50 ciclos
    end process clk_process;


    alu_test: process
    begin
		wait for 20000 ps;
		reset_t<= '1';
		wait for 20000 ps;
		S0_t<='0';
		S1_t<='1';
		wait for 20000 ps;
		reset_t <= '0';
        wait;
    end process alu_test;

end architecture;