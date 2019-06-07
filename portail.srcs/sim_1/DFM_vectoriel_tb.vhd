----------------------------------------------------------------------------------
-- Company: ENSEA
-- Engineer: Alban Benmouffek, Salomé Wattiaux, Marco Guzzon
-- 
-- Create Date: 25.02.2019 10:50:01
-- Design Name: 
-- Module Name: DFM_vectoriel_tb - Behavioral
-- Project Name: Portail
-- Target Devices: 
-- Tool Versions: 
-- Description: simulation de DFM_vectoriel
-- 
-- Dependencies: 
--  DFM_vectoriel (DFM_vectoriel.vhd)
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;use IEEE.NUMERIC_STD.ALL;

entity DFM_vectoriel_tb is
--  Port ( );
end DFM_vectoriel_tb;

architecture Behavioral of DFM_vectoriel_tb is
    signal CLK : STD_LOGIC;
    constant CLK_period: time := 10 ns;
    signal entree : STD_LOGIC_VECTOR(1 downto 0);
    signal front : STD_LOGIC_VECTOR(1 downto 0);
begin
    UUT: entity work.DFM_vectoriel generic map (dim => 2) port map (CLK => CLK, entree => entree, front => front);

    CLK_process : process begin
        CLK <= '0';
        wait for CLK_period/2;
        CLK <= '1';
        wait for CLK_period/2;
    end process;
    
    process begin
        entree(0) <= '0';
        wait for CLK_period*10;
        entree(1) <= '0';
        wait for CLK_period*10;
        entree(0) <= '1';
        wait for CLK_period*10;
        entree(1) <= '1';
        wait for CLK_period*10;
    end process;

end Behavioral;
