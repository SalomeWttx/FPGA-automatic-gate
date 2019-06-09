----------------------------------------------------------------------------------
-- Company: ENSEA
-- Engineer: Alban Benmouffek, Salomé Wattiaux, Marco Guzzon 
-- 
-- Create Date: 01.03.2019 19:05:30
-- Design Name: 
-- Module Name: GestionTelecommunications - Behavioral
-- Project Name: Portail
-- Target Devices: 
-- Tool Versions: 
-- Description: gère l'authentification du propriétaire via les télécommandes (ne programme pas de nouvelle télécommande et ne gère pas les signaux physiquement envoyés : ne gère que le flux de données)
--
-- Dependencies: 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity GestionTelecommunications is
    Port ( 
        CLK : in STD_LOGIC; --Horlore
        
        fonction : out STD_LOGIC_VECTOR(2 downto 0)
        --ORDRES:
        --rien : "000"
        --changer : "011"
        --ouvrir : "001"
        --fermer : "010"
        --stop : "111"
    );
end GestionTelecommunications;

architecture Behavioral of GestionTelecommunications is
    signal fonction_sg : STD_LOGIC_VECTOR(2 downto 0) := "000";
begin
    process(CLK) begin
        if rising_edge(CLK) then
            fonction_sg <= "000"; --C'est un peu vide ici (fonctionnalité pas encore créée)
        end if;
    end process;
    
    fonction <= fonction_sg;
end Behavioral;
