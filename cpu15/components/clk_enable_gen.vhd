----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 2025/08/11 14:42:08
-- Design Name:
-- Module Name: clock_enable_gen - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clk_enable_gen is
    port(
        clk : in std_logic;
        clk_enable_fetch : out std_logic;
        clk_enable_decode : out std_logic;
        clk_enable_execute : out std_logic;
        clk_enable_writeback : out std_logic
    );
end clk_enable_gen;

architecture rtl of clk_enable_gen is
signal count: std_logic_vector(1 downto 0) := "00";

begin
    process(clk)
    begin
        if rising_edge(clk) then
            case count is
                when "00" =>
                    clk_enable_fetch <= '1';
                    clk_enable_decode <= '0';
                    clk_enable_execute <= '0';
                    clk_enable_writeback <= '0';
                when "01" =>
                    clk_enable_fetch <= '0';
                    clk_enable_decode <= '1';
                    clk_enable_execute <= '0';
                    clk_enable_writeback <= '0';
                when "10" =>
                    clk_enable_fetch <= '0';
                    clk_enable_decode <= '0';
                    clk_enable_execute <= '1';
                    clk_enable_writeback <= '0';
                when "11" =>
                    clk_enable_fetch <= '0';
                    clk_enable_decode <= '0';
                    clk_enable_execute <= '0';
                    clk_enable_writeback <= '1';
                when others =>
                    null;
            end case;

            count <= count + 1;
        end if;
    end process;


end rtl;
