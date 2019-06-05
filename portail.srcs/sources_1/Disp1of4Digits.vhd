----------------------------------------------------------------------------------
-- Company: ENSEA
-- Engineers: Vincent GUITSCHULA and Alban BENMOUFFEK
-- 
-- Create Date: 14.11.2018 13:52:26
-- Design Name: 
-- Module Name: Disp1of4Digits - Behavioral
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

entity Disp1of4Digits is
    Port ( A : in STD_LOGIC_VECTOR (3 downto 0);
           B : in STD_LOGIC_VECTOR (3 downto 0);
           C : in STD_LOGIC_VECTOR (3 downto 0);
           D : in STD_LOGIC_VECTOR (3 downto 0);
           N : in STD_LOGIC_VECTOR (1 downto 0);
           ENAN : out STD_LOGIC_VECTOR (3 downto 0);
           S : out STD_LOGIC_VECTOR (6 downto 0));
end Disp1of4Digits;

architecture Behavioral of Disp1of4Digits is
    signal V: STD_LOGIC_VECTOR(3 downto 0);
begin
    u1 : entity work.MUX4x4v1x4
        port map (A=>A, B=>B, C=>C, D=>D, Sel=>N,O=>V);
    
    u2 : entity work.Disp1Digit
        port map (N=>N, S=>S, ENAN=>ENAN, V=>V);

end Behavioral;
