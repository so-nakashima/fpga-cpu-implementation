----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 2025/08/10 23:24:58
-- Design Name:
-- Module Name: main - Behavioral
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

entity main is
    port(
        clk : in std_logic;
        input : in std_logic_vector(15 downto 0);
        anode_digit : out std_logic_vector(3 downto 0);
        seg : out std_logic_vector(6 downto 0);
        decimal_point : out std_logic
    );
end main;

architecture rtl of main is
component seg7_driver is
    port(
        clk : in std_logic;
        value : in std_logic_vector(15 downto 0);
        anode_digit : out std_logic_vector(3 downto 0);
        seg : out std_logic_vector(6 downto 0);
        decimal_point : out std_logic
    );
end component;

constant TICK_CYCLES : natural := 10_000_000;
constant DIV_WIDTH : natural := 24;

signal div       : unsigned(DIV_WIDTH-1 downto 0) := (others => '0');
signal value_tmp : unsigned(15 downto 0)          := (others => '0');
signal value : std_logic_vector(15 downto 0);

begin

    -- 以下をコメントインして、それ以下のコードをコメントアウトすると、
    -- トグルスイッチの入力を7セグメントディスプレイに表示する
    -- u1: seg7_driver port map(
    --     clk => clk,
    --     value => input,
    --     anode_digit => anode_digit,
    --     seg => seg,
    --     decimal_point => decimal_point
    -- );

    u1: seg7_driver port map(
        clk => clk,
        value => value,
        anode_digit => anode_digit,
        seg => seg,
        decimal_point => decimal_point
    );

  process(clk)
  begin
    if rising_edge(clk) then
      if div = to_unsigned(TICK_CYCLES-1, div'length) then
        div       <= (others => '0');
        value_tmp <= value_tmp + 1;
      else
        div <= div + 1;
      end if;
    end if;
  end process;

  value <= std_logic_vector(value_tmp);

end rtl;
