----------------------------------------------------------------------------------
-- Company: ENSEA
-- Engineer: Alban Benmouffek, Salomé Wattiaux, Marco Guzzon
-- 
-- Create Date: 04.04.2019 09:35:31
-- Design Name: 
-- Module Name: PWM - Behavioral
-- Project Name: Portail
-- Target Devices: 
-- Tool Versions: 
-- Description: module permettant d'envoyer un signal PWM réglable par la variable duty.
--  Le signal est envoyé sur la sortie si entree = '1'.
-- 
-- Dependencies: 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PWM is
    Generic (
        periode : integer := 2; --période du signal, en ms
        duty : integer := 35 --duty cycle, en % 
    );
    Port ( 
        --ENTREES DIVERSES:
        CLK: in STD_LOGIC; --Horloge
        entree : in STD_LOGIC; --Signal indiquant si on doit envoyer du jus
        
        --SORTIES DIVERSES:
        sortie : out STD_LOGIC --Sortie (en PWM)
    );
end PWM;

architecture Behavioral of PWM is
    signal sortie_temp : STD_LOGIC := '0'; --PWM en permanence, indépendamment de entree
    signal compteur : integer := 0;
begin
    
    process(CLK) begin
        if rising_edge(CLK) then
            if compteur = 1000*periode*duty and sortie_temp = '1' then --On passe de '1' à '0'
                sortie_temp <= NOT(sortie_temp);
                compteur <= 0;
            elsif compteur = 1000*periode*(100-duty) and sortie_temp = '0' then --On passe de '0' à '1'
                sortie_temp <= NOT(sortie_temp);
                compteur <= 0;
            else --On ne change rien, seul le temps continue de s'écouler indéfiniment, vers l'infini sans ne jamais l'atteindre
                sortie_temp <= sortie_temp;
                compteur <= compteur + 1;
            end if;
        end if;
    end process;
    
    --On n'envoie le signal que si entree vaut '1' :
    sortie <= sortie_temp when entree = '1' else '0';
    
end Behavioral;
