----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 2025/08/10 23:46:18
-- Design Name:
-- Module Name: 16bits_to_7seg - rtl
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

entity seg7_driver is
    port(
        clk : in std_logic;
        value : in std_logic_vector(15 downto 0);
        anode_digit: out std_logic_vector(3 downto 0);
        seg : out std_logic_vector(6 downto 0);
        decimal_point: out std_logic
    );
end seg7_driver;

architecture rtl of seg7_driver is

    type seg7_t is array (0 to 15) of std_logic_vector(6 downto 0);
    constant HEX_TO_7SEG_LUT: seg7_t := (
        0  => "1000000",
        1  => "1111001",
        2  => "0100100",
        3  => "0110000",
        4  => "0011001",
        5  => "0010010",
        6  => "0000010",
        7  => "1111000",
        8  => "0000000",
        9  => "0010000",
        10 => "0001000",
        11 => "0000011",
        12 => "1000110",
        13 => "0100001",
        14 => "0000110",
        15 => "0001110"
    );

    signal cnt: unsigned(16 downto 0) := (others => '0');
    signal selected_digit_2bit: std_logic_vector(1 downto 0);
    signal selected_nibble: std_logic_vector(3 downto 0);

    begin
        process(clk)
        begin
            if rising_edge(clk) then
                cnt <= cnt + 1;
            end if;
    end process;

    selected_digit_2bit <= std_logic_vector(cnt(16 downto 15));
    with selected_digit_2bit select anode_digit <=
        "1110" when "00",
        "1101" when "01",
        "1011" when "10",
        "0111" when others;

    with selected_digit_2bit select selected_nibble <=
        value(3 downto 0) when "00",
        value(7 downto 4) when "01",
        value(11 downto 8) when "10",
        value(15 downto 12) when others;

    seg <= HEX_TO_7SEG_LUT(to_integer(unsigned(selected_nibble)));
    decimal_point <= '1'; -- decimal point is always off

end rtl;
