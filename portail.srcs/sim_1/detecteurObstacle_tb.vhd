----------------------------------------------------------------------------------
-- Company: ENSEA
-- Engineer: Alban Benmouffek, Salomé Wattiaux, Marco Guzzon
-- 
-- Create Date: 26.02.2019 16:33:13
-- Design Name: 
-- Module Name: detecteurObstacle_tb - Behavioral
-- Project Name: Portail
-- Target Devices: 
-- Tool Versions: 
-- Description: simulation de detecteurObstacle.vhd
-- 
-- Dependencies: 
--  detecteurObstacle (detecteurObstacle.vhd)
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity detecteurObstacle_tb is
--  Port ( );
end detecteurObstacle_tb;

architecture Behavioral of detecteurObstacle_tb is
    signal CLK : STD_LOGIC;
    constant CLK_period: time := 10 ns;
    
    signal SensMoteur : STD_LOGIC;
    signal SignalMoteur : STD_LOGIC;
    signal InfoCourant : STD_LOGIC;
    signal Collision : STD_LOGIC;
begin
    UUT: entity work.detecteurObstacle port map(CLK => CLK, SensMoteur => SensMoteur, SignalMoteur => SignalMoteur, InfoCourant => InfoCourant, Collision => Collision);

    CLK_process : process begin
        CLK <= '0';
        wait for CLK_period/2;
        CLK <= '1';
        wait for CLK_period/2;
    end process;
    
    process begin
        SignalMoteur <= '1';
        SensMoteur <= '1';
        wait for 50ms;
        SignalMoteur <= '0';
        SensMoteur <= '1';
        wait for 50ms;
        SignalMoteur <= '1';
        SensMoteur <= '0';
        wait for 50ms;
        SignalMoteur <= '0';
        SensMoteur <= '0';
        wait for 50ms;
    end process;
    
    process begin
        InfoCourant <= '1';
        wait for 2ms;
        InfoCourant <= '0';
        wait for 7000ns;
    end process;
    
end Behavioral;

