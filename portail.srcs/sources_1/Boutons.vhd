----------------------------------------------------------------------------------
-- Company: ENSEA
-- Engineer: Alban Benmouffek, Salomé Wattiaux, Marco Guzzon
-- 
-- Create Date: 25.02.2019 12:36:17
-- Design Name: 
-- Module Name: Boutons - Behavioral
-- Project Name: Portail
-- Target Devices: 
-- Tool Versions: 
-- Description: traite le signal recu de la part des boutons (applique au signal un anti pic, puis ne renvoie en sortie que les fronts montants de l'entrée)
--
-- Dependencies: 
--  TICK_1ms (TICK_1ms.vhd)
--  AntiPics_vectoriel (AntiPics_vectoriel.vhd)
--  DFM_vectoriel (DFM_vectoriel.vhd)

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Boutons is
    Port ( 
        CLK : in STD_LOGIC; --Horloge
        
        --ENTREES:
        boutonOuvrir_IN : in STD_LOGIC; -- vaut '1' si on veut ouvrir le portail
        boutonStop_IN : in STD_LOGIC; -- vaut '1' si on veut fermer le portail
        boutonFermer_IN : in STD_LOGIC; -- vaut '1' si on veut fermer le portail
        boutonChange_IN : in STD_LOGIC; -- vaut '1' si on veut changer l'état du portail
        
        --SORTIES:
        boutonOuvrir_OUT : out STD_LOGIC; -- vaut '1' si on veut ouvrir le portail
        boutonStop_OUT : out STD_LOGIC; -- vaut '1' si on veut fermer le portail
        boutonFermer_OUT : out STD_LOGIC; -- vaut '1' si on veut fermer le portail
        boutonChange_OUT : out STD_LOGIC -- vaut '1' si on veut changer l'état du portail
       
        
    );
end Boutons;

architecture Behavioral of Boutons is
    signal Tick1 : STD_LOGIC := '0'; --un 'Tick' toutes les ms
    
    signal brut : STD_LOGIC_VECTOR(3 downto 0) := "0000"; --Signaux recus directement de la part des boutons (vient de l'entrée)
    signal sansPic : STD_LOGIC_VECTOR(3 downto 0) := "0000"; --Signaux sans pics
    signal frontMontant : STD_LOGIC_VECTOR(3 downto 0) := "0000"; --Fronts montants (sera envoyé sur la sortie)
begin
    tick_1ms: 
        entity work.TICK_1ms 
        port map(
            --Entrées:
            CLK => CLK, 
            --Sorties:
            Tick => Tick1
        );
    
    antipic : 
        entity work.AntiPics_vectoriel 
        generic map (
            N => 100, --Retard introduit (en ms)
            dim => 4 --Nombre de touches
        ) 
        port map(
            --Entrées:
            CLK => CLK, 
            Tick => Tick1,
            Sig_IN => brut, 
            --Sorties:
            Sig_OUT => sansPic
        );

    dfm : 
        entity work.DFM_vectoriel 
        generic map (
            dim => 4 --Nombre de touches
        ) 
        port map (
            --Entrées:
            CLK => CLK, 
            entree => sansPic, 
            --Sorties:
            front => frontMontant
        );
    
    --Lecture des signaux d'entrée:
    brut(0) <= boutonOuvrir_IN;
    brut(1) <= boutonStop_IN;
    brut(2) <= boutonFermer_IN;
    brut(3) <= boutonChange_IN;
    

    --Sorties:
    boutonOuvrir_OUT <= frontMontant(0);
    boutonStop_OUT <= frontMontant(1);
    boutonFermer_OUT <= frontMontant(2);
    boutonChange_OUT <= frontMontant(3);
    
end Behavioral;
