----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/13/2020 10:27:17 PM
-- Design Name: 
-- Module Name: test_env - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


entity test_env is
 Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env;

architecture Behavioral of test_env is
component unitate_IF is
    Port ( clk : in STD_LOGIC;
           branchAdress : in STD_LOGIC_VECTOR (15 downto 0);
           jumpAdress : in STD_LOGIC_VECTOR (15 downto 0);
           Jump : in STD_LOGIC;
           PCSsrc : in STD_LOGIC;
           PC_out : out STD_LOGIC_vector(15 downto 0);
           RESET:in STD_LOGIC;
           enable:in STD_LOGIC;
           Instruction : out STD_LOGIC_vector(15 downto 0));
           
end component;

component Monoimpuls_n is
    Port ( input : in STD_LOGIC;
           clock : in STD_LOGIC;
           en : out STD_LOGIC);
  end component;
  
 component SSD is
  Port ( Digit0 : in STD_LOGIC_VECTOR (3 downto 0);
           Digit1 : in STD_LOGIC_VECTOR (3 downto 0);
           Digit2 : in STD_LOGIC_VECTOR (3 downto 0);
           Digit3 : in STD_LOGIC_VECTOR (3 downto 0);
           clk : in STD_LOGIC;
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
           
end component;

component UC is
   Port ( Opcode : in STD_LOGIC_VECTOR (2 downto 0);
           RegDst : out STD_LOGIC;
           Ext_Op: out STD_LOGIC;
           ALUSrc : out STD_LOGIC;
           Branch : out STD_LOGIC;
           Jump : out STD_LOGIC;
           AluOp : out STD_LOGIC_Vector(2 downto 0);
           MemWrite : out STD_LOGIC;
           MemtoReg : out STD_LOGIC;
           RegWrite : out STD_LOGIC;
           BranchNE: out std_logic);
end component;

component EX is
      Port(
            Zero : out  STD_LOGIC;
            AluRezultat : out  std_logic_vector (15 downto 0);
            RD1:in std_logic_vector(15 downto 0);
            RD2:in std_logic_vector(15 downto 0);
            Ext_imm:in std_logic_vector(15 downto 0);
            sa:in std_logic;
            funct:in std_logic_vector(2 downto 0);
            Alu_src:in std_logic;
            AluOp : in  std_logic_vector (2 downto 0));
end component;

component ID is
Port(
clk:in std_logic;
WD:in std_logic_vector(15 downto 0);
RegWrite:in std_logic;
MPG_en:in std_logic;
Instr:in std_logic_vector(15 downto 0);
RegDst:in std_logic;
ExtOp:in std_logic;
RD1:out std_logic_vector(15 downto 0);
RD2:out std_logic_vector(15 downto 0);
SA:out std_logic;
funct: out std_logic_vector(2 downto 0);
ext_imm:out std_logic_vector(15 downto 0));
end component;


component MEM is
    Port (clk:in std_logic; 
          MemWrite : in std_logic;--enable
          AluRes_IN:in std_logic_vector(15 downto 0); --address
          RD2:in std_logic_vector(15 downto 0);    --write data
          en:in std_logic;
          MemData:out std_logic_vector(15 downto 0);
          ALURes_OUT:out std_logic_vector(15 downto 0));
end component;

signal intrare_SSD:std_logic_vector(15 downto 0);
signal PC:std_logic_vector(15 downto 0);
signal instruction:std_logic_vector(15 downto 0);
signal reset:std_logic;
signal en:std_logic;
signal branchAdress:std_logic_vector(15 downto 0);
signal jumpAdress:std_logic_vector(15 downto 0);
signal WD:std_logic_vector(15 downto 0);
signal RD1:std_logic_vector(15 downto 0);
signal RD2:std_logic_vector(15 downto 0);
signal RegDst:std_logic;
signal Ext_Op:std_logic;
signal ALUsrc:std_logic;
signal Branch:std_logic;
signal Jump:std_logic;
signal AluOp:std_logic_vector(2 downto 0);
signal MemWrite:std_logic;
signal MemToReg:std_logic;
signal RegWrite:std_logic;
signal BranchNe:std_logic;
signal SA:std_logic;
signal funct:std_logic_vector(2 downto 0);
signal ext_imm:std_logic_vector(15 downto 0);
signal zero: std_logic;
signal pcSrc:std_logic;
signal rezultatBE: std_logic;
signal rezultatBNE:std_logic;
signal ALU_rezultat:std_logic_vector(15 downto 0);
signal MemData:std_logic_vector(15 downto 0);
signal ALURes_OUT:std_logic_vector(15 downto 0);
begin

v1:Monoimpuls_n port map(btn(0), clk, en);
v2:Monoimpuls_n port map(btn(1), clk, reset);
v3: SSD port map(intrare_SSD(3 DOWNTO 0), intrare_SSD(7 DOWNTO 4), intrare_SSD(11 DOWNTO 8), intrare_SSD(15 DOWNTO 12), clk, an, cat);
v4:unitate_IF port map(clk, branchAdress, jumpAdress, Jump, pcSRC, PC, reset, en, instruction);

v5: ID port map(clk, WD, RegWrite, en, instruction, RegDst, Ext_Op, RD1, RD2, SA, funct, ext_imm);
v6:UC port map(instruction(15 downto 13), RegDst, Ext_Op, ALUsrc, Branch, Jump, AluOp, MemWrite, MemToReg, RegWrite, BranchNe);
v7:EX port map(zero, ALU_rezultat, RD1, RD2,ext_imm, SA, funct, ALUsrc, AluOp);
v8:MEM port map(clk, MemWrite, ALU_rezultat, RD2, en, MemData, ALURes_OUT);

process(MemToReg)
begin
if MemToReg='0' then 
   WD<=ALURes_OUT;
 else
   WD<=MemData;
end if;
end process;

branchAdress<=ext_imm+PC;
jumpAdress<=PC(15 downto 13) & instruction(12 downto 0);
rezultatBE<=zero AND Branch;
rezultatBNE<=(NOT zero) AND BranchNe;

pcSRC<=rezultatBE OR rezultatBNE;
process(PC, sw(7 downto 0), instruction)
begin
 case sw(7 downto 5) is
    when "000"=>intrare_SSD<=instruction;
    when "001"=>intrare_SSD<=PC;
    when "010"=>intrare_SSD<=RD1;
    when "011"=>intrare_SSD<=RD2;
    when "100"=>intrare_SSD<=ext_imm;
    when "101"=>intrare_SSD<=ALU_rezultat;
    when "110"=>intrare_SSD<=MemData;
    when others=>intrare_SSD<=WD;
  end case;
end process; 

led(0)<=RegDst;
led(1)<=Ext_Op;
led(2)<=ALUsrc;
led(3)<=Branch;
led(4)<=Jump;
led(5)<=MemWrite;
led(6)<=RegWrite;
led(7)<=MemToReg;
led(8)<=BranchNE;
led(11 downto 9)<=AluOp;

end Behavioral;
