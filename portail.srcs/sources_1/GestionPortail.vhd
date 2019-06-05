----------------------------------------------------------------------------------
-- Company: ENSEA
-- Engineer: Alban Benmouffek, Salom� Wattiaux, Marco Guzzon 
-- 
-- Create Date: 01.03.2019 19:08:05
-- Design Name: 
-- Module Name: GestionPortail - Behavioral
-- Project Name: Portail
-- Target Devices: 
-- Tool Versions: 
-- Description: G�re les ordres donn�s au portail une fois que l'authentification est faite.
--      Les ordres sont directement envoy�s � l'entit� fonctionnement.
-- Ce module est une machine � �tats.
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
        
        --Ordres venant d'une t�l�commande:
        fonctionTelecommande : in STD_LOGIC_VECTOR(2 downto 0);
        
        --Ordres venant des boutons � l'int�rieur de la maison:
        fonctionBoutons : in STD_LOGIC_VECTOR(2 downto 0);
        
        
        
        --SORTIES:
        ControlSignal : out STD_LOGIC; --Demande de changement d'�tat du portail (comme si on avait une t�l�commande � 1 bouton) (activ� que pendant une p�riode d'horloge)
        ForceFermeture : out STD_LOGIC; --Demande de fermeture du portail (activ� que pendant une p�riode d'horloge)
        Stop : out STD_LOGIC; --Demande d'arr�t du portail
        ForceOuverture : out STD_LOGIC --Demande d'ouverture du portail (activ� que pendant une p�riode d'horloge)
    );
end GestionPortail;

architecture Behavioral of GestionPortail is
    --Liste des �tats:
    type liste_etat is (Attente, OrdreOuverture, OrdreChange, OrdreFermeture, OrdreStop);
    signal ETAT_PR, ETAT_FU : liste_etat:=Attente;
begin
    --Actualisation de l'�tat pr�sent:
    process(CLK) begin
        if rising_edge(CLK) then
            ETAT_PR <= ETAT_FU;
        end if;
    end process;
    
    --Calcul de l'�tat futur:
    process(ETAT_PR, fonctionDigicode, fonctionTelecommande, fonctionBoutons) begin
        case ETAT_PR is
            when Attente =>
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
            when OrdreOuverture =>
                ETAT_FU <= Attente;
            when OrdreChange =>
                ETAT_FU <= Attente;
            when OrdreFermeture =>
                ETAT_FU <= Attente;
            when OrdreStop =>
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
