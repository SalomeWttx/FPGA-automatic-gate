----------------------------------------------------------------------------------
-- Company: ENSEA
-- Engineer: Alban Benmouffek, Salomé Wattiaux, Marco Guzzon
-- 
-- Create Date: 26.02.2019 14:49:28
-- Design Name: 
-- Module Name: Fonctionnement - Behavioral
-- Project Name: Portail
-- Target Devices: 
-- Tool Versions: 
-- Description: ce module gère le fonctionnement du portail : détection d'obstacle, contrôle du moteur, éclairage...
-- 
-- Dependencies: 
--  detecteurObstacle (detecteurObstacle.vhd)
--  ctrlPortail (ctrlPortail.vhd)
--  Attendre (Attendre.vhd)
--  Cligno (Cligno.vhd)
--  PWM (PWM.vhd)
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Fonctionnement is
    Generic (
        TempsMaxPortailNonFerme : integer := 60; --temps maximal ou le portail reste non fermé (en secondes)
        
        duty : integer := 80  --duty cycle du PWM, en %
        );
    Port (
        --ENTREES DIVERSES:
        CLK : in STD_LOGIC; -- Horloge
        
        FinDeCourse : in STD_LOGIC_VECTOR (1 downto 0); --Capteur de fin de course
        -- FinDeCourse(1) = '1' <=> Portail Ferme ; FinDeCourse(0) = '1' <=> Portail Ouvert
        
        ControlSignal : in STD_LOGIC; --Demande de changement d'état du portail (comme si on avait une télécommande à 1 bouton) (activé que pendant une période d'horloge)
        ForceOuverture : in STD_LOGIC; --Demande d'ouverture du portail (activé que pendant une période d'horloge)
        ForceFermeture : in STD_LOGIC; --Demande de fermeture du portail (activé que pendant une période d'horloge)
        Stop : in STD_LOGIC; --Demande d'arrêt du portail

        InfoCourant : in STD_LOGIC; --Signal indiquant si le moteur est bloqué ou non
                
        --SORTIES DIVERSES:
        LED_Clignottant : out STD_LOGIC; --Clignottant orange
        LED_Eclairage : out STD_LOGIC; --Eclairage puissant autour du portail
        
        --Contrôle du moteur:
        SensMoteur : out STD_LOGIC; -- SensMoteur = '1' <=> Ouverture
        NonSensMoteur : out STD_LOGIC; -- NonSensMoteur = '0' <=> Ouverture
        SignalMoteur : out STD_LOGIC -- SignalMoteur = '1' <=> Moteur en marche
        );
end Fonctionnement;

architecture Behavioral of Fonctionnement is
    --Liaison ctrlPortail <-> attendre2s
    signal ctrlPortail_attendre2s_Attente2s : STD_LOGIC;
    signal attente2s_ctrlPortail_FinAttente2s : STD_LOGIC;    
    
    --Liaison ctrlPortail <-> attendre30s
    signal ctrlPortail_attendre30s_Attente : STD_LOGIC;
    signal attente30s_ctrlPortail_FinAttente : STD_LOGIC;
    
    --Liaison ctrlPortail <-> cligno
    signal ctrlPortail_cligno_Clignottant : STD_LOGIC;
    
    --Liaison ctrlPortail <-> detecteur
    signal detecteur_ctrlPortail_Collision : STD_LOGIC;
    
    --Liaison ctrlPortail <-> PWM
    signal ctrlPortail_PWM_SignalMoteur : STD_LOGIC;
    
    --Infos Moteur (permet de lier detecteur, PWM, et CtrlPortail) :
    signal sig_SensMoteur : STD_LOGIC;
    signal sig_SignalMoteur : STD_LOGIC;
    signal SignalMoteur_PWM : STD_LOGIC;
begin
    
    detecteur:
        entity work.detecteurObstacle
        port map(
            --Entrées:
            CLK => CLK,
            InfoCourant => InfoCourant,
            SensMoteur => sig_SensMoteur,
            SignalMoteur => sig_SignalMoteur,
            --Sorties:
            collision => detecteur_ctrlPortail_Collision
        );
    
    PWM:
        entity work.PWM
        generic map(
            duty => duty
        )
        port map(
            --Entrées:
            CLK => CLK,
            entree => ctrlPortail_PWM_SignalMoteur,
            --Sorties:
            sortie => SignalMoteur_PWM
        );
    
    ctrlPortail:    
        entity work.ctrlPortail 
        port map(
            --Entrées:
            CLK => CLK, 
            FinDeCourse => FinDeCourse, 
            ControlSignal => ControlSignal, 
            ForceOuverture => ForceOuverture,
            ForceFermeture => ForceFermeture,
            Stop => Stop,
            Collision => detecteur_ctrlPortail_Collision,
            FinAttente => attente30s_ctrlPortail_FinAttente, 
            FinAttente2s => attente2s_ctrlPortail_FinAttente2s,
            --Sorties:
            Attente => ctrlPortail_attendre30s_Attente, 
            Attente2s => ctrlPortail_attendre2s_Attente2s, 
            Clignottant => ctrlPortail_cligno_Clignottant, 
            Eclairage => LED_Eclairage, 
            SensMoteur => sig_SensMoteur, 
            NonSensMoteur => NonSensMoteur,
            SignalMoteur => sig_SignalMoteur
        );
    
    attendre2s:     
        entity work.Attendre 
        generic map(
            Duree => 2 --Durée de l'attente, en secondes
        ) 
        port map(
            --Entrées:
            CLK => CLK, 
            Attente => ctrlPortail_attendre2s_Attente2s, 
            ForceReset => '0',
            --Sorties:
            FinAttente => attente2s_ctrlPortail_FinAttente2s
        );
    
    attendre30s:    
        entity work.Attendre 
        generic map(
            Duree => TempsMaxPortailNonFerme --Durée de l'attente, en secondes
        ) 
        port map(
            --Entrées:
            CLK => CLK,
            Attente => ctrlPortail_attendre30s_Attente, 
            ForceReset => '0',
            --Sorties:
            FinAttente => attente30s_ctrlPortail_FinAttente
        );
    
    cligno:         
        entity work.Cligno 
        port map(
            --Entrées:
            CLK => CLK, 
            active => ctrlPortail_cligno_Clignottant, 
            --Sorties:
            lampe => LED_Clignottant
        );

    ctrlPortail_PWM_SignalMoteur <= sig_SignalMoteur;
    SensMoteur <= sig_SensMoteur;
    SignalMoteur <= SignalMoteur_PWM;
end Behavioral;
