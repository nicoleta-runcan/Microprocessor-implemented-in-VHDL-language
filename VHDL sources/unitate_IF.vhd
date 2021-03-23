----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/24/2020 04:37:22 PM
-- Design Name: 
-- Module Name: unitate_IF - Behavioral
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

entity unitate_IF is
    Port ( clk : in STD_LOGIC;
           branchAdress : in STD_LOGIC_VECTOR (15 downto 0);
           jumpAdress : in STD_LOGIC_VECTOR (15 downto 0);
           Jump : in STD_LOGIC;
           PCSsrc : in STD_LOGIC;
           PC_out : out STD_LOGIC_vector(15 downto 0);
           RESET:in STD_LOGIC;
           enable:in STD_LOGIC;
           Instruction : out STD_LOGIC_vector(15 downto 0));
           
end unitate_IF;

architecture Behavioral of unitate_IF is
signal signal_PC:std_logic_vector(15 downto 0);
signal mux2_out:std_logic_vector(15 downto 0);
signal mux1_out:std_logic_vector(15 downto 0);
signal next_adr:std_logic_vector(15 downto 0);
type mem is array (0 to 255) of STD_LOGIC_VECTOR (15 downto 0);

--Acest program realizeaza suma numerelor impare scazute cu 1 dintr-un sir cu 4 elemente, iar aceasta suma o memorez la adresa 7
signal M:mem:=(
B"000_000_000_001_0_000", --add $1, $0,$0 --0010
B"001_000_010_0000100", --addi $2, $0, 4 --2204
B"000_000_000_011_0_101", --or $3, $0, $0 --0035
B"000_000_000_100_0_000", --add $4, $0, $0 --0040
B"001_000_111_0000001", --addi $7, $0, 1 --2381
B"100_001_010_0001000", --beq $1, $2, 8 --8508
B"010_011_110_0000010", --lw $6, 2($3) --4B02
B"000_110_111_101_0_100", --and $5, $6, $7 --1BD4
B"011_101_111_0000010", --bne $5, $7, 2 --7782
B"000_110_111_110_0_001", --sub $6, $6, $7 --1BE1
B"000_100_110_100_0_000", --add $4, $4, $6 --1340
B"001_011_011_0000001", --addi $3, $3, 1 --2D81
B"001_001_001_0000001", --addi $1, $1, 1 --2481
B"111_0000000000101", --j 5 --E005
B"011_000_100_0000111", --sw $4, 7($0) --6207 
others => B"0000"
);

begin

process(clk, reset)
begin
 if(RESET='1')then
   signal_PC<=x"0000";
 end if;
 if(clk'event and clk='1') then
   if(enable='1') then
     signal_PC<=mux2_out;
   end if;
 end if;
end process; 
    
Instruction<=M(conv_integer(signal_PC(7 downto 0)));

next_adr<=signal_PC+x"0001";
PC_out<=next_adr;

process(PCSsrc, next_adr, branchAdress)
begin
case(PCSsrc) is
   when '0' => mux1_out<=next_adr;
   when others => mux1_out<=branchAdress;
  end case;
end process;

process(Jump, mux1_out, jumpAdress)
begin
  case(Jump) is
   when '0' => mux2_out<=mux1_out;
   when others => mux2_out<=jumpAdress;
 end case;
end process;
end Behavioral;
