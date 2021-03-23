----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/07/2020 03:39:19 PM
-- Design Name: 
-- Module Name: EX - Behavioral
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

entity EX is
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
end EX;

architecture Behavioral of EX is
signal ALUctrl:std_logic_vector(2 downto 0);
signal iesire_mux:std_logic_vector(15 downto 0);
signal ALU_sign:std_logic_vector(15 downto 0);
begin

 process(AluOp)
 begin
  case AluOp is 
   when "000"=> 
        case funct is 
        when "000"=>ALUctrl<="000"; --add
        when "001"=>ALUctrl<="001"; --sub
        when "010"=>ALUctrl<="010"; --sll
        when "011"=>ALUctrl<="011"; --srl
        when "100"=>ALUctrl<="100"; --and
        when "101"=>ALUctrl<="101"; --OR
        when "110"=>ALUctrl<="110"; --xor
        when others=>ALUctrl<="111"; --srlv
        end case;
   when "001"=>ALUctrl<="000"; --addi/lw/sw
   when "011"=>ALUctrl<="001"; --beq/bne
   when "100"=>ALUctrl<="101"; --ori
   when others => null;
   end case;
end process;

process(ALU_src, RD2, Ext_imm)
begin
  
  if ALU_src='0' then
     iesire_mux<=RD2;
  else
     iesire_mux<=Ext_imm;
   end if;
end process;


process(ALUctrl)
begin
   case ALUctrl is
        when "000"=> ALU_sign<=RD1+iesire_mux; --adunare
        when "001"=>ALU_sign<=RD1-iesire_mux; --scadare
        when "010"=>if sa='0' then            --sll
                            ALU_sign<=RD1;
                        else
                            ALU_sign<=RD1(15 downto 1)&'0'; --sll
                        end if;
         when "011"=>if sa='0' then
                                 ALU_sign<=RD1;
                            else
                                ALU_sign<='0' & RD1(14 downto 0);--srl
                             end if;
         when "100"=> ALU_sign<=RD1 and iesire_mux;
         when "101"=> ALU_sign<=RD1 or iesire_mux;
         when "110"=>ALU_sign<=RD1 xor iesire_mux;
         when "111"=>
             case iesire_mux is
             when x"0001"=>ALU_sign<='0' & RD1(14 downto 0); 
             when x"0002"=>ALU_sign<="00" & RD1(13 downto 0);
             when x"0003"=>ALU_sign<="000" & RD1(12 downto 0);
             when x"0004"=>ALU_sign<="0000" & RD1(11 downto 0);
             when others=>ALU_sign<=RD1;
             end case;
    end case;
 end process;
Zero<='1'  when Alu_sign = x"0000" else '0';
ALUrezultat<=ALU_sign;
end Behavioral;
