# Python — yk-application 小型デスクトップ（L3 参照）

**SSOT:** 本ファイル · **索引:** [`PYTHON_RULES.md`](../PYTHON_RULES.md) §12  
**ROUTER tag:** `yk_desktop`  
**最終更新:** 2026-09-09（P14f · L1 §14 から分割 / 種別グループ見出しはバー・選択中項目は複数手掛かりで強調）

exe 手順は [`PYTHON_PYINSTALLER_GUI.md`](PYTHON_PYINSTALLER_GUI.md)。本ファイルは **yk-application 小型 GUI**（COM 所有権 · StayOnTop · プラグインハブ）。

---

**対象:** Python の Windows GUI に限る。自作ツール全体（Web · 他言語）の受付はスキル `creating-personal-tool-yk`。本節は Python デスクトップ実装時だけ読む。

**実例:** `bmp-resizer` · `excel-shape-arranger` · `toolkit`（旧 `excel-toolkit`。プラグイン集約）· `word-table-formatter`。置き場は `YK_APPLICATION_RULES` §6。

### 着手前チェック（yk-application Python デスクトップを新規/改修する前に必ず）

- [ ] Office を COM 操作するなら **`StayOnTop`**（`app/ui/stay_on_top.py` をコピー · `_finish`/完了時に `raise_window()` · `messagebox(parent=self)`）。非 COM は不要
- [ ] **フォント統一** — `theme.py` を SSOT に `CTkFont` の family を `Yu Gothic UI` へ · `font_title()/font_body()/font_small()` factory 経由（`ctk.CTkFont(size=...)` を widget へ直書きしない）
- [ ] **`pyproject.toml [tool.ruff] select` を明示 pin**（例 `["E","F","I","UP","B"]`）。未 pin リポは変更スコープ内のみ green を基準 · `main.py` DPI catch は `# noqa: BLE001`
- [ ] **`tk.StringVar()` を import 時に作らない** — `build_panel` / Tk root 確定後に生成
- [ ] 純ロジックは `app/core/` や Tk 非依存モジュールへ分離しユニットテスト（COM 実機はユーザー担当）
- [ ] プラグイン集約なら registry 自動収集 · 純関数は元リポからコピー（相互 import しない · 両方へ反映）
- [ ] exe は [`PYTHON_PYINSTALLER_GUI.md`](PYTHON_PYINSTALLER_GUI.md)（`build/<name>` + `dist/<name>.exe` 削除 → **venv の** `build_exe.py` → `plugins_discovered` 件数・id を突き合わせ）

**5.Python MZ テンプレとの差:** 独立リポの Product Spec は `docs/`（No 17 / 25）。`仕様・管理/` は使わない。起動は bmp-resizer 型（`requirements.txt` · `python main.py` · 日本語 bat）。`pyproject.toml` は依存・Ruff の併記可（`requirements.txt` 単独を正本にしない）。

**Excel を触るとき:** `GetActiveObject` で起動中に接続する。未起動の Excel を `Dispatch` で起こさない。**`Excel.Quit` しない**。COM は UI スレッドのみ（[`PYTHON_PYINSTALLER_GUI.md`](PYTHON_PYINSTALLER_GUI.md) Tk/CTk + Excel COM と同趣旨）。

**Word を触るとき（Excel と同型）:** 同じく `GetActiveObject`。未起動の Word を `Dispatch` で起こさない。**`Word.Quit` しない**。COM は UI スレッドのみ。共有基盤は `app/core/word/`（Word を使うプラグインだけが import。Excel 非依存プラグインは触らない）。

**exe:** [`PYTHON_PYINSTALLER_GUI.md`](PYTHON_PYINSTALLER_GUI.md)。ファイル名は ASCII、画面タイトルは日本語可。bat は `dist\{Exe}.exe` があればそれを起動する。再ビルド前に起動中 exe を止める。**新設で exe まで作るか**はスキル `creating-personal-tool-yk`（Windows GUI は同一ターンでビルド）。

**テスト:** ドメインは unittest。COM 実機はユーザー担当。

**静的解析（ruff）:** `pyproject.toml [tool.ruff]` に `select` を書かないと、ruff 更新（0.16 系）で `I001` / `UP028` / `BLE001` / `SIM117` 等が既定に加わり、**既存コードに新規指摘が出る**（`toolkit` の committed main が 10 件・`word-table-formatter` 新設で `BLE001`）。小型ツールは `select` を明示 pin する（例: `["E", "F", "I", "UP", "B"]`）。pin していないリポに手を入れるときは **変更スコープ内のファイルのみ green** を完了基準とし、無関係な既存指摘は同じ変更で直さない。`main.py` の DPI 設定 `except Exception` は `# noqa: BLE001`（best-effort・起動を止めない）を定型にする。

**フォント統一（CTk）:** CTk 既定の `Roboto` は日本語グリフを持たず、Tk が **文字ごとに system フォントへ fallback** するため、日本語混在 UI が「フォントバラバラ」に見える（`toolkit` で発覚。ラベル・ボタン・見出しで別々の和文フォントに落ちる）。`app/ui/theme.py` を 1 ファミリ SSOT にし、`apply_theme()` で `ctk.ThemeManager.theme["CTkFont"]["family"]` を **Latin+日本語を 1 面で賄うフォント**へ上書きする（明示 `font=` 未指定の widget も揃う）。サイズ・太さ違いは `font_title()` / `font_body()` / `font_small()` の factory 経由にし、`ctk.CTkFont(size=...)` を各 widget へ直書きしない。`apply_theme()` は `ctk.CTk.__init__` 呼び出し前（widget 生成前）に呼ぶ — 個別の `set_appearance_mode` / `set_default_color_theme` 直書きは `theme.py` に一本化し呼び出し側へ残さない。
**フォントファミリ:** `BIZ UDPゴシック`（モリサワ製ユニバーサルデザインフォント。Windows 10 October 2018 Update 以降 標準搭載・プロポーショナル版）。似た形の数字・かな濁点半濁点を判別しやすい UD 設計で、小サイズ UI の視認性を優先し採用（2026-09-10 · Web 調査で `Yu Gothic UI` 比較のうえ乗り換え）。固定ピッチ版 `BIZ UDゴシック` は表形式など桁揃えが要る場面用で UI 既定には使わない。旧 `Yu Gothic UI`（Windows 既定 UI フォント）も許容候補ではあるが、新規/横展開は `BIZ UDPゴシック` を既定とする。
**適用対象:** `toolkit` · `bmp-resizer` · `excel-kana-toggle` · `excel-shape-arranger` · `figure-renumberer` · `term-consistency-checker` · `word-kana-toggle`（2026-09-09 全 7 リポへ `theme.py` 横展開 · 2026-09-10 `BIZ UDPゴシック` へ乗り換え）。**新規ツール:** `creating-personal-tool-yk` の雛形で最初から `theme.py` を持つ。

**プラグイン集約（複数ツールを 1 窓に · 実例 `toolkit`）:**

- 共有基盤は `app/core/`（`ToolPlugin` 契約・結果型。Office 非依存）+ `app/core/excel/` · `app/core/word/`（各 Office を使うプラグインだけが import）。各ツールは `app/plugins/<name>/plugin.py` 末尾で `PLUGIN = ...` を公開し、`registry.discover()` が `pkgutil.iter_modules` + `ispkg` で自動収集する。ハブに if 分岐を足さない
- **選択操作と全文走査は core へ寄せる** — 選択は `selection`（例: `as_cell_range` / `as_text_selection`）、文書・ブック全文の読取は `document` / `workbook`（例: `scan_active_document` / `scan_active_workbook`）。プラグイン内で `GetActiveObject` や全文読取を再実装しない（検出のみツールも書込なしのまま core 経由）。**アンチパターン:** プラグインごとに `word_scan.py` / `excel_scan.py` をコピーして COM 接続を二重管理する
- 純関数は各プラグインフォルダに閉じてユニットテスト。元の単機能リポからはロジック無改変で **コピー**（相互 import しない · 更新は両方へ · コピー元/先を docstring と AGENTS に明記）
- **`tk.StringVar()` を import 時に生成しない** — `PLUGIN = Plugin()` がモジュール読込で走るため、`__init__` で Tk 変数を作るとヘッドレステストが `RuntimeError: no default root window` で落ちる。Tk 変数は `build_panel`（Tk root 確定後）で生成する
- **ハブの一覧ロジックも Tk 非依存モジュールへ** — 分類フィルタ・グループ分け・フッター文言などの分岐は `app/ui/nav_model.py` 等の Tk 非依存な純関数（例: `visible_plugins` / `split_by_kind` / `keeps_open_text`）へ寄せ、`hub_window` に種別 if を散らさずデータ駆動（`meta.kind` 等）にして `test_nav_model.py` で単体テストする。分類などの語彙は `PluginMeta` の `Literal` を単一正本にし `get_args` で並び順を導出（二重定義しない）。**`CTkScrollableFrame` に `.pack()` した子は `winfo_children()` で列挙できない**（内部フレームへ再ペアレントされる）ため、一覧を動的に組み直すなら生成 widget を `list` で保持して `destroy()` する
- **一覧の種別グループ見出しは「バー」で強調する** — 「通常ツール」「ランチャーツール」等のグループ見出しを `font_small` + `TEXT_MUTED` の素ラベルにすると本文に埋もれ、グループ境界が読めない（`toolkit` で「強調が弱い」指摘・2026-09-09）。**薄い accent 地の角丸フレーム**（`fg_color=ACCENT_SOFT`＝blue-100 · `corner_radius=6` · 上に `pady` を多め）に **accent 太字ラベル**（`font_body(bold=True)` · `text_color=ACCENT`）を載せる。`ACCENT_SOFT` は `constants.py` のパレットに追加。`CTkLabel` に内側 padding を効かせたいときはフレームでラップして子ラベルを `pack(padx=…)` する
- **選択中の項目（左ナビ・分類フィルタ）は複数の手掛かりで強調する** — `fg_color=SURFACE_MUTED` だけの選択表示は地色（`SURFACE`）との差が小さく「選択が分からない」（`toolkit` で指摘・2026-09-09）。Web 調査（Apple HIG / 各 UX ガイド / a11y ガイド）の一致点は **①塗り（brand/accent 色のフィルタ地）②左アクセントバー ③文字の太さ ④文字・アイコン色** を**複数**組み合わせること、**色だけに頼らない**こと、**描画直後から**見えること。CTk 実装は選択中＝`fg_color=ACCENT` + `text_color`（白 `TEXT_ON_ACCENT`）+ `font_body(bold=True)` + `hover_color=ACCENT_HOVER`、非選択＝`fg_color="transparent"` + `TEXT` + 通常太さ。塗り・文字色・太さの 3 手掛かりで色覚に依らず判別できる。`CTkButton` は片側だけの border を持てないため左バーの代わりに全面塗りで代替。**塗り替えヘルパを 1 つ**（例 `_paint_selectable(btn, *, active)`）にまとめ、生成時・`_select`・`_on_category` すべてそれを呼ぶ（分岐を散らさない）。`font_body()` を毎回呼ばず `__init__` で通常／太字の `CTkFont` を 1 つずつキャッシュして使い回す
- PyInstaller: 動的 import は `--collect-submodules=app`（解析対象パッケージ）で同梱。漏れると凍結 exe の `plugins_discovered count=0`（1 プラグインの hard import 依存漏れは [`PYTHON_PYINSTALLER_GUI.md`](PYTHON_PYINSTALLER_GUI.md)「依存を足したら…」参照）
- **重量級・別スタックのツールは in-process 取り込みしない — launcher プラグイン方式**（`toolkit` の `flowchart-excel`＝React Flow の Web アプリ。2026-09-08）。`app/plugins/<name>/launcher.py` に exe 探索と起動を閉じる: 探索順は **環境変数 override → Toolkit.exe 同梱 / 開発時 `dist/` → 隣接リポ `../<tool>/dist/` → `PATH`**、起動は `subprocess.Popen`（Windows は `creationflags=subprocess.DETACHED_PROCESS`・`cwd=exe.parent`）、未検出時は解決手順つき `ToolError`。純関数コピーは不要（起動するだけ）。GUI は「起動」＋「exe を指定…」程度に留める
  - **アンチパターン:** 別スタックのツールを移植して二重管理を増やす · `Popen(**kwargs)` に `dict[str, object]` を渡す（mypy `call-overload`。キーワード引数を明示するか platform 分岐で書く）

**COM ツールのウィンドウを前面に保つ（`StayOnTop` · 2026-09-08）:**

- **症状:** 起動中の Excel/Word を COM 操作すると、Office 窓が前面を取り自ツール窓が背面へ落ちる。ユーザーが「先に Excel で選択」と Office をクリックした時点でも同じ。`lift()` 単体では戻らない（Windows のフォアグラウンドロック）。
- **対策:** `-topmost` ビットのトグル（**パルス**＝一瞬 True にして戻す）はバックグラウンドからでも許可される。これで前面へ引き上げる。あわせて「常に最前面」チェックボックス（**既定 ON・セッション限り・設定は永続化しない**＝要求定義の「設定永続化しない」に抵触させない）を置く。
- **共通ヘルパ `app/ui/stay_on_top.py`**（`StayOnTop` クラス。純関数コピーと同じ方式で各リポへ**コピー**・相互 import しない）:
  - `StayOnTop(win, *, default=True)` — `super().__init__()` の後、`_build_ui()` の前に生成（import 時に Tk 変数を作らないルールと同じ理由）
  - `.checkbox(parent)` → 「常に最前面」`CTkCheckBox` を返す。配置はフッターへ呼び出し側が `grid`
  - `.raise_window()` — **COM 操作の完了・エラー時**（各 `_on_*_done` の `_set_busy(False)` 直後、ハブは `_finish`）に呼ぶ。ON ならそのまま最前面、OFF なら `-topmost` パルスで一度だけ復帰
  - `tk.TclError` は握りつぶす（ウィンドウ破棄後）
- **`messagebox` は `parent=self`** を渡す（親に紐付き前面化する）。
- **適用対象:** 起動中 Office を COM 操作するデスクトップツールすべて（`toolkit` ハブ · `excel-kana-toggle` · `word-kana-toggle` · `term-consistency-checker` · `excel-shape-arranger` · `figure-renumberer`）。**Office 非 COM ツール（`bmp-resizer` 等）は対象外**（隠れる相手がいない）。
- **新規ツール:** Windows GUI で Office を COM 操作するなら最初から組み込む（`creating-personal-tool-yk` の雛形）。
- **テスト:** GUI 部品のため `theme.py` 同様ユニットテストは置かない。構築スモーク（`App(); app.update(); app.destroy()`）で足りる。
