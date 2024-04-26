library ieee;
use ieee.std_logic_1164.all;

entity divi6 is
    port(
        clk: in std_logic;
        A, B: in std_logic_vector(11 downto 0);
        result: out std_logic_vector(11 downto 0)
    );
end entity;

architecture a_divi6 of divi6 is
    component add_sub_12 is
        port(
            A, B: in std_logic_vector(11 downto 0);
            sub: in std_logic;
            S: inout std_logic_vector(11 downto 0);
            cout: out std_logic
        );
    end component;

    signal subtractor_input, one: std_logic_vector(11 downto 0);
    signal subtractor_output, increment_output: std_logic_vector(11 downto 0);
    signal subtraction_counter: std_logic_vector(11 downto 0) := (others => '0');
    signal operation_complete: std_logic := '0';
    
begin
    one <= "000000000001";

    process(clk)
    begin
        if (clk'event and clk='1') then
		    if B = "000000000000" then
				result <= "111111111111";
				operation_complete <= '1'; 
            elsif operation_complete = '0' then
                if subtractor_input < B then
                    result <= subtraction_counter;
                    operation_complete <= '1';
                else
                    subtractor_input <= subtractor_output;
                    subtraction_counter <= increment_output;
                end if;
            end if;
        end if;
    end process;
    
    subtraction_instance: add_sub_12 port map(subtractor_input,B,'1',subtractor_output,open);
    increment_instance: add_sub_12 port map(subtraction_counter,one,'0',increment_output,open);
    
    initial_process: process(A, B)
    begin
        subtractor_input <= A;
        subtraction_counter <= "000000000000";
        operation_complete <= '0';
    end process;

end architecture;