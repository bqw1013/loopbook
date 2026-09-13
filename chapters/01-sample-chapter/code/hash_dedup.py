"""示例章配套脚本：用哈希指纹找出重复文件。

运行：uv run python chapters/01-sample-chapter/code/hash_dedup.py
产物：scratch/ch1/ 下的演示文件与 report.txt（已被 .gitignore 忽略）
"""

import hashlib
import sys
from pathlib import Path

BOOK = Path(__file__).resolve().parents[3]
WORK = BOOK / "scratch" / "ch1"

# 文件名叫什么不重要，内容是否相同只有哈希说了算：
# 两个 cat 名字不同、内容相同；两个 notes.txt 同名、内容不同
CONTENTS = {
    "inbox-a/cat.jpg": b"fake-image-bytes-001",
    "inbox-a/notes.txt": b"todo: finish the chapter",
    "inbox-b/cat-copy.jpg": b"fake-image-bytes-001",
    "inbox-b/notes.txt": b"todo: buy milk after lunch",
    "inbox-b/dog.jpg": b"fake-image-bytes-999",
}


def make_demo_files() -> None:
    for rel, payload in CONTENTS.items():
        path = WORK / rel
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_bytes(payload)


def fingerprint(path: Path) -> str:
    digest = hashlib.sha1()
    with path.open("rb") as fh:
        for chunk in iter(lambda: fh.read(65536), b""):
            digest.update(chunk)
    return digest.hexdigest()


def find_duplicates(root: Path) -> dict[str, list[Path]]:
    groups: dict[str, list[Path]] = {}
    for path in sorted(root.rglob("*")):
        if path.is_file() and path.name != "report.txt":
            groups.setdefault(fingerprint(path), []).append(path)
    return groups


def main() -> None:
    sys.stdout.reconfigure(encoding="utf-8")  # 强制 UTF-8 输出
    make_demo_files()
    groups = find_duplicates(WORK)
    lines = []
    for digest, paths in groups.items():
        names = ", ".join(p.name for p in paths)
        mark = "  <== 重复" if len(paths) > 1 else ""
        lines.append(f"{digest[:12]}  {names}{mark}")
    report = WORK / "report.txt"
    report.write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(f"共 {len(groups)} 组指纹，报告写入 {report}")
    print("\n".join(lines))


if __name__ == "__main__":
    main()
