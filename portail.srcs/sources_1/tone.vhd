----------------------------------------------------------------------------------
-- Company: ENSEA
-- Engineer: Alban Benmouffek, Salom� Wattiaux, Marco Guzzon
-- 
-- Create Date: 01.03.2019 14:44:11
-- Design Name: 
-- Module Name: tone - Behavioral
-- Project Name: Portail
-- Target Devices: 
-- Tool Versions: 
-- Description: permet de g�n�rer des bip, on peut pr�ciser le nombre de r�p�titions, la dur�e des bip, et la tonalit� (grave ou aigu)
-- La sortie doit �tre reli�e � un g�n�rateur de son.
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
        
        incomingData : in STD_LOGIC; --Vaut '1' pendant une p�riode d'horloge quand des nouvelles donn�es sont envoy�es
        duree : in STD_LOGIC_VECTOR(6 downto 0); --Dur�e de chaque bip, ainsi que entre les bip, en dixieme de seconde MAX 12,7s !
        repetition : in STD_LOGIC_VECTOR(2 downto 0); --Nombre de r�p�titions. MAX 7 REPETITIONS!
        ton_IN : in STD_LOGIC;-- ton_IN = '1' <=> bip aigu!
        
        --SORTIES:
        ton_OUT : out STD_LOGIC;-- ton_OUT = '1' <=> bip aigu!
        active : out STD_LOGIC
    );
end tone;

architecture Behavioral of tone is
    signal repetitions_restantes : integer range 0 to 7 := 0;
    signal duree_bip : integer range 0 to 127 := 0;
    signal ton_bip : STD_LOGIC := '0';
    signal tick : STD_LOGIC := '0' ;
    signal compteur : integer range 0 to 127 :=1 ;
    signal active_son : STD_LOGIC;
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
            if incomingData = '1' then
                --acquisition des donn�es
                repetitions_restantes <= TO_INTEGER(UNSIGNED(repetition));
                duree_bip <= TO_INTEGER(UNSIGNED(duree));
                ton_bip <= ton_IN;
                active_son <= '1';
                compteur <= 1;
            elsif repetitions_restantes = 0 then
                --rien � faire
                active_son <= '0';
                duree_bip <= duree_bip;
                ton_bip <= ton_bip;
                compteur <= 1;
                repetitions_restantes <= repetitions_restantes;
            else
                duree_bip <= duree_bip;
                ton_bip <= ton_bip;
                if tick = '1' then
                    if compteur = duree_bip and active_son = '1' then
                        compteur <= 1;
                        active_son <= '0';
                        repetitions_restantes <= repetitions_restantes -1;
                    elsif compteur = duree_bip and active_son = '0' then
                        compteur <= 1;
                        active_son <= '1';
                        repetitions_restantes <= repetitions_restantes;
                    else
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
