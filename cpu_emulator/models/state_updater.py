from assembler_parser.mnemonic import MnemoticToMachineCode
from bit_operation.slice import slice_bits

from .machine_state import MachineState

# 本質的には不要だが，可読性のため入れておく
MachineCodeToMnemonic = {int(value, 2): key for key, value in MnemoticToMachineCode.items()}


class StateUpdater:
    def _extract_bits(self, machine_code: int, start: int, end: int) -> int:
        return (machine_code >> start) & ((1 << (end - start)) - 1)

    def calc_updated_state(self, state: MachineState) -> MachineState:
        machine_code = state.rom[state.program_counter]

        instruction_code = slice_bits(machine_code, 11, 15)
        instruction_code_str = MachineCodeToMnemonic[instruction_code]

        # 命令コードごとに処理を実行
        if instruction_code_str == "mov":
            return self._calc_updated_state_mov(machine_code, state)
        elif instruction_code_str == "add":
            return self._calc_updated_state_add(machine_code, state)
        elif instruction_code_str == "sub":
            return self._calc_updated_state_sub(machine_code, state)
        elif instruction_code_str == "and":
            return self._calc_updated_state_and(machine_code, state)
        elif instruction_code_str == "or":
            return self._calc_updated_state_or(machine_code, state)
        elif instruction_code_str == "sl":
            return self._calc_updated_state_sl(machine_code, state)
        elif instruction_code_str == "sr":
            return self._calc_updated_state_sr(machine_code, state)
        elif instruction_code_str == "sra":
            return self._calc_updated_state_sra(machine_code, state)
        elif instruction_code_str == "ldl":
            return self._calc_updated_state_ldl(machine_code, state)
        elif instruction_code_str == "ldh":
            return self._calc_updated_state_ldh(machine_code, state)
        elif instruction_code_str == "cmp":
            return self._calc_updated_state_cmp(machine_code, state)
        elif instruction_code_str == "je":
            return self._calc_updated_state_je(machine_code, state)
        elif instruction_code_str == "jmp":
            return self._calc_updated_state_jmp(machine_code, state)
        elif instruction_code_str == "ld":
            return self._calc_updated_state_ld(machine_code, state)
        elif instruction_code_str == "st":
            return self._calc_updated_state_st(machine_code, state)
        elif instruction_code_str == "hlt":
            return self._calc_updated_state_hlt(machine_code, state)
        else:
            raise ValueError(f"Invalid instruction code: {instruction_code_str}")

    def _calc_updated_state_mov(self, machine_code: int, state: MachineState) -> MachineState:
        operand_1 = slice_bits(machine_code, 8, 11)
        operand_2 = slice_bits(machine_code, 5, 8)

        updated_registers = state.registers.copy()
        updated_registers[operand_1] = state.registers[operand_2]

        return MachineState(
            program_counter=state.program_counter + 1,
            ram=state.ram,
            registers=updated_registers,
            flag=state.flag,
            halt=state.halt,
            rom=state.rom,
        )

    def _calc_updated_state_add(self, machine_code: int, state: MachineState) -> MachineState:
        operand_1 = slice_bits(machine_code, 8, 11)
        operand_2 = slice_bits(machine_code, 5, 8)

        updated_registers = state.registers.copy()
        updated_registers[operand_1] = state.registers[operand_1] + state.registers[operand_2]

        return MachineState(
            program_counter=state.program_counter + 1,
            ram=state.ram,
            registers=updated_registers,
            flag=state.flag,
            halt=state.halt,
            rom=state.rom,
        )

    def _calc_updated_state_sub(self, machine_code: int, state: MachineState) -> MachineState:
        operand_1 = slice_bits(machine_code, 8, 11)
        operand_2 = slice_bits(machine_code, 5, 8)

        updated_registers = state.registers.copy()
        updated_registers[operand_1] = state.registers[operand_1] - state.registers[operand_2]

        return MachineState(
            program_counter=state.program_counter + 1,
            ram=state.ram,
            registers=updated_registers,
            flag=state.flag,
            halt=state.halt,
            rom=state.rom,
        )

    def _calc_updated_state_and(self, machine_code: int, state: MachineState) -> MachineState:
        operand_1 = slice_bits(machine_code, 8, 11)
        operand_2 = slice_bits(machine_code, 5, 8)

        updated_registers = state.registers.copy()
        updated_registers[operand_1] = state.registers[operand_1] & state.registers[operand_2]

        return MachineState(
            program_counter=state.program_counter + 1,
            ram=state.ram,
            registers=updated_registers,
            flag=state.flag,
            halt=state.halt,
            rom=state.rom,
        )

    def _calc_updated_state_or(self, machine_code: int, state: MachineState) -> MachineState:
        operand_1 = slice_bits(machine_code, 8, 11)
        operand_2 = slice_bits(machine_code, 5, 8)

        updated_registers = state.registers.copy()
        updated_registers[operand_1] = state.registers[operand_1] | state.registers[operand_2]

        return MachineState(
            program_counter=state.program_counter + 1,
            ram=state.ram,
            registers=updated_registers,
            flag=state.flag,
            halt=state.halt,
            rom=state.rom,
        )

    def _calc_updated_state_sl(self, machine_code: int, state: MachineState) -> MachineState:
        operand1 = slice_bits(machine_code, 8, 11)

        updated_registers = state.registers.copy()
        updated_registers[operand1] = state.registers[operand1] << 1

        return MachineState(
            program_counter=state.program_counter + 1,
            ram=state.ram,
            registers=updated_registers,
            flag=state.flag,
            halt=state.halt,
            rom=state.rom,
        )

    def _calc_updated_state_sr(self, machine_code: int, state: MachineState) -> MachineState:
        operand1 = slice_bits(machine_code, 8, 11)

        updated_registers = state.registers.copy()
        updated_registers[operand1] = state.registers[operand1] >> 1

        return MachineState(
            program_counter=state.program_counter + 1,
            ram=state.ram,
            registers=updated_registers,
            flag=state.flag,
            halt=state.halt,
            rom=state.rom,
        )

    def _calc_updated_state_sra(self, machine_code: int, state: MachineState) -> MachineState:
        # 算術右シフト
        operand1 = slice_bits(machine_code, 8, 11)
        updated_registers = state.registers.copy()
        updated_registers[operand1] = state.registers[operand1] >> 1
        # 最上位ビットは保持
        updated_registers[operand1] |= state.registers[operand1] & 0b1000000000000000
        return MachineState(
            program_counter=state.program_counter + 1,
            ram=state.ram,
            registers=updated_registers,
            flag=state.flag,
            halt=state.halt,
            rom=state.rom,
        )

    def _calc_updated_state_ldl(self, machine_code: int, state: MachineState) -> MachineState:
        operand1 = slice_bits(machine_code, 8, 11)
        operand2 = slice_bits(machine_code, 0, 8)

        updated_registers = state.registers.copy()
        # 下位8bitにoperand2を代入
        updated_registers[operand1] = operand2 | (state.registers[operand1] & 0b1111111100000000)

        return MachineState(
            program_counter=state.program_counter + 1,
            ram=state.ram,
            registers=updated_registers,
            flag=state.flag,
            halt=state.halt,
            rom=state.rom,
        )

    def _calc_updated_state_ldh(self, machine_code: int, state: MachineState) -> MachineState:
        operand1 = slice_bits(machine_code, 8, 11)
        operand2 = slice_bits(machine_code, 0, 8)

        # 上位8bitにoperand2を代入
        updated_registers = state.registers.copy()
        updated_registers[operand1] = operand2 << 8 | (state.registers[operand1] & 0b0000000011111111)

        return MachineState(
            program_counter=state.program_counter + 1,
            ram=state.ram,
            registers=updated_registers,
            flag=state.flag,
            halt=state.halt,
            rom=state.rom,
        )

    def _calc_updated_state_cmp(self, machine_code: int, state: MachineState) -> MachineState:
        operand1 = slice_bits(machine_code, 8, 11)
        operand2 = slice_bits(machine_code, 5, 8)

        updated_flag = False
        if state.registers[operand1] == state.registers[operand2]:
            updated_flag = True

        return MachineState(
            program_counter=state.program_counter + 1,
            ram=state.ram,
            registers=state.registers,
            flag=updated_flag,
            halt=state.halt,
            rom=state.rom,
        )

    def _calc_updated_state_je(self, machine_code: int, state: MachineState) -> MachineState:
        operand2 = slice_bits(machine_code, 0, 8)
        if state.flag:
            return MachineState(
                program_counter=operand2,
                ram=state.ram,
                registers=state.registers,
                flag=state.flag,
                halt=state.halt,
                rom=state.rom,
            )
        else:
            return MachineState(
                program_counter=state.program_counter + 1,
                ram=state.ram,
                registers=state.registers,
                flag=state.flag,
                halt=state.halt,
                rom=state.rom,
            )

    def _calc_updated_state_jmp(self, machine_code: int, state: MachineState) -> MachineState:
        operand2 = slice_bits(machine_code, 0, 8)

        return MachineState(
            program_counter=operand2,
            ram=state.ram,
            registers=state.registers,
            flag=state.flag,
            halt=state.halt,
            rom=state.rom,
        )

    def _calc_updated_state_ld(self, machine_code: int, state: MachineState) -> MachineState:
        operand1 = slice_bits(machine_code, 8, 11)
        operand2 = slice_bits(machine_code, 0, 8)

        updated_registers = state.registers.copy()
        updated_registers[operand1] = state.ram[operand2]

        return MachineState(
            program_counter=state.program_counter + 1,
            ram=state.ram,
            registers=updated_registers,
            flag=state.flag,
            halt=state.halt,
            rom=state.rom,
        )

    def _calc_updated_state_st(self, machine_code: int, state: MachineState) -> MachineState:
        operand1 = slice_bits(machine_code, 8, 11)
        operand2 = slice_bits(machine_code, 0, 8)

        updated_ram = state.ram.copy()
        updated_ram[operand2] = state.registers[operand1]

        return MachineState(
            program_counter=state.program_counter + 1,
            ram=updated_ram,
            registers=state.registers,
            flag=state.flag,
            halt=state.halt,
            rom=state.rom,
        )

    def _calc_updated_state_hlt(self, machine_code: int, state: MachineState) -> MachineState:
        return MachineState(
            program_counter=state.program_counter,
            ram=state.ram,
            registers=state.registers,
            flag=state.flag,
            halt=True,
            rom=state.rom,
        )
