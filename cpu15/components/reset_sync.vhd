----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 2025/08/15 11:17:05
-- Design Name:
-- Module Name: reset_sync - Behavioral
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

entity reset_sync is
    port(
        clk : in std_logic;
        reset_raw : in std_logic;
        reset_synced : out std_logic
    );
end reset_sync;

architecture rtl  of reset_sync is
    -- 二段FFでメタステーブルを回避
    signal r1, r2 : std_logic := '0';
begin
    process(clk)
    begin
        if reset_raw = '1' then
            r1 <= '1';
            r2 <= r1;
        elsif rising_edge(clk) then
            r1 <= '0';
            r2 <= r1;
        end if;
    end process;

    reset_synced <= r2;
end rtl;
