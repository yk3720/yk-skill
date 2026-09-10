# Python — PyInstaller / GUI exe（L3 参照）

**SSOT:** 本ファイル · **索引:** [`PYTHON_RULES.md`](../PYTHON_RULES.md) §12  
**ROUTER tag:** `exe` · `yk_webview`  
**最終更新:** 2026-09-10（tkinterweb 4.x の frozen 同梱 · watchdog 併用時の型注釈とスレッド安全を追記 · `skill-doc-viewer` で確定）

汎用の `sys.frozen` パス解決はスキル KB `Python_2_技術ナレッジベース_04_環境・配布.md`（K-001）。本ファイルは **PyInstaller GUI exe**（relative import · 同梱 · tkwebview2）。プラグイン欠落の症状差は [`PYTHON_YK_DESKTOP.md`](PYTHON_YK_DESKTOP.md)。

---

`flowchart-studio` の `FlowchartStudio-ExcelConverter.exe` · `flowchart-excel` の `FlowchartExcel.exe` 実装で確定したパターン。詳細手順は各リポの `docs/03_技術仕様/装置Excel変換exe.md` · `npm run excel:converter:verify` · **`npm run excel:converter:release`**（版 bump 済み commit 上で verify → タグ → GitHub Release）· `flowchart-excel/build_exe.py`。

### relative import を `__main__.py` に書かない（凍結 exe で ImportError）

PyInstaller の `--windowed` onefile では、Analysis 入口を `package/__main__.py` にすると **`from .module import …` が「no known parent package」で落ちる**。

- **対策:** ロジックは `runner.py` 等に置き **absolute import のみ**（`from pkg.runner import main`）。PyInstaller 入口は `packaging/*_entry.py`（`excel_converter_gui.__main__` を import しない）。
- **アンチパターン:** `hiddenimports` だけ増やして `__main__.py` の relative import を残す。

### ビルド前に実行中 exe を止める

Windows では dist の exe が起動中だと PyInstaller が `PermissionError: WinError 5` で上書き失敗する（GUI 起動確認 · 作者の手元 exe · エージェントの `Start-Process` テスト）。

- **対策:** 再ビルド前に `taskkill /IM Foo.exe /F` 相当。リポでは `python/scripts/build_and_verify_converter.py` が自動実行。
- **アンチパターン:** ビルド失敗を「PyInstaller の不具合」と決めつける。
- **エージェント:** ソースを変えても `dist/*.exe` は自動更新されない — 作者が exe で確認する前に `build_exe.py` で再ビルドする。

### 凍結 exe の検証は GUI 目視だけにしない

`--windowed` exe は `--convert` 等の **ヘッドレス CLI 分岐**を同梱し、smoke で module CLI + 凍結 exe の両方を通す。stdout は cp932 環境で Unicode 記号（中黒等）を避ける。

### 命名は 3 層（作者向け / ファイル名 / 技術キー）

- **GUI · VERSIONINFO:** 日本語可（例: `Flowchart Studio — Excel 変換`）
- **exe ファイル名 · Release 資産:** **ASCII**（PATH · SmartScreen · npm 脚本）
- **Python パッケージ · spec · Git タグ:** kebab/snake（`excel_converter_gui` · `excel-converter-v0.1.1`）
- **Release 自動化:** `python/scripts/release_converter.py` — `pyproject.toml` 版を読み `excel-converter-v{semver}` タグ + 版付き exe 添付（exe 本体は Git に commit しない）

### v0.3 フロー表 ↔ モジュールは ListObject 名を使わない

作者が Excel テーブルをコピペすると **ListObject 名**（例: `動作00018`）は MID と無関係になり、テーブル名から MID を推測すると **別モジュールにフローが紐付く**。

- **SSOT:** `構成` シート（UinID + MID + モジュール名）— Product Spec: `flowchart-studio/docs/03_技術仕様/Excel入力フォーマット_v0.3.md` §6.4
- **物理表のキー:** 各 Excel テーブル **直上 2 行**（行1: UinID · ユニット / 行2: MID · モジュール）— テンプレは `FlowTableMeta` + `_add_flow_table`（`workbook_builder.py`）が自動挿入
- **正規化:** `tables._read_table_meta_rows` → `kosei.module_label_for_mid`。**ListObject 名は照合に使わない**
- **互換:** 見出し 2 行が無い v0.2 / 旧 U0 手書きのみ `resolve_table_module_label`（テーブル名フォールバック）
- **アンチパターン:** `動作(\d+)` を MID として `% 100` 照合（`動作00018` → MID 18 誤マップ）

### Tk / CTk + pywebview · Excel COM（デスクトップ + 埋め込み Web）

`flowchart-excel` の studio 相当プレビュー調査（2026-07）で確定。詳細 URL · ルート比較はリポ調査書を正本とする:  
`yk-application/flowchart-excel/docs/03_技術仕様/調査_1窓WebView埋め込み_事前調査_2026-07-26.md`

| 原則 | 内容 |
|------|------|
| **埋め込み** | **pywebview は tk Frame に埋め込まない**（メンテナ明言）。`webview.start` と tk `mainloop` は双方ブロッキング — **同一スレッド同居はアンチパターン** |
| **真の1窓（HWND 1）** | pywebview 本体では不可。**tkwebview2**（EdgeChrome を WinForms 子 HWND 化）で CTk 内埋め込み可（`flowchart-excel` rev007）。失敗時は **2窓フォールバック**（別プロセス + `on_top`）を維持 |
| **Excel COM** | Office OM はスレッドセーフではない（STA）。ライブ更新・ステータス・描画を同一プロセスに寄せるなら **単一ワーカー／キューで直列化** · 描画中はライブ停止 |
| **製品約束** | 「常時 OS 最前面」を絶対約束にしない。ゴールは **Excel 操作中もプレビュー作業が継続できる**こと（1窓なら CTk `-topmost` · 2窓なら子 WebView `on_top` 等の**手段**は可） |

- **アンチパターン:** pywebview を tk Frame に直接載せる · 同一プロセス化だけして COM を複数経路から叩く · 「常時最前面」を**製品の絶対約束文言**にする · **pywebview 6.x を tkwebview2 と無確認で混在**

### tkwebview2 + pywebview 版固定（flowchart-excel 1窓 · 2026-07）

`tkwebview2` 3.5.0 は pywebview 旧 API（`EdgeChrome.web_view.web_view`）前提。**pywebview 5+/6+ は `EdgeChrome.webview`** のため、6.x 混在で起動直後に `AttributeError` → exe が即終了する。

加えて **`evaluate_js` も旧シグネチャ**（`script, semaphore, js_r`）のまま。pywebview 5+ は `evaluate_js(script, parse_json)` のため **TypeError で payload 注入が黙って失敗**する。症状: ステータスはライブ ON・画面は「プレビューデータを待機中…」。

| やる | やらない |
|------|----------|
| `requirements.txt` で **`pywebview>=5,<6`**（または upstream 追随まで compat 維持） | `pip install pywebview` で 6.x を無条件に上げる |
| 起動前に **`_ensure_tkwebview2_compat()`** — `__init__`（`self.web = edge.webview`）**と `evaluate_js`** を差し替え | `__init__` だけ直し `evaluate_js` を素のままにする |
| 埋め込み注入は **`CoreWebView2.ExecuteScriptAsync`** を優先（失敗時リトライ · ログは warning 以上） | 例外を `debug` だけに埋めて UI 無反応のままにする |
| WebView 初期 HWND サイズは **親 Frame 以下**（狭い1窓で読込ボタン等を覆わない） | 親より大きい固定 `800×480` で `MoveWindow` して放置 |
| **埋め込み `__init__` 中に `update` / `update_idletasks` しない**（サイズは `after` で同期） | pythonnet STA 上で init 中に `update*` → **GIL fatal で exe 即終了** |
| **CLR / pywebview `loaded` コールバックでは Tk を触らない**（フラグのみ · Tk メインの `after` pump で inject/resize） | `event_core_completed` / `loaded` から `winfo_*` · `after` · CTk を直接呼ぶ |
| **STA スレッド**で tk mainloop（`main.py` 参照） | MTA スレッドから tkwebview2 初期化 |
| PyInstaller: **`--collect-all=tkwebview2`** + webview 同梱（§下記） | webview のみ同梱して tkwebview2 を漏らす |
| 埋め込み init 失敗時は **子 widget を destroy して 2窓 UI にフォールバック** | 失敗後に同一親へ `pack` 済み領域へ `grid` でエラー表示 |

- **切り分け（起動即終了・ログに exception 無し）:** stderr に `PyEval_RestoreThread` / GIL → **init 中の `update*`** または STA/tk 競合を疑う
- **切り分け（起動失敗）:** `dist/logs/app.log` の `embedded_preview_init_failed` · venv の `python main.py` は可で exe のみ不可 → 同梱漏れまたは pywebview 版不一致
- **切り分け（読込無反応）:** `embedded_inject_failed` / `embedded_inject_ok` の有無。ライブ ON なのに「待機中」→ **evaluate_js 非互換または注入未到達**
- **詳細 POC:** `yk-application/flowchart-excel/docs/03_技術仕様/POC_ルートA_結果_2026-07-27.md`
- **実装参照:** `yk-application/flowchart-excel/app/ui/embedded_preview.py`（`_ensure_tkwebview2_compat`）

### tkinterweb 4.x（CTk 内埋め込み Markdown/HTML ビュー）の frozen 同梱

`skill-doc-viewer`（2026-09-10）で確定。単一ウィンドウ内に HTML を出したいだけなら
tkwebview2 + pywebview の重量スタックより `tkinterweb.HtmlFrame` が軽い（描画は Tkhtml3 ＝
**HTML 4.01 / CSS 2.1 まで**。flexbox・CSS 変数・角丸・影・`rem` は無効。CSS は 2.1 で手書きする）。

- **バイナリは別パッケージ:** tkinterweb 4.x は Python 層 `tkinterweb` と、プリビルド Tkhtml
  （`libTkhtml3.0.dll`）を持つ `tkinterweb-tkhtml` に分割されている。**`--collect-all=tkinterweb`
  だけでは DLL が入らず**、frozen 実行時に描画層ごと落ちる（GUI が即終了 or 白画面）。
- **やる:** `build_exe.py` に `--collect-all=tkinterweb_tkhtml`（import 名なのでハイフンでなく
  **アンダースコア**）を追加し、保険で `--collect-data=tkinterweb --collect-binaries=tkinterweb` も。
  `pyinstaller-hooks-contrib` を `requirements.txt` にピン。
- **ビルド後スモーク:** `dist/<App>/_internal/tkinterweb_tkhtml/tkhtml/libTkhtml3.0.dll` の存在と、
  `--add-data` した `assets/` の同梱を目視。`warn-*.txt` の `missing module named PIL` は
  画像描画（`PIL.ImageTk`）用 — 画像を出すなら `Pillow` を依存に足す（出さないなら optional で可）。
- **リソースパス:** CSS 等は `sys._MEIPASS` 分岐の1関数（K-001）経由。`__file__` / cwd 相対で開かない。
- **onedir → onefile:** frozen 差分の切り分けが速いので onedir で DLL 同梱を確認してから onefile。

### watchdog を併用するとき（ライブリロード）

- **`watchdog.observers.Observer` は型ではなくファクトリ関数。** mypy で `Observer | None` を
  注釈にすると `valid-type` エラー。型注釈は `from watchdog.observers.api import BaseObserver` を使う。
- コールバックは**別スレッド**で発火する。Tk はスレッドセーフでないので、ハンドラから
  ウィジェットを直接触らず `root.after(0, cb)` で UI スレッドへ渡す。純粋なデバウンス判定は
  時刻を引数で受ける関数に切り出してユニットテストする。
- エディタの atomic save（temp 書き込み→rename）は `on_modified` では届かない。
  `on_modified` / `on_created` / `on_moved`(dest) / `on_deleted` の4種を購読する。

### 隣接リポを Vite alias する preview-web は両側で npm install

`flowchart-excel/preview-web` は `@` → `../../flowchart-studio` で studio の React Flow ソースをバンドルする。解決起点は studio 配下のため、**preview-web だけの `npm install` では `@xyflow/react` 等が解決できず** `vite build` / `build_exe.py` が失敗する。

- **対策:** `c:/yk-application/flowchart-studio` でも `npm install` してから `python build_exe.py`（または `preview-web` の `npm run build`）
- **アンチパターン:** preview-web 側だけ準備して「依存漏れ」と決めつける · studio 未 clone / 未 install のまま exe ビルド

### Windows コンソール向け print に ✓ 等を書かない

PowerShell / cmd の既定 cp932 では `print("✓ …")` が **`UnicodeEncodeError`** になり、`setup_venv.py` 等が venv 作成前に落ちることがある。

- **対策:** セットアップ · ビルド脚本の stdout は ASCII（`[OK]` 等）。やむを得ず Unicode を出すなら `PYTHONIOENCODING=utf-8` または `sys.stdout.reconfigure(encoding="utf-8")`
- **アンチパターン:** 成功マークに ✓ / ✔ を使う（凍結 exe の smoke 出力も同様 — 上記「凍結 exe の検証」参照）

### PyInstaller は venv の Python 経由 · 遅延 import の webview を明示同梱

`flowchart-excel`（2026-07）で、**ビルド成功なのに exe でプレビューが開かない**事例。原因は次の複合。

1. **`build_exe.py` が PATH の `pyinstaller`（ストア版 Python）を呼んだ** — 依存は `.venv` に入れたが、解析環境には `webview` が無い  
2. **`preview_host` が `try: import webview`（delayed + optional）** — Analysis が webview を必須扱いにせず、`--collect-all=webview` も「not a package」でスキップ  
3. 結果: `preview-web/dist`（HTML）は同梱されるが **`webview` は PYZ に入らない** → 子プロセス `--flowchart-preview` が即終了し `{"error": "pywebview missing"}`（exit 2）

| やる | やらない |
|------|----------|
| ビルド脚本は **`sys.executable -m PyInstaller`**（＝ `python build_exe.py` した同一環境） | 素の `pyinstaller` コマンド（PATH の別 Python） |
| ビルド前に `import webview` で **同じ interpreter に入っているか**確認 | 「ビルド exit 0」だけ見て配布 |
| `--hidden-import=webview`（必要なら `pythonnet` · `clr_loader` も） | delayed/optional import だけに任せた同梱 |
| **1窓（tkwebview2）時:** `--collect-all=tkwebview2` も追加 | webview のみ同梱 |
| ビルド後 smoke: `FlowchartExcel.exe --flowchart-preview payload.json result.json <dist>` が **exit 2 / pywebview missing でない**こと · **GUI 起動で `starting_app` のみで落ちない** | GUI 目視だけ · warn の `missing module named webview` を無視 |

- **切り分け:** `.venv` の `python main.py` でプレビュー可 · 当該 exe だけ不可 → ほぼ同梱漏れ（Runtime / 別PC差分ではない）
- **warn の合図:** `build/*/warn-*.txt` に `missing module named webview` があれば **配布禁止**で再ビルド

### 依存を足したら venv 再インストール + build/ 削除でクリーンリビルド

`toolkit`（2026-09-08）で、`requirements.txt` に `Pillow` を書いたのに **その `.venv` へ `pip install -r requirements.txt` を流し直していなかった**ため、T-2 以降ずっと凍結 `Toolkit.exe` で `bmp-resizer` プラグインが読み込み失敗していた（`resize.py` の `from PIL import Image` が hard import なのに同梱漏れ）。さらに `pip install` 後に素の `build_exe.py` を回しても **PyInstaller が `build/<name>` のキャッシュ解析を再利用し exe は Pillow なしのまま**。`build/<name>` と `dist/<name>.exe` を消して初めて反映された。

| やる | やらない |
|------|----------|
| 依存追加後は **`.venv` へ `pip install -r requirements.txt` を流し直す** | `requirements.txt` を編集しただけで「入っている」とみなす |
| ビルド前に **`requirements.txt` の各行が当該 interpreter で `import` できるか**確認（optional import だけでなく hard import も） | `import webview` 等 optional import だけ確認して満足する |
| 依存が変わったら **`build/<name>` と `dist/<name>.exe` を削除してからリビルド** | `--noconfirm` の素ビルドでキャッシュ解析を再利用したまま配布 |
| exe 起動確認は **`plugins_discovered` の件数と id 一覧を期待値と突き合わせ**、`plugin_without_plugin_module` の WARNING が 0 であることまで見る | `count > 0` や GUI 目視だけで OK とする |

- **症状の別型:** [`PYTHON_YK_DESKTOP.md`](PYTHON_YK_DESKTOP.md) が書く `plugins_discovered count=0`（全滅）ではなく、**`count` が期待より 1 件少ない + `plugin_without_plugin_module | package=X`**（部分欠落・ダイアログ無し）。1 プラグインの hard import 依存が exe に無いと出る
- **切り分け:** `.venv` の `python -c "import <dep>"` が可 · 当該 exe だけプラグイン欠落 → venv 未同期またはキャッシュ再利用
