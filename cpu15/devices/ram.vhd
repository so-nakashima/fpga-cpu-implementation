----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 2025/08/13 15:20:09
-- Design Name:
-- Module Name: ram - rtl
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

entity ram is
    generic(
        RAM_ADDRESS_WIDTH : integer := RAM_ADDRESS_WIDTH;
        WIDTH : integer := OPERAND_WIDTH
    );
    port(
        clk : in std_logic;
        reset : in std_logic;
        -- 書き込みポート
        -- 現在writeback phaseかのフラグ
        clk_write_enable : in std_logic;
        -- execute phaseで書き込みを行う場合のフラグ
        exec_write_enable : in std_logic;
        write_address : in std_logic_vector(RAM_ADDRESS_WIDTH - 1 downto 0);
        write_data : in std_logic_vector(WIDTH - 1 downto 0);
        -- 読み出しポート
        read_address_1 : in std_logic_vector(RAM_ADDRESS_WIDTH - 1 downto 0);
        read_address_2 : in std_logic_vector(RAM_ADDRESS_WIDTH - 1 downto 0);
        read_data_1 : out std_logic_vector(WIDTH - 1 downto 0);
        read_data_2 : out std_logic_vector(WIDTH - 1 downto 0);
        -- MMIO (input)
        mmio_input : in std_logic_vector(WIDTH - 1 downto 0)
    );
end ram;

architecture rtl of ram is

subtype word_t is std_logic_vector(WIDTH - 1 downto 0);
type ram_array_t is array(0 to 2 ** RAM_ADDRESS_WIDTH - 1) of word_t;
signal ram_array : ram_array_t := (others => (others => '0'));


-- MMIO address
constant MMIO_ADDRESS : std_logic_vector(RAM_ADDRESS_WIDTH - 1 downto 0) := (others => '1');

begin
    process(clk)
    begin
        if rising_edge(clk) then
            -- reset case
            if reset = '1' then
                ram_array <= (others => (others => '0'));
            -- normal case
            elsif clk_write_enable = '1' and exec_write_enable = '1' then
                ram_array(conv_integer(write_address)) <= write_data;
            end if;

            -- read
            if read_address_1 = MMIO_ADDRESS then
                read_data_1 <= mmio_input;
            else
                read_data_1 <= ram_array(conv_integer(read_address_1));
            end if;

            if read_address_2 = MMIO_ADDRESS then
                read_data_2 <= mmio_input;
            else
                read_data_2 <= ram_array(conv_integer(read_address_2));
            end if;
        end if;
    end process;
end rtl;
