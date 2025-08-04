import os
from typing import Any

from lark import Lark, Transformer, v_args

from .mnemonic import MnemoticToMachineCode


def load_grammar() -> str:
    current_dir = os.path.dirname(os.path.abspath(__file__))
    with open(os.path.join(current_dir, "grammer.lark"), "r") as f:
        grammar = f.read()
    return grammar


def parse(code: str) -> list[str]:
    grammar = load_grammar()

    parser = Lark(grammar, parser="lalr")  # LALR(1) で高速
    tree = parser.parse(code)

    decoded: list[str] = ToMachineCode().transform(tree)
    return decoded


@v_args(inline=True)
class ToMachineCode(Transformer[Any, Any]):
    INT = int
    FUNC_NAME = str

    def func_call(self, name: str, args: tuple[int, ...]) -> list[str]:
        # 1命令のみのときでもlistにするため，ここでlistにする
        return [convert_to_operation_code(name, args)]

    def arg_list(self, *args: int) -> tuple[int, ...]:
        return args

    def start(self, *function_calls: list[str]) -> list[str]:
        res = []
        for function_call in function_calls:
            res.extend(function_call)
        return res


def convert_to_operation_code(name: str, args: tuple[int, ...]) -> str:
    operation_code = MnemoticToMachineCode[name]
    if name in ["mov", "add", "sub", "and", "or", "cmp"]:
        # CCCCxxxyyy-----というパターン
        # CCCC: 命令コード
        # xxx: 第1引数
        # yyy: 第2引数
        # -----: 何でもよい
        assert len(args) == 2
        assert all(0 <= arg < 8 for arg in args)
        arg1_code = f"{args[0]:03b}"
        arg2_code = f"{args[1]:03b}"
        # argsで11bit（全体で15bit）になるようになるよう右を0で埋める
        return operation_code + arg1_code + arg2_code + "0" * (11 - len(arg1_code) - len(arg2_code))
    elif name in ["sl", "sr", "sra"]:
        # CCCCxxx--------というパターン
        # CCCC: 命令コード
        # xxx: 第1引数
        # -----: 何でもよい
        assert len(args) == 1
        assert 0 <= args[0] < 8
        arg1_code = f"{args[0]:03b}"
        return operation_code + arg1_code + "0" * (11 - len(arg1_code))
    elif name in ["ldh", "ldl", "ld", "st"]:
        # CCCCxxxzzzzzzzzというパターン
        # CCCC: 命令コード
        # xxx: 第1引数
        # zzzzzzzz: 第2引数
        assert len(args) == 2
        assert 0 <= args[0] < 8
        assert 0 <= args[1] < 256
        arg1_code = f"{args[0]:03b}"
        arg2_code = f"{args[1]:08b}"
        return operation_code + arg1_code + arg2_code
    elif name in ["je", "jmp"]:
        # CCCC---zzzzzzzzというパターン
        # CCCC: 命令コード
        # zzzzzzzz: 第1引数
        assert len(args) == 1
        assert 0 <= args[0] < 256
        arg1_code = f"{args[0]:08b}"
        return operation_code + "000" + arg1_code
    else:
        # hlt
        # CCCC-----------というパターン
        # CCCC: 命令コード
        return operation_code + "00000000000"
