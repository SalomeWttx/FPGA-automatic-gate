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
-- Description: enlève les pics d'un signal vectoriel. Idée : compter le nombre de millisecondes écoulées depuis que le signal d'entrée a changé
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

entity AntiPics_vectoriel is
    generic (
        N : integer := 20; --nombre de ms avant déclenchement
        dim : integer := 16 --taille des signaux à traiter
    );
    port (
        sig_IN : in STD_LOGIC_VECTOR(dim-1 downto 0);
        sig_OUT : out STD_LOGIC_VECTOR(dim-1 downto 0);
        CLK : in STD_LOGIC;
        Tick : in STD_LOGIC
    );
end AntiPics_vectoriel;

architecture Behavioral of AntiPics_vectoriel is
    type LIST is array (dim-1 downto 0) of integer;
    signal signal_sortie : STD_LOGIC_VECTOR(dim-1 downto 0);
    signal successful : LIST;
begin
    process(CLK) begin
        if rising_edge(CLK) then
            for composante in 0 to dim-1 loop
                if signal_sortie(composante) = '1' or signal_sortie(composante) = '0' then
                    if successful(composante) = N then
                        signal_sortie(composante) <= NOT(signal_sortie(composante));
                        successful(composante) <= 0;                
                    else
                        if signal_sortie(composante) = '0' then
                            if Tick = '1' and sig_IN(composante) = '1' then
                                successful(composante) <= successful(composante) + 1;
                            elsif sig_IN(composante) = '0' then
                                successful(composante) <= 0;
                            else
                                successful(composante) <= successful(composante);
                            end if;
                        else
                            if Tick = '1' and sig_IN(composante) = '0' then
                                successful(composante) <= successful(composante) + 1;
                            elsif sig_IN(composante) = '1' then
                                successful(composante) <= 0;
                            else
                                successful(composante) <= successful(composante);
                            end if;           
                        end if;
                    end if;
                else
                    signal_sortie(composante) <= '0';
                end if;
            end loop;
        end if;
    end process;
    
    sig_OUT <= signal_sortie;
end Behavioral;
