----------------------------------------------------------------------------------
-- Company: ENSEA
-- Engineer: Alban Benmouffek, Salomé Wattiaux, Marco Guzzon
-- 
-- Create Date: 25.02.2019 10:15:12
-- Design Name: 
-- Module Name: DFM - Behavioral
-- Project Name: Portail
-- Target Devices: 
-- Tool Versions: 
-- Description: detecteur de front montant : prend un signal quelconque en entrée, en donne en sortie '1' pendant une période d'horloge au moment du front montant de l'entrée
-- 
-- Dependencies: 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DFM is
    Port ( 
        --ENTREES:
        CLK : in STD_LOGIC; --Horloge
        entree : in STD_LOGIC; --Signal d'entrée
        
        --SORTIES:
        front : out STD_LOGIC --Front montant
    );
end DFM;

architecture Behavioral of DFM is
    signal entree_current, entree_previous, EP, EF : STD_LOGIC:= '0';
    signal Q,D : STD_LOGIC_VECTOR(1 downto 0) := "00";
begin
    
    process(CLK) begin
        if rising_edge(CLK) then
            entree_current <= entree;
            entree_previous <= entree_current;
        end if;
    end process;
    
    D(0) <= ( NOT(Q(1)) and NOT(Q(0)) )  and  ( entree_current and NOT(entree_previous) );
    D(1) <= ( NOT(Q(1)) and Q(0) )  or  ( (Q(1) and NOT(Q(0))) and (entree_current or entree_previous) );
    
    process(CLK) begin
        if rising_edge(CLK) then
            Q(0) <= D(0);
            Q(1) <= D(1);
        end if;
    end process;
    
    front <= Q(0);
    
end Behavioral;
