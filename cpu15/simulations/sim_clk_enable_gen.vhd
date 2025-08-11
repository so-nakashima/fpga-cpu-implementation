----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 2025/08/11 14:46:40
-- Design Name:
-- Module Name: sim_clk_enable_gen - Behavioral
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

entity sim_clk_enable_gen is
end sim_clk_enable_gen;

architecture rtl of sim_clk_enable_gen is

component clk_enable_gen is
    port(
        clk : in std_logic;
        clk_enable_fetch : out std_logic;
        clk_enable_decode : out std_logic;
        clk_enable_execute : out std_logic;
        clk_enable_writeback : out std_logic
    );
end component;

signal clk: std_logic;
signal clk_enable_fetch: std_logic;
signal clk_enable_decode: std_logic;
signal clk_enable_execute: std_logic;
signal clk_enable_writeback: std_logic;


begin
    clk_enable_gen_inst: clk_enable_gen
    port map(
        clk => clk,
        clk_enable_fetch => clk_enable_fetch,
        clk_enable_decode => clk_enable_decode,
        clk_enable_execute => clk_enable_execute,
        clk_enable_writeback => clk_enable_writeback
    );

    process
    begin
        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
        assert clk_enable_fetch = '1' report "clk_enable_fetch is not 1" severity error;
        assert clk_enable_decode = '0' report "clk_enable_decode is not 0" severity error;
        assert clk_enable_execute = '0' report "clk_enable_execute is not 0" severity error;
        assert clk_enable_writeback = '0' report "clk_enable_writeback is not 0" severity error;

        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
        assert clk_enable_fetch = '0' report "clk_enable_fetch is not 0" severity error;
        assert clk_enable_decode = '1' report "clk_enable_decode is not 1" severity error;
        assert clk_enable_execute = '0' report "clk_enable_execute is not 0" severity error;
        assert clk_enable_writeback = '0' report "clk_enable_writeback is not 0" severity error;

        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
        assert clk_enable_fetch = '0' report "clk_enable_fetch is not 0" severity error;
        assert clk_enable_decode = '0' report "clk_enable_decode is not 0" severity error;
        assert clk_enable_execute = '1' report "clk_enable_execute is not 1" severity error;
        assert clk_enable_writeback = '0' report "clk_enable_writeback is not 0" severity error;

        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
        assert clk_enable_fetch = '0' report "clk_enable_fetch is not 0" severity error;
        assert clk_enable_decode = '0' report "clk_enable_decode is not 0" severity error;
        assert clk_enable_execute = '0' report "clk_enable_execute is not 0" severity error;
        assert clk_enable_writeback = '1' report "clk_enable_writeback is not 1" severity error;

        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
        assert clk_enable_fetch = '1' report "clk_enable_fetch is not 1" severity error;
        assert clk_enable_decode = '0' report "clk_enable_decode is not 0" severity error;
        assert clk_enable_execute = '0' report "clk_enable_execute is not 0" severity error;
        assert clk_enable_writeback = '0' report "clk_enable_writeback is not 0" severity error;

        wait;
    end process;

end rtl;
