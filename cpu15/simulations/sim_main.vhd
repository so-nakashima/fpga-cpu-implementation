----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 2025/08/14 23:41:21
-- Design Name:
-- Module Name: sim_main - Behavioral
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

entity sim_main is
end sim_main;

architecture Behavioral of sim_main is

constant CLK_PERIOD : time := 20 ns;

component main is
    port(
        clk : in std_logic;
        input : in std_logic_vector(15 downto 0);
        reset : in std_logic;
        -- output to 7-seg display
        anode_digit : out std_logic_vector(3 downto 0);
        seg : out std_logic_vector(6 downto 0);
        decimal_point : out std_logic;
        -- output to LED
        led : out std_logic_vector(15 downto 0)
    );
end component;

signal clk : std_logic := '0';
signal input : std_logic_vector(15 downto 0) := (others => '0');
signal reset : std_logic := '0';
signal anode_digit : std_logic_vector(3 downto 0);
signal seg : std_logic_vector(6 downto 0);
signal decimal_point : std_logic;
signal led : std_logic_vector(15 downto 0);

begin
    main_inst : main
        port map(
            clk => clk,
            input => input,
            reset => reset,
            anode_digit => anode_digit,
            seg => seg,
            decimal_point => decimal_point,
            led => led
        );

    process
    begin
        clk <= '0';
        wait for CLK_PERIOD / 2;
        clk <= '1';
        wait for CLK_PERIOD / 2;
    end process;

end Behavioral;
