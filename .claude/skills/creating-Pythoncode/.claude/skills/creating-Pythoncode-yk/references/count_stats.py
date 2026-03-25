import os

ROOT_DIR = "0.ルール・操作方法"
PREFIX = "rule_Pythonコード作成のルール"
SUFFIX = ".md"


def find_latest_rule_file(root_dir: str) -> str | None:
    candidates: list[str] = []
    for current_dir, _dirs, files in os.walk(root_dir):
        for name in files:
            if name.startswith(PREFIX) and name.endswith(SUFFIX):
                candidates.append(os.path.join(current_dir, name))

    if not candidates:
        return None

    return max(candidates, key=os.path.getmtime)


file_path = find_latest_rule_file(ROOT_DIR)
if file_path is None:
    print(f"File not found: {ROOT_DIR}/{PREFIX}*{SUFFIX}")
    raise SystemExit(1)

with open(file_path, "r", encoding="utf-8") as f:
    content = f.read()
    lines = len(content.splitlines())
    chars = len(content)
    print(f"File: {file_path}")
    print(f"Lines: {lines}")
    print(f"Characters: {chars}")
