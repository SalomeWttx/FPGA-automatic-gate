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
-- La sortie doit être reliée à un haut parleur.
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
        sound : out STD_LOGIC
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
