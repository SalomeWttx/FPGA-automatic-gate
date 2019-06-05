----------------------------------------------------------------------------------
-- Company: ENSEA
-- Engineer: Alban Benmouffek, Salomé Wattiaux, Marco Guzzon
-- 
-- Create Date: 25.02.2019 12:36:17
-- Design Name: 
-- Module Name: Digicode - Behavioral
-- Project Name: Portail
-- Target Devices: 
-- Tool Versions: 
-- Description: lit un clavier matriciel (4 lignes, 4 colonnes)
--      Fonctionnement:
--          Les lignes sont des sorties. Les colonnes des entrées.
--          Toutes les lignes sont mises au niveau '0' sauf une (la ligne à '1'
--          change très rapidement). Les colonnes à '1' correspondent donc à un appui sur un bouton.
--
--touche      colonnes(0)     colonnes(1)     colonnes(2)     colonnes(3)
--lignes(0)       1               2               3              10
--lignes(1)       4               5               6              11
--lignes(2)       7               8               9              12
--lignes(3)       15              0              14              13
--
-- Quand une touche est détectée, l'info est envoyée dans numeroTouche tel que ci-dessus, pendant une période d'horloge.
-- Quand l'info est envoyée, on met à '1' toucheDetectee. La détection d'une touche se fait sur front montant unuiquement.
--
-- Ce module contient une fonctionnalité Anti Pic, introduisant un retard de quelques ms (20ms par défaut).
-- Hormis ce module, le clavier (Brut) est actualisé toutes les 8ms. Ce paramètre peut être changé via la variable N de tick_Nms.
-- Dans ce cas, le clavier sera actualisé toutes les N*8 ms.
--
-- Dependencies: 
--  TICK_1ms (TICK_1ms.vhd)
--  TICK_Nms (TICK_Nms.vhd)
--  ClavMatriciel (ClavMatriciel.vhd)
--  AntiPics_vectoriel (AntiPics_vectoriel.vhd)
--  DFM_vectoriel (DFM_vectoriel.vhd)
--  TransposeurDigicode (TransposeurDigicode)

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Digicode is
    Port ( 
        CLK : in STD_LOGIC; --Horloge
        
        --Clavier Matriciel:
        lignes : out STD_LOGIC_VECTOR (3 downto 0);
        colonnes : in STD_LOGIC_VECTOR (3 downto 0);
        
        --Information récupérée:
        numeroTouche : out STD_LOGIC_VECTOR (3 downto 0); --Numéro de la touhe détectée (détails dans la description)
        toucheDetectee : out STD_LOGIC --Vaut '1' pendant une période d'horloge quand une nouvelle touche est détectée
    );
end Digicode;

architecture Behavioral of Digicode is
    signal TickN : STD_LOGIC := '0'; --un 'Tick' toutes les N ms (par défaut 1)
    signal Tick1 : STD_LOGIC := '0'; --un 'Tick' toutes les ms
    signal clavierBrut : STD_LOGIC_VECTOR (15 downto 0); --Clavier sans traitement (brut de décoffrage)
    signal clavierSansPic : STD_LOGIC_VECTOR (15 downto 0); --Clavier sans Pic (mais avec un léger retard)
    signal clavierFrontMontant : STD_LOGIC_VECTOR (15 downto 0); --Fronts montants

begin
    
    tick_1ms: 
        entity work.TICK_1ms 
        port map(
            --Entrées:
            CLK => CLK, 
            --Sorties:
            Tick => Tick1
        );
    
    tick_Nms: 
        entity work.TICK_Nms 
        generic map (
            N => 1
        ) 
        port map(
            --Entrées:
            CLK => CLK,  
            Reset => '0',
            --Sorties:
            Tick => TickN
        );
    
    capteur: 
        entity work.ClavMatriciel 
        port map(
            --Entrées:
            CLK => CLK,
            colonnes => colonnes, 
            Tick => TickN,  
            --Sorties:
            lignes => lignes, 
            Clavier_OUT => clavierBrut
        );
    
    antipic : 
        entity work.AntiPics_vectoriel 
        generic map (
            N => 20, --Retard introduit (en ms)
            dim => 16 --Nombre de touches
        ) 
        port map(
            --Entrées:
            CLK => CLK, 
            Tick => Tick1,
            Sig_IN => clavierBrut, 
            --Sorties:
            Sig_OUT => clavierSansPic
        );

    dfm : 
        entity work.DFM_vectoriel 
        generic map (
            dim => 16 --Nombre de touches
        ) 
        port map (
            --Entrées:
            CLK => CLK, 
            entree => clavierSansPic, 
            --Sorties:
            front => clavierFrontMontant
        );

    traducteur : 
        entity work.TransposeurDigicode 
        port map (
            --Entrées:
            CLK => CLK, 
            clavier => clavierFrontMontant,
            --Sorties: 
            toucheDetectee => toucheDetectee, 
            numeroTouche => numeroTouche
        );
end Behavioral;
