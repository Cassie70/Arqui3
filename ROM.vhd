library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity ROM is port(
	clk: in std_logic;
	clr: in std_logic;
	enable: in std_logic;
	read_m : in std_logic; 
	address: in std_logic_vector(7 downto 0);
	data_out : out std_logic_vector(23 downto 0)
);
end ROM;

architecture a_ROM of ROM is
	
	constant OP_NOP:  std_logic_vector(5 downto 0):=  "000000";
	constant OP_LOAD: std_logic_vector(5 downto 0):=  "000001";
	constant OP_ADDI: std_logic_vector(5 downto 0):=  "000010";
	constant OP_DPLY: std_logic_vector(5 downto 0):=  "000011";
	constant OP_ADEC: std_logic_vector(5 downto 0):=  "000100";
	constant OP_BNZ: std_logic_vector(5 downto 0):=   "000101";
	constant OP_BZ: std_logic_vector(5 downto 0):=    "000110";
	constant OP_BS: std_logic_vector(5 downto 0):=    "000111";
	constant OP_BNS: std_logic_vector(5 downto 0):=   "001000";
	constant OP_BNC: std_logic_vector(5 downto 0):=   "001001";
	constant OP_BC: std_logic_vector(5 downto 0):=    "001010";
	constant OP_BNV: std_logic_vector(5 downto 0):=   "001011";
	constant OP_BV: std_logic_vector(5 downto 0):=    "001100";
	constant OP_HALT: std_logic_vector(5 downto 0):=  "001101";
	constant OP_ADD: std_logic_vector(5 downto 0):=   "001110";
	constant OP_SUB: std_logic_vector(5 downto 0):=   "011111";
	constant OP_MULT: std_logic_vector(5 downto 0):=  "010000";
	constant OP_DIV: std_logic_vector(5 downto 0):=   "010001";
	constant OP_MULTI: std_logic_vector(5 downto 0):= "010010";
	constant OP_DIVI: std_logic_vector(5 downto 0):=  "010011";
	constant OP_COMP1: std_logic_vector(5 downto 0):= "010100";
	constant OP_COMP2: std_logic_vector(5 downto 0):= "010101";
	constant OP_JMP: std_logic_vector(5 downto 0):=   "010110";
	constant OP_JALR: std_logic_vector(5 downto 0):=  "010111";
	constant OP_CMP: std_logic_vector(5 downto 0):=   "011000";
	constant OP_CMPI: std_logic_vector(5 downto 0):=  "011001";
	

	--Control RPG
	constant RPG_A: std_logic_vector(1 downto 0):= "00";
	constant RPG_B: std_logic_vector(1 downto 0):= "01";
	constant RPG_C: std_logic_vector(1 downto 0):= "10"; 
	constant RPG_D: std_logic_vector(1 downto 0):= "11";

	--TIPO I |OP CODE(6)| REGISTRO DESTINO(2) | DIRECCION DE MEMORIA (16) Y OP A REALIZAR|
	--TIPO R |OP CODE(6)| REGISTRO DESTINO(2) | DIRECCION DE MEMORIA (16)|
	--TIPO J |OP CODE(6)| DIRECCION DE MEMORIA (18)|
	type ROM_Array is array (0 to 255) of std_logic_vector(23 downto 0);
	constant content: ROM_Array := (
		0 => OP_LOAD&RPG_A&"0000000011110101",--LOAD 0,RA
		1 => OP_DPLY&RPG_A&"0000000000000000", --DPLY RA
		2 => OP_ADDI&RPG_A&"0000000000000001", --ADDI RA,1
		3 => OP_CMPI&RPG_A&"0000000000011110", --CMPI RA,30
		4 => OP_BNZ&"001111111111111100",--BNZ -3
		5 => OP_DPLY&RPG_A&"0000000000000000", --DPLY RA
		--Ecuacion a) 17X + 25Y - W/4
		23 => OP_LOAD&RPG_A&"0000000011111000",--LOAD X, RA
		24 =>OP_MULTI&RPG_A&"0000000000010001",--MULTI RA,17 
		25 => OP_LOAD&RPG_B&"0000000011111001",--LOAD Y, RB
		26 =>OP_MULTI&RPG_B&"0000000000011001",--MULTI RB,25 
		27 => OP_LOAD&RPG_C&"0000000011110111",--LOAD W,RC
		28 => OP_DIVI&RPG_C&"0000000000000100",--DIVI RC,4 
		29 => OP_ADD&RPG_A&RPG_B&RPG_A&"000000000000",--ADD RA,RB,RA 
		30 => OP_SUB&RPG_A&RPG_C&RPG_A&"000000000000",--SUB RA,RC,RA 

		--Ecuacion b) 10X^2 + 30X - Z/2
		47 => OP_LOAD&RPG_A&"00000000"&"11111000", --LOAD X, RA
		48 => OP_LOAD&RPG_B&"00000000"&"11111000", --LOAD X, RB
		49 => OP_MULT&RPG_A&RPG_B&"0000000000"&"1101", --MULT RA * RA, RA RES=X*X
		50 => OP_MULTI&RPG_A&"000000001010"&"1101", --MULTI RA, 10 RES=10*X*X
		51 => OP_MULTI&RPG_B&"000000011110"&"1101", --MULTI RB, 30 RES=30*X
		52 => OP_LOAD&RPG_C&"00000000"&"11111010", --LOAD Z, RC
		53 => OP_DIVI&RPG_C&"000000000010"&"1110", --DIVI RC, 2 RES=Z/2
		54 => OP_ADD&RPG_A&RPG_B&"0000000000"&"0110", --ADD RA + RB, RA RES=10*X*X + X*X
		55 => OP_SUB&RPG_A&RPG_C&"0000000000"&"0111", --SUB RA - RC, RA RES= 10*X*X + X*X - Z/2

		--Ecuacion c) -X^3 - 7Z +W/10
		71 => OP_LOAD&RPG_A&"00000000"&"11111000", --LOAD X, RA
		72 => OP_LOAD&RPG_B&"00000000"&"11111000", --LOAD X, RB
		73 => OP_MULT&RPG_A&RPG_B&"0000000000"&"1101", --MULT RA * RA, RA RES=X*X
		74 => OP_MULT&RPG_A&RPG_B&"0000000000"&"1101", --MULT RA * RA, RA RES=X*X*X
		75 => OP_LOAD&RPG_C&"00000000"&"11111010", --LOAD Z, RC
		76 => OP_MULTI&RPG_C&"000000000111"&"1101", --MULTI RC, 7 RES=7*Z
		77 => OP_LOAD&RPG_B&"00000000"&"11110111", --LOAD W, RC
		78 => OP_DIVI&RPG_B&"000000001010"&"1110", --DIVI RB, 10 RES=W/10
		79 => OP_SUB&RPG_B&RPG_C&"0000000000"&"0111", --SUB RB - RC, RB=W/10 - 7*Z
		80 => OP_SUB&RPG_B&RPG_A&"0000000000"&"0111", --SUB RB - RA, RB RES= W/10 - 7*Z - X^3

		--Ecuacion d) desplegar 0000 en el display
		245 => x"000000",
		246 => x"00001E",-- 30 en decimal i
		247 => x"000028", -- 40 en decimal W pra que sea divisible exacto del 10 y del 4
		248 => x"000001", -- 1 en decimal X
		249 => x"000002", -- 2 en decimal Y 
		250 => x"000003", -- 3 en decimal Z
		251 => x"000012", -- 18 en decimal M
		252 => x"000007", -- 7 en decimal N 
		253 => x"000017", -- 23 en decimal O 
		254 => x"000037", -- 55 en decimal P 
		255 => x"00004D", -- 77 en decimal Q
		others => x"FFFFFF"
	);
begin
	process(clk,clr,read_m,address)
	begin
		if(clr='1') then	
			data_out<=(others=>'Z');
		elsif(clk'event and clk='1') then
			if(enable='1') then 
				if(read_m='1') then
					data_out<=content(conv_integer(address));
				else
					data_out<=(others=>'Z');
				end if;
			end if;
		end if;
	end process;
end a_ROM;
					