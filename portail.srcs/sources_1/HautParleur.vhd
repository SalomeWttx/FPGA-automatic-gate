----------------------------------------------------------------------------------
-- Company: ENSEA
-- Engineer: Alban Benmouffek, Salom� Wattiaux, Marco Guzzon
-- 
-- Create Date: 01.03.2019 14:44:11
-- Design Name: 
-- Module Name: HautParleur - Behavioral
-- Project Name: Portail
-- Target Devices: 
-- Tool Versions: 
-- Description: gestion du haut parleur. Permet de g�n�rer des bips de dur�e et de tonalit� variable.
-- La sortie doit �tre reli�e � un haut parleur.
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
        
        incomingData : in STD_LOGIC; --Vaut '1' pendant une p�riode d'horloge quand des nouvelles donn�es sont envoy�es
        duree : in STD_LOGIC_VECTOR(6 downto 0); --Dur�e de chaque bip, ainsi que entre les bip, en dixieme de seconde MAX 12,7s !
        repetition : in STD_LOGIC_VECTOR(2 downto 0); --Nombre de r�p�titions. MAX 7 REPETITIONS!
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
            --Entr�es:
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
            --Entr�es:
            CLK => CLK, 
            active => tone_bip_HautParleurdigicode, 
            tonalite => tone_bip_TonBip, 
            --Sorties:
            sound => sound
        );
end Behavioral;
