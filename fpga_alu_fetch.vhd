library ieee;
use ieee.std_logic_1164.all;


entity fpga_alu_fetch is port(
	reset,S0,S1: in std_logic;
	stop_run: in std_logic;
	display: out std_logic_vector(6 downto 0);
	signo: out std_logic;
	sel: out std_logic_vector(3 downto 0)
);
end fpga_alu_fetch;

architecture behavior of alu_fetch is
signal clk: std_logic;

	

	component alu_fetch is port(
		clk : in std_logic;
		reset,S0,S1: in std_logic;
		stop_run: in std_logic;
		display: out std_logic_vector(6 downto 0);
		signo: out std_logic;
		sel: out std_logic_vector(3 downto 0)
	);
	end component;

	
begin


end behavior;