# Python — yk-application 小型デスクトップ（L3 参照）

**SSOT:** 本ファイル · **索引:** [`PYTHON_RULES.md`](../PYTHON_RULES.md) §12
**ROUTER tag:** `yk_desktop`
**最終更新:** 2026-09-18（全体を章立てに再構成 · Excel COM は「UIスレッドのみ」ではなく「単一ワーカーで直列化」が正確な表現と訂正 · 空欄区別用の姉妹関数パターン · 埋め込みWebView構成での計算ロジック配置判断基準 · `threading.Thread` と CLR/WinFormsコールバックのTk安全性の違い · `flowchart-excel` の `.venv` に ruff が無い件を追加）。旧: 2026-09-16（3値以上のボタン状態色は既存のポーリングに便乗させ1箇所で計算する · CTk ボタンの状態色は生成直後に確定させる · `update_idletasks()` では同期COM呼び出し前の色変更が反映不安定 · Excel位置ズレ報告は実測ログで裏取りしてから直す · `flowchart-excel` 追加）。旧: 2026-09-15（CTk grid の空列だけ伸びる落とし穴を追加 · Excel `Shapes.AddConnector` の `.Type` 実機値・アンカー不要の浮き終点パターン · エージェントの実機Excel検証は隔離インスタンス+`Visible=False`で・`flowchart-excel` 追加）

exe 手順は [`PYTHON_PYINSTALLER_GUI.md`](PYTHON_PYINSTALLER_GUI.md)。本ファイルは **yk-application 小型 GUI**（COM 所有権 · StayOnTop · プラグインハブ）。

---

## 1. 対象・実例・着手前チェック

**対象:** Python の Windows GUI に限る。自作ツール全体（Web · 他言語）の受付はスキル `creating-personal-tool-yk`。本節は Python デスクトップ実装時だけ読む。

**実例:** `bmp-resizer` · `excel-shape-arranger` · `flowchart-excel`（Excel AutoShape フローチャート生成。10列表駆動、WebView埋め込みプレビュー）· `toolkit`（旧 `excel-toolkit`。プラグイン集約）· `word-table-formatter` · `skill-doc-viewer`（非 COM。tkinterweb 埋め込みで yk-skill の rule/skills MD をビュー。CSS 2.1 天井は各リポ decision-log）。置き場は `YK_APPLICATION_RULES` §6。

### 着手前チェック（yk-application Python デスクトップを新規/改修する前に必ず）

- [ ] Office を COM 操作するなら **`StayOnTop`**（`app/ui/stay_on_top.py` をコピー · `_finish`/完了時に `raise_window()` · `messagebox(parent=self)`）。非 COM は不要
- [ ] **フォント統一** — `theme.py` を SSOT に `CTkFont` の family を `BIZ UDPゴシック` へ · `font_title()/font_body()/font_small()` factory 経由（`ctk.CTkFont(size=...)` を widget へ直書きしない）· 選定理由は下記「フォントファミリ」節
- [ ] **`pyproject.toml [tool.ruff] select` を明示 pin**（例 `["E","F","I","UP","B"]`）。未 pin リポは変更スコープ内のみ green を基準 · `main.py` DPI catch は `# noqa: BLE001`
- [ ] **`tk.StringVar()` を import 時に作らない** — `build_panel` / Tk root 確定後に生成
- [ ] 純ロジックは `app/core/` や Tk 非依存モジュールへ分離しユニットテスト（COM 実機はユーザー担当）
- [ ] プラグイン集約なら registry 自動収集 · 純関数は元リポからコピー（相互 import しない · 両方へ反映）
- [ ] exe は [`PYTHON_PYINSTALLER_GUI.md`](PYTHON_PYINSTALLER_GUI.md)（`build/<name>` + `dist/<name>.exe` 削除 → **venv の** `build_exe.py` → `plugins_discovered` 件数・id を突き合わせ）

**5.Python MZ テンプレとの差:** 独立リポの Product Spec は `docs/`（No 17 / 25）。`仕様・管理/` は使わない。起動は bmp-resizer 型（`requirements.txt` · `python main.py` · 日本語 bat）。`pyproject.toml` は依存・Ruff の併記可（`requirements.txt` 単独を正本にしない）。

**Python バージョン（現実）:** yk-application デスクトップ群は**事実上 Python 3.13 運用**（この開発 PC に 3.12 が無い。`toolkit` の venv も 3.13）。`.python-version` の `3.12` 系の記述は「3.12 が使える環境ではそちらを優先」という努力目標であって、3.13 で作って構わない。`requires-python` は `>=3.12` に留め、上限で 3.13 を弾かない。tkinterweb の 3.13 系不具合（空 `<title>` で `TclError`）に当たるなら、生成 HTML の `<title>` を必ず非空にして回避する（`skill-doc-viewer` の `render.py` 参照）。

---

## 2. Excel / Word COM 操作

**Excel を触るとき:** `GetActiveObject` で起動中に接続する。未起動の Excel を `Dispatch` で起こさない。**`Excel.Quit` しない**。Office OM はスレッドセーフではない（STA）— COM 呼び出しは Tk メインスレッドか、**1機能につき単一のワーカースレッド**に限り、複数ワーカーから同時に同じブックへ触らせない（直列化。[`PYTHON_PYINSTALLER_GUI.md`](PYTHON_PYINSTALLER_GUI.md) の表と同趣旨）。「COM は UI スレッドのみ」という言い切りは不正確 — `flowchart-excel` の描画パイプライン（`_worker_from_snapshot`）や C-2 の提案計算ワーカーは実際に専用バックグラウンドスレッド + 自前 `pythoncom.CoInitialize()` で COM を扱っており、これは許容パターンである。守るべきは「スレッドの場所」ではなく「同時に複数スレッドから同じ COM オブジェクトを叩かない」こと。

**エージェントが実機Excelで動作確認するとき（`flowchart-excel` 2026-09-15）:** `GetActiveObject` はユーザーが**今まさに開いている実インスタンス**に繋がる（実際にこのセッションでユーザーの実ブックが開いた状態のインスタンスへ接続した）。使い捨て検証で新規ブックを作って壊す可能性があるなら、`win32com.client.Dispatch("Excel.Application")` + `app.Visible = False` で**完全に別プロセスの隔離インスタンス**を立て、そちらだけで検証してから `app.Quit()` する（`GetActiveObject` で得たユーザーの実インスタンス側は絶対に `Quit()` しない）。検証前後で `app.Workbooks.Count` を比較し、増減が自分の操作分とズレていないか必ず確認する。

**AutoShape コネクタ（`Shapes.AddConnector`）の落とし穴（`flowchart-excel` 2026-09-15 実機確認、Excel 16.0/365）:**
- `.Type` は「コネクタは `msoLine`(9)」という通説に反し、実機では **`msoAutoShape`(1)** として報告された（`BeginConnect`/`EndConnect` の有無に関わらず）。「Type で通常図形とコネクタを見分ける」設計は当てにせず、実機で `.Type` を確認してから判定条件を書く。
- 接続先が無い「浮いた終点」を作りたいだけなら、終点用のダミー図形（アンカー）を作って `EndConnect` → 後で消す、という手順は不要。`AddConnector(type, x1, y1, x2, y2)` の `x2, y2` に浮かせたい座標を直接渡し `BeginConnect` だけ呼べば、未接続のままその座標に固定される。アンカー方式は削除し忘れによる残留シェイプ（不可視・極小サイズの図形がシートに蓄積）のリスクを生む。

**Excel 上の「位置がおかしい」報告は先に実測ログで裏取りする（`flowchart-excel` 2026-09-16）:** `app.Selection` を都度読み直して描画位置を決める設計は正しく動いていても、ユーザーの「意図した位置と違う」報告だけでコードを疑って推測パッチを当てると空振りしやすい。アンカー解決箇所へ `sheet.Name` / `Range.Address` を出すログを1行足し、再現後に `dist/logs/app.log` を読むと、コードは正しく選択セルを使えており、原因はシート上の別テーブルとの近接・重複だった（狙ったセルが別データ島のすぐ近くにあった）。**対策:** COM 経由の「位置がズレる」系の報告は、まずアンカー解決点に実測ログを1行足してから再現してもらう（コードを直す前に「本当にコードが原因か」を実測で切り分ける）。

**Word を触るとき（Excel と同型）:** 同じく `GetActiveObject`。未起動の Word を `Dispatch` で起こさない。**`Word.Quit` しない**。COM の直列化方針は Excel と同じ。共有基盤は `app/core/word/`（Word を使うプラグインだけが import。Excel 非依存プラグインは触らない）。

**Word の選択範囲を書き換えるツールの落とし穴（`word-kana-toggle` v0.3.0〜v0.3.1 · 2026-09-10 で全部踏んだ）:**

1. **表をまたぐ `Selection.Range.Text = …` 一括代入は表を破壊**（セル境界・行・段落が潰れる）。**`Range.Find` の `wdReplaceAll` は表で激遅**（置換ごとにセル再レイアウト。実測: 表1個17箇所で20〜30秒。`ScreenUpdating=False` でも止まらない）。→ `Selection.Range.Tables.Count` で分岐。**表なし**=`Range.Text` 1回 / **表あり**=`Selection.Range.Paragraphs` を**末尾から**、段落ごとに **本文レンジ `doc.Range(para.Range.Start, para.Range.End - 1)`**（`\r` を除く。下記 8）へ `.Text =`（後ろから編集で位置ずれ回避・対象なし段落は書かない）。
2. **`Find.Execute` 等 多引数 COM メソッドはキーワード引数が凍結 exe（`gen_py` 不在＝純遅延バインディング）で無言失敗**し既定値で走る（`Replace` が `wdReplaceNone` に落ち「変わらないのにエラーも出ない」。`.venv` の `python main.py` は makepy で動くので exe だけ再現）。→ プロパティ設定 + 全引数を位置指定。`Execute` の戻り値も見る。
3. **書き込みは「実測」で成否を出す**（計画件数を success 表示にしない）。書戻し後に領域を読み直し、純関数で「残っている対象数」を数え `変換済み = 総数 − 残り`。`0`→エラー / `<総数`→「一部だけ N/M」/ `==総数`→成功。**完全一致のバイト比較を成功条件にしない**（フィールドコード `\x13…\x15` 等で `Selection.Text` と `Range.Text` の表現が食い違い、中身が合っていても「未確認」に落ちる。診断ログ止まり）。
4. **書戻し後は変換後領域を `Select()` し直す**（積算した長さ差分 `delta` から `doc.Range(開始, 元終端+delta)`）。サブ範囲編集や `Range.Text=` で Selection は崩れ、`開始+len(期待値)` の位置推定はマーカー差でずれる。再選択で読み直しが `Selection.Range.Text` 基準になり、ユーザーも続けて操作できる。
5. **`Range.Paragraphs` はテキストボックス・図形・フィールド・ヘッダー/フッター・脚注の中を辿らない**。段落を歩く書き換えはそれらを素通りする（`Range.Text` にも出ないので実測でも検知不可）。対象にするなら `Range.ShapeRange` → `shape.TextFrame.TextRange` を別途。
6. **`len(Selection.Text)` は画面の文字数より多い**（`\r` `\x07` `\x0c` 等を含む）。上限判定・件数表示はこれらを除いた数で（`word-kana-toggle` の `strip_structural_markers`）。
7. **変換中だけ `ScreenUpdating` と `Options.CheckSpellingAsYouType` / `CheckGrammarAsYouType` を OFF**（`finally` で復元）。`TrackRevisions` が ON なら warning（勝手に切らない）。
8. **`Range.Text` の文字数と文字位置は一致しない。** `\x07`（セル/行終端）は `Range.Text` に出るが**位置を 0 しか占めない**（実機ログ `Range(a,b).Text` 長 = `b-a+1`）。`\x13…\x15` フィールド・貼り込み画像も同種。→ **書き込みレンジの終端をテキスト長の引き算で出さない**（`span_end - len(tail)` は `\x07` のぶん 1 引きすぎ、本文末尾が範囲外に残って**変換のたび末尾が 1 文字重複**する。`word-kana-toggle` v0.3.1 実機バグ）。段落本文は `para.Range.End - 1`（`\r` は必ず 1 位置）で取る。
9. **`Range.Paragraphs` を `.Item(i)` で `i=1..N` 回さない。** `Paragraphs` は内部が連結リストで `.Item(i)` は毎回頭から辿る → **O(N²)**。文書全体を選ぶと `WINWORD` が 1 コア回しっぱなしでツールごとフリーズ（UI スレッド同期実行なら GUI も固まる）。**列挙子で 1 度だけ舐める**（`for para in paragraphs:`）= O(N)。加えて段落数の上限（`MAX_PARAGRAPHS`）で門番し、超過は書き込む前に弾く。長時間になる表あり書戻しは段落ループの合間に `progress(done,total)` コールバック + `update()` で進捗バー / 中断を出す（`word-kana-toggle` v0.3.1）。

---

## 3. 非同期・スレッド設計

**通常の `threading.Thread` と CLR/WinForms イベントコールバックは、Tkへの反映方法が異なる（`flowchart-excel` 2026-09-18）:** 自分で起動した通常の `threading.Thread`（例 `main_window.py` の `_worker_from_snapshot`）からは `self.after(0, cb)` でTkメインスレッドへ安全に反映できる（Tcl のイベントキューへの登録はスレッドセーフ）。一方、tkwebview2/CLR側が発火するイベントコールバック（`loaded` · `event_core_completed` 等）は **Tkを直接触ってはいけない**（フラグを立てるだけにして `_main_pump` の `after` ポーリングで拾う、というのが本ファイル既出の鉄則）。**この2種類のバックグラウンド実行元を同一視して「バックグラウンドスレッドだから all `after(0,...)` NG」あるいは逆に「CLRコールバックでも `after` すれば大丈夫」と誤解しないこと。** 新機能の非同期ワーカーを追加するときは、それが自分で `threading.Thread(...).start()` したものか、CLR/WinFormsが呼ぶコールバックかを最初に見極める。

**埋め込みWebView構成（1窓 tkwebview2）で新機能の計算ロジックをどちら側に置くか（`flowchart-excel` 2026-09-18）:** JS→Python通知が `ExecuteScriptAsync` ポーリング限定（`window.pywebview.api` も同期 `evaluate_js` も使えない。詳細は [`PYTHON_PYINSTALLER_GUI.md`](PYTHON_PYINSTALLER_GUI.md)「JS→Python通知は…使えない」節）という制約下では、JS側で計算してもPython側で計算しても結果を受け渡すのに同じポーリング往復が必要になり、計算をJS側に置くレイテンシ上の利点は無い。加えて Excel COM の最新読取・`stop_event` によるキャンセルは Python 側でしか自然に書けない。**対策:** このアーキテクチャで「Excelデータを読んで何かを計算しUIへ出す」新機能は、既存の描画・座標計算ロジック（TS側の React Flow 用ジオメトリ計算）と混同せず、**原則 Python 側に実装する**。TS側に置く理由があるのは React Flow の描画そのものを担う処理（レイアウト座標計算等）に限る。

---

## 4. CTk / Tk UI パターン

**CTk/Tk grid の「空列だけ伸びる」落とし穴（`flowchart-excel` 2026-09-15）:** `grid_columnconfigure(N, weight=1)` を設定しても、その列に**実際にウィジェットが無い**（空のまま）と、ウィンドウ拡大時にその空列だけが伸び、隣の列に置いた実ウィジェットは伸びていないように見える。「ボタンが2列あるはずなのに片方しかリサイズで広がらない」症状が出たら、まず両方の列に実ウィジェットが入っているか（片方が空のプレースホルダー列になっていないか）を疑う。今回はボタンが1個だけ列1に配置され列0が空だったのが原因で、列0にも実際のボタンを置いて初めて両方均等に伸びた。

**CTk ボタンの状態色は生成直後に確定させる（`flowchart-excel` 2026-09-16）:** ウィジェット生成時に `state=` と色スタイル（例 `**STYLE_PRIMARY`）を決め打ちし、実際の有効/無効に応じた色分岐は別の更新関数（例 `_update_create_button_state()`）に切り出す設計だと、**その更新関数を起動直後に一度も呼んでいない**限り初期表示は決め打ち色のまま残る。ユーザー報告「非活性ボタンの色が変わらない」の実体はこれだった。ウィジェット生成の末尾で同じ更新関数を1回呼び、初期表示と状態変化後の色を必ず同じ関数で作る。
- **アンチパターン:** 生成時のスタイル引数と、状態別の色分岐関数を別々に用意して同期を人手に頼る。

**同期COM呼び出し前のボタン色変更は `update_idletasks()` では反映が不安定（`flowchart-excel` 2026-09-16）:** 「読込中」を示すためボタン色を変えてから重い同期処理（Excel COM 読取等）を呼ぶ場合、`widget.update_idletasks()` だけでは実際に画面へ反映される前に処理が始まってしまうことがある。`self.update()`（ウィンドウ全体の pending イベントを処理）を使う方が確実。

**3値以上のボタン状態色は、新規タイマーを足さず既存のポーリングに便乗させて1箇所で計算する（`flowchart-excel` 2026-09-16）:** 「未検出=白 / 検出済み=青 / プレビュー中=緑」のような3値以上の状態色を実装するとき、クリック時だけ一瞬色を変える方式（`configure` → `update()` → 処理 → `configure` で戻す）は、処理が一瞬で終わると人間の目には変化が見えず「変わっていない」という報告になる。この用途では、**既に1秒間隔で外部状態（Excelの選択内容）をポーリングしている関数**（例 `_refresh_status_line`）の中で状態を判定し、そのまま色も確定させる方が確実（新しい状態変数・タイマーを増やさない）。判定に使う値は、ステータス表示に既に使っている値（例: タイトル検出結果）を再利用でき、二重に判定ロジックを持たずに済む。
- **アンチパターン:** ボタン色の切り替えを「クリックイベントの前後で一瞬変える」方式だけで実装し、常時変化する外部状態（Excel選択・ライブ監視対象の有無等）との整合を取らない。

**フォント統一（CTk）:** CTk 既定の `Roboto` は日本語グリフを持たず、Tk が **文字ごとに system フォントへ fallback** するため、日本語混在 UI が「フォントバラバラ」に見える（`toolkit` で発覚。ラベル・ボタン・見出しで別々の和文フォントに落ちる）。`app/ui/theme.py` を 1 ファミリ SSOT にし、`apply_theme()` で `ctk.ThemeManager.theme["CTkFont"]["family"]` を **Latin+日本語を 1 面で賄うフォント**へ上書きする（明示 `font=` 未指定の widget も揃う）。サイズ・太さ違いは `font_title()` / `font_body()` / `font_small()` の factory 経由にし、`ctk.CTkFont(size=...)` を各 widget へ直書きしない。`apply_theme()` は `ctk.CTk.__init__` 呼び出し前（widget 生成前）に呼ぶ — 個別の `set_appearance_mode` / `set_default_color_theme` 直書きは `theme.py` に一本化し呼び出し側へ残さない。
**フォントファミリ:** `BIZ UDPゴシック`（モリサワ製ユニバーサルデザインフォント。Windows 10 October 2018 Update 以降 標準搭載・プロポーショナル版）。似た形の数字・かな濁点半濁点を判別しやすい UD 設計で、小サイズ UI の視認性を優先し採用（2026-09-10 · Web 調査で `Yu Gothic UI` 比較のうえ乗り換え）。固定ピッチ版 `BIZ UDゴシック` は表形式など桁揃えが要る場面用で UI 既定には使わない。旧 `Yu Gothic UI`（Windows 既定 UI フォント）も許容候補ではあるが、新規/横展開は `BIZ UDPゴシック` を既定とする。
**適用対象:** `toolkit` · `bmp-resizer` · `excel-kana-toggle` · `excel-shape-arranger` · `figure-renumberer` · `term-consistency-checker` · `word-kana-toggle`（2026-09-09 全 7 リポへ `theme.py` 横展開 · 2026-09-10 `BIZ UDPゴシック` へ乗り換え）· `skill-doc-viewer`（2026-09-10 新設。`theme.py` を CTk と tkinterweb の CSS 両方の SSOT にし `dynamic_css()` で `<style>` 注入）。**新規ツール:** `creating-personal-tool-yk` の雛形で最初から `theme.py` を持つ。

---

## 5. StayOnTop（COM ツールのウィンドウを前面に保つ · 2026-09-08）

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

---

## 6. プラグイン集約（複数ツールを 1 窓に · 実例 `toolkit`）

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

---

## 7. 静的解析（ruff）

**`pyproject.toml [tool.ruff]` に `select` を書かないと**、ruff 更新（0.16 系）で `I001` / `UP028` / `BLE001` / `SIM117` 等が既定に加わり、**既存コードに新規指摘が出る**（`toolkit` の committed main が 10 件・`word-table-formatter` 新設で `BLE001`）。小型ツールは `select` を明示 pin する（例: `["E", "F", "I", "UP", "B"]`）。pin していないリポに手を入れるときは **変更スコープ内のファイルのみ green** を完了基準とし、無関係な既存指摘は同じ変更で直さない。`main.py` の DPI 設定 `except Exception` は `# noqa: BLE001`（best-effort・起動を止めない）を定型にする。

**`BLE001` の抑制条件（`word-kana-toggle` 2026-09-10）:** ruff 0.16 の `BLE001` は `except Exception` でも **ハンドラが例外をログすれば**（`logger.exception(...)` / `logger.debug(..., exc_info=True)`）指摘しない。素の `logger.debug("msg")`（`exc_info` なし）は指摘が残るので `# noqa: BLE001` が要る。逆に、ログ付きハンドラへ `# noqa: BLE001` を付けると `RUF100`（unused directive）になる。`except (AttributeError, pywintypes.com_error)` のように**具体名で捕まえれば** noqa 不要。

**`flowchart-excel` の `.venv` には ruff が入っていない（2026-09-18）:** `.venv/Scripts/python.exe -m ruff` は `No module named ruff` で失敗する。`requirements.txt`/`pyproject.toml` の開発依存に含まれておらず、実際には作者環境のグローバル Python（`AppData/Local/Packages/...Python313/LocalCache/local-packages/Python313/Scripts/ruff.exe`）を直接叩いて lint している。次回このリポで ruff を使うときは venv 内を探す前にこのパスを確認する（またはプロジェクトの `.venv` へ `pip install ruff` する）。

---

## 8. 新機能追加時の設計判断

**既存パーサーの「空欄→既定値への丸め」を壊さず新機能で区別するには、既存関数を変えず姉妹関数を足す（`flowchart-excel` 2026-09-18）:** `parse_level()` は空欄・不正値を `0` に丸めて返す設計で、描画・レイアウト側の複数箇所とテストがこの丸めに依存していた。新機能（列の自動推測）は「空欄かどうか」を区別する必要があったが、`parse_level()` 自体の戻り値型を `Optional[int]` に変えると依存箇所すべてに `None` 処理を足す羽目になり、変更の影響範囲が新機能の必要以上に広がる。**対策:** 同じ入力を受け取り空欄/不正値を `None` で返す**姉妹関数**（例 `parse_level_optional()`）を追加し、既存関数・既存の呼び出し元は一切変更しない。新機能だけが新しい関数を使う。
- **アンチパターン:** 「型をより正確にする」という理由だけで、多くの既存呼び出し元が依存する共有パーサーの戻り値契約を変更する。

---

## 9. exe / テスト

**exe:** [`PYTHON_PYINSTALLER_GUI.md`](PYTHON_PYINSTALLER_GUI.md)。ファイル名は ASCII、画面タイトルは日本語可。bat は `dist\{Exe}.exe` があればそれを起動する。再ビルド前に起動中 exe を止める。**新設で exe まで作るか**はスキル `creating-personal-tool-yk`（Windows GUI は同一ターンでビルド）。

**テスト:** ドメインは unittest。COM 実機はユーザー担当。
