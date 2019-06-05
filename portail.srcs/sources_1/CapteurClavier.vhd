----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Alban Benmouffek
-- 
-- Create Date: 25.02.2019 12:36:17
-- Design Name: 
-- Module Name: CapteurClavier - Behavioral
-- Project Name: Portail
-- Target Devices: 
-- Tool Versions: 
-- Description: lit un clavier matriciel (4 lignes, 4 colonnes) SORTIE: la ligne consideree et les touches appuyees sur cette ligne
--touche      colonnes(0)     colonnes(1)     colonnes(2)     colonnes(3)
--lignes(0)       0               1               2               3
--lignes(1)       4               5               6               7
--lignes(2)       8               9               10              11
--lignes(3)       12              13              14              15

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

entity CapteurClavier is
    Port ( 
        CLK : in STD_LOGIC; --Horloge
        
        --Clavier:
        lignes : out STD_LOGIC_VECTOR (3 downto 0);
        colonnes : in STD_LOGIC_VECTOR (3 downto 0);
        
        touches : out STD_LOGIC_VECTOR (3 downto 0); --Touches detectees
        ligne : out STD_LOGIC_VECTOR (1 downto 0); --Ligne consideree
        
        tick : in STD_LOGIC --Changement de ligne
        
    );
end CapteurClavier;

architecture Behavioral of CapteurClavier is
    signal numeroLigne : unsigned(1 downto 0) := "00";
begin
    
    process(CLK) begin
        if rising_edge(CLK) then
            
            --TEST: changement de ligne
            if tick = '1' then
                --On incremente numeroLigne de 1
                if numeroLigne = "11" then
                    numeroLigne <= "00";
                else
                    numeroLigne <= numeroLigne + 1;
                end if;
                --Fin de l'incrementation
            else
                numeroLigne <= numeroLigne;
            end if;
            
            --On met a '0' uniquement la ligne numero numeroLigne
            if numeroLigne = "00" then
                lignes <= "1110";
            elsif numeroLigne = "01" then
                lignes <= "1101";
            elsif numeroLigne = "10" then
                lignes <= "1011";
            else
                lignes <= "0111";
            end if;
        end if;
    end process;
    
    touches <= colonnes;
    ligne <= STD_LOGIC_VECTOR(numeroLigne);
    
end Behavioral;
