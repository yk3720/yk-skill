# Python 技術ナレッジベース Excel・デスクトップ連携 (Field Manual - Excel & Desktop)
## ■ 本書の役割
Excel (win32com)、ファイル操作、およびデスクトップアプリ固有の外部連携に関するナレッジ。

---

## 第1章：Excel 連携の儀式 (Excel Automation)

### [K-010] Excel ghost process の完全抹殺
- **導入**: `uv add pywin32` (win32com 使用時は必須)
- **三位一体の解放**:
  ```python
  import pythoncom
  from win32com.client import Dispatch

  pythoncom.CoInitialize()
  try:
      excel = Dispatch("Excel.Application")
      # ... 処理 ...
  finally:
      if 'excel' in locals():
          excel.Quit()
      pythoncom.CoUninitialize()
  ```
- **Excel定数**: `win32com.client.constants` を参照。

### [K-011] Atomic保存 (Atomic Save)
- **データ破損防止**: 直接上書きせず、一時ファイル（`.tmp`）に書き出し、成功後に `os.replace()` で置換せよ。

### [K-011-1] サンプルファイル作成機能
- **利便性**: Excel 読み込みアプリには、必ず「標準テンプレートの出力」機能を UI に備えよ。

### [K-024] Excel ファイルロックの事前検知
- **問題**: `pandas` で開く前に、既に Excel で開かれていると書き込みに失敗する。
- **解決策**: `open(file_path, 'r+b')` を試行し、`PermissionError` を捕捉することで、ユーザーに「ファイルを閉じてください」と具体的な指示を出せ。

---

## 第2章：デスクトップ UI 連携 (Desktop UI)

### [K-053] モダンなデスクトップ UI (CustomTkinter)
- **外観**: 標準の `tkinter` ではなく `customtkinter` を採用することで、Windows 10/11 に馴染むモダンな UI（ダークモード対応等）を容易に実現できる。
- **導入**: `uv add customtkinter`

### [K-054] Rich によるターミナル出力の美装
- **CLI ツール**: ログや進行状況を `Rich` ライブラリで表示することで、コマンドラインツールとしての直感性と高級感を高めよ。
- **導入**: `uv add rich`
