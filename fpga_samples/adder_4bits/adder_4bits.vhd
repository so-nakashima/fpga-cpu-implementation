----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 2025/08/10 22:07:37
-- Design Name:
-- Module Name: adder_4bits - Behavioral
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

entity adder_4bits is
    port(
        a : in std_logic_vector(3 downto 0);
        b : in std_logic_vector(3 downto 0);
        sum : out std_logic_vector(4 downto 0)
    );
end adder_4bits;

architecture rtl of adder_4bits is

component half_adder is
    port(
        a : in std_logic;
        b : in std_logic;
        sum : out std_logic;
        carry : out std_logic
    );
end component;

component full_adder is
    port(
        a : in std_logic;
        b : in std_logic;
        carry_in : in std_logic;
        sum : out std_logic;
        carry_out : out std_logic
    );
end component;

signal carry_out_tmp: std_logic_vector(3 downto 0);

begin

    half_adder_1: half_adder port map(a(0), b(0), sum(0), carry_out_tmp(0));
    full_adder_1: full_adder port map(a(1), b(1), carry_out_tmp(0), sum(1), carry_out_tmp(1));
    full_adder_2: full_adder port map(a(2), b(2), carry_out_tmp(1), sum(2), carry_out_tmp(2));
    full_adder_3: full_adder port map(a(3), b(3), carry_out_tmp(2), sum(3), carry_out_tmp(3));
    sum(4) <= carry_out_tmp(3);

end rtl;
