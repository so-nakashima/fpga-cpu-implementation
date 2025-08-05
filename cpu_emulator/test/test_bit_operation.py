from bit_operation import slice_bits


def test_slice_bits() -> None:
    assert slice_bits(0b10101010, 0, 4) == 0b1010  # 下位4ビット: 1010
    assert slice_bits(0b10101010, 4, 8) == 0b1010  # 上位4ビット: 1010
    assert slice_bits(0b10101010, 0, 8) == 0b10101010  # 全8ビット
    assert slice_bits(0b10101010, 0, 1) == 0b0  # 最下位ビット: 0
    assert slice_bits(0b10101010, 7, 8) == 0b1  # 最上位ビット: 1
