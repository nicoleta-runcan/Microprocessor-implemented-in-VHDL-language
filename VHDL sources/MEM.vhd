----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/07/2020 05:16:17 PM
-- Design Name: 
-- Module Name: MEM - Behavioral
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

entity MEM is
    Port (clk:in std_logic; 
          MemWrite : in std_logic;--enable
          AluRes_IN:in std_logic_vector(15 downto 0); --address
          RD2:in std_logic_vector(15 downto 0);    --write data
          en:in std_logic;
          MemData:out std_logic_vector(15 downto 0);
          ALURes_OUT:out std_logic_vector(15 downto 0));
end MEM;

architecture Behavioral of MEM is
type ram_type is array (0 to 63) of std_logic_vector (15 downto 0);
signal RAM: ram_type:=(x"0000",x"0000",x"0003",x"0007", x"0008", x"0001", others=>x"0000");
begin

process(clk)
begin
   if rising_edge(clk) then
      if en='1' then
         if MemWrite='1' then
           RAM(conv_integer(AluRes_IN(5 downto 0)))<=RD2;
         end if;
       end if;
   end if;
 end process;
 
MemData<= RAM( conv_integer(AluRes_IN));
AluRes_OUT<=AluRes_IN;
end Behavioral;
