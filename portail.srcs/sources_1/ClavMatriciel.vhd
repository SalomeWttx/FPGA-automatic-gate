----------------------------------------------------------------------------------
-- Company: ENSEA
-- Engineer: Alban Benmouffek, Salomé Wattiaux, Marco Guzzon 
-- 
-- Create Date: 25.02.2019 12:36:17
-- Design Name: 
-- Module Name: ClavMatriciel - Behavioral
-- Project Name: Portail
-- Target Devices: 
-- Tool Versions: 
-- Description: lit un clavier matriciel (4 lignes, 4 colonnes) SORTIE: le clavier reconstitué sous forme de vecteur 16 composantes
--clavier     colonnes(0)     colonnes(1)     colonnes(2)     colonnes(3)
--lignes(0)       0               1               2               3
--lignes(1)       4               5               6               7
--lignes(2)       8               9               10              11
--lignes(3)       12              13              14              15
--
--
-- Pseudo chronogramme: (un '-' par milliseconde)
--   ...
--  -on met la ligne 0 à '1' et toutes les autres à '0'
--  -on lit le signal venant des colonnes et on le stocke dans clavier
--  -on met la ligne 1 à '1' et toutes les autres à '0'
--  -on lit le signal venant des colonnes et on le stocke dans clavier
--  -on met la ligne 2 à '1' et toutes les autres à '0'
--  -on lit le signal venant des colonnes et on le stocke dans clavier
--  -on met la ligne 3 à '1' et toutes les autres à '0'
--  -on lit le signal venant des colonnes et on le stocke dans clavier
--  -on copie clavier sur clavier_all
--   ...
--  
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ClavMatriciel is
    Port ( 
        CLK : in STD_LOGIC; --Horloge
        tick : in STD_LOGIC; -- 1 Tick toutes les millisecondes
                
        --Capteurs Clavier:
        lignes : out STD_LOGIC_VECTOR (3 downto 0);
        colonnes : in STD_LOGIC_VECTOR (3 downto 0);
        
        Clavier_OUT : out STD_LOGIC_VECTOR(15 downto 0) --Clavier Reconstitué
        
    );
end ClavMatriciel;

architecture Behavioral of ClavMatriciel is
    signal numeroLigne : integer range 0 to 3 := 0; --Ligne qui sera à '1'. Change en permanence
    signal colonnesOK : STD_LOGIC := '0'; --Signal indiquant si on peut capter le signal des colonnes

    signal clavier : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";--ce signal est actualisé ligne par ligne
    signal clavier_all : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";--ce signal est actualisé tout d'un coup (une fois que les 4 lignes ont été actualisées)
    --La période d'actualisation de clavier_all est donc 4 fois plus grande que celle de clavier.
begin
    
    process(CLK, numeroLigne, clavier, clavier_all) begin
        if rising_edge(CLK) then
            
            --On vérifie s'il est l'heure de passer à la ligne suivante
            if tick = '1' then
                if colonnesOK = '1' then --Oui, on peut passer à la ligne suivante
                    if numeroLigne = 3 then
                        numeroLigne <= 0;
                    else
                        numeroLigne <= numeroLigne + 1;
                    end if;
                    colonnesOK <= NOT(colonnesOK); --On vient de changer de ligne, on ne peut pas immédiatement lire le signal venant des colonnes
                else
                    colonnesOK <= NOT(colonnesOK); --On est resté sur la même ligne depuis 1ms : on peut lire le signal venant des colonnes
                end if;
            else
                numeroLigne <= numeroLigne;
                colonnesOK <= colonnesOK;
            end if;
            
                
            --On met a '1' uniquement la ligne numero numeroLigne
            if numeroLigne = 0 then
                lignes(0) <= '1';
                lignes(1) <= '0';
                lignes(2) <= '0';
                lignes(3) <= '0';
            elsif numeroLigne = 1 then
                lignes(0) <= '0';
                lignes(1) <= '1';
                lignes(2) <= '0';
                lignes(3) <= '0';            
            elsif numeroLigne = 2 then
                lignes(0) <= '0';
                lignes(1) <= '0';
                lignes(2) <= '1';
                lignes(3) <= '0';            
            elsif numeroLigne = 3 then
                lignes(0) <= '0';
                lignes(1) <= '0';
                lignes(2) <= '0';
                lignes(3) <= '1';   
            else
                lignes(0) <= '0';
                lignes(1) <= '0';
                lignes(2) <= '0';
                lignes(3) <= '0';                        
            end if;
            
                
            --On actualise le clavier
            if colonnesOK = '1' then
                if numeroLigne = 0 then
                    clavier(0) <= colonnes(0);
                    clavier(1) <= colonnes(1);
                    clavier(2) <= colonnes(2);
                    clavier(3) <= colonnes(3);
                elsif numeroLigne = 1 then 
                    clavier(4) <= colonnes(0);
                    clavier(5) <= colonnes(1);
                    clavier(6) <= colonnes(2);
                    clavier(7) <= colonnes(3);     
                elsif numeroLigne = 2 then
                    clavier(8) <= colonnes(0);
                    clavier(9) <= colonnes(1);
                    clavier(10) <= colonnes(2);
                    clavier(11) <= colonnes(3);       
                elsif numeroLigne = 3 then
                    clavier(12) <= colonnes(0);
                    clavier(13) <= colonnes(1);
                    clavier(14) <= colonnes(2);
                    clavier(15) <= colonnes(3);
                else
                    clavier(0) <= '0';
                    clavier(1) <= '0';
                    clavier(2) <= '0';
                    clavier(3) <= '0';                    
                end if;
            else
                clavier <= clavier;
            end if;
        end if;
        
        --Enfin, si on a parcouru les 4 lignes, on peut actualiser clavier_all
        if numeroLigne = 0 then
            clavier_all <= clavier;
        else
            clavier_all <= clavier_all;
        end if;
    end process;
    
    --On met sur la sortie le clavier, actualisé tout d'un coup
    Clavier_OUT <= clavier_all;
    
end Behavioral;
