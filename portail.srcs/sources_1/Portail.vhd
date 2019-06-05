----------------------------------------------------------------------------------
-- Company: ENSEA
-- Engineer: Alban Benmouffek, Salomé Wattiaux, Marco Guzzon
-- 
-- Create Date: 25.02.2019 11:20:45
-- Design Name: 
-- Module Name: Portail - Behavioral
-- Project Name: Portail
-- Target Devices: 
-- Tool Versions: 
-- Description: Ce module contient toute la partie numérique dans le fonctionnement d'un portail automatique. 
--      Après avoir implémenté ce code dans un FPGA, il faudra y connecter:
--      -Le clavier matriciel (digicode)
--      -L'interface moteur (pont en H et capteur de courant)
--      -L'horloge (oscillateur à quartz)
--      -Les capteurs de fin de course
--      -Toutes les LED
--      -L'Haut Parleur du Digicode
--      -Les détecteurs d'obstacle
-- 
-- Dependencies: 
--  Fonctionnement (Fonctionnement.vhd)
--  Interface (Interface.vhd)
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Portail is
    Generic (
        TempsMaxPortailNonFerme : integer := 60; --temps maximal ou le portail reste non fermé (en secondes)
        DigicodeOvertime : integer := 10; --Temps d'inactivité max du digicode (en secondes)

        duty : integer := 80  --duty cycle du PWM, en %
         );
    Port ( 
        --Clavier matriciel: (plus d'infos dans Digicode.vhd)
        lignes : out STD_LOGIC_VECTOR (3 downto 0);
        colonnes : in STD_LOGIC_VECTOR (3 downto 0);        
        
        --ENTREES DIVERSES:
        CLK : in STD_LOGIC; -- Horloge
        bouton : in STD_LOGIC; --bouton
        
        FinDeCourse : in STD_LOGIC_VECTOR (1 downto 0); --Capteur de fin de course
        -- FinDeCourse(1) = '1' <=> Portail Ferme ; FinDeCourse(0) = '1' <=> Portail Ouvert 
        
        InfoCourant : in STD_LOGIC; --Signal indiquant si le moteur est bloqué ou non

        --SORTIES DIVERSES:
        LED_Clignottant : out STD_LOGIC; --Clignottant orange
        LED_Eclairage : out STD_LOGIC; --Eclairage puissant autour du portail
        LED_digicode : out STD_LOGIC_VECTOR(4 downto 0); --5 LED pour le digicode
        retroEclairageDigicode : out STD_LOGIC;
        HP_digicode : out STD_LOGIC; --Haut parleur pour le digicode
        --Contrôle du moteur:
        NonSensMoteur : out STD_LOGIC; 
        SensMoteur : out STD_LOGIC; -- SensMoteur = '1' <=> Ouverture
        SignalMoteur : out STD_LOGIC -- SignalMoteur = '1' <=> Moteur en marche
        );
end Portail;

architecture Behavioral of Portail is
    --Liaison interface <-> fonctionnement
    signal interface_fonctionnement_ControlSignal : STD_LOGIC;
    signal interface_fonctionnement_ForceOuverture : STD_LOGIC;
    signal interface_fonctionnement_ForceFermeture : STD_LOGIC;
    signal interface_fonctionnement_Stop : STD_LOGIC;
    
    signal FinDeCourseSignal : STD_LOGIC_VECTOR (1 downto 0);
begin
    FinDeCourseSignal(0) <= not(FinDeCourse(0));
    FinDeCourseSignal(1) <= FinDeCourse(1);
    
    fonctionnement:    
        entity work.Fonctionnement
        generic map(
            duty => duty,
            TempsMaxPortailNonFerme => TempsMaxPortailNonFerme --temps maximal ou le portail reste non fermé (en secondes)
        )
        port map(
            --Entrées:
            CLK => CLK, 
            FinDeCourse => FinDeCourseSignal, 
            ControlSignal => interface_fonctionnement_ControlSignal, 
            ForceOuverture => interface_fonctionnement_ForceOuverture,
            ForceFermeture => interface_fonctionnement_ForceFermeture,
            Stop => interface_fonctionnement_Stop,
            --Sorties:
            LED_clignottant => LED_clignottant, 
            LED_Eclairage => LED_Eclairage, 
            SensMoteur => SensMoteur, 
            NonSensMoteur => NonSensMoteur,
            SignalMoteur => SignalMoteur, 
            InfoCourant => InfoCourant
        );
    
    interface:     
        entity work.Interface 
        generic map (
            DigicodeOvertime => DigicodeOvertime
        )
        port map(
            --Entrées:
            CLK => CLK, 
            colonnes => colonnes,
            boutonOuvrir => '0', 
            boutonStop => '0',
            boutonFermer => '0',
            boutonChange => bouton,
            --Sorties:
            ForceOuverture => interface_fonctionnement_ForceOuverture,
            ForceFermeture => interface_fonctionnement_ForceFermeture,
            ControlSignal => interface_fonctionnement_ControlSignal,
            Stop => interface_fonctionnement_Stop,
            LED_digicode => LED_digicode,
            lignes => lignes,
            retroEclairageDigicode => retroEclairageDigicode,
            HP_digicode => HP_digicode
        );
    
end Behavioral;
