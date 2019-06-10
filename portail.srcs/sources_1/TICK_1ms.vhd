----------------------------------------------------------------------------------
-- Company: ENSEA
-- Engineer: Alban Benmouffek, Salomé Wattiaux, Marco Guzzon
-- 
-- Create Date: 25.02.2019 08:14:23
-- Design Name: 
-- Module Name: TICK_1ms - Behavioral
-- Project Name: Portail
-- Target Devices: 
-- Tool Versions: 
-- Description: envoie un signal de une période d'horloge toutes les millisecondes.
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TICK_1ms is
    Port ( 
        CLK : in STD_LOGIC;--Horloge
        Tick : out STD_LOGIC --Signal de sortie
    );
end TICK_1ms;

architecture Behavioral of TICK_1ms is
    constant div : integer := 99999; --Nombre de fronts d'horloge que l'on doit compter
    signal count : integer range 0 to div := 0; --Compteur
begin
    process(CLK) begin
        if rising_edge(CLK) then
            if count = div then --on a fini de compter
                count <= 0;
            else
                count <= count+1;
            end if;
        end if;
    end process;
    
    Tick <= '1' when count = 0 else '0';
end Behavioral;
