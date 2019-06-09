----------------------------------------------------------------------------------
-- Company: ENSEA
-- Engineer: Alban Benmouffek, Salomé Wattiaux, Marco Guzzon 
-- 
-- Create Date: 01.03.2019 19:08:05
-- Design Name: 
-- Module Name: GestionPortail - Behavioral
-- Project Name: Portail
-- Target Devices: 
-- Tool Versions: 
-- Description: Gère les ordres donnés au portail une fois que l'authentification est faite.
--      Les ordres sont directement envoyés à l'entité fonctionnement.
-- Ce module est une machine à états.
-- 
-- Dependencies: 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity GestionPortail is
    port (
        --ENTREES:
        CLK : in STD_LOGIC;--Horloge
        
        --ORDRES:
        --rien : "000"
        --changer : "011"
        --ouvrir : "001"
        --fermer : "010"
        --stop : "111"
        
        --Ordres venant du Digicode:
        fonctionDigicode : in STD_LOGIC_VECTOR(2 downto 0);
        
        --Ordres venant d'une télécommande:
        fonctionTelecommande : in STD_LOGIC_VECTOR(2 downto 0);
        
        --Ordres venant des boutons à l'intérieur de la maison:
        fonctionBoutons : in STD_LOGIC_VECTOR(2 downto 0);
        
        
        
        --SORTIES:
        ControlSignal : out STD_LOGIC; --Demande de changement d'état du portail (comme si on avait une télécommande à 1 bouton) (activé que pendant une période d'horloge)
        ForceFermeture : out STD_LOGIC; --Demande de fermeture du portail (activé que pendant une période d'horloge)
        Stop : out STD_LOGIC; --Demande d'arrêt du portail
        ForceOuverture : out STD_LOGIC --Demande d'ouverture du portail (activé que pendant une période d'horloge)
    );
end GestionPortail;

architecture Behavioral of GestionPortail is
    --Liste des états:
    type liste_etat is (Attente, OrdreOuverture, OrdreChange, OrdreFermeture, OrdreStop);
    signal ETAT_PR, ETAT_FU : liste_etat:=Attente;
begin
    --Actualisation de l'état présent:
    process(CLK) begin
        if rising_edge(CLK) then
            ETAT_PR <= ETAT_FU;
        end if;
    end process;
    
    --Calcul de l'état futur:
    process(ETAT_PR, fonctionDigicode, fonctionTelecommande, fonctionBoutons) begin
        case ETAT_PR is
            when Attente => --On est dans l'attente de recevoir un ordre
                if fonctionDigicode = "011" or fonctionTelecommande = "011" or fonctionBoutons = "011" then
                    ETAT_FU <= OrdreChange;
                elsif fonctionDigicode = "001" or fonctionTelecommande = "001" or fonctionBoutons = "001" then
                    ETAT_FU <= OrdreOuverture;
                elsif fonctionDigicode = "010" or fonctionTelecommande = "010" or fonctionBoutons = "010" then
                    ETAT_FU <= OrdreFermeture;
                elsif fonctionDigicode = "111" or fonctionTelecommande = "111" or fonctionBoutons = "111" then
                    ETAT_FU <= OrdreStop;
                else
                    ETAT_FU <= Attente;
                end if;
            when OrdreOuverture => --On a reçu l'ordre d'ouvrir le portail
                ETAT_FU <= Attente;
            when OrdreChange => --On a reçu l'ordre de changer l'état du portail
                ETAT_FU <= Attente;
            when OrdreFermeture => --On a reçu l'ordre de fermer le portail
                ETAT_FU <= Attente;
            when OrdreStop => --On a reçu l'ordre d'arrêter le portail
                ETAT_FU <= Attente;
            when others =>
                ETAT_FU <= Attente;
        end case;
    end process;
    
    --Calcul des sorties:
    process(ETAT_PR) begin
        case ETAT_PR is
            when Attente =>
                ControlSignal <= '0';
                ForceOuverture <= '0';
                ForceFermeture <= '0';
                Stop <= '0';
            when OrdreOuverture =>
                ControlSignal <= '0';
                ForceOuverture <= '1';
                ForceFermeture <= '0';
                Stop <= '0';
            when OrdreChange =>
                ControlSignal <= '1';
                ForceOuverture <= '0';
                ForceFermeture <= '0';
                Stop <= '0';
            when OrdreFermeture =>
                ControlSignal <= '0';
                ForceOuverture <= '0';
                ForceFermeture <= '1';
                Stop <= '0';
            when OrdreStop =>
                ControlSignal <= '0';
                ForceOuverture <= '0';
                ForceFermeture <= '0';
                Stop <= '1';
            when others =>
                ControlSignal <= '0';
                ForceOuverture <= '0';
                ForceFermeture <= '0';
                Stop <= '0';
        end case;
    end process;
end Behavioral;
