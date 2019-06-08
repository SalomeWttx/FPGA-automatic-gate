----------------------------------------------------------------------------------
-- Company: ENSEA
-- Engineer: Alban Benmouffek, Salomé Wattiaux, Marco Guzzon
-- 
-- Create Date: 28.02.2019 15:05:57
-- Design Name: 
-- Module Name: AntiPics_vectoriel - Behavioral
-- Project Name: Portail
-- Target Devices: 
-- Tool Versions: 
-- Description: enlève les pics d'un signal vectoriel. 
--  Idée : compter le nombre de millisecondes écoulées depuis que le signal d'entrée a changé
-- 
-- Le nombre de millisecondes maximum d'un pic des défini par N.
--
-- Si N est trop grand, il y aura trop de latence et le filtre risque d'être trop puissant
-- Si N est trop petit, tous les pics d'une durée plus grande que N ne seront pas retirés du signal
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity AntiPics_vectoriel is
    generic (
        N : integer := 20; --nombre de ms avant déclenchement
        dim : integer := 16 --taille des signaux à traiter
    );
    port (
        sig_IN : in STD_LOGIC_VECTOR(dim-1 downto 0); --Signal d'entrée (avec pics)
        sig_OUT : out STD_LOGIC_VECTOR(dim-1 downto 0); --Signal de sortie (sans pics)
        CLK : in STD_LOGIC; --Horloge
        Tick : in STD_LOGIC --1 Tick toutes les millisecondes
    );
end AntiPics_vectoriel;

architecture Behavioral of AntiPics_vectoriel is
    type LIST is array (dim-1 downto 0) of integer;

    signal signal_sortie : STD_LOGIC_VECTOR(dim-1 downto 0); --Signal qui sera envoyé sur la sortie
    signal successful : LIST; --Liste d'entiers qui va servir à compter le nombre de millisecondes depuis qu'une composante à changé
begin
    process(CLK) begin
        if rising_edge(CLK) then
            for composante in 0 to dim-1 loop
                if signal_sortie(composante) = '1' or signal_sortie(composante) = '0' then --Petite astuce pour initialiser signal_sortie avec des '0'
                    if successful(composante) = N then --La composante a changé depuis plus de N ms, donc il ne s'agissait pas d'un pic
                        signal_sortie(composante) <= NOT(signal_sortie(composante)); --On peut donc faire changer signal_sortie
                        successful(composante) <= 0;                
                    else
                        if signal_sortie(composante) = '0' then
                            if Tick = '1' and sig_IN(composante) = '1' then --Sig_IN est différent de signal_sortie (composante) !
                                successful(composante) <= successful(composante) + 1;
                            elsif sig_IN(composante) = '0' then --Sig_IN est identique à signal_sortie (composante) !
                                successful(composante) <= 0;
                            else --Cas où on n'est pas sur une nouvelle milliseconde
                                successful(composante) <= successful(composante);
                            end if;
                        else
                            if Tick = '1' and sig_IN(composante) = '0' then --Sig_IN est différent de signal_sortie (composante) !
                                successful(composante) <= successful(composante) + 1;
                            elsif sig_IN(composante) = '1' then --Sig_IN est identique à signal_sortie (composante) !
                                successful(composante) <= 0;
                            else --Cas où on n'est pas sur une nouvelle milliseconde
                                successful(composante) <= successful(composante);
                            end if;           
                        end if;
                    end if;
                else
                    signal_sortie(composante) <= '0'; --Cas où signal_sortie n'était pas encore initialisé
                end if;
            end loop;
        end if;
    end process;
    
    sig_OUT <= signal_sortie;
end Behavioral;
