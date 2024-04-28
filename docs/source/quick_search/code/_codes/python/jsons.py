import json
from typing import Any


def load_json(path: str) -> Any:
    """将path文件转为合法的json"""

    def parse_constant(v: str):
        # v in ("nan", "inf", "-inf")
        # json ("NaN", "Infinity", "-Infinity")
        raise ValueError("非法json字符: %s" % v)

    with open(path, "r", encoding="utf-8") as f:
        return json.load(f, parse_constant=parse_constant)


def dump_json(obj: Any, path: str):
    """将obj以json形式写入path文件"""
    with open(path, "w", encoding="utf-8") as f:
        json.dump(obj, f, ensure_ascii=False, indent=4)
