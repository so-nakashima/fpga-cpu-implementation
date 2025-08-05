import os

from assembler_parser.parser import parse


def test_composition_case() -> None:
    print("test_composition")
    print(os.getcwd())
    code = """
    mov(1,5)
    sr(4)
    hlt()"""
    decoded = parse(code)
    assert decoded == ["0000" + "001" + "101" + "00000", "0110" + "100" + "00000000", "1111" + "00000000000"]


# 16個のニーモニックすべてについてのテスト
def test_mov() -> None:
    code = "mov(2,4)"
    decoded = parse(code)
    assert decoded == ["0000" + "010" + "100" + "00000"]


def test_add() -> None:
    code = "add(1,6)"
    decoded = parse(code)
    assert decoded == ["0001" + "001" + "110" + "00000"]


def test_sub() -> None:
    code = "sub(5,3)"
    decoded = parse(code)
    assert decoded == ["0010" + "101" + "011" + "00000"]


def test_and() -> None:
    code = "and(7,1)"
    decoded = parse(code)
    assert decoded == ["0011" + "111" + "001" + "00000"]


def test_or() -> None:
    code = "or(4,2)"
    decoded = parse(code)
    assert decoded == ["0100" + "100" + "010" + "00000"]


def test_sl() -> None:
    code = "sl(6)"
    decoded = parse(code)
    assert decoded == ["0101" + "110" + "00000000"]


def test_sr() -> None:
    code = "sr(3)"
    decoded = parse(code)
    assert decoded == ["0110" + "011" + "00000000"]


def test_sra() -> None:
    code = "sra(1)"
    decoded = parse(code)
    assert decoded == ["0111" + "001" + "00000000"]


def test_ldl() -> None:
    code = "ldl(2,128)"
    decoded = parse(code)
    assert decoded == ["1000" + "010" + "10000000"]


def test_ldh() -> None:
    code = "ldh(5,64)"
    decoded = parse(code)
    assert decoded == ["1001" + "101" + "01000000"]


def test_cmp() -> None:
    code = "cmp(7,2)"
    decoded = parse(code)
    assert decoded == ["1010" + "111" + "010" + "00000"]


def test_je() -> None:
    code = "je(200)"
    decoded = parse(code)
    assert decoded == ["1011" + "000" + "11001000"]


def test_jmp() -> None:
    code = "jmp(150)"
    decoded = parse(code)
    assert decoded == ["1100" + "000" + "10010110"]


def test_ld() -> None:
    code = "ld(4,100)"
    decoded = parse(code)
    assert decoded == ["1101" + "100" + "01100100"]


def test_st() -> None:
    code = "st(6,75)"
    decoded = parse(code)
    assert decoded == ["1110" + "110" + "01001011"]


def test_hlt() -> None:
    code = "hlt()"
    decoded = parse(code)
    assert decoded == ["1111" + "00000000000"]


def test_null() -> None:
    code = ""
    decoded = parse(code)
    assert decoded == []
