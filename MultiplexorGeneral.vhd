library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
----------------------------------------------------------

entity MultiplexorGeneral is port(
	S0: in std_logic;
	S1: in std_logic;
	PcOut: out std_logic_vector(7 downto 0)
);
end MultiplexorGeneral;

architecture Procesos of MultiplexorGeneral is

signal selector : std_logic_vector(1 downto 0);

begin 
selector <=S0&S1;
--se declaran las 4 operaciones que haran
--00 sea primer ecuacion
--00 sea segunda ecuacion
--00 sea tercera ecuacion
--00 sea salida en display 0000

process(selector)
begin 
	case selector is
		when "00" => --0
			PcOut <= "00000000";
		when "01" =>--96
			PcOut <= "01100000";
		when "10" =>--108
			PcOut <= "01101100";
		when others =>--120
			PcOut <= "01111000";
	end case;
end process;

end Procesos;