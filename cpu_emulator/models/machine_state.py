from dataclasses import dataclass

from config import (
    COMPUTER_WORD_BITS,
    RAM_ADDRESS_BITS,
    RAM_CONTENT_BITS,
    REGISTER_ADDRESS_BITS,
    REGISTER_CONTENT_BITS,
    ROM_ADDRESS_BITS,
)


@dataclass(frozen=True)
class MachineState:
    program_counter: int
    ram: list[int]
    rom: list[int]
    registers: list[int]
    flag: bool
    halt: bool

    def _check_validity(self) -> None:
        if not 0 <= self.program_counter < 2**ROM_ADDRESS_BITS:
            raise ValueError("program_counter is out of range")
        if not 0 <= self.flag < 2**COMPUTER_WORD_BITS:
            raise ValueError("flag is out of range")
        if not len(self.ram) == 2**RAM_ADDRESS_BITS:
            raise ValueError("ram length is not correct")
        if not all(0 <= content < 2**RAM_CONTENT_BITS for content in self.ram):
            raise ValueError("ram content is out of range")
        if not len(self.rom) == 2**ROM_ADDRESS_BITS:
            raise ValueError("rom length is not correct")
        if not all(0 <= content < 2**COMPUTER_WORD_BITS for content in self.rom):
            raise ValueError("rom content is out of range")
        if not len(self.registers) == 2**REGISTER_ADDRESS_BITS:
            raise ValueError("registers length is not correct")
        if not all(0 <= content < 2**REGISTER_CONTENT_BITS for content in self.registers):
            raise ValueError("registers content is out of range")

    def __post_init__(self) -> None:
        self._check_validity()

    @staticmethod
    def from_machine_codes(machine_codes: list[str]) -> "MachineState":
        program_counter = 0
        ram = [0] * 2**RAM_ADDRESS_BITS
        registers = [0] * 2**REGISTER_ADDRESS_BITS
        flag = False
        halt = False
        rom = [int(machine_code, 2) for machine_code in machine_codes]
        # 長さが2**ROM_ADDRESS_BITSになるように0を追加
        rom += [0] * (2**ROM_ADDRESS_BITS - len(rom))

        return MachineState(program_counter, ram, rom, registers, flag, halt)
