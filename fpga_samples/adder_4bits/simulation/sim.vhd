----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 2025/08/10 21:52:16
-- Design Name:
-- Module Name: simulation - rtl
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sim is
end sim;

architecture rtl of sim is

component adder_4bits
    port(
        a : in std_logic_vector(3 downto 0);
        b : in std_logic_vector(3 downto 0);
        sum : out std_logic_vector(4 downto 0)
    );
end component;

signal a, b : std_logic_vector(3 downto 0);
signal sum: std_logic_vector(4 downto 0);

begin

    adder: adder_4bits port map(a, b, sum);
    process
    begin
        for i in 0 to 15 loop
            for j in 0 to 15 loop
                a <= std_logic_vector(to_unsigned(i, 4));
                b <= std_logic_vector(to_unsigned(j, 4));
                wait for 1 ns;
            end loop;
        end loop;
        wait;
    end process;
end rtl;
