----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Alban Benmouffek
-- 
-- Create Date: 25.02.2019 11:53:49
-- Design Name: 
-- Module Name: Cligno_tb - Behavioral
-- Project Name: Portail
-- Target Devices: 
-- Tool Versions: 
-- Description: simulation de Cligno
-- 
-- Dependencies: Cligno
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;use IEEE.NUMERIC_STD.ALL;

entity Cligno_tb is
--  Port ( );
end Cligno_tb;

architecture Behavioral of Cligno_tb is
    signal CLK : STD_LOGIC;
    constant CLK_period: time := 10 ns;
    signal active : STD_LOGIC;
    signal lampe : STD_LOGIC;
    constant seconde: time := 1000 ms;
begin
    UUT: entity work.Cligno port map(CLK => CLK, active => active, lampe => lampe);

    CLK_process : process begin
        CLK <= '0';
        wait for CLK_period/2;
        CLK <= '1';
        wait for CLK_period/2;
    end process;
    
    process begin
        active <= '0';
        wait for CLK_period*1000;
        active <= '1';
        wait for 2*seconde;
    end process;

end Behavioral;
