----------------------------------------------------------------------------------
-- Company: ENSEA
-- Engineer: Alban Benmouffek, Salom� Wattiaux, Marco Guzzon
-- 
-- Create Date: 25.02.2019 07:19:00
-- Design Name: 
-- Module Name: CtrlPortail - Behavioral
-- Project Name: Portail
-- Target Devices: 
-- Tool Versions: 
-- Description: ce module g�re le fonctionnement du portail (moteur, �clairage, normes...)
--  Il s'agit d'une bonne grosse machine � �tats des familles.
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
        
        ControlSignal : in STD_LOGIC; --Demande de changement d'�tat du portail (comme si on avait une t�l�commande � 1 bouton) (activ� que pendant une p�riode d'horloge)
        ForceOuverture : in STD_LOGIC; --Demande d'ouverture du portail (activ� que pendant une p�riode d'horloge)
        ForceFermeture : in STD_LOGIC; --Demande de fermeture du portail (activ� que pendant une p�riode d'horloge)
        Stop : in STD_LOGIC; --Demande d'arr�t du portail
        
        Collision : in STD_LOGIC; -- Collision = '1' <=> Collision d�tect�e

        
        --SORTIES DIVERSES:
        Clignottant : out STD_LOGIC; -- ..=1 <=> Le clignottant doit clignotter (ce signal est continu et sera trait� par un autre module pour permettre � la LED de clignotter)
        Eclairage : out STD_LOGIC; -- ..=1 <=> Lampe puissante allum�e
        
        --Contr�le du moteur:
        SensMoteur : out STD_LOGIC; -- SensMoteur = '1' <=> Ouverture
        NonSensMoteur : out STD_LOGIC; -- NonSensMoteur = '0' <=> Ouverture
        SignalMoteur : out STD_LOGIC -- SignalMoteur = '1' <=> Moteur en marche

    );
end CtrlPortail;

architecture Behavioral of CtrlPortail is
    --Liste des �tats:
    type liste_etat is (Ferme, AttenteAvantOuverture, Ouverture, Ouvert, StopOuverture, StopFermeture, ObstacleDetecte, VerifObstacle, AttenteAvantFermeture, Fermeture);
    signal ETAT_PR, ETAT_FU : liste_etat:=Ferme; --�tat par d�faut
begin
    --Actualisation de l'�tat pr�sent:
    process(CLK) begin
        if rising_edge(CLK) then
            ETAT_PR <= ETAT_FU;
        end if;
    end process;
    
    --Calcul de l'�tat futur:
    process(ETAT_PR, FinDeCourse, FinAttente, FinAttente2s, Collision, ControlSignal, ForceOuverture, ForceFermeture, Stop) begin
        case ETAT_PR is
            when Ferme =>
                if ControlSignal = '1' or ForceOuverture = '1' then
                    ETAT_FU <= AttenteAvantOuverture;
                elsif FinDeCourse(1) = '0' then
                    ETAT_FU <= AttenteAvantFermeture;
                else
                    ETAT_FU <= Ferme;
                end if;
            when AttenteAvantOuverture =>
                if ControlSignal = '1' or Stop = '1' then
                    ETAT_FU <= StopFermeture;
                elsif FinAttente2s = '1' then
                    ETAT_FU <= Ouverture;
                elsif FinDeCourse(0) = '1' then
                    ETAT_FU <= Ouvert;
                else
                    ETAT_FU <= AttenteAvantOuverture;
                end if;
            when Ouverture =>
                if ControlSignal = '1' or Stop = '1' then
                    ETAT_FU <= StopFermeture;
                elsif Collision = '1' then
                    ETAT_FU <= ObstacleDetecte;
                elsif FinDeCourse(0) = '1' then
                    ETAT_FU <= Ouvert;
                elsif ForceFermeture = '1' then
                    ETAT_FU <= AttenteAvantFermeture;
                else
                    ETAT_FU <= Ouverture;
                end if;
            when Ouvert =>
                if ControlSignal = '1' or FinAttente = '1' or ForceFermeture = '1' then
                    ETAT_FU <= AttenteAvantFermeture;
                elsif FinDeCourse(1) = '1' then
                    ETAT_FU <= Ferme;
                else
                    ETAT_FU <= Ouvert;
                end if;
            when StopOuverture =>
                if ControlSignal = '1' or ForceOuverture = '1' then
                    ETAT_FU <= AttenteAvantOuverture;
                elsif FinAttente = '1' or ForceFermeture = '1' then
                    ETAT_FU <= AttenteAvantFermeture;
                elsif FinDeCourse(1) = '1' then
                    ETAT_FU <= Ferme;
                else
                    ETAT_FU <= StopOuverture;
                end if;
            when StopFermeture =>
                if ControlSignal = '1' or FinAttente = '1' or ForceFermeture = '1' then
                    ETAT_FU <= AttenteAvantFermeture;
                elsif ForceOuverture = '1' then
                    ETAT_FU <= AttenteAvantOuverture;
                elsif FinDeCourse(1) = '1' then
                    ETAT_FU <= Ferme;
                else
                    ETAT_FU <= StopFermeture;
                end if;
            when ObstacleDetecte =>
                if FinAttente2s = '1' then
                    ETAT_FU <= VerifObstacle;
                elsif FinDeCourse(1) = '1' then
                    ETAT_FU <= Ferme;
                else
                    ETAT_FU <= ObstacleDetecte;
                end if;
            when VerifObstacle =>
                if Collision = '0' then
                    ETAT_FU <= AttenteAvantOuverture;
                elsif FinDeCourse(1) = '1' then
                    ETAT_FU <= Ferme;
                else
                    ETAT_FU <= ObstacleDetecte;
                end if;
            when AttenteAvantFermeture =>
                if ControlSignal = '1' or Stop = '1' then
                    ETAT_FU <= StopOuverture;
                elsif ForceOuverture = '1' then
                    ETAT_FU <= AttenteAvantOuverture;
                elsif FinAttente2s = '1' then
                    ETAT_FU <= Fermeture;
                elsif FinDeCourse(1) = '1' then
                    ETAT_FU <= Ferme;
                else
                    ETAT_FU <= AttenteAvantFermeture;
                end if;
            when Fermeture =>
                if ControlSignal = '1' or Stop = '1' then
                    ETAT_FU <= StopOuverture;
                elsif Collision = '1' then
                    ETAT_FU <= ObstacleDetecte;
                elsif ForceOuverture = '1' then
                    ETAT_FU <= AttenteAvantOuverture;
                elsif FinDeCourse(1) = '1' then
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
