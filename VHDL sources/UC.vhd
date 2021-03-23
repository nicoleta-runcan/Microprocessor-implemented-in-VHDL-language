----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/31/2020 08:08:36 PM
-- Design Name: 
-- Module Name: UC - Behavioral
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

entity UC is
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
end UC;

architecture Behavioral of UC is

begin
process
begin
AluOp<="000"; RegDst<='0';  Ext_Op<='0'; ALUsrc<='0'; Branch<='0'; Jump<='0';
MemWrite<='0'; MemtoReg<='0'; RegWrite<='0'; BranchNE<='0';  
case Opcode is
when "000"=> RegDst<='1';RegWrite<='1';
when "001"=> RegWrite<='1';ALUsrc<='1'; Ext_Op<='1'; AluOp<="001";
when "010"=>  RegWrite<='1';ALUsrc<='1'; Ext_Op<='1'; AluOp<="001"; MemtoReg<='1';
when "011"=>  ALUsrc<='1'; Ext_Op<='1'; AluOp<="001"; MemWrite<='1';
when "100"=>  Ext_Op<='1'; AluOp<="011"; Branch<='1';
when "101"=>  RegWrite<='1';ALUsrc<='1'; AluOp<="100";
when "110"=> Ext_Op<='1'; AluOp<="011"; BranchNE<='1';
when "111"=>Jump<='1';

end case;
end process;
end Behavioral;
