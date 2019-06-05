----------------------------------------------------------------------------------
-- Company: ENSEA
-- Engineers: Vincent GUITSCHULA and Alban BENMOUFFEK
-- 
-- Create Date: 24.10.2018 16:06:57
-- Design Name: 
-- Module Name: MUX4x4v1x4 - Behavioral
-- Project Name: Chrono
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MUX4x4v1x4 is
    Port ( A : in STD_LOGIC_VECTOR (3 downto 0);
           B : in STD_LOGIC_VECTOR (3 downto 0);
           C : in STD_LOGIC_VECTOR (3 downto 0);
           D : in STD_LOGIC_VECTOR (3 downto 0);
           Sel : in STD_LOGIC_VECTOR (1 downto 0);
           O : out STD_LOGIC_VECTOR (3 downto 0));
end MUX4x4v1x4;

architecture Behavioral of MUX4x4v1x4 is

begin
    O<= A when Sel="00" else
        B when Sel="01" else
        C when Sel="10" else
        D;

end Behavioral;
