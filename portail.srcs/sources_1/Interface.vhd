----------------------------------------------------------------------------------
-- Company: ENSEA
-- Engineer: Alban Benmouffek, Salomé Wattiaux, Marco Guzzon
-- 
-- Create Date: 26.02.2019 14:49:50
-- Design Name: 
-- Module Name: Interface - Behavioral
-- Project Name: Portail
-- Target Devices: 
-- Tool Versions: 
-- Description: ce module gère les interactions avec l'utilisateur : saisie du code, télécommandes...
-- 
-- Dependencies: 
--  Digicode (Digicode.vhd)
--  Auth (Auth.vhd)
--  hautparleur (hautparleur.vhd)
--  Boutons (Boutons.vhd)
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Interface is
    generic (
        DigicodeOvertime : integer := 10 --Temps d'inactivité max du digicode (en secondes)
    );
    Port ( 
        --Clavier matriciel: (plus d'infos dans Digicode.vhd)
        lignes : out STD_LOGIC_VECTOR (3 downto 0);
        colonnes : in STD_LOGIC_VECTOR (3 downto 0);        
        
        --EENTREES DIVERSES:
        CLK : in STD_LOGIC; -- Horloge
        
        --Boutons:
        boutonOuvrir : in STD_LOGIC; -- vaut '1' si on veut ouvrir le portail
        boutonStop : in STD_LOGIC; -- vaut '1' si on veut fermer le portail
        boutonFermer : in STD_LOGIC; -- vaut '1' si on veut fermer le portail
        boutonChange : in STD_LOGIC; -- vaut '1' si on veut changer l'état du portail
        
        --SORTIES DIVERSES:
        ForceOuverture : out STD_LOGIC; --Demande d'ouverture du portail (activé que pendant une période d'horloge)
        ForceFermeture : out STD_LOGIC; --Demande de fermeture du portail (activé que pendant une période d'horloge)
        ControlSignal : out STD_LOGIC; --Demande de changement d'état du portail (comme si on avait une télécommande à 1 bouton) (activé que pendant une période d'horloge)
        Stop : out STD_LOGIC; --Demande d'arrêt du portail
        
        retroEclairageDigicode : out STD_LOGIC;
        LED_digicode : out STD_LOGIC_VECTOR(4 downto 0); --5 LED pour le digicode
        HP_digicode : out STD_LOGIC --Haut parleur pour le digicode
        
        );
end Interface;

architecture Behavioral of Interface is
    
    --Liaison auth <-> hautparleur
    signal auth_hautparleur_TonBip : STD_LOGIC;
    signal auth_hautparleur_repetitionBip : STD_LOGIC_VECTOR(2 downto 0);
    signal auth_hautparleur_DureeBip : STD_LOGIC_VECTOR(6 downto 0);
    signal auth_hautparleur_DataBip : STD_LOGIC;
    
    --Liaison auth <-> digicode
    signal digicode_auth_numeroTouche : STD_LOGIC_VECTOR (3 downto 0);
    signal digicode_auth_toucheDetectee : STD_LOGIC;
    
    --Liaison auth <-> boutons
    signal boutons_auth_boutonOuvrir : STD_LOGIC;
    signal boutons_auth_boutonStop : STD_LOGIC;
    signal boutons_auth_boutonFermer : STD_LOGIC;
    signal boutons_auth_boutonChange : STD_LOGIC;

begin
    digicode:       
        entity work.Digicode 
        port map(
            --Entrées:
            CLK=>CLK,  
            colonnes=>colonnes,
            --Sorties:
            lignes=>lignes, 
            numeroTouche => digicode_auth_numeroTouche,
            toucheDetectee => digicode_auth_toucheDetectee
        );
        
    boutons:
        entity work.Boutons
        port map(
            --Entrées:
            CLK => CLK,
            boutonOuvrir_IN => boutonOuvrir,
            boutonStop_IN => boutonStop,
            boutonFermer_IN => boutonFermer, 
            boutonChange_IN => boutonChange, 
            
            --Sorties:
            boutonOuvrir_OUT => boutons_auth_boutonOuvrir, 
            boutonStop_OUT => boutons_auth_boutonStop,
            boutonFermer_OUT => boutons_auth_boutonFermer,
            boutonChange_OUT => boutons_auth_boutonChange
        );

    
    auth:           
        entity work.Auth 
        generic map(
            DigicodeOvertime => DigicodeOvertime
        )
        port map(
            --Entrées:
            CLK => CLK, 
            numeroTouche => digicode_auth_numeroTouche,
            toucheDetectee => digicode_auth_toucheDetectee,
            boutonOuvrir => boutons_auth_boutonOuvrir, 
            boutonStop => boutons_auth_boutonStop,
            boutonFermer => boutons_auth_boutonFermer,
            boutonChange => boutons_auth_boutonChange,
            --Sorties:
            retroEclairageDigicode => retroEclairageDigicode,
            ForceOuverture => ForceOuverture,
            ForceFermeture => ForceFermeture,
            ControlSignal => ControlSignal, 
            Stop => Stop,
            LEDdigicode => LED_digicode,
            DataBip => auth_hautparleur_DataBip,
            NombreBip => auth_hautparleur_repetitionBip,
            DureeBip => auth_hautparleur_DureeBip,
            TonBip => auth_hautparleur_TonBip
        );
    
    hautparleur:
        entity work.HautParleur
        port map(
            --Entrées:
            CLK => CLK,
            duree => auth_hautparleur_DureeBip,
            repetition => auth_hautparleur_repetitionBip,
            ton_IN => auth_hautparleur_TonBip,
            incomingData => auth_hautparleur_DataBip,
            --Sorties:
            sound => HP_digicode
        );

end Behavioral;
