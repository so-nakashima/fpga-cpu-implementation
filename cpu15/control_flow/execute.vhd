----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 2025/08/14 21:34:10
-- Design Name:
-- Module Name: execute - rtl
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
use work.constants_pkg.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity execute is
    port(
        clk : in std_logic;
        clk_enable : in std_logic;
        reset : in std_logic;
        instruction : in std_logic_vector(INSTRUCTION_WIDTH - 1 downto 0);
        program_counter : in std_logic_vector(PC_WIDTH - 1 downto 0);
        flag : in std_logic;
        reg_1_data : in std_logic_vector(OPERAND_WIDTH - 1 downto 0);
        reg_2_data : in std_logic_vector(OPERAND_WIDTH - 1 downto 0);
        ram_data : in std_logic_vector(OPERAND_WIDTH - 1 downto 0);
        op_data : in std_logic_vector(OPERAND_WIDTH/2 - 1 downto 0);
        next_program_counter : out std_logic_vector(PC_WIDTH - 1 downto 0);
        next_flag : out std_logic;
        reg_write_enable : out std_logic;
        reg_write_data : out std_logic_vector(OPERAND_WIDTH - 1 downto 0);
        ram_write_enable : out std_logic;
        ram_write_data : out std_logic_vector(OPERAND_WIDTH - 1 downto 0)
    );
end execute;

architecture rtl of execute is
type alu_op_t is (
    ALU_MOV,
    ALU_ADD,
    ALU_SUB,
    ALU_AND,
    ALU_OR,
    ALU_SL,
    ALU_SR,
    ALU_SRA,
    ALU_LDL,
    ALU_LDH,
    ALU_CMP,
    ALU_JE,
    ALU_JMP,
    ALU_LD,
    ALU_ST,
    ALU_HLT
);

type alu_op_vec is array(0 to 15) of alu_op_t;
constant instruction_to_alu_op : alu_op_vec := (
    0 => ALU_MOV,
    1 => ALU_ADD,
    2 => ALU_SUB,
    3 => ALU_AND,
    4 => ALU_OR,
    5 => ALU_SL,
    6 => ALU_SR,
    7 => ALU_SRA,
    8 => ALU_LDL,
    9 => ALU_LDH,
    10 => ALU_CMP,
    11 => ALU_JE,
    12 => ALU_JMP,
    13 => ALU_LD,
    14 => ALU_ST,
    15 => ALU_HLT
);




begin
    process(clk)
    variable alu_op : alu_op_t;

    begin
        -- reset case
        if rising_edge(clk) then
            if reset = '1' then
                next_program_counter <= (others => '0');
                reg_write_enable <= '0';
                ram_write_enable <= '0';
                next_flag <= '0';
                reg_write_data <= (others => '0');
                ram_write_data <= (others => '0');
            -- normal case
            elsif clk_enable = '1' then
                alu_op := instruction_to_alu_op(to_integer(unsigned(instruction)));

                -- default assignment
                next_program_counter <= std_logic_vector(unsigned(program_counter) + 1);
                reg_write_enable <= '0';
                ram_write_enable <= '0';
                next_flag <= flag;

                case alu_op is
                    when ALU_MOV =>
                        reg_write_data <= reg_2_data;
                        reg_write_enable <= '1';
                    when ALU_ADD =>
                        reg_write_data <= std_logic_vector(unsigned(reg_1_data) + unsigned(reg_2_data));
                        reg_write_enable <= '1';
                    when ALU_SUB =>
                        reg_write_data <= std_logic_vector(unsigned(reg_1_data) - unsigned(reg_2_data));
                        reg_write_enable <= '1';
                    when ALU_AND =>
                        reg_write_data <= reg_1_data and reg_2_data;
                        reg_write_enable <= '1';
                    when ALU_OR =>
                        reg_write_data <= reg_1_data or reg_2_data;
                        reg_write_enable <= '1';
                    when ALU_SL =>
                        reg_write_data <= std_logic_vector(unsigned(reg_1_data) sll 1);
                        reg_write_enable <= '1';
                    when ALU_SR =>
                        reg_write_data <= std_logic_vector(unsigned(reg_1_data) srl 1);
                        reg_write_enable <= '1';
                    when ALU_SRA =>
                        reg_write_data <= std_logic_vector(
                            shift_right(signed(reg_1_data), 1)
                        );
                        reg_write_enable <= '1';
                    when ALU_LDL =>
                        reg_write_data <= reg_1_data(OPERAND_WIDTH - 1 downto 8) & op_data(7 downto 0);
                        reg_write_enable <= '1';
                    when ALU_LDH =>
                        reg_write_data <= op_data & reg_1_data(7 downto 0);
                        reg_write_enable <= '1';
                    when ALU_CMP =>
                        if reg_1_data = reg_2_data then
                            next_flag <= '1';
                        else
                            next_flag <= '0';
                        end if;
                    when ALU_JE =>
                        if flag = '1' then
                            next_program_counter <= op_data(PC_WIDTH - 1 downto 0);
                        end if;
                    when ALU_JMP =>
                        next_program_counter <= op_data(PC_WIDTH - 1 downto 0);
                    when ALU_LD =>
                        reg_write_data <= ram_data;
                        reg_write_enable <= '1';
                    when ALU_ST =>
                        ram_write_data <= reg_1_data;
                        ram_write_enable <= '1';
                    when ALU_HLT =>
                        next_program_counter <= program_counter;
                    when others =>
                        next_program_counter <= program_counter;
                end case;
            end if;
        end if;
    end process;

end rtl;
