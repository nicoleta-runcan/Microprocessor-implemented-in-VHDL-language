----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/09/2020 10:32:20 AM
-- Design Name: 
-- Module Name: RF - Behavioral
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

entity RF is
    Port ( clk : in STD_LOGIC;
           ra1 : in STD_LOGIC_VECTOR (2 downto 0);
           ra2 : in STD_LOGIC_VECTOR (2 downto 0);
           wa : in STD_LOGIC_VECTOR (2 downto 0);
           wd : in STD_LOGIC_VECTOR (15 downto 0);
           wen : in STD_LOGIC;
           mpg_enable:in std_logic;
           rd1 : out STD_LOGIC_VECTOR (15 downto 0);
           rd2 : out STD_LOGIC_VECTOR (15 downto 0));
end RF;

architecture Behavioral of RF is
 type reg_array is array (0 to 7) of std_logic_vector(15 downto 0);
 signal reg_file:reg_array:=
 (0=>"0000000000000000",
 1=>"0000000000000001",
2=> "0000000000000010",
3=> "0000000000000011",
4=> "0000000000000100",
5=> "0000000000000101",
6=> "0000000000000110",
others=> "0000000000000111");
 

begin

   process(clk)
   begin
     if clk'event and clk='1' then 
       if wen='1' then 
        if mpg_enable='1' then
           reg_file(conv_integer(wa))<=wd;
         end if;
       end if;
     end if;
   end process;
 
rd1 <= reg_file(conv_integer(ra1));
rd2 <= reg_file(conv_integer(ra2));
end Behavioral;
