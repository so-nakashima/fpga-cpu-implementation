----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 2025/08/11 15:58:55
-- Design Name:
-- Module Name: fetch - Behavioral
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
use work.constants_pkg.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fetch is
    port(
        clk : in std_logic;
        clk_enable : in std_logic;
        program_counter : in std_logic_vector(PC_WIDTH - 1 downto 0);
        machine_code : out std_logic_vector(MACHINE_CODE_WIDTH - 1 downto 0)
    );
end fetch;

architecture rtl of fetch is

-- 以下はfetchでプログラムを持つ妥協をしたための部分
constant LEN_MACHINE_CODE_ARRAY : integer := 16;
type machine_code_array_t is array(0 to LEN_MACHINE_CODE_ARRAY - 1) of std_logic_vector(MACHINE_CODE_WIDTH - 1 downto 0);

constant PROGRAM : machine_code_array_t :=
(
    "100100000000000", -- ldh Reg0, 0
    "100000000000000", -- ldl Reg0, 0
    "100100100000000", -- ldh Reg1, 0
    "100001000000001", -- ldl Reg1, 1
    "100101000000000", -- ldh Reg2, 0
    "100010000000000", -- ldl Reg2, 0
    "100101100000000", -- ldh Reg3, 0
    "100011000001010", -- ldl Reg3, 10
    "000101000100000", -- add Reg2, Reg1
    "000100000100000", -- add Reg0, Reg2
    "111000001000000", -- st Reg0, 64(40h)
    "101001001100000", -- cmp Reg2, Reg3
    "101100000001110", -- je 14 (Eh)
    "110000000001000", -- jmp 0 (0h)
    "111100000000000", -- hlt
    "000000000000000"  -- nop
);

begin
    process(clk)
    begin
        if rising_edge(clk) then
            if clk_enable = '1' then
                machine_code <= PROGRAM(conv_integer(program_counter));
            end if;
        end if;
    end process;

end rtl;
