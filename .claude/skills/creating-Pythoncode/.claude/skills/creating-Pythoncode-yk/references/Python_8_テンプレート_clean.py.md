import shutil
import argparse
from pathlib import Path

def clean_environment(keep_logs=False):
    """環境浄化スクリプト：デバッグ残骸や一時ファイルを物理的に抹消する。"""
    
    # 削除対象のパターン
    patterns = [
        "**/__pycache__",
        "**/.pytest_cache",
        "**/.mypy_cache",
        "**/.ruff_cache",
        "temp/*",
        "*.spec",
        "build/",
        "dist/",
    ]
    
    # ログ削除はオプション
    if not keep_logs:
        patterns.append("logs/*.log")
    
    base_path = Path(__file__).resolve().parent
    print(f"--- 環境浄化開始: {base_path} (keep_logs={keep_logs}) ---")
    
    count = 0
    for pattern in patterns:
        for path in base_path.glob(pattern):
            try:
                if path.is_file():
                    path.unlink()
                elif path.is_dir():
                    shutil.rmtree(path)
                print(f"パージ成功: {path.relative_to(base_path)}")
                count += 1
            except Exception as e:
                print(f"パージ失敗: {path} ({e})")
                
    print(f"--- 浄化完了: {count} 個のアイテムを清算しました ---")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="環境浄化スクリプト")
    parser.add_argument("--keep-logs", action="store_true", help="ログファイルを保持する")
    args = parser.parse_args()
    
    clean_environment(keep_logs=args.keep_logs)
