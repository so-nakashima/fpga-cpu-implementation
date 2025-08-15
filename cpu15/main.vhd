----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 2025/08/11 14:13:40
-- Design Name:
-- Module Name: main - rtl
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
use work.constants_pkg.all;

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
        reset : in std_logic;
        -- output to 7-seg display
        anode_digit : out std_logic_vector(3 downto 0);
        seg : out std_logic_vector(6 downto 0);
        decimal_point : out std_logic;
        -- output to LED
        led : out std_logic_vector(15 downto 0)
    );
end main;

architecture rtl of main is

component clk_enable_gen is
    port(
        clk : in std_logic;
        reset : in std_logic;
        clk_enable_fetch : out std_logic;
        clk_enable_decode : out std_logic;
        clk_enable_load : out std_logic;
        clk_enable_execute : out std_logic;
        clk_enable_writeback : out std_logic
    );
end component;

component reset_sync is
    port(
        clk : in std_logic;
        reset_raw : in std_logic;
        reset_synced : out std_logic
    );
end component;

component fetch is
    -- プログラム本体は一旦妥協でfetchに内蔵する
    port(
        clk : in std_logic;
        clk_enable : in std_logic;
        program_counter : in std_logic_vector(PC_WIDTH - 1 downto 0);
        machine_code : out std_logic_vector(MACHINE_CODE_WIDTH - 1 downto 0)
    );
end component;

component decode is
    port(
        clk : in std_logic;
        clk_enable : in std_logic;
        machine_code : in std_logic_vector(MACHINE_CODE_WIDTH - 1 downto 0);
        instruction : out std_logic_vector(INSTRUCTION_WIDTH - 1 downto 0);
        reg_1_address : out std_logic_vector(REGISTER_ADDRESS_WIDTH - 1 downto 0);
        reg_2_address : out std_logic_vector(REGISTER_ADDRESS_WIDTH - 1 downto 0);
        ram_address : out std_logic_vector(RAM_ADDRESS_WIDTH - 1 downto 0)
    );
end component;

component execute is
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
        op_data : in std_logic_vector(OPERAND_WIDTH / 2 - 1 downto 0);
        -- output = next machine state
        next_program_counter : out std_logic_vector(PC_WIDTH - 1 downto 0);
        next_flag : out std_logic;
        reg_write_enable : out std_logic;
        reg_write_data : out std_logic_vector(OPERAND_WIDTH - 1 downto 0);
        ram_write_enable : out std_logic;
        ram_write_data : out std_logic_vector(OPERAND_WIDTH - 1 downto 0)
    );
end component;

component reg is
    generic(
        REGISTER_ADDRESS_WIDTH : integer := REGISTER_ADDRESS_WIDTH;
        WIDTH : integer := OPERAND_WIDTH
    );
    port(
        clk : in std_logic;
        reset : in std_logic;
        -- 書き込みポート
        -- 現在writeback phaseかのフラグ
        clk_write_enable : in std_logic;
        -- execute phaseで書き込みを行う場合のフラグ
        exec_write_enable : in std_logic;
        write_address : in std_logic_vector(REGISTER_ADDRESS_WIDTH - 1 downto 0);
        write_data : in std_logic_vector(WIDTH - 1 downto 0);
        -- 読み出しポート(2つ)
        read_address_1 : in std_logic_vector(REGISTER_ADDRESS_WIDTH - 1 downto 0);
        read_address_2 : in std_logic_vector(REGISTER_ADDRESS_WIDTH - 1 downto 0);
        read_data_1 : out std_logic_vector(WIDTH - 1 downto 0);
        read_data_2 : out std_logic_vector(WIDTH - 1 downto 0)
    );
end component;

component ram is
    generic(
        RAM_ADDRESS_WIDTH : integer := RAM_ADDRESS_WIDTH;
        WIDTH : integer := OPERAND_WIDTH
    );
    port(
        clk : in std_logic;
        reset : in std_logic;
        -- 書き込みポート
        -- 現在writeback phaseかのフラグ
        clk_write_enable : in std_logic;
        -- execute phaseで書き込みを行う場合のフラグ
        exec_write_enable : in std_logic;
        write_address : in std_logic_vector(RAM_ADDRESS_WIDTH - 1 downto 0);
        write_data : in std_logic_vector(WIDTH - 1 downto 0);
        -- 読み出しポート(2つ)
        read_address_1 : in std_logic_vector(RAM_ADDRESS_WIDTH - 1 downto 0);
        read_address_2 : in std_logic_vector(RAM_ADDRESS_WIDTH - 1 downto 0);
        read_data_1 : out std_logic_vector(WIDTH - 1 downto 0);
        read_data_2 : out std_logic_vector(WIDTH - 1 downto 0)
    );
end component;

component seg7_driver is
    port(
        clk : in std_logic;
        value : in std_logic_vector(15 downto 0);
        anode_digit: out std_logic_vector(3 downto 0);
        seg : out std_logic_vector(6 downto 0);
        decimal_point: out std_logic
    );
end component;


-- clock enable signals
signal clk_enable_fetch : std_logic;
signal clk_enable_decode : std_logic;
-- 常にloadしているため，このフラグは使っていない．
-- ただし1clock分decode後に待つ必要があるため，clock_enable_genで定義している．
signal clk_enable_load : std_logic;
signal clk_enable_execute : std_logic;
signal clk_enable_writeback : std_logic;

-- reset signals
signal reset_synced : std_logic;

-- machine states
signal program_counter : std_logic_vector(PC_WIDTH - 1 downto 0) := (others => '0');
signal flag : std_logic;

-- fetch phase
signal machine_code : std_logic_vector(MACHINE_CODE_WIDTH - 1 downto 0);

-- decode/load phase
signal instruction : std_logic_vector(INSTRUCTION_WIDTH -1 downto 0);
signal reg_1_data : std_logic_vector(OPERAND_WIDTH - 1 downto 0);
signal reg_2_data : std_logic_vector(OPERAND_WIDTH - 1 downto 0);
signal reg_1_address : std_logic_vector(REGISTER_ADDRESS_WIDTH - 1 downto 0);
signal reg_2_address : std_logic_vector(REGISTER_ADDRESS_WIDTH - 1 downto 0);
signal ram_address : std_logic_vector(RAM_ADDRESS_WIDTH - 1 downto 0);
signal ram_data : std_logic_vector(OPERAND_WIDTH - 1 downto 0);

-- execute phase
signal next_program_counter : std_logic_vector(PC_WIDTH - 1 downto 0);
signal reg_write_enable : std_logic;
signal reg_write_data : std_logic_vector(OPERAND_WIDTH - 1 downto 0);
signal ram_write_enable : std_logic;
signal ram_write_data : std_logic_vector(OPERAND_WIDTH - 1 downto 0);

-- MMIO
signal ram_7seg_address : std_logic_vector(RAM_ADDRESS_WIDTH - 1 downto 0) := "00000000";
signal ram_7seg_data : std_logic_vector(OPERAND_WIDTH - 1 downto 0);


-- writeback phase outputs
-- (reg_write_data and ram_write_data are now defined in execute phase section)

begin

    -- 処理フロー
    -- フェーズの分割
    clk_enable_gen_inst : clk_enable_gen
        port map(
            clk => clk,
            reset => reset_synced,
            clk_enable_fetch => clk_enable_fetch,
            clk_enable_decode => clk_enable_decode,
            clk_enable_load => clk_enable_load,
            clk_enable_execute => clk_enable_execute,
            clk_enable_writeback => clk_enable_writeback
        );

    -- reset信号の同期化
    reset_sync_inst : reset_sync
        port map(
            clk => clk,
            reset_raw => reset,
            reset_synced => reset_synced
        );

    -- fetch
    fetch_inst : fetch
        port map(
            clk => clk,
            clk_enable => clk_enable_fetch,
            program_counter => program_counter,
            machine_code => machine_code
        );

    -- decode
    decode_inst : decode
        port map(
            clk => clk,
            clk_enable => clk_enable_decode,
            machine_code => machine_code,
            instruction => instruction,
            reg_1_address => reg_1_address,
            reg_2_address => reg_2_address,
            ram_address => ram_address
        );

    -- load
    -- reg/ramのcomponentにて処理がなされている．
    -- そのため特段の記載は必要ない．

    -- execute
    execute_inst : execute
        port map(
            clk => clk,
            clk_enable => clk_enable_execute,
            reset => reset_synced,
            instruction => instruction,
            program_counter => program_counter,
            flag => flag,
            reg_1_data => reg_1_data,
            reg_2_data => reg_2_data,
            ram_data => ram_data,
            -- 今回の設計では機械語自身にデータをコードする場合ram_addressと同じ値になる
            -- やや紛らわしい記述になるが配線を減らすため変数を流用する
            op_data => ram_address,
            next_program_counter => program_counter,
            next_flag => flag,
            reg_write_enable => reg_write_enable,
            reg_write_data => reg_write_data,
            ram_write_enable => ram_write_enable,
            ram_write_data => ram_write_data
        );

    -- writeback
    -- reg/ramのcomponentにて処理がなされている．
    -- program counterについてもexecute phaseで更新される．
    -- そのためwriteback phaseで特段処理を書く必要はない

    -- 各種デバイスの接続
    -- レジスタ
    reg_inst : reg
        generic map(REGISTER_ADDRESS_WIDTH => REGISTER_ADDRESS_WIDTH, WIDTH => OPERAND_WIDTH)
        port map(
            clk => clk,
            reset => reset_synced,
            clk_write_enable => clk_enable_writeback,
            exec_write_enable => reg_write_enable,
            write_address => reg_1_address,
            write_data => reg_write_data,
            read_address_1 => reg_1_address,
            read_address_2 => reg_2_address,
            read_data_1 => reg_1_data,
            read_data_2 => reg_2_data
        );

    -- RAM
    ram_inst : ram
        generic map(RAM_ADDRESS_WIDTH => RAM_ADDRESS_WIDTH, WIDTH => OPERAND_WIDTH)
        port map(
            clk => clk,
            reset => reset_synced,
            clk_write_enable => clk_enable_writeback,
            exec_write_enable => ram_write_enable,
            write_address => ram_address,
            write_data => ram_write_data,
            read_address_1 => ram_address,
            read_address_2 => ram_7seg_address,
            read_data_1 => ram_data,
            read_data_2 => ram_7seg_data
        );

    -- 7セグメントディスプレイ
    -- メモリマップドIOを採用する．RAM[0]を7セグに表示する
    seg7_driver_inst : seg7_driver
        port map(
            clk => clk,
            value => ram_7seg_data,
            anode_digit => anode_digit,
            seg => seg,
            decimal_point => decimal_point
        );


end rtl;
