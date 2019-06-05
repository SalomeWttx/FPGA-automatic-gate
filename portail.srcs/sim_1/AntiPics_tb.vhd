----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Alban Benmouffek
-- 
-- Create Date: 28.02.2019 16:17:08
-- Design Name: 
-- Module Name: AntiPics_tb - Behavioral
-- Project Name: Portail
-- Target Devices: 
-- Tool Versions: 
-- Description: test de AntiPics
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

entity AntiPics_tb is

end AntiPics_tb;

architecture Behavioral of AntiPics_tb is
    signal CLK : STD_LOGIC;
    constant CLK_period: time := 10 ns;
    signal Sig_IN : STD_LOGIC;
    signal Sig_OUT : STD_LOGIC;
    signal Tick : STD_LOGIC;
begin
    UUT: entity work.AntiPics port map (CLK => CLK, Sig_IN => Sig_IN, Sig_OUT => Sig_OUT, Tick => Tick);

    CLK_process : process begin
        CLK <= '0';
        wait for CLK_period/2;
        CLK <= '1';
        wait for CLK_period/2;
    end process;
    
    process begin
        Tick <= '0';
        wait for 1ms;
        Tick <= '1';
        wait for CLK_period;
    end process;
    
    process begin
        Sig_IN <= '0';
        wait for 30ms;
        Sig_IN <= '1';
        wait for 3ms;
        Sig_IN <= '0';
        wait for 1ms;
        Sig_IN <= '1';
        wait for 30ms;
        Sig_IN <= '0';
        wait for 3ms;
        Sig_IN <= '1';
        wait for 30ms;
        Sig_IN <= '0';
        wait for 30ms;
        Sig_IN <= '1';
        wait for 3ms;
        Sig_IN <= '0';
        wait for 30ms;
        
    end process;

end Behavioral;
