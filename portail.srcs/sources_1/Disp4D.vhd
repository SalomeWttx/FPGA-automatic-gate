----------------------------------------------------------------------------------
-- Company: ENSEA
-- Engineers: Vincent GUITSCHULA and Alban BENMOUFFEK
-- 
-- Create Date: 14.11.2018 16:24:07
-- Design Name: 
-- Module Name: Disp4D - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Disp4D is
    Port ( A : in STD_LOGIC_VECTOR (3 downto 0);
           B : in STD_LOGIC_VECTOR (3 downto 0);
           C : in STD_LOGIC_VECTOR (3 downto 0);
           D : in STD_LOGIC_VECTOR (3 downto 0);
           CLK : in STD_LOGIC;
           S : out STD_LOGIC_VECTOR (6 downto 0);
           ENAN : out STD_LOGIC_VECTOR (3 downto 0));
end Disp4D;

architecture Behavioral of Disp4D is
    signal N0t : std_logic_vector(1 downto 0);
    signal Q: std_logic;
begin
    u1: entity work.Cmpt0to3 port map(CLK=>CLK, EN=>Q, N=>N0t);
    
    u2: entity work.Disp1of4Digits port map(A=>A,B=>B,C=>C,D=>D,N=>N0t,S=>S,ENAN=>ENAN);
    
    u3: entity work.TICK_1ms port map(Tick=>Q,CLK=>CLK);

end Behavioral;
