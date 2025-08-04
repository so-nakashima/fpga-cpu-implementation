from enum import Enum


class Mnemonic(Enum):
    MOV = "mov"
    ADD = "add"
    SUB = "sub"
    AND = "and"
    OR = "or"
    SL = "sl"
    SR = "sr"
    SRA = "sra"
    LDH = "ldh"
    LDL = "ldl"
    CMP = "cmp"
    JE = "je"
    JMP = "jmp"
    LD = "ld"
    ST = "st"
    HLT = "hlt"
