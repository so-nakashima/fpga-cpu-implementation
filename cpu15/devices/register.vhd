----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 2025/08/13 15:20:09
-- Design Name:
-- Module Name: register - rtl
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
library work;
use work.constants_pkg.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity reg is
    generic(
        REGISTER_ADDRESS_WIDTH : integer := REGISTER_ADDRESS_WIDTH;
        WIDTH : integer := OPERAND_WIDTH
    );
    port(
        clk : in std_logic;
        -- 書き込みポート
        write_enable : in std_logic;
        write_address : in std_logic_vector(REGISTER_ADDRESS_WIDTH - 1 downto 0);
        write_data : in std_logic_vector(WIDTH - 1 downto 0);
        -- 読み出しポート(2つ)
        read_address_1 : in std_logic_vector(REGISTER_ADDRESS_WIDTH - 1 downto 0);
        read_address_2 : in std_logic_vector(REGISTER_ADDRESS_WIDTH - 1 downto 0);
        read_data_1 : out std_logic_vector(WIDTH - 1 downto 0);
        read_data_2 : out std_logic_vector(WIDTH - 1 downto 0)
    );
end reg;

architecture rtl of reg is
    subtype word_t is std_logic_vector(WIDTH - 1 downto 0);
    type reg_array_t is array(0 to 2 ** REGISTER_ADDRESS_WIDTH - 1) of word_t;
    signal reg_array : reg_array_t := (others => (others => '0'));

begin
    process(clk)
    begin
        if rising_edge(clk) then
            if write_enable = '1' then
                reg_array(conv_integer(write_address)) <= write_data;
            end if;
            read_data_1 <= reg_array(conv_integer(read_address_1));
            read_data_2 <= reg_array(conv_integer(read_address_2));
        end if;
    end process;
end rtl;
