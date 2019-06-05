----------------------------------------------------------------------------------
-- Company: ENSEA
-- Engineer: Alban Benmouffek, Salom� Wattiaux, Marco Guzzon
-- 
-- Create Date: 25.02.2019 16:31:37
-- Design Name: 
-- Module Name: Auth - Behavioral
-- Project Name: Portail
-- Target Devices: 
-- Tool Versions: 
-- Description: authentifie le propri�taire, et envoie les signaux permettant de contr�ler le portail
--
-- Dependencies: 
--  GestionCode (GestionCode.vhd)
--  GestionPortail (GestionPortail.vhd)
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Auth is
    generic (
        DigicodeOvertime : integer := 10 --Temps d'inactivit� max du digicode (en secondes)
    );
    Port ( 
        --ENTREES DIVERSES:
        CLK : in STD_LOGIC; --Horloge
        
        --Boutons:
        boutonOuvrir : in STD_LOGIC; -- vaut '1' si on veut ouvrir le portail
        boutonStop : in STD_LOGIC; -- vaut '1' si on veut fermer le portail
        boutonFermer : in STD_LOGIC; -- vaut '1' si on veut fermer le portail
        boutonChange : in STD_LOGIC; -- vaut '1' si on veut changer l'�tat du portail
        
        --Info venant du digicode:
        numeroTouche : in STD_LOGIC_VECTOR (3 downto 0); --num�ro de la touche press�e
        toucheDetectee : in STD_LOGIC; --vaut '1' pendant une p�riode d'horloge si un nouvel appui est d�tect�
        
        --SORTIES DIVERSES:
        --Contr�le du portail
        ForceOuverture : out STD_LOGIC; --Demande d'ouverture du portail (activ� que pendant une p�riode d'horloge)
        ForceFermeture : out STD_LOGIC; --Demande de fermeture du portail (activ� que pendant une p�riode d'horloge)
        ControlSignal : out STD_LOGIC; --Demande de changement d'�tat du portail (comme si on avait une t�l�commande � 1 bouton) (activ� que pendant une p�riode d'horloge)
        Stop : out STD_LOGIC; --Demande d'arr�t du portail

        
        --haut parleur
        NombreBip : out STD_LOGIC_VECTOR(2 downto 0); --Nombre de r�p�titions. MAX 7 REPETITIONS!
        DureeBip : out STD_LOGIC_VECTOR(6 downto 0);--Dur�e de chaque bip, ainsi que entre les bip, en dixieme de seconde MAX 12,7s !
        TonBip : out STD_LOGIC; -- ..=1 <=> bip aigu!
        DataBip : out STD_LOGIC;--Vaut '1' pendant une p�riode d'horloge quand des nouvelles donn�es sont envoy�es
        --LED
        retroEclairageDigicode : out STD_LOGIC;
        LEDdigicode : out STD_LOGIC_VECTOR(4 downto 0)
    );
end Auth;

architecture Behavioral of Auth is
    --Liaison gestion <-> code:
    signal code_gestion_fonctionDigicode : STD_LOGIC_VECTOR(2 downto 0);
    
    --Liaison gestion <-> telecommandes
    signal telecommandes_gestion_fonctionTelecommande : STD_LOGIC_VECTOR(2 downto 0);
    
    --Liaison boutons <-> gestion
    signal boutons_gestion_fonctionBoutons : STD_LOGIC_VECTOR(2 downto 0);

begin
    code:
        entity work.GestionCode
        generic map(
            TempsAttenteMax => DigicodeOvertime
        )
        port map(
            --Entr�es:
            CLK => CLK,
            numeroTouche => numeroTouche,
            toucheDetectee => toucheDetectee,
            --Sorties:
            retroEclairage => retroEclairageDigicode,
            LEDdigicode => LEDdigicode,
            NombreBip => NombreBip,
            DureeBip => DureeBip,
            TonBip => TonBip,
            DataBip => DataBip,
            fonction => code_gestion_fonctionDigicode
        );
    
    telecommandes:
        entity work.GestionTelecommunications
        port map (
            --Entr�es:
            CLK => CLK,
            --Sorties:
            fonction => telecommandes_gestion_fonctionTelecommande
        );
    
    boutons:
        entity work.GestionBoutons
        port map (
            --Entr�es:
            CLK => CLK,
            boutonOuvrir => boutonOuvrir,
            boutonFermer => boutonFermer,
            boutonStop => boutonStop,
            boutonChange => boutonChange,
            --Sorties:
            fonction => boutons_gestion_fonctionBoutons
        );
    
    gestion:
        entity work.GestionPortail
        port map (
            --Entr�es:
            CLK => CLK,
            fonctionDigicode => code_gestion_fonctionDigicode,
            fonctionTelecommande => telecommandes_gestion_fonctionTelecommande,
            fonctionBoutons => boutons_gestion_fonctionBoutons,
            --Sorties:
            ControlSignal => ControlSignal,
            ForceFermeture => ForceFermeture,
            Stop => Stop,
            ForceOuverture => ForceOuverture
        );
end Behavioral;
