----------------------------------------------------------------------------------
-- Company: ENSEA
-- Engineer: Alban Benmouffek, Salomé Wattiaux, Marco Guzzon
-- 
-- Create Date: 25.02.2019 11:37:56
-- Design Name: 
-- Module Name: Cligno - Behavioral
-- Project Name: Portail
-- Target Devices: 
-- Tool Versions: 
-- Description: gere le clignottement du clignottant, ce module utilise une machine à états.
--  Un clignottement par seconde.
--
-- Dependencies: 
-- TICK_Ns (TICK_Ns.vhd)
-- DFM (DFM.vhd)
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Cligno is
    Port ( 
        --ENTREES DIVERSES:
        CLK : in STD_LOGIC;
        active : in STD_LOGIC; -- active = '1' <=> le clignottant doit clignotter
        
        --SORTIES DIVERSES:
        lampe : out STD_LOGIC -- lampe = '1' <=> le clignottant est allumé
    );
end Cligno;

architecture Behavioral of Cligno is
    signal front : STD_LOGIC;--Signal qui va contenir le front montant de active
    signal Tick : STD_LOGIC;--Signal qui passe à '1' pendant une période d'horloge toutes les demi secondes
    signal changementEtat : STD_LOGIC;
    
    --Liste des états:
    type liste_etat is (Allume, Eteint);
    signal ETAT_PR, ETAT_FU : liste_etat:=Eteint;
begin
    dfm: 
        entity work.DFM 
        port map(
            --Entrées:
            CLK => CLK, 
            entree => active,
            --Sorties: 
            front => front
        );

    waiter: 
        entity work.TICK_Ns 
        generic map(
            N => 1 --Un 'Tick' toutes les demi secondes
        ) port map(
            --Entrées:
            CLK => CLK, 
            Reset => front,
            --Sorties: 
            Tick => Tick
        );
    
    changementEtat <= '1' when front = '1' or Tick = '1' else '0';
    
    --Actualisation de l'état présent:
    process(CLK) begin
        if rising_edge(CLK) then
            ETAT_PR <= ETAT_FU;
        end if;
    end process;
    
    --Calcul de l'état futur:
    process(ETAT_PR, active, changementEtat) begin
        case ETAT_PR is
            when Eteint =>
                if active = '1' and changementEtat = '1' then
                    ETAT_FU <= Allume;
                else
                    ETAT_FU <= Eteint;
                end if;
            when Allume =>
                if changementEtat = '1' or active = '0' then
                    ETAT_FU <= Eteint;
                else
                    ETAT_FU <= Allume;
                end if;
            when others =>
                ETAT_FU <= Eteint;
        end case;
    end process;
    
    --Calcul des sorties:
    process(ETAT_PR) begin
        case ETAT_PR is
            when Eteint =>
                lampe <= '0';
            when Allume =>
                lampe <= '1';
            when others =>
                lampe <= '0';
        end case;
    end process;
    
end Behavioral;
