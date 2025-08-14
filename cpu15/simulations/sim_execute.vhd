----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 2025/08/14 22:00:00
-- Design Name:
-- Module Name: sim_execute - Behavioral
-- Project Name:
-- Target Devices:
-- Tool Versions:
-- Description: execute.vhdの各オペレーションに対するテストベンチ
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
use work.constants_pkg.ALL;

entity sim_execute is
end sim_execute;

architecture Behavioral of sim_execute is
    -- テスト対象のコンポーネント
    component execute is
        port(
            clk : in std_logic;
            clk_enable : in std_logic;
            instruction : in std_logic_vector(INSTRUCTION_WIDTH - 1 downto 0);
            program_counter : in std_logic_vector(PC_WIDTH - 1 downto 0);
            flag : in std_logic;
            reg_1_data : in std_logic_vector(OPERAND_WIDTH - 1 downto 0);
            reg_2_data : in std_logic_vector(OPERAND_WIDTH - 1 downto 0);
            ram_data : in std_logic_vector(OPERAND_WIDTH - 1 downto 0);
            op_data : in std_logic_vector(OPERAND_WIDTH / 2 - 1 downto 0);
            next_program_counter : out std_logic_vector(PC_WIDTH - 1 downto 0);
            next_flag : out std_logic;
            reg_write_enable : out std_logic;
            reg_write_data : out std_logic_vector(OPERAND_WIDTH - 1 downto 0);
            ram_write_enable : out std_logic;
            ram_write_data : out std_logic_vector(OPERAND_WIDTH - 1 downto 0)
        );
    end component;

    -- テスト信号
    signal clk : std_logic := '0';
    signal clk_enable : std_logic := '1';
    signal instruction : std_logic_vector(INSTRUCTION_WIDTH - 1 downto 0) := (others => '0');
    signal program_counter : std_logic_vector(PC_WIDTH - 1 downto 0) := (others => '0');
    signal flag : std_logic := '0';
    signal reg_1_data : std_logic_vector(OPERAND_WIDTH - 1 downto 0) := (others => '0');
    signal reg_2_data : std_logic_vector(OPERAND_WIDTH - 1 downto 0) := (others => '0');
    signal ram_data : std_logic_vector(OPERAND_WIDTH - 1 downto 0) := (others => '0');
    signal op_data : std_logic_vector(OPERAND_WIDTH / 2 - 1 downto 0) := (others => '0');
    signal next_program_counter : std_logic_vector(PC_WIDTH - 1 downto 0);
    signal next_flag : std_logic;
    signal reg_write_enable : std_logic;
    signal reg_write_data : std_logic_vector(OPERAND_WIDTH - 1 downto 0);
    signal ram_write_enable : std_logic;
    signal ram_write_data : std_logic_vector(OPERAND_WIDTH - 1 downto 0);

    -- クロック周期
    constant CLK_PERIOD : time := 20 ns;

begin
    -- テスト対象のインスタンス化
    uut: execute port map(
        clk => clk,
        clk_enable => clk_enable,
        instruction => instruction,
        program_counter => program_counter,
        flag => flag,
        reg_1_data => reg_1_data,
        reg_2_data => reg_2_data,
        ram_data => ram_data,
        op_data => op_data,
        next_program_counter => next_program_counter,
        next_flag => next_flag,
        reg_write_enable => reg_write_enable,
        reg_write_data => reg_write_data,
        ram_write_enable => ram_write_enable,
        ram_write_data => ram_write_data
    );

    -- クロック生成
    clk_process: process
    begin
        clk <= '0';
        wait for CLK_PERIOD / 2;
        clk <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    -- テストプロセス
    stim_proc: process
    begin
        -- 初期化
        wait for CLK_PERIOD;

        -- テスト1: ALU_MOV (instruction = 0)
        instruction <= "0000";
        program_counter <= "00000001";
        reg_1_data <= x"1234";
        reg_2_data <= x"5678";
        flag <= '0';
        wait until rising_edge(clk);  -- この立上がりで演算
        wait for 1 ps;                -- 少しだけ待ってからチェック
        assert reg_write_data = x"5678" report "ALU_MOV: reg_write_data is wrong" severity error;
        assert next_program_counter = "00000010" report "ALU_MOV: next_program_counter is wrong" severity error;
        assert reg_write_enable = '1' report "ALU_MOV: reg_write_enable is wrong" severity error;
        assert ram_write_enable = '0' report "ALU_MOV: ram_write_enable is wrong" severity error;

        -- テスト2: ALU_ADD (instruction = 1)
        instruction <= "0001";
        program_counter <= "00000010";
        reg_1_data <= x"0005";
        reg_2_data <= x"0003";
        wait until rising_edge(clk);  -- この立上がりで演算
        wait for 1 ps;                -- 少しだけ待ってからチェック
        assert reg_write_data = x"0008" report "ALU_ADD: reg_write_data is wrong" severity error;
        assert next_program_counter = "00000011" report "ALU_ADD: next_program_counter is wrong" severity error;
        assert reg_write_enable = '1' report "ALU_ADD: reg_write_enable is wrong" severity error;

        -- テスト3: ALU_SUB (instruction = 2)
        instruction <= "0010";
        program_counter <= "00000011";
        reg_1_data <= x"0008";
        reg_2_data <= x"0003";
        wait until rising_edge(clk);  -- この立上がりで演算
        wait for 1 ps;                -- 少しだけ待ってからチェック
        assert reg_write_data = x"0005" report "ALU_SUB: reg_write_data is wrong" severity error;
        assert next_program_counter = "00000100" report "ALU_SUB: next_program_counter is wrong" severity error;

        -- テスト4: ALU_AND (instruction = 3)
        instruction <= "0011";
        program_counter <= "00000100";
        reg_1_data <= x"00FF";
        reg_2_data <= x"0F0F";
        wait until rising_edge(clk);  -- この立上がりで演算
        wait for 1 ps;                -- 少しだけ待ってからチェック
        assert reg_write_data = x"000F" report "ALU_AND: reg_write_data is wrong" severity error;
        assert next_program_counter = "00000101" report "ALU_AND: next_program_counter is wrong" severity error;

        -- テスト5: ALU_OR (instruction = 4)
        instruction <= "0100";
        program_counter <= "00000101";
        reg_1_data <= x"00F0";
        reg_2_data <= x"000F";
        wait until rising_edge(clk);  -- この立上がりで演算
        wait for 1 ps;                -- 少しだけ待ってからチェック
        assert reg_write_data = x"00FF" report "ALU_OR: reg_write_data is wrong" severity error;

        -- テスト6: ALU_SL (instruction = 5)
        instruction <= "0101";
        program_counter <= "00000110";
        reg_1_data <= x"0001";
        wait until rising_edge(clk);  -- この立上がりで演算
        wait for 1 ps;                -- 少しだけ待ってからチェック
        assert reg_write_data = x"0002" report "ALU_SL: reg_write_data is wrong" severity error;
        assert next_program_counter = "00000111" report "ALU_SL: next_program_counter is wrong" severity error;

        -- テスト7: ALU_SR (instruction = 6)
        instruction <= "0110";
        program_counter <= "00000111";
        reg_1_data <= x"8002";
        wait until rising_edge(clk);  -- この立上がりで演算
        wait for 1 ps;                -- 少しだけ待ってからチェック
        assert reg_write_data = x"4001" report "ALU_SR: reg_write_data is wrong" severity error;
        assert next_program_counter = "00001000" report "ALU_SR: next_program_counter is wrong" severity error;

        -- テスト8: ALU_SRA (instruction = 7)
        instruction <= "0111";
        program_counter <= "00001000";
        reg_1_data <= x"8002";  -- 符号付き右シフトのテスト
        wait until rising_edge(clk);  -- この立上がりで演算
        wait for 1 ps;                -- 少しだけ待ってからチェック
        assert reg_write_data = x"C001" report "ALU_SRA: reg_write_data is wrong" severity error;
        assert next_program_counter = "00001001" report "ALU_SRA: next_program_counter is wrong" severity error;

        -- テスト9: ALU_LDL (instruction = 8)
        instruction <= "1000";
        program_counter <= "00001001";
        reg_1_data <= x"1234";
        op_data <= x"56";
        wait until rising_edge(clk);  -- この立上がりで演算
        wait for 1 ps;                -- 少しだけ待ってからチェック
        assert reg_write_data = x"1256" report "ALU_LDL: reg_write_data is wrong" severity error;
        assert next_program_counter = "00001010" report "ALU_LDL: next_program_counter is wrong" severity error;

        -- テスト10: ALU_LDH (instruction = 9)
        instruction <= "1001";
        program_counter <= "00001010";
        reg_1_data <= x"1234";
        op_data <= x"78";
        wait until rising_edge(clk);  -- この立上がりで演算
        wait for 1 ps;                -- 少しだけ待ってからチェック
        assert reg_write_data = x"7834" report "ALU_LDH: reg_write_data is wrong" severity error;
        assert next_program_counter = "00001011" report "ALU_LDH: next_program_counter is wrong" severity error;

        -- テスト11: ALU_CMP (instruction = 10) - 等しい場合
        instruction <= "1010";
        program_counter <= "00001011";
        reg_1_data <= x"1234";
        reg_2_data <= x"1234";
        wait until rising_edge(clk);  -- この立上がりで演算
        wait for 1 ps;                -- 少しだけ待ってからチェック
        assert next_flag = '1' report "ALU_CMP: next_flag is wrong (equal case)" severity error;
        assert next_program_counter = "00001100" report "ALU_CMP: next_program_counter is wrong" severity error;
        assert reg_write_enable = '0' report "ALU_CMP: reg_write_enable is wrong" severity error;

        -- テスト12: ALU_CMP (instruction = 10) - 等しくない場合
        instruction <= "1010";
        program_counter <= "00001100";
        reg_1_data <= x"1234";
        reg_2_data <= x"5678";
        wait until rising_edge(clk);  -- この立上がりで演算
        wait for 1 ps;                -- 少しだけ待ってからチェック
        assert next_flag = '0' report "ALU_CMP: next_flag is wrong (not equal case)" severity error;
        assert next_program_counter = "00001101" report "ALU_CMP: next_program_counter is wrong" severity error;

        -- テスト13: ALU_JE (instruction = 11) - フラグが1の場合
        instruction <= "1011";
        program_counter <= "00001101";
        flag <= '1';
        op_data <= x"10";
        wait until rising_edge(clk);  -- この立上がりで演算
        wait for 1 ps;                -- 少しだけ待ってからチェック
        assert next_program_counter = x"10" report "ALU_JE: next_program_counter is wrong (flag = 1)" severity error;
        assert reg_write_enable = '0' report "ALU_JE: reg_write_enable is wrong" severity error;

        -- テスト14: ALU_JE (instruction = 11) - フラグが0の場合
        instruction <= "1011";
        program_counter <= "00001110";
        flag <= '0';
        op_data <= x"10";
        wait until rising_edge(clk);  -- この立上がりで演算
        wait for 1 ps;                -- 少しだけ待ってからチェック
        assert next_program_counter = x"11" report "ALU_JE: next_program_counter is wrong (flag = 0)" severity error;

        -- テスト15: ALU_JMP (instruction = 12)
        instruction <= "1100";
        program_counter <= "00001111";
        op_data <= x"10";
        wait until rising_edge(clk);  -- この立上がりで演算
        wait for 1 ps;                -- 少しだけ待ってからチェック
        assert next_program_counter = x"10" report "ALU_JMP: next_program_counter is wrong" severity error;
        assert reg_write_enable = '0' report "ALU_JMP: reg_write_enable is wrong" severity error;

        -- テスト16: ALU_LD (instruction = 13)
        instruction <= "1101";
        program_counter <= "00010000";
        ram_data <= x"DEAD";
        wait until rising_edge(clk);  -- この立上がりで演算
        wait for 1 ps;                -- 少しだけ待ってからチェック
        assert reg_write_data = x"DEAD" report "ALU_LD: reg_write_data is wrong" severity error;
        assert next_program_counter = "00010001" report "ALU_LD: next_program_counter is wrong" severity error;
        assert reg_write_enable = '1' report "ALU_LD: reg_write_enable is wrong" severity error;
        assert ram_write_enable = '0' report "ALU_LD: ram_write_enable is wrong" severity error;

        -- テスト17: ALU_ST (instruction = 14)
        instruction <= "1110";
        program_counter <= "00010001";
        reg_1_data <= x"BEEF";
        wait until rising_edge(clk);  -- この立上がりで演算
        wait for 1 ps;                -- 少しだけ待ってからチェック
        assert ram_write_data = x"BEEF" report "ALU_ST: ram_write_data is wrong" severity error;
        assert next_program_counter = "00010010" report "ALU_ST: next_program_counter is wrong" severity error;
        assert reg_write_enable = '0' report "ALU_ST: reg_write_enable is wrong" severity error;
        assert ram_write_enable = '1' report "ALU_ST: ram_write_enable is wrong" severity error;

        -- テスト18: ALU_HLT (instruction = 15)
        instruction <= "1111";
        program_counter <= "00010010";
        wait until rising_edge(clk);  -- この立上がりで演算
        wait for 1 ps;                -- 少しだけ待ってからチェック
        assert next_program_counter = "00010010" report "ALU_HLT: next_program_counter is wrong" severity error;
        assert reg_write_enable = '0' report "ALU_HLT: reg_write_enable is wrong" severity error;
        assert ram_write_enable = '0' report "ALU_HLT: ram_write_enable is wrong" severity error;

        -- テスト完了
        report "All tests finished";
        wait for CLK_PERIOD * 5;

        -- シミュレーション終了
        report "Simulation finished";
        wait;
    end process;

end Behavioral;
