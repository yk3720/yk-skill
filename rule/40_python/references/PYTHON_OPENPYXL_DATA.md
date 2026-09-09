# Python — openpyxl / データ処理（L3 参照）

**SSOT:** 本ファイル · **索引:** [`PYTHON_RULES.md`](../PYTHON_RULES.md) §12  
**ROUTER tag:** `yk_openpyxl` · `excel`  
**最終更新:** 2026-09-09（P14f · L1 §12 から分割）

win32com の起動・Quit はスキル KB `Python_2_技術ナレッジベース_06_Excel連携.md`（K-010）。本ファイルは **openpyxl ファイル層**（数式キャッシュ・sentinel・文字コード）。

---

### openpyxl: `data_only=True` でインメモリビルダーの数式セルが全 None になる

`load_workbook(path, data_only=True)` は Excel アプリが保存したキャッシュ値を読む。  
openpyxl 自身が保存したファイルにはキャッシュがないため、**数式セルの値が全部 `None`** になる。

- **対策:** 数式セルに依存する行を処理するときは `None` / 空文字フォールバックを用意する。  
- **アンチパターン:** フォールバックなしに `assert cell_value is not None` → テスト fixture で必ず落ちる。

### データ処理: 空行スキップは「フォールバック適用後」に判定する

セルが空に見えても数式 → None の場合があるため、「最初に空チェックでスキップ」すると有効行まで消える。

```python
# NG: フォールバック前にスキップ
if not any(cells):
    continue

# OK: フォールバックで値を埋めてから判定
value = raw_value or derive_from_fallback(idx)
if not value:
    continue   # 本当に空の末尾余白行のみここに到達
```

### Excel テンプレートのプレースホルダー行: sentinel 終端で判定する

Excel テンプレートには「まだ未入力」を示すプレースホルダー行が混在することがある（例: `M001_` — モジュール名 + 末尾アンダースコア）。`is None` チェックだけでは抜けるため、フォールバック後にセル値の末尾文字も判定してスキップする。

```python
def _is_placeholder(comment: str | None) -> bool:
    """None・空・末尾アンダースコア（テンプレ未入力）はプレースホルダーとみなす"""
    if not comment:
        return True
    return comment.strip().endswith("_")
```

- **アンチパターン:** `if comment is None: continue` のみ → 部分入力行（`M001_`）が有効行として通過する
- sentinel 文字はドメインにより異なる（`-`・`*` 等）。定数化して `constants.py` に置くとメンテしやすい

### 外部ツール向け CSV/TSV 出力は文字コードを明示する

Windows FA ツール（キーエンス KV-STUDIO 等）や業務アプリへのテキスト出力は UTF-8 ではなく Shift-JIS（`cp932`）を要求するケースがある。半角カタカナ（`ﾏｶﾞｼﾞﾝ` 等）は UTF-8 コピペで特に文字化けする。

```python
# 外部ツール向け（Shift-JIS）
with open(path, "w", encoding="shift_jis", errors="replace") as f:
    f.write(f"{address}\t{comment}\n")

# Web アプリ・内部データ向け（UTF-8）
with open(path, "w", encoding="utf-8") as f:
    json.dump(data, f, ensure_ascii=False, indent=2)
```

- `errors="replace"` で変換不能文字を `?` 置換し、サイレントクラッシュを防ぐ
- エンコード変換は出力層（`export_*.py`）のみに閉じ、読み込み・変換ロジックは UTF-8 で統一する
