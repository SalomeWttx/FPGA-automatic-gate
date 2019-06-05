----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.03.2019 09:04:11
-- Design Name: 
-- Module Name: testdigicode - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity testdigicode is
    Port ( A : out STD_LOGIC_VECTOR (3 downto 0);
           B : out STD_LOGIC_VECTOR (3 downto 0);
           C : out STD_LOGIC_VECTOR (3 downto 0);
           D : out STD_LOGIC_VECTOR (3 downto 0);
        CLK : in STD_LOGIC;
        toucheDetectee : in STD_LOGIC;
        numeroTouche : in STD_LOGIC_VECTOR (3 downto 0)
        );
end testdigicode;

architecture Behavioral of testdigicode is
    signal chiffre1 : STD_LOGIC_VECTOR(3 downto 0) := "0000" ;
    signal chiffre2 : STD_LOGIC_VECTOR(3 downto 0) := "0000" ;
    signal chiffre3 : STD_LOGIC_VECTOR(3 downto 0) := "0000" ;
    signal chiffre4 : STD_LOGIC_VECTOR(3 downto 0) := "0000" ;
begin
    
    process(CLK) begin
        if rising_edge(CLK) then
            if toucheDetectee = '1' then
                chiffre4 <= chiffre3;
                chiffre3 <= chiffre2;
                chiffre2 <= chiffre1;
                chiffre1 <= numeroTouche;
            end if;
        end if;
    end process;
    
    A <= chiffre1;
    B <= chiffre2;
    C <= chiffre3;
    D <= chiffre4;

end Behavioral;
