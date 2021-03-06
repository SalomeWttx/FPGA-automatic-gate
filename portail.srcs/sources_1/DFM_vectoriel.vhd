----------------------------------------------------------------------------------
-- Company: ENSEA
-- Engineer: Alban Benmouffek, Salomé Wattiaux, Marco Guzzon 
-- 
-- Create Date: 25.02.2019 15:20:44
-- Design Name: 
-- Module Name: DFM_vectoriel - Behavioral
-- Project Name: Portail
-- Target Devices: 
-- Tool Versions: 
-- Description: générateur (ou extracteur) de front montant vectoriel (prend en entree un vecteur, donne en sortie les fronts montants de chaque composante de l'entrée; sous forme d'un vecteur)
--  
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DFM_vectoriel is
    Generic (
        dim: integer := 4 --Dimention du vecteur d'entrée (et de sortie)
    );
    Port (
        CLK : in STD_LOGIC; --Horloge
        entree : in STD_LOGIC_VECTOR(dim-1 downto 0); --Vecteur d'entrée
        front : out STD_LOGIC_VECTOR(dim-1 downto 0) --Fronts montants de chaque composante
        );
end DFM_vectoriel;

architecture Behavioral of DFM_vectoriel is
    signal entree_current, entree_previous, EP, EF : STD_LOGIC_VECTOR(dim-1 downto 0);
    signal Q0, Q1, D0, D1 : STD_LOGIC_VECTOR(dim-1 downto 0);
begin
    
    process(CLK) begin
        if rising_edge(CLK) then
            entree_current <= entree;
            entree_previous <= entree_current;
        end if;
    end process;
    
    process(CLK, Q1, Q0, entree_current, entree_previous) begin
        for composante in 0 to dim-1 loop
            D0(composante) <= ( NOT(Q1(composante)) and NOT(Q0(composante)) )  and  ( entree_current(composante) and NOT(entree_previous(composante)) );
            D1(composante) <= ( NOT(Q1(composante)) and Q0(composante) )  or  ( (Q1(composante) and NOT(Q0(composante))) and (entree_current(composante) or entree_previous(composante)) );
        end loop;
    end process;
    
    process(CLK) begin
        if rising_edge(CLK) then
            Q0 <= D0;
            Q1 <= D1;
        end if;
    end process;
    
    front <= Q0;
    
end Behavioral;
