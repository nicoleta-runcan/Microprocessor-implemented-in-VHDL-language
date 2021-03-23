----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/31/2020 07:01:50 PM
-- Design Name: 
-- Module Name: ID - Behavioral
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

entity ID is
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

end ID;

architecture Behavioral of ID is
component RF is
    Port ( clk : in STD_LOGIC;
           ra1 : in STD_LOGIC_VECTOR (2 downto 0);
           ra2 : in STD_LOGIC_VECTOR (2 downto 0);
           wa : in STD_LOGIC_VECTOR (2 downto 0);
           wd : in STD_LOGIC_VECTOR (15 downto 0);
           wen : in STD_LOGIC;
           mpg_enable:in std_logic;
           rd1 : out STD_LOGIC_VECTOR (15 downto 0);
           rd2 : out STD_LOGIC_VECTOR (15 downto 0));
     end component;
 signal mux_out:std_logic_vector(2 downto 0);
begin
   RegFile: RF port map(clk, Instr(12 downto 10), Instr(9 downto 7), mux_out,WD, RegWrite, MPG_en, RD1, RD2);  
    process(Instr, RegDst)
    begin
     if RegDst='0' then 
            mux_out<=Instr(9 downto 7);
            else
            mux_out<=Instr(6 downto 4);
         end if;
    end process;
    
   process(ExtOp, Instr(6 downto 0))
   begin
    if ExtOp='0'then
        ext_imm<="000000000"&Instr(6 downto 0);
    else
        if(Instr(6)='1') then
            ext_imm<="111111111"&Instr(6 downto 0);
        else
            ext_imm<="000000000"&Instr(6 downto 0);
        end if;
    end if;
  end process;
  
  funct<=Instr(2 downto 0);
  SA<=Instr(3);
end Behavioral;
