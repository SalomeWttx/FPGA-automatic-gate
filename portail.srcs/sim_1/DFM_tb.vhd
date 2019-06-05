----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Alban Benmouffek
-- 
-- Create Date: 25.02.2019 10:50:01
-- Design Name: 
-- Module Name: DFM_tb - Behavioral
-- Project Name: Portail
-- Target Devices: 
-- Tool Versions: 
-- Description: simulation de DFM
-- 
-- Dependencies: DFM
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;use IEEE.NUMERIC_STD.ALL;

entity DFM_tb is
--  Port ( );
end DFM_tb;

architecture Behavioral of DFM_tb is
    signal CLK : STD_LOGIC;
    constant CLK_period: time := 10 ns;
    signal entree : STD_LOGIC;
    signal front : STD_LOGIC;
begin
    UUT: entity work.DFM port map (CLK => CLK, entree => entree, front => front);

    CLK_process : process begin
        CLK <= '0';
        wait for CLK_period/2;
        CLK <= '1';
        wait for CLK_period/2;
    end process;
    
    process begin
        entree <= '0';
        wait for CLK_period*10;
        entree <= '1';
        wait for CLK_period*10;
    end process;

end Behavioral;
