----------------------------------------------------------------------------------
-- Company: ENSEA
-- Engineer: Alban Benmouffek, Salomé Wattiaux, Marco Guzzon
-- 
-- Create Date: 25.02.2019 16:45:43
-- Design Name: 
-- Module Name: GenerateurDeBip - Behavioral
-- Project Name: Portail
-- Target Devices: 
-- Tool Versions: 
-- Description: generateur de son : prend en entrée la tonalité (grave ou aigu) et un signal d'activation,
--          donne en sortie un signal carré pouvant aller directement dans l'haut-parleur.
-- (aigu = 500Hz ; grave = 250Hz)
--
-- Dependencies: 
--  TICK_Nms (TICK_Nms.vhd)
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity GenerateurDeBip is
    Port ( 
        --ENTREES:
        CLK : in STD_LOGIC;--Horloge
        active : in STD_LOGIC; -- active = '1' <=> On veut du son!
        tonalite : in STD_LOGIC; -- tonalite = '1' <=> bip aigu! (aigu = 500Hz ; grave = 250Hz)
        
        --SORTIES:
        sound : out STD_LOGIC
    );
end GenerateurDeBip;

architecture Behavioral of GenerateurDeBip is
    signal son: STD_LOGIC := '0';
    signal tick_aigu: STD_LOGIC;
    signal tick_grave: STD_LOGIC;
begin
    aigu: 
        entity work.TICK_Nms
        generic map(
            N => 1
        )
        port map(
            CLK => CLK,
            Reset => '0',
            Tick => tick_aigu
        );
        
    grave: 
        entity work.TICK_Nms
        generic map(
            N => 2
        )
        port map(
            CLK => CLK,
            Reset => '0',
            Tick => tick_grave
        );
    
    process(CLK) begin
        if rising_edge(CLK) then
            if tonalite = '1' then
                if tick_aigu = '1' then
                    son <= NOT(son);
                else
                    son <= son;
                end if;
            else
                if tick_grave = '1' then
                    son <= NOT(son);
                else
                    son <= son;
                end if;
            end if;
        end if;
    end process;
    
    sound <= '0' when active = '0' else son;
end Behavioral;
