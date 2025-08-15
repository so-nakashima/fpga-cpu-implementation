----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 2025/08/14 19:38:04
-- Design Name:
-- Module Name: sim_decode - Behavioral
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

entity sim_decode is
end sim_decode;

architecture Behavioral of sim_decode is
    signal clk : std_logic := '0';
    signal clk_enable : std_logic := '0';
    signal machine_code : std_logic_vector(MACHINE_CODE_WIDTH - 1 downto 0) := (others => '0');
    signal instruction : std_logic_vector(INSTRUCTION_WIDTH - 1 downto 0);
    signal reg_1_address : std_logic_vector(REGISTER_ADDRESS_WIDTH - 1 downto 0);
    signal reg_2_address : std_logic_vector(REGISTER_ADDRESS_WIDTH - 1 downto 0);
    signal ram_address : std_logic_vector(RAM_ADDRESS_WIDTH - 1 downto 0);

    -- クロック周期の定義
    constant CLK_PERIOD : time := 20 ns;

begin
    -- decodeモジュールのインスタンス化
    uut: entity work.decode
        port map(
            clk => clk,
            clk_enable => clk_enable,
            machine_code => machine_code,
            instruction => instruction,
            reg_1_address => reg_1_address,
            reg_2_address => reg_2_address,
            ram_address => ram_address
        );

    -- クロック生成
    clk_process: process
    begin
        clk <= '0';
        wait for CLK_PERIOD/2;
        clk <= '1';
        wait for CLK_PERIOD/2;
    end process;

    -- テストケース
    stim_proc: process
    begin
        -- 初期化
        clk_enable <= '0';
        machine_code <= (others => '0');
        wait for CLK_PERIOD;

        -- テストケース1
        clk_enable <= '1';
        machine_code <= "000110111011010";
        wait for CLK_PERIOD;
        assert instruction = "0001" report "instruction is not 0001" severity error;
        assert reg_1_address = "101" report "reg_1_address is not 101" severity error;
        assert reg_2_address = "110" report "reg_2_address is not 110" severity error;
        assert ram_address = "11011010" report "ram_address is not 11011010" severity error;

        -- テストケース2:
        machine_code <= "001001100100100";
        wait for CLK_PERIOD;
        assert instruction = "0010" report "instruction is not 0010" severity error;
        assert reg_1_address = "011" report "reg_1_address is not 011" severity error;
        assert reg_2_address = "001" report "reg_2_address is not 001" severity error;
        assert ram_address = "00100100" report "ram_address is not 00100100" severity error;

        -- テストケース3: (instruction=0011, reg1=111, reg2=000, ram=11100000)
        machine_code <= "001111100000000";  -- 0011 111 000 00000000
        wait for CLK_PERIOD;
        assert instruction = "0011" report "instruction is not 0011" severity error;
        assert reg_1_address = "111" report "reg_1_address is not 111" severity error;
        assert reg_2_address = "000" report "reg_2_address is not 000" severity error;
        assert ram_address = "00000000" report "ram_address is not 00000000" severity error;

        -- テスト終了
        clk_enable <= '0';
        wait for CLK_PERIOD * 2;

        wait;
    end process;

end Behavioral;
