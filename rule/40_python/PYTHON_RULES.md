# Python 開発ルール
## YK Python ツール開発 — Design & Development Rules v1

**SSOT（本ファイル）:** `yk-skill/rule/40_python/PYTHON_RULES.md`  
**実行手順・ゲート:** スキル `creating-pythoncode-yk`（`.claude/skills/creating-pythoncode-yk/SKILL.md`）  
**詳細ナレッジ・テンプレ全文:** 上記スキルの `references/`  
**人間向けアーカイブ（rev 積層）:** `c:/1.cursor/5.Python/0.ルール・操作方法/`（入口: 同フォルダ `入口.md`）

**5.Python ワークスペース:** `.cursor/rules/python-dev-entry.mdc`（`**.py` 編集時に自動適用）

**ルーティング SSOT:** スキル `references/ROUTER.md`（tier + tag + Ref Plan）  
**他言語向け設計パターン:** [`../10_meta/PROGRESSIVE_CONTEXT_ROUTING_RULES.md`](../10_meta/PROGRESSIVE_CONTEXT_ROUTING_RULES.md)

**最終更新:** 2026-06-28  
**索引:** [`../RULE_INDEX.md`](../RULE_INDEX.md) · スキル執筆は [`../10_meta/SKILL_AUTHORING_RULES.md`](../10_meta/SKILL_AUTHORING_RULES.md)

---

## 0. エージェント向け — いつ何を読むか

| 段階 | 読むもの | タイミング |
|------|----------|------------|
| L1 | **本ファイル** `PYTHON_RULES.md` | 毎回・最初 |
| L2 | `creating-pythoncode-yk/SKILL.md` | スキル発火 or `.py` 作業時 |
| L2.5 | **Ref Plan**（チャット出力） | **コード編集前・必須**（Light は短形式 · 質問のみは不要） |
| L3 | `references/` の個別ファイル | **Ref Plan の `load` に列挙したものだけ** |

**禁止:** rev 付きアーカイブの全件 Read · `references/` の全件 Read。

**手順:** `ROUTER.md` で tier（Light/Standard/Full）と tag を決める → Ref Plan を出す → 列挙ファイルのみ Read。

---

## 1. 四大精神（要約）

1. **積層的必然** — 各 Step の成果物をその Step の完成形として扱い、後工程で手戻りしない。
2. **仕様先行** — プロジェクト仕様書を唯一の正解とし、コードは論理の鏡にする。
3. **論理的生存・データ完全性** — 欠損・サイレント失敗・ゴースト行を許さない（Excel・バリデーションは KB 参照）。
4. **工数削減・環境浄化** — `TODO:` / 一時ファイル / 重複定義を残さない。

---

## 2. アーキテクチャ — MUST

| 項目 | 規則 |
|------|------|
| 依存方向 | **UI → Schemas ← Core**（循環参照禁止） |
| ファイルサイズ | `app/` 内 1 ファイル **500 行以内**（超える前に分割） |
| 環境 | **uv** + `pyproject.toml` + `uv.lock` + `.python-version` |
| 静的解析 | **Ruff**（`ruff check --fix`）+ **mypy**（`uv run mypy`）をリリース前に実行 |
| エントリ | `main.py` 先頭で **インポート・ハイジーン [K-002]**（`sys.path` 聖域化） |
| パス | `sys.frozen` 判定で exe 内外を分離 **[K-001]** |
| 機密 | `.env` + `.gitignore` で秘匿 **[K-016]** — 横断: [`../10_meta/SECRETS_HYGIENE_RULES.md`](../10_meta/SECRETS_HYGIENE_RULES.md) |

起動例: `uv run python main.py`

---

## 3. 標準プロジェクト構成（要約）

```
project_root/
├── 仕様・管理/          # 仕様書・ADR・テスト定義書
├── pyproject.toml
├── uv.lock
├── main.py
├── clean.py
├── app/
│   ├── constants.py
│   ├── core/
│   ├── ui/
│   └── schemas/       # Pydantic 等
├── assets/  logs/  output/  temp/
└── プロジェクト名.code-workspace
```

詳細ツリー → スキル `references/ファイル構成について.md`

---

## 4. SDD 開発フロー（Spec-Driven Development）

| Step | 内容 |
|------|------|
| 0 | 本ルール + SKILL + **ROUTER.md** |
| 0.1 | **Ref Plan** 出力（未出力なら実装しない） |
| 0.5 | 納期があれば **1 箇所に固定**（tag `deadline`） |
| 1 | 目的・対象・制約・成功条件を短文で固定 |
| 2 | 最小差分方針。破壊的 I/O 変更の要否を判断 |
| 3 | 実装（新規: 骨格→最短経路→境界。修正: 再現→原因→最小修正） |
| 4 | 品質ゲート（チェックリスト → `references/` または下記 §7） |
| 5 | SSoT 監査（定数・仕様の二重定義がないか） |
| 6 | 完了報告（§8 の tier に従う） |

---

## 5. 思考の三層監査（全工程で実施）

- **抽出:** 今回の制約・参照ファイルを箇条書きで固定
- **写経:** 変更ごとに「どの規律・KB ID に基づくか」を自問
- **検挙:** 完了前に「破っていないか」を逆方向チェック（`TODO:`、SSoT 重複、手順スキップ）

---

## 6. 参照ルーティング

**SSOT（何をいつ Read するか）:** スキル `creating-pythoncode-yk/references/ROUTER.md` のみ。  
tier / tag / K-ID / Ref Plan テンプレ・パージ規則は **ROUTER に書かない**（本節へ複製しない）。

| やること | 参照 |
|----------|------|
| tier・tag を決める | ROUTER §2〜§4 |
| K-ID から KB を足す | ROUTER §5 |
| 実装前に Ref Plan を出す | Light → ROUTER §7 短形式 · Standard 以上 → §7 フル形式 · SKILL Step 0.1 |
| 読み過ぎを防ぐ | ROUTER §6（パージ） |
| **FastAPI · REST API · UploadFile** | [`FASTAPI_RULES.md`](FASTAPI_RULES.md)（No 42）— 本ファイルの uv/Ruff/SDD は **そのまま適用** |

**目次（KB 全体像が必要なときだけ）:** `references/Python_2_技術ナレッジベース_01_目次.md`

---

## 7. 品質ゲート（最小チェックリスト）

完了前に確認する（詳細は `references/ssot-audit.md` · `exemplar.md`）。

**Git hook / CI（`flowchart-studio` 等）:** Ruff · pre-commit の機械ゲートと hook 失敗時のエージェント行動 → [`../60_tooling/QUALITY_GATE_RULES.md`](../60_tooling/QUALITY_GATE_RULES.md) §4 · §5。本 §7 は **設計・監査の人手チェックリスト**。

- [ ] 仕様・定数・マジックナンバーが **1 箇所（SSoT）** にある
- [ ] UI / Core / Schemas の依存方向を破っていない
- [ ] `TODO:` / `FIXME:` を残していない（意図的なら理由をコメント）
- [ ] 既存の公開 I/O を不用意に変更していない
- [ ] Ruff / mypy を実行した（または実行不要な理由を明記）
- [ ] 設計墓場と矛盾する案を採用していない

---

## 8. 完了報告（tier）

| tier | いつ | 末尾に含めるもの |
|------|------|------------------|
| **Light** | 1〜2 ファイルの小修正 | **変更概要** · **読んだ refs**（三層監査は実施するが報告文には書かない） |
| **Standard** | 通常の機能追加・改善 | 変更概要 · 三層監査 · ネガティブ監査 · 影響範囲 · SSoT 確認 · 検証コマンド · **読んだ refs** |
| **Full** | 新規プロジェクト・リリース・配布 | Standard 項目 + 物理的計量 · 環境浄化 · ディレクトリツリー · **読んだ refs** |

儀式的な長文は **Full のときのみ** 必須。

---

## 9. Git・リビジョン運用

**横断方針（SSOT）:** [`../10_meta/GIT_WORKFLOW_RULES.md`](../10_meta/GIT_WORKFLOW_RULES.md) — commit / push / メッセージ / 禁止操作

| 対象 | 方針 |
|------|------|
| **yk-skill（本ルール・スキル）** | 履歴は **Git が SSoT**。`rule/` とスキルは通常ファイル名で更新 |
| **5.Python/0.ルール・操作方法** | **rev 積層**（ワークスペース `revision-protection`）。既存 rev ファイルの上書き禁止 |

---

## 10. テンプレート（新規時のみ）

| 成果物 | references |
|--------|------------|
| プロジェクト仕様書 | `Python_3_テンプレート_プロジェクト仕様書.md` |
| ADR | `Python_4_テンプレート_意思決定記録(ADR).md` |
| テスト定義書 | `Python_5_テンプレート_テスト定義書.md` |
| main.py | `Python_6_テンプレート_main.py.md` |
| pyproject.toml | `Python_7_テンプレート_pyproject.toml.md` |
| clean.py | `Python_8_テンプレート_clean.py.md` |

---

## 11. 変更時のルール

- ロード規則を変えるときは **`references/ROUTER.md` のみ**更新する（本ファイル §6 に表を戻さない）。
- 詳細ナレッジは **`references/` に追記**し、ROUTER の tag / ID 表に1行足す。
- `5.Python/0.ルール・操作方法` の rev ファイルは、ユーザー明示時以外 AI が編集しない。
- 他言語スキルを新設するときは [`../10_meta/PROGRESSIVE_CONTEXT_ROUTING_RULES.md`](../10_meta/PROGRESSIVE_CONTEXT_ROUTING_RULES.md) に従う。

---

## 12. YK パターン補足（openpyxl / データ処理）

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

---

## 13. YK パターン補足（PyInstaller · GUI exe）

`flowchart-studio` の `FlowchartStudio-ExcelConverter.exe` · `flowchart-excel` の `FlowchartExcel.exe` 実装で確定したパターン。詳細手順は各リポの `docs/03_技術仕様/装置Excel変換exe.md` · `npm run excel:converter:verify` · **`npm run excel:converter:release`**（版 bump 済み commit 上で verify → タグ → GitHub Release）· `flowchart-excel/build_exe.py`。

### relative import を `__main__.py` に書かない（凍結 exe で ImportError）

PyInstaller の `--windowed` onefile では、Analysis 入口を `package/__main__.py` にすると **`from .module import …` が「no known parent package」で落ちる**。

- **対策:** ロジックは `runner.py` 等に置き **absolute import のみ**（`from pkg.runner import main`）。PyInstaller 入口は `packaging/*_entry.py`（`excel_converter_gui.__main__` を import しない）。
- **アンチパターン:** `hiddenimports` だけ増やして `__main__.py` の relative import を残す。

### ビルド前に実行中 exe を止める

Windows では dist の exe が起動中だと PyInstaller が `PermissionError: WinError 5` で上書き失敗する（GUI 起動確認 · 作者の手元 exe · エージェントの `Start-Process` テスト）。

- **対策:** 再ビルド前に `taskkill /IM Foo.exe /F` 相当。リポでは `python/scripts/build_and_verify_converter.py` が自動実行。
- **アンチパターン:** ビルド失敗を「PyInstaller の不具合」と決めつける。

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
| **製品約束** | 「常時 OS 最前面」を絶対約束にしない。ゴールは **Excel 操作中もプレビュー作業が継続できる**こと |

- **アンチパターン:** pywebview を tk Frame に直接載せる · 同一プロセス化だけして COM を複数経路から叩く · UI 仕様で常時最前面を必須化する · **pywebview 6.x を tkwebview2 と無確認で混在**

### tkwebview2 + pywebview 版固定（flowchart-excel 1窓 · 2026-07）

`tkwebview2` 3.5.0 は pywebview 旧 API（`EdgeChrome.web_view.web_view`）前提。**pywebview 5+/6+ は `EdgeChrome.webview`** のため、6.x 混在で起動直後に `AttributeError` → exe が即終了する。

| やる | やらない |
|------|----------|
| `requirements.txt` で **`pywebview>=5,<6`**（または upstream 追随まで compat 維持） | `pip install pywebview` で 6.x を無条件に上げる |
| 起動前に **`_ensure_tkwebview2_compat()`** — `WebView2.__init__` を差し替え `self.web = edge.webview` | tkwebview2 素の `WebView2(...)` だけに任せる |
| **STA スレッド**で tk mainloop（`main.py` 参照） | MTA スレッドから tkwebview2 初期化 |
| PyInstaller: **`--collect-all=tkwebview2`** + webview 同梱（§下記） | webview のみ同梱して tkwebview2 を漏らす |
| 埋め込み init 失敗時は **子 widget を destroy して 2窓 UI にフォールバック** | 失敗後に同一親へ `pack` 済み領域へ `grid` でエラー表示 |

- **切り分け:** `dist/logs/app.log` の `embedded_preview_init_failed` · venv の `python main.py` は可で exe のみ不可 → 同梱漏れまたは pywebview 版不一致
- **詳細 POC:** `yk-application/flowchart-excel/docs/03_技術仕様/POC_ルートA_結果_2026-07-27.md`

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

---

## 14. 変更履歴（L1）

| 日付 | 内容 |
|------|------|
| 2026-07-27 | §13 tkwebview2 + pywebview 版固定 · 1窓 compat · PyInstaller tkwebview2 同梱（flowchart-excel rev007） |
| 2026-07-27 | §13 PyInstaller — venv 経由必須 · delayed webview 同梱漏れ（flowchart-excel プレビュー） |
| 2026-07-27 | §13 flowchart-excel — 隣接 studio の npm install · setup 脚本の cp932/✓ 回避 |
| 2026-07-26 | §13 Tk/CTk + pywebview · Excel COM · 真の1窓（flowchart-excel 事前調査） |
| 2026-06-28 | §13 v0.3 フロー表↔モジュール — MID 見出し行 · ListObject 名非使用（excel_normalize） |
| 2026-06-28 | §13 PyInstaller · GUI exe パターン追記（flowchart-studio 変換 exe） |
| 2026-07-01 | §12 プレースホルダー行 sentinel 終端判定 · 外部ツール向け Shift-JIS 出力パターン追記（comment-studio） |
