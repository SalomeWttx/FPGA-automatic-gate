----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.02.2019 17:08:25
-- Design Name: 
-- Module Name: AntiPics_vectoriel_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity AntiPics_vectoriel_tb is
--  Port ( );
end AntiPics_vectoriel_tb;

architecture Behavioral of AntiPics_vectoriel_tb is
    signal CLK : STD_LOGIC;
    constant CLK_period: time := 10 ns;
    signal Sig_IN : STD_LOGIC_VECTOR(1 downto 0);
    signal Sig_OUT : STD_LOGIC_VECTOR(1 downto 0);
    signal Tick : STD_LOGIC;
begin
    UUT: entity work.AntiPics_vectoriel generic map (dim => 2) port map (CLK => CLK, Sig_IN => Sig_IN, Sig_OUT => Sig_OUT, Tick => Tick);

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
        Sig_IN(0) <= '0';
        wait for 30ms;
        Sig_IN(0) <= '1';
        wait for 3ms;
        Sig_IN(0) <= '0';
        wait for 1ms;
        Sig_IN(0) <= '1';
        wait for 30ms;
        Sig_IN(0) <= '0';
        wait for 3ms;
        Sig_IN(0) <= '1';
        wait for 30ms;
        Sig_IN(0) <= '0';
        wait for 30ms;
        Sig_IN(0) <= '1';
        wait for 3ms;
        Sig_IN(0) <= '0';
        wait for 30ms;
        
    end process;

    process begin
        Sig_IN(1) <= '0';
        wait for 60ms;
        Sig_IN(1) <= '1';
        wait for 3ms;
        Sig_IN(1) <= '0';
        wait for 1ms;
        Sig_IN(1) <= '1';
        wait for 30ms;
        Sig_IN(1) <= '0';
        wait for 3ms;
        Sig_IN(1) <= '1';
        wait for 30ms;
        Sig_IN(1) <= '0';
        wait for 30ms;
        Sig_IN(1) <= '1';
        wait for 3ms;
        Sig_IN(1) <= '0';
        wait for 30ms;
        
    end process;
end Behavioral;

