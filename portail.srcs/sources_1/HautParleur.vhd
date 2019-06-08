----------------------------------------------------------------------------------
-- Company: ENSEA
-- Engineer: Alban Benmouffek, Salomé Wattiaux, Marco Guzzon
-- 
-- Create Date: 01.03.2019 14:44:11
-- Design Name: 
-- Module Name: HautParleur - Behavioral
-- Project Name: Portail
-- Target Devices: 
-- Tool Versions: 
-- Description: gestion du haut parleur. Permet de générer des bips de durée et de tonalité variable.
-- La sortie (sound) doit être reliée à un haut parleur.
-- 
-- Les bips peuvent être aigus (entrée ton_IN à '1') ou graves (entrée ton_IN à '0') 
-- Le nombre de répétitions est paramêtré en binaire par l'entrée repetition (maximum 7 répétitions)
-- La durée de chaque bip est égale à la durée séparant 2 bips consécutifs. Elle est paramêtrée par l'entrée duree (en 10ème de seconde, codé en binaire, max. 12.7s!)
--
-- Pour créer en bip, il faut pendant une période d'horloge saisir les paramêtres (détaillés ci-dessus) ET mettre l'entrée incomingData à '1'.
-- Le bip sera joué dès que l'entrée incomingData repasse à '0'.
--
-- Dependencies:
--  GenerateurDeBip (GenerateurDeBip.vhd)
--  tone (tone.vhd)
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity HautParleur is
    port (
        --ENTREES:
        CLK : in STD_LOGIC; --Horloge
        
        incomingData : in STD_LOGIC; --Vaut '1' pendant une période d'horloge quand des nouvelles données sont envoyées
        duree : in STD_LOGIC_VECTOR(6 downto 0); --Durée de chaque bip, ainsi que entre les bip, en dixieme de seconde MAX 12,7s !
        repetition : in STD_LOGIC_VECTOR(2 downto 0); --Nombre de répétitions. MAX 7 REPETITIONS!
        ton_IN : in STD_LOGIC;-- ton_IN = '1' <=> bip aigu!
        
        --SORTIES:
        sound : out STD_LOGIC --Signal directement envoyé à l'haut parleur
    );
end HautParleur;

architecture Behavioral of HautParleur is
    --Liaison tone <-> bip
    signal tone_bip_HautParleurdigicode : STD_LOGIC;
    signal tone_bip_TonBip : STD_LOGIC;
begin
    tone:
        entity work.tone
        port map(
            --Entrées:
            CLK => CLK,
            duree => duree,
            repetition => repetition,
            ton_IN => ton_IN,
            incomingData => incomingData,
            --Sorties:
            ton_OUT => tone_bip_TonBip,
            active => tone_bip_HautParleurdigicode
        );
    
    bip:            
        entity work.GenerateurDeBip 
        port map(
            --Entrées:
            CLK => CLK, 
            active => tone_bip_HautParleurdigicode, 
            tonalite => tone_bip_TonBip, 
            --Sorties:
            sound => sound
        );
end Behavioral;
