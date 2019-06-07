----------------------------------------------------------------------------------
-- Company: ENSEA
-- Engineer: Alban Benmouffek, Salomé Wattiaux, Marco Guzzon
-- 
-- Create Date: 26.02.2019 16:33:13
-- Design Name: 
-- Module Name: PWM_tb - Behavioral
-- Project Name: Portail
-- Target Devices: 
-- Tool Versions: 
-- Description: simulation de PWM
-- 
-- Dependencies:
--  PWM (PWM.vhd)
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PWM_tb is
--  Port ( );
end PWM_tb;

architecture Behavioral of PWM_tb is
    signal CLK : STD_LOGIC;
    constant CLK_period: time := 10 ns;
    signal entree : STD_LOGIC;
    signal sortie : STD_LOGIC;
begin
    UUT: entity work.PWM port map(CLK => CLK, entree => entree, sortie => sortie);

    CLK_process : process begin
        CLK <= '0';
        wait for CLK_period/2;
        CLK <= '1';
        wait for CLK_period/2;
    end process;
    
    process begin
        entree <= '0';
        wait for 50ms;
        entree <= '1';
        wait for 50ms;
    end process;
    
end Behavioral;

