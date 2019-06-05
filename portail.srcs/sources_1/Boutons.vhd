----------------------------------------------------------------------------------
-- Company: ENSEA
-- Engineer: Alban Benmouffek, Salom� Wattiaux, Marco Guzzon
-- 
-- Create Date: 25.02.2019 12:36:17
-- Design Name: 
-- Module Name: Boutons - Behavioral
-- Project Name: Portail
-- Target Devices: 
-- Tool Versions: 
-- Description: traite le signal recu de la part des boutos (anti pic et DFM)
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
        boutonChange_IN : in STD_LOGIC; -- vaut '1' si on veut changer l'�tat du portail
        
        --SORTIES:
        boutonOuvrir_OUT : out STD_LOGIC; -- vaut '1' si on veut ouvrir le portail
        boutonStop_OUT : out STD_LOGIC; -- vaut '1' si on veut fermer le portail
        boutonFermer_OUT : out STD_LOGIC; -- vaut '1' si on veut fermer le portail
        boutonChange_OUT : out STD_LOGIC -- vaut '1' si on veut changer l'�tat du portail
       
        
    );
end Boutons;

architecture Behavioral of Boutons is
    signal Tick1 : STD_LOGIC := '0'; --un 'Tick' toutes les ms
    
    signal brut : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal sansPic : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal frontMontant : STD_LOGIC_VECTOR(3 downto 0) := "0000";
begin
    tick_1ms: 
        entity work.TICK_1ms 
        port map(
            --Entr�es:
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
            --Entr�es:
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
            --Entr�es:
            CLK => CLK, 
            entree => sansPic, 
            --Sorties:
            front => frontMontant
        );
    
    brut(0) <= boutonOuvrir_IN;
    brut(1) <= boutonStop_IN;
    brut(2) <= boutonFermer_IN;
    brut(3) <= boutonChange_IN;
    
    boutonOuvrir_OUT <= frontMontant(0);
    boutonStop_OUT <= frontMontant(1);
    boutonFermer_OUT <= frontMontant(2);
    boutonChange_OUT <= frontMontant(3);
    
end Behavioral;
