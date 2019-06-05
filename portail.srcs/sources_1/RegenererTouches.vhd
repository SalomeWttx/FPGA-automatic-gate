----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Alban Benmouffek
-- 
-- Create Date: 25.02.2019 13:56:32
-- Design Name: 
-- Module Name: RegenererTouches - Behavioral
-- Project Name: Portail
-- Target Devices: 
-- Tool Versions: 
-- Description: Regenerateur de touches pour le digicode. Prend en entree la ligne consideree et les touches, met en sortie le digicode complet
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
use IEEE.NUMERIC_STD.ALL;

entity RegenererTouches is
    Port ( 
        CLK : in STD_LOGIC; --Horloge
        
        --Clavier
        touches : in STD_LOGIC_VECTOR (3 downto 0); --Touches detectees
        ligne : in STD_LOGIC_VECTOR (1 downto 0); --Ligne consideree
        
        clavier : out STD_LOGIC_VECTOR (15 downto 0) --digicode complet
    );
end RegenererTouches;

architecture Behavioral of RegenererTouches is

begin
    process(CLK) begin
        if rising_edge(CLK) then
        
            if ligne = "00" then --de 0 a 3
                clavier(3 downto 0) <= touches;
            elsif ligne = "01" then --de 4 a 7
                clavier(7 downto 4) <= touches;
            elsif ligne = "10" then --de 8 a 11
                clavier(11 downto 8) <= touches;
            else --de 12 a 15
                clavier(15 downto 12) <= touches;
            end if;
            
        end if;
    end process;

end Behavioral;
