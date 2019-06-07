----------------------------------------------------------------------------------
-- Company: ENSEA
-- Engineer: Alban Benmouffek, Salomé Wattiaux, Marco Guzzon
-- 
-- Create Date: 01.03.2019 16:00:23
-- Design Name: 
-- Module Name: tone_tb - Behavioral
-- Project Name: Portail
-- Target Devices: 
-- Tool Versions: 
-- Description: Simulation de tone
-- 
-- Dependencies: 
--  tone (tone.vhd)
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tone_tb is
--  Port ( );
end tone_tb;

architecture Behavioral of tone_tb is
    signal CLK : STD_LOGIC;
    constant CLK_period: time := 10 ns;
    signal incomingData : STD_LOGIC;
    signal duree : STD_LOGIC_VECTOR(5 downto 0);
    signal repetition : STD_LOGIC_VECTOR(2 downto 0);
    signal ton_IN : STD_LOGIC;
    signal ton_OUT : STD_LOGIC;
    signal active : STD_LOGIC;
begin
    UUT: entity work.tone port map(CLK => CLK, incomingData => incomingData, active => active, duree => duree, repetition => repetition, ton_IN => ton_IN, ton_OUT => ton_OUT);

    CLK_process : process begin
        CLK <= '0';
        wait for CLK_period/2;
        CLK <= '1';
        wait for CLK_period/2;
    end process;
    
    process begin
        incomingData <= '0';
        duree <= "000000";
        repetition <= "000";
        ton_IN <= '0';
        wait for CLK_period*2;
        incomingData <= '1';
        duree <= "000001";
        repetition <= "001";
        ton_IN <= '0';
        wait for CLK_period;
        incomingData <= '0';
        duree <= "000000";
        repetition <= "000";
        ton_IN <= '0';  
        wait for 1000ms;      
    end process;
    
end Behavioral;
