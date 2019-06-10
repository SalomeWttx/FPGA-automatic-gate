----------------------------------------------------------------------------------
-- Company: ENSEA
-- Engineer: Alban Benmouffek, Salomé Wattiaux, Marco Guzzon
-- 
-- Create Date: 01.03.2019 14:44:11
-- Design Name: 
-- Module Name: tone - Behavioral
-- Project Name: Portail
-- Target Devices: 
-- Tool Versions: 
-- Description: permet de générer des bip, on peut préciser le nombre de répétitions, la durée des bip, et la tonalité (grave ou aigu)
-- La sortie doit être reliée à un générateur de son. (générateur de signal oscillant)
--
-- Dependencies:
--  TICK_Nms (TICK_Nms.vhd)
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tone is
    port (
        --ENTREES:
        CLK : in STD_LOGIC; --Horloge
        
        incomingData : in STD_LOGIC; --Vaut '1' pendant une période d'horloge quand des nouvelles données sont envoyées
        duree : in STD_LOGIC_VECTOR(6 downto 0); --Durée de chaque bip, ainsi que entre les bip, en dixieme de seconde MAX 12,7s !
        repetition : in STD_LOGIC_VECTOR(2 downto 0); --Nombre de répétitions. MAX 7 REPETITIONS!
        ton_IN : in STD_LOGIC;-- ton_IN = '1' <=> bip aigu!
        
        --SORTIES:
        ton_OUT : out STD_LOGIC;-- ton_OUT = '1' <=> bip aigu!
        active : out STD_LOGIC --active = '1' <=> On veut du son !
    );
end tone;

architecture Behavioral of tone is
    signal repetitions_restantes : integer range 0 to 7 := 0;
    signal duree_bip : integer range 0 to 127 := 0;
    signal ton_bip : STD_LOGIC := '0';
    signal tick : STD_LOGIC := '0' ; --1 Tick tous les 10ms
    signal compteur : integer range 0 to 127 :=1 ; --Sert à mesurer la durée de chaque bip en train d'être joué (et aussi la durée entre 2 bip consécutifs)
    signal active_son : STD_LOGIC; --Signal qui sera recopié sur la sortie active
begin
    tick10ms: 
        entity work.TICK_Nms
        generic map (
            N => 100
        )
        port map (
            CLK => CLK,
            Tick => tick,
            Reset => '0'
        );
    
    process(CLK) begin
        if rising_edge(CLK) then
            
            
            --ACQUISITION DES DONNEES
            if incomingData = '1' then
                repetitions_restantes <= TO_INTEGER(UNSIGNED(repetition));
                duree_bip <= TO_INTEGER(UNSIGNED(duree));
                ton_bip <= ton_IN;
                active_son <= '1';
                compteur <= 1;


            --RIEN A FAIRE
            elsif repetitions_restantes = 0 then
                active_son <= '0';
                duree_bip <= duree_bip;
                ton_bip <= ton_bip;
                compteur <= 1;
                repetitions_restantes <= repetitions_restantes;


            --IL FAUT FAIRE DU SON!
            else
                duree_bip <= duree_bip;
                ton_bip <= ton_bip;
                if tick = '1' then --Gestion des répétitions
                    if compteur = duree_bip and active_son = '1' then --On doit arrêter le son
                        compteur <= 1;
                        active_son <= '0';
                        repetitions_restantes <= repetitions_restantes -1;
                    elsif compteur = duree_bip and active_son = '0' then --On doit envoyer du son
                        compteur <= 1;
                        active_son <= '1';
                        repetitions_restantes <= repetitions_restantes;
                    else --On continue exactement ce qu'on fait
                        compteur <= compteur + 1;
                        active_son <= active_son;
                        repetitions_restantes <= repetitions_restantes;
                    end if;
                else
                    compteur <= compteur;
                    active_son <= active_son;
                    repetitions_restantes <= repetitions_restantes;               
                end if;
                    
            end if;
        end if;
    end process;
    
    active <= active_son;
    ton_OUT <= ton_bip;
    
end Behavioral;
