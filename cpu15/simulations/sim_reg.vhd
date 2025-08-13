----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 2025/08/13 15:33:13
-- Design Name:
-- Module Name: sim_reg - Behavioral
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
library work;
use work.constants_pkg.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sim_reg is
end sim_reg;

architecture rtl of sim_reg is

signal clk : std_logic;
signal write_enable : std_logic;
signal write_address : std_logic_vector(REGISTER_ADDRESS_WIDTH - 1 downto 0);
signal write_data : std_logic_vector(OPERAND_WIDTH - 1 downto 0);
signal read_address_1 : std_logic_vector(REGISTER_ADDRESS_WIDTH - 1 downto 0);
signal read_address_2 : std_logic_vector(REGISTER_ADDRESS_WIDTH - 1 downto 0);
signal read_data_1 : std_logic_vector(OPERAND_WIDTH - 1 downto 0);
signal read_data_2 : std_logic_vector(OPERAND_WIDTH - 1 downto 0);

component reg is
    generic(
        REGISTER_ADDRESS_WIDTH : integer := REGISTER_ADDRESS_WIDTH;
        WIDTH : integer := OPERAND_WIDTH);
    port(
        clk : in std_logic;
        write_enable : in std_logic;
        write_data : in std_logic_vector(WIDTH - 1 downto 0);
        write_address : in std_logic_vector(REGISTER_ADDRESS_WIDTH - 1 downto 0);
        read_address_1 : in std_logic_vector(REGISTER_ADDRESS_WIDTH - 1 downto 0);
        read_address_2 : in std_logic_vector(REGISTER_ADDRESS_WIDTH - 1 downto 0);
        read_data_1 : out std_logic_vector(WIDTH - 1 downto 0);
        read_data_2 : out std_logic_vector(WIDTH - 1 downto 0)
    );
end component;


begin
    reg_inst : reg
        generic map(REGISTER_ADDRESS_WIDTH => REGISTER_ADDRESS_WIDTH, WIDTH => OPERAND_WIDTH)
        port map(
            clk => clk,
            write_enable => write_enable,
            write_data => write_data,
            write_address => write_address,
            read_address_1 => read_address_1,
            read_address_2 => read_address_2,
            read_data_1 => read_data_1,
            read_data_2 => read_data_2
        );

    process begin
        -- check initialization
        -- also check no write during write_enable = 0
        clk <= '0';
        write_enable <= '0';
        read_address_1 <= "000";
        read_address_2 <= "001";
        write_address <= "000";
        write_data <= "0000000000000001";
        write_enable <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
        assert read_data_1 = "0000000000000000" report "read_data_1 is not 0" severity error;
        assert read_data_2 = "0000000000000000" report "read_data_2 is not 0" severity error;

        -- check write
        write_enable <= '1';
        wait for 10 ns;
        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
        assert read_data_1 = "0000000000000001" report "read_data_1 is not 1" severity error;
        assert read_data_2 = "0000000000000000" report "read_data_2 is not 0" severity error;
    end process;

end rtl;
