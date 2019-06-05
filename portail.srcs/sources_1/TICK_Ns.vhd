----------------------------------------------------------------------------------
-- Company: ENSEA
-- Engineer: Alban Benmouffek, Salomé Wattiaux, Marco Guzzon
-- 
-- Create Date: 25.02.2019 08:14:23
-- Design Name: 
-- Module Name: TICK_Ns - Behavioral
-- Project Name: Portail
-- Target Devices: 
-- Tool Versions: 
-- Description: envoie un signal de une période d'horloge toutes les N/2 secondes. Reset permet de remettre a 0 (arret du fonctionnement tant que Reset est a '1', remise a zero des que Reset repasse a '0')
-- 
-- Dependencies: 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TICK_Ns is
    generic (
        N : integer := 10 -- Nombre de demi secondes
    );
    Port ( 
        --ENTREES:
        CLK : in STD_LOGIC; --Horloge
        Reset: in STD_LOGIC; --signal de debut
        
        --SORTIES:
        Tick : out STD_LOGIC --Signal de période N/2 secondes
    );
end TICK_Ns;

architecture Behavioral of TICK_Ns is
    constant div : integer := 50000000*N;
    signal count : integer range 0 to div := 0;
begin
    process(CLK, Reset) begin
        if rising_edge(CLK) then
            if count = div then --on a fini de compter
                count <= 0;
            elsif Reset = '1' then --remise à zéro
                count <= 1;
            else
                count <= count+1;
            end if;
        end if;
    end process;
    
    Tick <= '1' when count = 0 else '0';
end Behavioral;
