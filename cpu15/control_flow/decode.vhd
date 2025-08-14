----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 2025/08/12 01:43:22
-- Design Name:
-- Module Name: decode - rtl
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
use work.constants_pkg.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity decode is
    port(
        clk : in std_logic;
        clk_enable : in std_logic;
        machine_code : in std_logic_vector(MACHINE_CODE_WIDTH - 1 downto 0);
        instruction : out std_logic_vector(INSTRUCTION_WIDTH - 1 downto 0);
        reg_1_address : out std_logic_vector(REGISTER_ADDRESS_WIDTH - 1 downto 0);
        reg_2_address : out std_logic_vector(REGISTER_ADDRESS_WIDTH - 1 downto 0);
        ram_address : out std_logic_vector(RAM_ADDRESS_WIDTH - 1 downto 0)
    );
end decode;

architecture rtl of decode is


begin
    process(clk)
    begin
        if rising_edge(clk) then
            if clk_enable = '1' then
                -- IIIIxxxxxxxxxxx のIIIIがinstruction
                instruction <= machine_code(14 downto 11);

                -- レジスタの読み出し
                reg_1_address <= machine_code(10 downto 8);
                reg_2_address <= machine_code(7 downto 5);

                -- メモリの読み出し
                ram_address <= machine_code(7 downto 0);
            end if;
        end if;
    end process;
end rtl;
