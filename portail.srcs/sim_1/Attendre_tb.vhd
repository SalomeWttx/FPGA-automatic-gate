----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Alban Benmouffek
-- 
-- Create Date: 25.02.2019 09:37:55
-- Design Name: 
-- Module Name: Attendre_tb - Behavioral
-- Project Name: Portail
-- Target Devices: 
-- Tool Versions: 
-- Description: simulation de Attendre
-- 
-- Dependencies: Attendre, TICK_Ns
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Attendre_tb is
--  Port ( );
end Attendre_tb;

architecture Behavioral of Attendre_tb is
    signal CLK: STD_LOGIC;
    signal Attente: STD_LOGIC;
    signal FinAttente: STD_LOGIC;
    constant CLK_period: time := 10 ns;
    constant seconde: time := 1000 ms;
begin
    UUT: entity work.Attendre generic map(Duree => 1) port map(CLK => CLK, Attente => Attente, FinAttente => FinAttente);
    
    CLK_process : process begin
        CLK <= '0';
        wait for CLK_period/2;
        CLK <= '1';
        wait for CLK_period/2;
    end process;
    
    process begin
        Attente <= '0';
        wait for CLK_period*5;
        Attente <= '1';
        wait for seconde;
        wait for CLK_period*1000;
        Attente <= '0';
         wait for seconde;
    end process;
end Behavioral;
