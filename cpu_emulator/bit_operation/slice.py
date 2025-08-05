def slice_bits(x: int, start: int, end: int) -> int:
    """
    xを二進数としたときに，下位から数えて[start, end)のビットを抜き出し，二進数と解釈した時の整数を返す．

    Args:
        x: 整数
        start: 開始インデックス
        end: 終端インデックス

    Returns:
        下位から数えて[start, end) のビットを抜き出し，二進数と解釈した時の整数

    """
    if not (0 <= start < end):
        raise ValueError("Invalid input")

    width = end - start
    mask = (1 << width) - 1
    return (x >> start) & mask
