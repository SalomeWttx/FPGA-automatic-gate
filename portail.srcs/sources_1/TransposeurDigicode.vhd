----------------------------------------------------------------------------------
-- Company: ENSEA
-- Engineer: Alban Benmouffek, Salomé Wattiaux, Marco Guzzon 
-- 
-- Create Date: 25.02.2019 16:07:36
-- Design Name: 
-- Module Name: TransposeurDigicode - Behavioral
-- Project Name: Portail
-- Target Devices: 
-- Tool Versions: 
-- Description: prend en entree le clavier (sous forme de vecteur), donne en sortie le numero de la touche correspondante (numeroTouche) et un signal qui vaut '1' pendant une période d'horloge quand une nouvelle touche est détectée (toucheDetectee)
--clavier     colonnes(0)     colonnes(1)     colonnes(2)     colonnes(3)
--lignes(0)       0               1               2               3
--lignes(1)       4               5               6               7
--lignes(2)       8               9               10              11
--lignes(3)       12              13              14              15

--TRADUCTION:
--touche      colonnes(0)     colonnes(1)     colonnes(2)     colonnes(3)
--lignes(0)       1               2               3              10
--lignes(1)       4               5               6              11
--lignes(2)       7               8               9              12
--lignes(3)       15              0              14              13
--
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TransposeurDigicode is
    Port ( 
        --ENTREES:
        CLK : in STD_LOGIC; --Horloge
        clavier : in STD_LOGIC_VECTOR (15 downto 0); --Clavier, sous forme de vecteur
        
        --SORTIES:
        toucheDetectee : out STD_LOGIC; --Signal indiquant si une nouvelle touche est pressée
        numeroTouche : out STD_LOGIC_VECTOR (3 downto 0) --Numéro de la touche détectée
        );
end TransposeurDigicode;

architecture Behavioral of TransposeurDigicode is
begin
    process(CLK) begin
        if rising_edge(CLK) then
            if clavier(0) = '1' then
                numeroTouche <= "0001"; --clavier(0) = '1' correspond à la touche 1
                toucheDetectee <= '1';
            elsif clavier(1) = '1' then
                numeroTouche <= "0010"; --clavier(1) = '1' correspond à la touche 2
                toucheDetectee <= '1';
            elsif clavier(2) = '1' then
                numeroTouche <= "0011"; --clavier(2) = '1' correspond à la touche 3
                toucheDetectee <= '1';
            elsif clavier(3) = '1' then
                numeroTouche <= "1010"; --clavier(3) = '1' correspond à la touche 10
                toucheDetectee <= '1';
            elsif clavier(4) = '1' then
                numeroTouche <= "0100"; --clavier(4) = '1' correspond à la touche 4
                toucheDetectee <= '1';
            elsif clavier(5) = '1' then
                numeroTouche <= "0101"; --clavier(5) = '1' correspond à la touche 5
                toucheDetectee <= '1';
            elsif clavier(6) = '1' then
                numeroTouche <= "0110"; --clavier(6) = '1' correspond à la touche 6
                toucheDetectee <= '1';
            elsif clavier(7) = '1' then
                numeroTouche <= "1011"; --clavier(7) = '1' correspond à la touche 11
                toucheDetectee <= '1';
            elsif clavier(8) = '1' then
                numeroTouche <= "0111"; --clavier(8) = '1' correspond à la touche 7
                toucheDetectee <= '1';
            elsif clavier(9) = '1' then
                numeroTouche <= "1000"; --clavier(9) = '1' correspond à la touche 8
                toucheDetectee <= '1';
            elsif clavier(10) = '1' then
                numeroTouche <= "1001"; --clavier(10) = '1' correspond à la touche 9
                toucheDetectee <= '1';
            elsif clavier(11) = '1' then
                numeroTouche <= "1100"; --clavier(11) = '1' correspond à la touche 12
                toucheDetectee <= '1';
            elsif clavier(12) = '1' then
                numeroTouche <= "1111"; --clavier(12) = '1' correspond à la touche 15
                toucheDetectee <= '1';
            elsif clavier(13) = '1' then
                numeroTouche <= "0000"; --clavier(13) = '1' correspond à la touche 0
                toucheDetectee <= '1';
            elsif clavier(14) = '1' then
                numeroTouche <= "1110"; --clavier(14) = '1' correspond à la touche 14
                toucheDetectee <= '1';
            elsif clavier(15) = '1' then
                numeroTouche <= "1101"; --clavier(15) = '1' correspond à la touche 13
                toucheDetectee <= '1';
            else
                numeroTouche <= "0000";
                toucheDetectee <= '0';
            end if;
        end if;
    end process;
    
end Behavioral;
