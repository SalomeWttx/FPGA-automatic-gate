----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Alban Benmouffek
-- 
-- Create Date: 25.02.2019 08:14:23
-- Design Name: 
-- Module Name: TICK_Nms - Behavioral
-- Project Name: Portail
-- Target Devices: 
-- Tool Versions: 
-- Description: envoie un signal de une période d'horloge toutes les N millisecondes. Reset permet de remettre a 0 (arret si Reset passe a '1', remise a zero des que Reset passe a '0')
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TICK_Nms is
    generic (
        N : integer := 10 -- Nombre de millisecondes
    );
    Port ( 
        CLK : in STD_LOGIC; --Horloge
        Reset: in STD_LOGIC; --signal de debut
        Tick : out STD_LOGIC --Signal de période N millisecondes
    );
end TICK_Nms;

architecture Behavioral of TICK_Nms is
    constant div : integer := 100000*N;
    signal count : integer range 0 to div := 0;
begin
    process(CLK, Reset) begin
        if rising_edge(CLK) then
            if count = div then
                count <= 0;
            elsif Reset = '1' then
                count <= 1;
            else
                count <= count+1;
            end if;
        end if;
    end process;
    
    Tick <= '1' when count = 0 else '0';
end Behavioral;
