----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 2025/08/11 16:23:07
-- Design Name:
-- Module Name: sim_fetch - rtl
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
use work.constants_pkg.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sim_fetch is
end sim_fetch;

architecture rtl of sim_fetch is

component fetch is
    port(
        clk : in std_logic;
        clk_enable : in std_logic;
        program_counter : in std_logic_vector(PC_WIDTH - 1 downto 0);
        machine_code : out std_logic_vector(MACHINE_CODE_WIDTH - 1 downto 0)
    );
end component;

signal clk: std_logic;
signal clk_enable: std_logic;
signal program_counter: std_logic_vector(PC_WIDTH - 1 downto 0);
signal machine_code: std_logic_vector(MACHINE_CODE_WIDTH - 1 downto 0);

begin

    fetch_inst: fetch
    port map(
        clk => clk,
        clk_enable => clk_enable,
        program_counter => program_counter,
        machine_code => machine_code
    );

    process
    begin
        clk_enable <= '1';
        program_counter <= "00000000";
        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
        assert machine_code = "100100000000000" report "test1: machine_code is not 100100000000000" severity error;


        program_counter <= "00000101";
        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
        assert machine_code = "100001000000000" report "test2: machine_code is not 100001000000000" severity error;

        program_counter <= "00001111";
        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
        assert machine_code = "000000000000000" report "test3: machine_code is not 000000000000000" severity error;

        program_counter <= "00000000";
        clk <= '0';
        clk_enable <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
        assert machine_code = "000000000000000" report "test4: fetched when clk_enable is 0" severity error;

        wait;

    end process;


end rtl;
