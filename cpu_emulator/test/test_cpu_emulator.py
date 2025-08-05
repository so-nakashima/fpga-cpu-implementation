#!/usr/bin/env python3
import assembler_parser.parser as parser
import pytest
from config import REGISTER_CONTENT_BITS
from models.cpu_emulator import CPU_Emulator
from models.machine_state import MachineState


class TestCPUEmulator:
    """CPUエミュレータのテストクラス"""

    def test_integration_multiple_instructions(self) -> None:
        """複数の命令を含む統合テスト"""
        # テスト用のアセンブリコード（example.pyと同様）
        code = """
        ldl(0,3)
        mov(1,0)
        st(1,0)
        hlt()
        """

        # アセンブリコードをパース
        decoded = parser.parse(code)

        # マシン状態を初期化
        state = MachineState.from_machine_codes(decoded)

        # CPUエミュレータを作成して実行
        cpu = CPU_Emulator(state)
        cpu.run()

        # 最終状態の検証
        final_state = cpu.state

        # 期待される結果
        assert final_state.registers[0] == 3  # ldl(0,3)でレジスタ0に3が格納
        assert final_state.registers[1] == 3  # mov(1,0)でレジスタ1にレジスタ0の値(3)がコピー
        assert final_state.ram[0] == 3  # st(1,0)でレジスタ1の値(3)がRAM[0]に格納
        assert final_state.halt  # hlt()で停止
        assert not final_state.flag  # フラグは初期値のまま

        # 実行履歴の検証
        assert len(cpu.history) == 5  # 初期状態 + 4つの命令実行 = 5つの状態

        # 各ステップでの状態変化を検証
        # ステップ1: ldl(0,3)実行後
        assert cpu.history[1].program_counter == 1
        assert cpu.history[1].registers[0] == 3

        # ステップ2: mov(1,0)実行後
        assert cpu.history[2].program_counter == 2
        assert cpu.history[2].registers[1] == 3

        # ステップ3: st(1,0)実行後
        assert cpu.history[3].program_counter == 3
        assert cpu.history[3].ram[0] == 3

        # ステップ4: hlt()実行後
        assert cpu.history[4].program_counter == 3  # hlt実行後はprogram_counterが変わらない
        assert cpu.history[4].halt

    def test_arithmetic_instructions(self) -> None:
        """算術命令のテスト"""
        code = """
        ldl(0,10)
        ldl(1,5)
        add(2,0)
        add(2,1)
        sub(3,2)
        sub(3,1)
        hlt()
        """

        decoded = parser.parse(code)
        state = MachineState.from_machine_codes(decoded)
        cpu = CPU_Emulator(state)
        cpu.run()

        final_state = cpu.state

        # 期待される結果
        assert final_state.registers[0] == 10  # ldl(0,10)
        assert final_state.registers[1] == 5  # ldl(1,5)
        assert final_state.registers[2] == 15  # add(2,0) + add(2,1) = 10 + 5 = 15
        assert final_state.registers[3] == 2**REGISTER_CONTENT_BITS - 20  # sub(3,2) + sub(3,1) = - 15 - 5 = -20
        # 2の補数表現を扱うため，ビットとしてはREGISTER_CONTENT_BITS - 20 の2進数で表現される

    def test_logical_instructions(self) -> None:
        """論理命令のテスト"""
        code = """
        ldl(0,12)
        ldl(1,10)
        mov(2,0)
        and(2,1)
        mov(3,0)
        or(3,1)
        hlt()
        """

        decoded = parser.parse(code)
        state = MachineState.from_machine_codes(decoded)
        cpu = CPU_Emulator(state)
        cpu.run()

        final_state = cpu.state

        # 期待される結果
        assert final_state.registers[0] == 12  # ldl(0,12)
        assert final_state.registers[1] == 10  # ldl(1,10)
        assert final_state.registers[2] == 8  # 12 & 10 = 1100 & 1010 = 1000 = 8
        assert final_state.registers[3] == 14  # 12 | 10 = 1100 | 1010 = 1110 = 14

    def test_shift_instructions(self) -> None:
        """シフト命令のテスト"""
        code = f"""
        ldl(0,8)
        sl(0)
        sr(0)
        ldh(1,{2 ** (REGISTER_CONTENT_BITS // 2 - 1)})
        sra(1)
        ldl(2,15)
        sl(2)
        ldl(3,15)
        sr(3)
        hlt()
        """
        # ldh(1,...) の第二オペランドは，二進数で"10000000"
        # レジスタのbit数が増えた時のため，計算式で書いている
        decoded = parser.parse(code)
        state = MachineState.from_machine_codes(decoded)
        cpu = CPU_Emulator(state)
        cpu.run()

        final_state = cpu.state

        # 期待される結果
        assert final_state.registers[0] == 8  # sl(0) + sr(0) = 16 >> 1 = 8
        assert final_state.registers[1] == (
            2 ** (REGISTER_CONTENT_BITS - 1) + 2 ** (REGISTER_CONTENT_BITS - 2)
        )  # sra(1) = 15 >> 1 = 7
        assert final_state.registers[2] == 30  # sl(2) = 15 << 1 = 30
        assert final_state.registers[3] == 7  # sr(3) = 15 >> 1 = 7

    def test_load_instructions(self) -> None:
        """ロード命令のテスト"""
        code = """
        ldl(0,255)
        ldh(0,15)
        ldl(1,128)
        ldh(1,1)
        hlt()
        """

        decoded = parser.parse(code)
        state = MachineState.from_machine_codes(decoded)
        cpu = CPU_Emulator(state)
        cpu.run()

        final_state = cpu.state

        # 期待される結果
        assert final_state.registers[0] == 4095  # ldl(0,255) + ldh(0,15) = 255 + 3840 = 4095
        assert final_state.registers[1] == 384  # ldl(1,128) + ldh(1,1) = 128 + 256 = 384

    def test_memory_instructions(self) -> None:
        """メモリ命令のテスト"""
        code = """
        ldl(0,100)
        ldl(1,200)
        st(0,50)
        st(1,60)
        ld(2,50)
        ld(3,60)
        hlt()
        """

        decoded = parser.parse(code)
        state = MachineState.from_machine_codes(decoded)
        cpu = CPU_Emulator(state)
        cpu.run()

        final_state = cpu.state

        # 期待される結果
        assert final_state.registers[0] == 100
        assert final_state.registers[1] == 200
        assert final_state.registers[2] == 100  # ld(2,50)
        assert final_state.registers[3] == 200  # ld(3,60)
        assert final_state.ram[50] == 100  # st(0,50)
        assert final_state.ram[60] == 200  # st(1,60)

    def test_jump_instructions(self) -> None:
        """ジャンプ命令のテスト"""
        code = """
        ldl(0,5)
        ldl(1,5)
        cmp(0,1)
        je(6)
        ldl(2,10)
        ldl(3,20)
        ldl(4,30)
        hlt()
        """

        decoded = parser.parse(code)
        state = MachineState.from_machine_codes(decoded)
        cpu = CPU_Emulator(state)
        cpu.run()

        final_state = cpu.state

        # 期待される結果
        assert final_state.registers[0] == 5
        assert final_state.registers[1] == 5
        assert final_state.registers[2] == 0  # スキップされた
        assert final_state.registers[3] == 0  # スキップされた
        assert final_state.registers[4] == 30  # ジャンプ先で実行
        assert final_state.flag  # cmp(0,1)でTrue

    def test_conditional_jump_false(self) -> None:
        """条件ジャンプ（条件が偽の場合）のテスト"""
        code = """
        ldl(0,5)
        ldl(1,10)
        cmp(0,1)
        je(6)
        ldl(2,15)
        ldl(3,20)
        ldl(4,25)
        hlt()
        """

        decoded = parser.parse(code)
        state = MachineState.from_machine_codes(decoded)
        cpu = CPU_Emulator(state)
        cpu.run()

        final_state = cpu.state

        # 期待される結果
        assert final_state.registers[0] == 5
        assert final_state.registers[1] == 10
        assert final_state.registers[2] == 15  # 実行された
        assert final_state.registers[3] == 20  # 実行された
        assert final_state.registers[4] == 25  # 実行された
        assert not final_state.flag  # cmp(0,1)でFalse

    def test_unconditional_jump(self) -> None:
        """無条件ジャンプのテスト"""
        code = """
        ldl(0,5)
        jmp(4)
        ldl(1,10)
        ldl(2,15)
        ldl(3,20)
        hlt()
        """

        decoded = parser.parse(code)
        state = MachineState.from_machine_codes(decoded)
        cpu = CPU_Emulator(state)
        cpu.run()

        final_state = cpu.state

        # 期待される結果
        assert final_state.registers[0] == 5
        assert final_state.registers[1] == 0  # スキップされた
        assert final_state.registers[2] == 0  # スキップされた
        assert final_state.registers[3] == 20  # ジャンプ先で実行


if __name__ == "__main__":
    # テストを実行
    pytest.main([__file__, "-v"])
