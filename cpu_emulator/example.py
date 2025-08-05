import assembler_parser.parser as parser
from models.cpu_emulator import CPU_Emulator
from models.machine_state import MachineState


def main() -> None:
    """メイン実行関数"""

    code = """
    ldl(1,1)
    ldl(2,10)
    add(3,1)
    add(0,3)
    cmp(2,3)
    je(7)
    jmp(2)
    hlt()
    """

    print("=== CPU Emulator ===")
    print(f"Assembly Code to calculate sum of 1 to 10:\n{code}")

    # アセンブリコードをパース
    decoded = parser.parse(code)
    print(f"\nDecoded Machine Codes: {decoded}")

    # マシン状態を初期化
    state = MachineState.from_machine_codes(decoded)
    print("\nInitial State:")
    print(f"  Program Counter: {state.program_counter}")
    print(f"  Registers: {state.registers}")
    print(f"  RAM[0]: {state.ram[0]}")

    # CPUエミュレータを作成して実行
    cpu = CPU_Emulator(state)
    print("\n=== Execution ===")
    cpu.run()

    # 最終状態を表示
    final_state = cpu.state
    print("\nFinal State:")
    print(f"  Program Counter: {final_state.program_counter}")
    print(f"  Registers: {final_state.registers}")
    print(f"  RAM[0]: {final_state.ram[0]}")
    print(f"  Flag: {final_state.flag}")
    print(f"  Halt: {final_state.halt}")

    # 実行履歴の長さを表示
    print(f"\nExecution History Length: {len(cpu.history)}")

    print(f"\nsum of 1 to 10 is on register 0. The value is {final_state.registers[0]}")


if __name__ == "__main__":
    main()
