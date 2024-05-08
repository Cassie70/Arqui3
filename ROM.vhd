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
	constant OP_JR: std_logic_vector(5 downto 0):=    "011010";
	constant OP_ADPLY: std_logic_vector(5 downto 0):= "011011";
	

	--Control RPG
	constant RA: std_logic_vector(1 downto 0):= "00";
	constant RB: std_logic_vector(1 downto 0):= "01";
	constant RC: std_logic_vector(1 downto 0):= "10"; 
	constant RD: std_logic_vector(1 downto 0):= "11";

	--TIPO I |OP CODE(6)| REGISTRO DESTINO(2) | DIRECCION DE MEMORIA (16) Y OP A REALIZAR|
	--TIPO R |OP CODE(6)| REGISTRO DESTINO(2) | DIRECCION DE MEMORIA (16)|
	--TIPO J |OP CODE(6)| DIRECCION DE MEMORIA (18)|
	type ROM_Array is array (0 to 255) of std_logic_vector(23 downto 0);
	constant content: ROM_Array := (
		--Ecuacion a) 17X + 25Y - W/4
		0 => OP_LOAD&RA&x"00F8",--LOAD X, RA
		1 =>OP_MULTI&RA&x"0011",--MULTI RA,17 
		2 => OP_LOAD&RB&x"00F9",--LOAD Y, RB
		3 =>OP_MULTI&RB&x"0019",--MULTI RB,25 
		4 => OP_LOAD&RC&x"00F7",--LOAD W,RC
		5 => OP_DIVI&RC&x"0004",--DIVI RC,4 
		6 => OP_ADD&RA&RB&RA&x"000",--ADD RA,RB,RA 
		7 => OP_SUB&RA&RC&RA&x"000",--SUB RA,RC,RA 
		8 => OP_DPLY&RA&x"0000",--DPLY RA
		9 => OP_LOAD&RA&x"00F2",--LOAD 10,RA
		10=> OP_LOAD&RB&x"00F1",--LOAD 24,RB
		11=> OP_JMP&"00"&x"000C",--JMP 12
		
		--T=RA
		12 => OP_ADEC&RA&"000000000000"&"0011",--DEC RA
		--SECUENCIA PARA 1 SEGUNDO
		13 => OP_LOAD&RC&x"00F4",--LOAD j, RC
		14 =>OP_LOAD&RD&x"00F4",--LOAD j, RD
		15 =>OP_ADEC&RC&"000000000000"&"0011",--DEC RC
		16 =>OP_ADEC&RD&"000000000000"&"0011",--DEC RD
		17 =>OP_NOP&"000000000000000000",--NOP
		18 =>OP_BNZ&"10"&x"00FE",--BNZ -2
		19 =>OP_CMPI&RC&x"0000",-- CMPI RC,0
		20 =>OP_BNZ&"10"&x"00FA",--BNZ -6
		--T=RA=0?
		21 =>OP_CMPI&RA&x"0000",--CMPI RA,0
		22 =>OP_BNZ&"10"&x"00F6",--BNZ -10
		--SALTAR AL VALOR DE RB
		23 =>OP_JR&RB&x"0000",--JR RB
		--CONTADOR 0 A 30 
		24 => OP_LOAD&RC&x"00F5",--LOAD 0,RC	
		25 => OP_LOAD&RA&x"00F9",--LOAD 2,RA
		26 => OP_LOAD&RB&x"001C",--LOAD 28,RB punto de retorno
		27 => OP_JMP&"00"&x"000C",
		28 => OP_DPLY&RC&x"0000", --DPLY RC
		29 => OP_ADDI&RC&x"0001", --ADDI RC,1
		30 => OP_CMPI&RC&x"001E", --CMPI RC,30
		31 => OP_BNZ&"10"&x"00FC",--BNZ -4
		32 => OP_DPLY&RC&x"0000", --DPLY RC
		33 => OP_HALT&"000000000000000000",
		--Ecuacion b) 10X^2 + 30X - Z/2
		47 => OP_LOAD&RA&"00000000"&"11111000", --LOAD X, RA
		48 => OP_LOAD&RB&"00000000"&"11111000", --LOAD X, RB
		49 => OP_MULT&RA&RB&"0000000000"&"1101", --MULT RA * RA, RA RES=X*X
		50 => OP_MULTI&RA&"000000001010"&"1101", --MULTI RA, 10 RES=10*X*X
		51 => OP_MULTI&RB&"000000011110"&"1101", --MULTI RB, 30 RES=30*X
		52 => OP_LOAD&RC&"00000000"&"11111010", --LOAD Z, RC
		53 => OP_DIVI&RC&"000000000010"&"1110", --DIVI RC, 2 RES=Z/2
		54 => OP_ADD&RA&RB&"0000000000"&"0110", --ADD RA + RB, RA RES=10*X*X + X*X
		55 => OP_SUB&RA&RC&"0000000000"&"0111", --SUB RA - RC, RA RES= 10*X*X + X*X - Z/2
		56 => OP_DPLY&RA&x"0000",
 
		--Ecuacion c) -X^3 - 7Z +W/10
		71 => OP_LOAD&RA&"00000000"&"11111000", --LOAD X, RA
		72 => OP_LOAD&RB&"00000000"&"11111000", --LOAD X, RB
		73 => OP_MULT&RA&RB&"0000000000"&"1101", --MULT RA * RA, RA RES=X*X
		74 => OP_MULT&RA&RB&"0000000000"&"1101", --MULT RA * RA, RA RES=X*X*X
		75 => OP_LOAD&RC&"00000000"&"11111010", --LOAD Z, RC
		76 => OP_MULTI&RC&"000000000111"&"1101", --MULTI RC, 7 RES=7*Z
		77 => OP_LOAD&RB&"00000000"&"11110111", --LOAD W, RC
		78 => OP_DIVI&RB&"000000001010"&"1110", --DIVI RB, 10 RES=W/10
		79 => OP_SUB&RB&RC&"0000000000"&"0111", --SUB RB - RC, RB=W/10 - 7*Z
		80 => OP_SUB&RB&RA&"0000000000"&"0111", --SUB RB - RA, RB RES= W/10 - 7*Z - X^3

		--Ecuacion d) desplegar 0000 en el display
		241 => x"000018",
		242 => x"00000A",--10
		243 => x"000004",--4
		244 => x"0003F4",--1012   3F4
		245 => x"000000",-- 0
		246 => x"000003",-- 30 en decimal i
		247 => x"000028", -- 40 en decimal W pra que sea divisible exacto del 10 y del 4
		248 => x"000001", -- 1 en decimal X
		249 => x"000002", -- 2 en decimal Y 
		250 => x"000003", -- 3 en decimal Z
		251 => x"000012", -- 18 en decimal M
		252 => x"000007", -- 7 en decimal N 
		253 => x"000017", -- 23 en decimal O 
		254 => x"000037", -- 55 en decimal P 
		255 => x"00004D", -- 77 en decimal Q
		others => x"000000"
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
					