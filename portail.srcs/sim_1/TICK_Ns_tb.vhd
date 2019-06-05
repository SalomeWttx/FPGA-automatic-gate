----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Alban Benmouffek
-- 
-- Create Date: 25.02.2019 08:30:51
-- Design Name: 
-- Module Name: TICK_Ns_tb - Behavioral
-- Project Name: Portail
-- Target Devices: 
-- Tool Versions: 
-- Description: simulation de TICK_Ns
-- 
-- Dependencies: TICK_Ns
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TICK_Ns_tb is
--  Port ( );
end TICK_Ns_tb;

architecture Behavioral of TICK_Ns_tb is
    signal CLK: STD_LOGIC;
    signal Tick: STD_LOGIC;
    signal Reset: STD_LOGIC;
    constant CLK_period: time := 10 ns;
begin
    UUT : entity work.TICK_Ns generic map(N => 1) port map(CLK => CLK, Tick => Tick, Reset => Reset);
    
    CLK_process : process begin
        CLK <= '0';
        wait for CLK_period/2;
        CLK <= '1';
        wait for CLK_period/2;
    end process;
    
    process begin
        Reset <= '0';
        wait for CLK_period*5;
        Reset <= '1';
        wait for CLK_period;
        Reset <= '0';
        wait for CLK_period*5;       
        Reset <= '1';
        wait for CLK_period*5;
        Reset <= '0';
        wait for CLK_period*5;
    end process;
end Behavioral;
