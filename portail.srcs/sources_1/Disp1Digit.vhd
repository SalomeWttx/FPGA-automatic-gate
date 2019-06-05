----------------------------------------------------------------------------------
-- Company: ENSEA
-- Engineers: Vincent GUITSCHULA and Alban BENMOUFFEK
-- 
-- Create Date: 24.10.2018 13:47:02
-- Design Name: 
-- Module Name: Disp1Digit - Behavioral
-- Project Name: Chrono
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Disp1Digit is
    Port ( ENAN : out STD_LOGIC_VECTOR (3 downto 0);
           S : out STD_LOGIC_VECTOR (6 downto 0);
           V : in STD_LOGIC_VECTOR (3 downto 0);
           N : in STD_LOGIC_VECTOR (1 downto 0));
end Disp1Digit;

architecture Behavioral of Disp1Digit is
    type lut is array (0 to 9) of std_logic_vector(6 downto 0);
    constant table:lut:=("0000001",
                            "1001111",
                            "0010010",
                            "0000110",
                            "1001100",
                            "0100100",
                            "0100000",
                            "0001111",
                            "0000000",
                            "0000100");
begin
    S<=table(to_integer(unsigned(V)));
    ENAN<= "1110" when N="00" else
            "1101" when N="01" else
            "1011" when N="10" else
            "0111";
end Behavioral;

