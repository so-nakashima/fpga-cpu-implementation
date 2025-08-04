import os
from typing import Any

from lark import Lark, Transformer, v_args

from .mnemonic import Mnemonic


def load_grammar() -> str:
    current_dir = os.path.dirname(os.path.abspath(__file__))
    with open(os.path.join(current_dir, "grammer.lark"), "r") as f:
        grammar = f.read()
    return grammar


def parse(code: str) -> list[tuple[Mnemonic, tuple[int, ...]]]:
    grammar = load_grammar()

    parser = Lark(grammar, parser="lalr")  # LALR(1) で高速
    tree = parser.parse(code)

    decoded: list[tuple[Mnemonic, tuple[int, ...]]] = ToPairs().transform(tree)
    return decoded


@v_args(inline=True)
class ToPairs(Transformer[Any, Any]):
    INT = int
    FUNC_NAME = str

    def func_call(self, name: str, args: tuple[int, ...]) -> tuple[Mnemonic, tuple[int, ...]]:
        return (Mnemonic(name), args)

    def arg_list(self, *args: int) -> tuple[int, ...]:
        return args

    def start(self, *pairs: tuple[Mnemonic, tuple[int, ...]]) -> list[tuple[Mnemonic, tuple[int, ...]]]:
        return list(pairs)
