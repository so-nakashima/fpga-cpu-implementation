----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 2025/08/10 21:44:16
-- Design Name:
-- Module Name: full_adder - Behavioral
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

entity full_adder is
    port(
        a : in std_logic;
        b : in std_logic;
        carry_in: in std_logic;
        sum: out std_logic;
        carry_out: out std_logic
    );
end full_adder;


architecture rtl of full_adder is


component half_adder is
    port(
        a : in std_logic;
        b : in std_logic;
        sum : out std_logic;
        carry : out std_logic
    );
end component;

signal sum_tmp: std_logic;
signal carry_out_tmp_1: std_logic;
signal carry_out_tmp_2: std_logic;

begin
    half_adder_1: half_adder port map(a, b, sum_tmp, carry_out_tmp_1);
    half_adder_2: half_adder port map(sum_tmp, carry_in, sum, carry_out_tmp_2);
    carry_out <= carry_out_tmp_1 or carry_out_tmp_2;
end rtl;
