----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Alban Benmouffek
-- 
-- Create Date: 25.02.2019 14:14:41
-- Design Name: 
-- Module Name: AntiRebond - Behavioral
-- Project Name: Portail
-- Target Devices: 
-- Tool Versions: 
-- Description: anti rebond pour le digicode (20ms par defaut)
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

entity AntiRebond is
    Generic ( 
        DureeRebond : integer := 20 --Puissance de l'anti rebond (en ms)
        );
    Port ( 
        CLK : in STD_LOGIC; --Horloge
        
        clavier_IN : in STD_LOGIC_VECTOR (15 downto 0);
        clavier_OUT : out STD_LOGIC_VECTOR (15 downto 0)

        
    );
end AntiRebond;

architecture Behavioral of AntiRebond is
    signal fin : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
    signal debut : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
    signal clavier : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
begin
    dfm : entity work.DFM_vectoriel generic map(dim => 16) port map(CLK => CLK, entree => clavier_IN, front => debut);
    
    waiter0: entity work.TICK_Nms generic map(N => DureeRebond) port map(CLK => CLK, Reset => debut(0), Tick => fin(0));
    
    waiter1: entity work.TICK_Nms generic map(N => DureeRebond) port map(CLK => CLK, Reset => debut(1), Tick => fin(1));

    waiter2: entity work.TICK_Nms generic map(N => DureeRebond) port map(CLK => CLK, Reset => debut(2), Tick => fin(2));

    waiter3: entity work.TICK_Nms generic map(N => DureeRebond) port map(CLK => CLK, Reset => debut(3), Tick => fin(3));

    waiter4: entity work.TICK_Nms generic map(N => DureeRebond) port map(CLK => CLK, Reset => debut(4), Tick => fin(4));

    waiter5: entity work.TICK_Nms generic map(N => DureeRebond) port map(CLK => CLK, Reset => debut(5), Tick => fin(5));

    waiter6: entity work.TICK_Nms generic map(N => DureeRebond) port map(CLK => CLK, Reset => debut(6), Tick => fin(6));

    waiter7: entity work.TICK_Nms generic map(N => DureeRebond) port map(CLK => CLK, Reset => debut(7), Tick => fin(7));

    waiter8: entity work.TICK_Nms generic map(N => DureeRebond) port map(CLK => CLK, Reset => debut(8), Tick => fin(8));

    waiter9: entity work.TICK_Nms generic map(N => DureeRebond) port map(CLK => CLK, Reset => debut(9), Tick => fin(9));

    waiter10: entity work.TICK_Nms generic map(N => DureeRebond) port map(CLK => CLK, Reset => debut(10), Tick => fin(10));

    waiter11: entity work.TICK_Nms generic map(N => DureeRebond) port map(CLK => CLK, Reset => debut(11), Tick => fin(11));

    waiter12: entity work.TICK_Nms generic map(N => DureeRebond) port map(CLK => CLK, Reset => debut(12), Tick => fin(12));

    waiter13: entity work.TICK_Nms generic map(N => DureeRebond) port map(CLK => CLK, Reset => debut(13), Tick => fin(13));

    waiter14: entity work.TICK_Nms generic map(N => DureeRebond) port map(CLK => CLK, Reset => debut(14), Tick => fin(14));

    waiter15: entity work.TICK_Nms generic map(N => DureeRebond) port map(CLK => CLK, Reset => debut(15), Tick => fin(15));
    
    
    process(CLK) begin
        if rising_edge(CLK) then
            for K in 0 to 15 loop
                if debut(K) = '1' then
                    clavier(K) <= '1';
                elsif fin(K) = '1' then
                    clavier(K) <= '1';
                else
                    clavier(K) <= clavier(K);
                end if;
            end loop;
        end if;
    end process;
    
    clavier_OUT <= clavier;
    
end Behavioral;
