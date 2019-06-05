----------------------------------------------------------------------------------
-- Company: ENSEA
-- Engineer: Alban Benmouffek, Salomé Wattiaux, Marco Guzzon 
-- 
-- Create Date: 01.03.2019 19:05:30
-- Design Name: 
-- Module Name: GestionBoutons - Behavioral
-- Project Name: Portail
-- Target Devices: 
-- Tool Versions: 
-- Description: gère l'authentification du propriétaire via des boutons placés à l'intérieur de la maison
--
-- Dependencies: 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity GestionBoutons is
    Port ( 
        CLK : in STD_LOGIC;
        
        boutonOuvrir : in STD_LOGIC; -- vaut '1' si on veut ouvrir le portail
        boutonStop : in STD_LOGIC; -- vaut '1' si on veut fermer le portail
        boutonFermer : in STD_LOGIC; -- vaut '1' si on veut fermer le portail
        boutonChange : in STD_LOGIC; -- vaut '1' si on veut changer l'état du portail
        
        fonction : out STD_LOGIC_VECTOR(2 downto 0)
        --ORDRES:
        --rien : "000"
        --changer : "011"
        --ouvrir : "001"
        --fermer : "010"
        --stop : "111"
    );
end GestionBoutons;

architecture Behavioral of GestionBoutons is

begin
    process(CLK) begin
        if rising_edge(CLK) then
            if boutonStop = '1' then
                fonction <= "111";
            elsif boutonStop = '0' and boutonChange = '1' then
                fonction <= "011";
            elsif boutonStop = '0' and boutonChange = '0' and boutonOuvrir = '1' and boutonFermer = '0' then
                fonction <= "001";
            elsif boutonStop = '0' and boutonChange = '0' and boutonFermer = '1' and boutonOuvrir = '0' then
                fonction <= "010";
            else
                fonction <= "000";
            end if;
        end if;
    end process;
    
end Behavioral;
