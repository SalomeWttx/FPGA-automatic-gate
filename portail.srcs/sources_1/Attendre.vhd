----------------------------------------------------------------------------------
-- Company: ENSEA
-- Engineer: Alban Benmouffek, Salomé Wattiaux, Marco Guzzon
-- 
-- Create Date: 25.02.2019 08:52:41
-- Design Name: 
-- Module Name: Attendre - Behavioral
-- Project Name: Portail
-- Target Devices: 
-- Tool Versions: 
-- Description: ce module permet de faire une temporisation pendant un certain nombre de secondes.
--  Le nombre de secondes est défini par Duree (variable définie dans generic).
--  Fonctionnement: 
--          Etat initial: FinAttente à '0'
--          Si la temporisation est en cours, alors l'entrée Attente vaut '1'. 
--          Tant que le temps n'est pas écoulé, la sortie FinAttente vaut '0'.
--          Dès que le temps est écoulé, la sortie FinAttente vaut '1'.
--          La sortie FinAttente ne repasse à '0' que si l'entrée Attente repasse à '0'
--  Utilité: rester dans un état pendant un certain nombre de secondes (dans une machine à état)
-- 
--  L'entrée ForceReset permet de remettre le compteur de temps à zéro
--
-- Dependencies: 
--  Tick_Ns (Tick_Ns.vhd)
--  DFM (DFM.vhd)
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Attendre is
    Generic (
        Duree : integer := 2 --nombre de secondes a attendre
    );
    Port ( 
        --ENTREES DIVERSES:
        CLK : in STD_LOGIC; --Horloge
        ForceReset : in STD_LOGIC; --Reset forcé
        Attente : in STD_LOGIC; --  Attente = '1' <=> une temporisation est en cours
        
        --SORTIES DIVERSES:
        FinAttente : out STD_LOGIC -- FinAttente = '1' <=> la temporisation est terminée
    );
end Attendre;

architecture Behavioral of Attendre is
    signal Reset: STD_LOGIC; --front montant du signal Attente (début de la temporisation), joue le rôle de synchronisation
    signal Tick: STD_LOGIC; --Vaut '1' pendant une période d'horloge toutes les Duree seconde
    signal fin : STD_LOGIC; --Vaut '1' pendant une période d'horloge à la fin de la temporisation
    signal count : integer range 0 to Duree := 0;
--    signal FinAttenteSignal : STD_LOGIC := '0';
begin
    
    waiter: 
        entity work.TICK_Ns 
        generic map (
            N => 2 --Un 'Tick' toutes les secondes
        ) 
        port map(
            --Entrées:
            CLK => CLK, 
            Reset => Reset,
            --Sorties: 
            Tick => Tick
        );
    
    dfm: 
        entity work.DFM 
        port map(
            --Entrées:
            CLK => CLK, 
            entree => Attente,
            --Sorties: 
            front => Reset
        );
    
    process(clk) begin
        if rising_edge(clk) then
            if Attente = '0' or Reset = '1' or ForceReset = '1' then --Il faut mettre le compteur à zéro
                count <= 0;
            elsif Tick = '1' and Attente = '1' then
                if count = Duree then --On a fini de compter
                    count <= 0;
                else
                    count <= count+1;
                end if;
            end if;
        end if;
    end process;
    
    fin <= '1' when count = Duree and Attente = '1' else '0';
    
    FinAttente <= fin;
    
end Behavioral;
