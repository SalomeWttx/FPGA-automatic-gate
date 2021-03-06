----------------------------------------------------------------------------------
-- Company: ENSEA
-- Engineer: Alban Benmouffek, Salomé Wattiaux, Marco Guzzon
-- 
-- Create Date: 26.02.2019 15:13:36
-- Design Name: 
-- Module Name: detecteurObstacle - Behavioral
-- Project Name: Portail
-- Target Devices: 
-- Tool Versions: 
-- Description: module permettant de dire s'il y a un obstacle ou non 
-- Attention ! Ne fonctionne que si le duty cycle du PWM est de 80%
--
-- Le signal reçu dans InfoCourant est analysé (on connait le signal correspondant à moteur bloqué après l'avoir analysé avec un oscilloscope)
-- 
-- Dependencies: 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity detecteurObstacle is
    Port ( 
        --ENTREES DIVERSES:
        CLK: in STD_LOGIC; -- Horloge
        
        SensMoteur : in STD_LOGIC; -- SensMoteur = '1' <=> Ouverture
        SignalMoteur : in STD_LOGIC; -- SignalMoteur = '1' <=> Moteur en marche
        InfoCourant : in STD_LOGIC; --Signal indiquant si le moteur est bloqué ou non (il faut analyser ce signal)
        
        collision : out STD_LOGIC -- collision = '1' <=> Colliison détectée
    );
end detecteurObstacle;

architecture Behavioral of detecteurObstacle is
    signal TimeOn_InfoCourant : integer range 0 to 200000 := 0; --Temps pendant lequel sig_InfoCourant est à '1' (actualisé à chaque fois que sig_InfoCourant revient à '1')
    signal TimeOff_InfoCourant : integer range 0 to 200000 := 0; --Temps pendant lequel sig_InfoCourant est à '0' (actualisé à chaque fois que sig_InfoCourant revient à '0')
    signal previousState_InfoCourant : STD_LOGIC := '0';
    
    signal collisionDetectee : STD_LOGIC := '0'; --Signal de collision détectée, ne sera activé que un front d'horloge en cas de collision, il faut donc traiter le signal
    signal sig_collision : STD_LOGIC := '0'; --Signal interne indiquant si une collision est détectée, sera directement envoyé sur collision. Correspond à collisionDetectee après traitement
    
    signal TimeOn_collision : integer range 0 to 500000 := 0; --Temps pendant lequel collisionDetectee est à '1' (actualisé à chaque fois que sig_InfoCourant revient à '1')
    signal TimeOff_collision : integer range 0 to 500000 := 0; --Temps pendant lequel collisionDetectee est à '0' (actualisé à chaque fois que sig_InfoCourant revient à '0')


    signal sig_InfoCourant : STD_LOGIC := '0'; --bricole pour travailler uniquement avec des signaux synchrones
begin
    
    
    --Détection du blocage du moteur
    process(CLK) begin
        if rising_edge(CLK) then
            if SignalMoteur = '0' then --Moteur éteint - no problemo
                collisionDetectee <= '0';
            
            else --Moteur en marche ! Danger !
                if SensMoteur = '1' then --Ouverture
                    --On essaye de reconnaître le pattern correspondant à moteur bloqué en ouverture
                    if TimeOn_InfoCourant > 61000 and TimeOn_InfoCourant < 71000 and TimeOff_InfoCourant > 129000 and TimeOff_InfoCourant < 139000 then
                        --BLOQUE!
                        collisionDetectee <= '1';
                    else
                        collisionDetectee <= '0';
                    end if;
                else --Fermeture
                    --On essaye de reconnaître le pattern correspondant à moteur bloqué en fermeture
                    if TimeOn_InfoCourant > 185000 and TimeOff_InfoCourant < 10000 and TimeOff_InfoCourant > 100 then
                        --BLOQUE!
                        collisionDetectee <= '1';
                    else
                        collisionDetectee <= '0';
                    end if; 
                end if;
                    
            end if;
        end if;
    end process;
    
    
            
    --Comptage du temps pendant lequel sig_InfoCourant est à '1' ou à '0'
    process(CLK) begin
        if rising_edge(CLK) then
            if previousState_InfoCourant = sig_InfoCourant then
                if sig_InfoCourant = '1' then
                    --On incrémente, mais si c'est déjà à 200000 on laisse tel quel
                    if TimeOn_InfoCourant < 200000 then
                        TimeOn_InfoCourant <= TimeOn_InfoCourant + 1;
                    else
                        TimeOn_InfoCourant <= TimeOn_InfoCourant;
                    end if;
                    previousState_InfoCourant <= '1';
                else
                    --On incrémente, mais si c'est déjà à 200000 on laisse tel quel
                    if TimeOff_InfoCourant < 200000 then
                        TimeOff_InfoCourant <= TimeOff_InfoCourant + 1;
                    else
                        TimeOff_InfoCourant <= TimeOff_InfoCourant;
                    end if;
                    previousState_InfoCourant <= '0';
                end if;
            else
                if sig_InfoCourant = '1' then
                    TimeOn_InfoCourant <= 0;
                    previousState_InfoCourant <= '1';
                else
                    TimeOff_InfoCourant <= 0;
                    previousState_InfoCourant <= '0';
                end if;            
            end if;
        end if;
    end process;
       
            
            
    --Traitement du signal collision
    process (CLK) begin
        if rising_edge(CLK) then
            if TimeOn_collision > 0 and TimeOn_collision < 400000 then
                sig_collision <= '1';
                TimeOn_collision <= TimeOn_collision + 1;
            elsif TimeOn_collision = 0 then
                if collisionDetectee = '1' then
                    TimeOn_collision <= 1;
                    sig_collision <= '1';
                else
                    TimeOn_collision <= 0;
                    sig_collision <= '0';
                end if;
            elsif TimeOn_collision = 400000 then
                sig_collision <= '1';
                if TimeOff_collision < 200000 then
                    TimeOn_collision <= TimeOn_collision;
                else
                    TimeOn_collision <= 0;
                end if;
            end if;
        end if;
    end process;
    
            
     
    --Comptage du temps pendant lequel collisionDetectee est à '0'
    process(CLK) begin
        if rising_edge(CLK) then
            if collisionDetectee = '0' then
                if TimeOff_collision < 200000 then
                    TimeOff_collision <= TimeOff_collision + 1;
                else
                    TimeOff_collision <= TimeOff_collision;
                end if;
            else
                TimeOff_collision <= 0;
            end if;
        end if;
    end process;
    
            
    
    --bricole pour travailler avec des signaux synchrones (on actualise sig_InfoCourant à chaque front d'horloge)
    process(CLK) begin
        if rising_edge(CLK) then
            sig_InfoCourant <= InfoCourant;
        end if;
    end process;
    
    collision <= sig_collision;
    
end Behavioral;
