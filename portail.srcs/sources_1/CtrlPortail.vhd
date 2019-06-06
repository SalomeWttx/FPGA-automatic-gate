----------------------------------------------------------------------------------
-- Company: ENSEA
-- Engineer: Alban Benmouffek, Salomé Wattiaux, Marco Guzzon
-- 
-- Create Date: 25.02.2019 07:19:00
-- Design Name: 
-- Module Name: CtrlPortail - Behavioral
-- Project Name: Portail
-- Target Devices: 
-- Tool Versions: 
-- Description: ce module gère le fonctionnement du portail (moteur, éclairage, normes...)
--  Il s'agit d'une bonne grosse machine à états des familles.
-- 
-- Dependencies: 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CtrlPortail is
    Port ( 
        --Temporisations:
        Attente : out STD_LOGIC; -- Attente = '1' <=> Une temporisation (30s) est en cours
        Attente2s : out STD_LOGIC; -- Attente2s = '1' <=> Une temporisation (2s) est en cours
                 
        FinAttente : in STD_LOGIC; -- FinAttente = '1' <=> Fin de la temporisation (30s)         
        FinAttente2s : in STD_LOGIC; -- FinAttente2s = '1' <=> Fin de la temporisation (2s)
           
        --ENTREES DIVERSES:
        CLK : in STD_LOGIC; -- Horloge
        
        FinDeCourse : in STD_LOGIC_VECTOR (1 downto 0); --Capteur de fin de course
        -- FinDeCourse(1) = '1' <=> Portail Ferme ; FinDeCourse(0) = '1' <=> Portail Ouvert
        
        ControlSignal : in STD_LOGIC; --Demande de changement d'état du portail (comme si on avait une télécommande à 1 bouton) (activé que pendant une période d'horloge)
        ForceOuverture : in STD_LOGIC; --Demande d'ouverture du portail (activé que pendant une période d'horloge)
        ForceFermeture : in STD_LOGIC; --Demande de fermeture du portail (activé que pendant une période d'horloge)
        Stop : in STD_LOGIC; --Demande d'arrêt du portail
        
        Collision : in STD_LOGIC; -- Collision = '1' <=> Collision détectée

        
        --SORTIES DIVERSES:
        Clignottant : out STD_LOGIC; -- ..=1 <=> Le clignottant doit clignotter (ce signal est continu et sera traité par un autre module pour permettre à la LED de clignotter)
        Eclairage : out STD_LOGIC; -- ..=1 <=> Lampe puissante allumée
        
        --Contrôle du moteur:
        SensMoteur : out STD_LOGIC; -- SensMoteur = '1' <=> Ouverture
        NonSensMoteur : out STD_LOGIC; -- NonSensMoteur = '0' <=> Ouverture
        SignalMoteur : out STD_LOGIC -- SignalMoteur = '1' <=> Moteur en marche

    );
end CtrlPortail;

architecture Behavioral of CtrlPortail is
    --Liste des états: (l'utilité de chaque état est décrite dans le calcul de l'état futur)
    type liste_etat is (Ferme, AttenteAvantOuverture, Ouverture, Ouvert, StopOuverture, StopFermeture, ObstacleDetecte, VerifObstacle, AttenteAvantFermeture, Fermeture);
    signal ETAT_PR, ETAT_FU : liste_etat:=Ferme; --état par défaut
begin
    --Actualisation de l'état présent:
    process(CLK) begin
        if rising_edge(CLK) then
            ETAT_PR <= ETAT_FU;
        end if;
    end process;
    
    --Calcul de l'état futur:
    process(ETAT_PR, FinDeCourse, FinAttente, FinAttente2s, Collision, ControlSignal, ForceOuverture, ForceFermeture, Stop) begin
        case ETAT_PR is
            when Ferme => --Portail fermé
                if ControlSignal = '1' or ForceOuverture = '1' then --Ouverture demandée
                    ETAT_FU <= AttenteAvantOuverture;
                elsif FinDeCourse(1) = '0' then --Le portail est ouvert alors qu'il ne le dervait pas : on le ferme
                    ETAT_FU <= AttenteAvantFermeture;
                else
                    ETAT_FU <= Ferme;
                end if;
            when AttenteAvantOuverture => --2 secondes d'attente obligatoire avant l'activation du moteur (dans le sens ouverture)
                if ControlSignal = '1' or Stop = '1' then --Arrêt demandé
                    ETAT_FU <= StopFermeture;
                elsif FinAttente2s = '1' then --On a fini d'attendre les 2 secondes
                    ETAT_FU <= Ouverture;
                elsif FinDeCourse(0) = '1' then --Le portail est déjà ouvert, rien à faire
                    ETAT_FU <= Ouvert;
                else
                    ETAT_FU <= AttenteAvantOuverture;
                end if;
            when Ouverture => --Portail en ouverture
                if ControlSignal = '1' or Stop = '1' then --Arrêt demandé
                    ETAT_FU <= StopFermeture;
                elsif Collision = '1' then --Obstacle détecté !!
                    ETAT_FU <= ObstacleDetecte;
                elsif FinDeCourse(0) = '1' then --C'est bon, le portail est ouvert
                    ETAT_FU <= Ouvert;
                elsif ForceFermeture = '1' then --Fermeture demandée
                    ETAT_FU <= AttenteAvantFermeture;
                else
                    ETAT_FU <= Ouverture;
                end if;
            when Ouvert => --Portail ouvert
                if ControlSignal = '1' or FinAttente = '1' or ForceFermeture = '1' then --On a fini d'attendre 30 secondes, ou la fermeture est demandée
                    ETAT_FU <= AttenteAvantFermeture;
                elsif FinDeCourse(1) = '1' then --Portail fermé. Bizarre, soit.
                    ETAT_FU <= Ferme;
                else
                    ETAT_FU <= Ouvert;
                end if;
            when StopOuverture => --Le portail est à l'arrêt, et si on clique sur le bouton principal il va s'ouvrir
                if ControlSignal = '1' or ForceOuverture = '1' then --Ouverture demandée
                    ETAT_FU <= AttenteAvantOuverture;
                elsif FinAttente = '1' or ForceFermeture = '1' then --Fermeture demandée, ou 30 secondes sont passées
                    ETAT_FU <= AttenteAvantFermeture;
                elsif FinDeCourse(1) = '1' then
                    ETAT_FU <= Ferme;
                else
                    ETAT_FU <= StopOuverture;
                end if;
            when StopFermeture => --Le portail est à l'arrêt, et si on clique sur le bouton principal il va se fermer
                if ControlSignal = '1' or FinAttente = '1' or ForceFermeture = '1' then --Fermeture demandée, ou 30 secondes sont passées
                    ETAT_FU <= AttenteAvantFermeture;
                elsif ForceOuverture = '1' then --Ouverture demandée
                    ETAT_FU <= AttenteAvantOuverture;
                elsif FinDeCourse(1) = '1' then --Portail fermé. 
                    ETAT_FU <= Ferme;
                else
                    ETAT_FU <= StopFermeture;
                end if;
            when ObstacleDetecte => --Un obstacle a été detecté il y a moins de 2 secondes
                if FinAttente2s = '1' then --On a fini d'attendre 2 secondes
                    ETAT_FU <= VerifObstacle;
                elsif FinDeCourse(1) = '1' then --Portail fermé. 
                    ETAT_FU <= Ferme;
                else
                    ETAT_FU <= ObstacleDetecte;
                end if;
            when VerifObstacle => --On vérifie si l'obstacle est toujours présent
                if Collision = '0' then --Plus d'obstacle, tout va bien
                    ETAT_FU <= AttenteAvantOuverture;
                elsif FinDeCourse(1) = '1' then --Portail fermé. 
                    ETAT_FU <= Ferme;
                else --Il y a encore un obstacle, on attend encore 2 secondes supplémentaires
                    ETAT_FU <= ObstacleDetecte;
                end if;
            when AttenteAvantFermeture => --2 secondes d'attente obligatoire avant l'activation du moteur (dans le sens fermeture)
                if ControlSignal = '1' or Stop = '1' then --Arrêt demandé
                    ETAT_FU <= StopOuverture;
                elsif ForceOuverture = '1' then --Ouverture demandée
                    ETAT_FU <= AttenteAvantOuverture;
                elsif FinAttente2s = '1' then --On a fini d'attendre 2 secondes, on peut fermer le portail
                    ETAT_FU <= Fermeture;
                elsif FinDeCourse(1) = '1' then --Portail fermé. 
                    ETAT_FU <= Ferme;
                else
                    ETAT_FU <= AttenteAvantFermeture;
                end if;
            when Fermeture => --Portail en fermeture
                if ControlSignal = '1' or Stop = '1' then --Arrêt demandé
                    ETAT_FU <= StopOuverture;
                elsif Collision = '1' then --Obstacle détecté !!
                    ETAT_FU <= ObstacleDetecte;
                elsif ForceOuverture = '1' then --Ouverture demandée
                    ETAT_FU <= AttenteAvantOuverture;
                elsif FinDeCourse(1) = '1' then --Portail fermé
                    ETAT_FU <= Ferme;
                else
                    ETAT_FU <= Fermeture;
                end if;
            when others =>
                ETAT_FU <= Ferme;
        end case;
    end process;
    
    --Calcul des sorties:
    process(ETAT_PR) begin
        case ETAT_PR is
            when Ferme =>
                SignalMoteur <= '0';
                SensMoteur <= '0';
                NonSensMoteur <= '1';
                Eclairage <= '0';
                Clignottant <= '0';
                Attente <= '0';
                Attente2s <= '0';
            when AttenteAvantOuverture =>
                SignalMoteur <= '0';
                SensMoteur <= '0';
                NonSensMoteur <= '1';
                Eclairage <= '1';
                Clignottant <= '1';
                Attente <= '0';
                Attente2s <= '1';
            when Ouverture =>
                SignalMoteur <= '1';
                SensMoteur <= '1';
                NonSensMoteur <= '0';
                Eclairage <= '1';
                Clignottant <= '1';
                Attente <= '0';
                Attente2s <= '0';
            when Ouvert =>
                SignalMoteur <= '0';
                SensMoteur <= '0';
                NonSensMoteur <= '1';
                Eclairage <= '1';
                Clignottant <= '0';
                Attente <= '1';
                Attente2s <= '0';
            when StopOuverture =>
                SignalMoteur <= '0';
                SensMoteur <= '0';
                NonSensMoteur <= '1';
                Eclairage <= '1';
                Clignottant <= '0';
                Attente <= '1';
                Attente2s <= '0';
            when StopFermeture =>
                SignalMoteur <= '0';
                SensMoteur <= '0';
                NonSensMoteur <= '1';
                Eclairage <= '1';
                Clignottant <= '0';
                Attente <= '1';
                Attente2s <= '0';
            when AttenteAvantFermeture =>
                SignalMoteur <= '0';
                SensMoteur <= '0';
                NonSensMoteur <= '1';
                Eclairage <= '1';
                Clignottant <= '1';
                Attente <= '0';
                Attente2s <= '1';
            when Fermeture =>
                SignalMoteur <= '1';
                SensMoteur <= '0';
                NonSensMoteur <= '1';
                Eclairage <= '1';
                Clignottant <= '1';
                Attente <= '0';
                Attente2s <= '0';
            when ObstacleDetecte =>
                SignalMoteur <= '0';
                SensMoteur <= '0';
                NonSensMoteur <= '1';
                Eclairage <= '1';
                Clignottant <= '0';
                Attente <= '0';
                Attente2s <= '1';
            when VerifObstacle =>
                SignalMoteur <= '0';
                SensMoteur <= '0';
                NonSensMoteur <= '1';
                Eclairage <= '1';
                Clignottant <= '0';
                Attente <= '0';
                Attente2s <= '0';
            when others =>
                SignalMoteur <= '0';
                SensMoteur <= '0';
                NonSensMoteur <= '0';
                Eclairage <= '0';
                Clignottant <= '0';
                Attente <= '0';
                Attente2s <= '0';
        end case;
    end process;
    
end Behavioral;
