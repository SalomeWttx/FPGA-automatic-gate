----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Alban Benmouffek
-- 
-- Create Date: 26.02.2019 16:33:13
-- Design Name: 
-- Module Name: GenerateurDeBip_tb - Behavioral
-- Project Name: Portail
-- Target Devices: 
-- Tool Versions: 
-- Description: simulation de generateurdebip.vhd
-- 
-- Dependencies: GenerateurDeBip
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity GenerateurDeBip_tb is
--  Port ( );
end GenerateurDeBip_tb;

architecture Behavioral of GenerateurDeBip_tb is
    signal CLK : STD_LOGIC;
    constant CLK_period: time := 10 ns;
    signal active : STD_LOGIC;
    signal tonalite : STD_LOGIC;
    signal sound : STD_LOGIC;
begin
    UUT: entity work.GenerateurDeBip port map(CLK => CLK, active => active, tonalite => tonalite, sound => sound);

    CLK_process : process begin
        CLK <= '0';
        wait for CLK_period/2;
        CLK <= '1';
        wait for CLK_period/2;
    end process;
    
    process begin
        active <= '0';
        wait for 50ms;
        active <= '1';
        wait for 50ms;
    end process;
    
    process begin
        tonalite <= '0';
        wait for 20ms;
        tonalite <= '1';
        wait for 20ms;
    end process;
    
end Behavioral;

