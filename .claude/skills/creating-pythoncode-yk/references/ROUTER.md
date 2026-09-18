# Python 参照ルーティング（ROUTER）

**SSOT:** 本ファイルが「何をいつ `references/` から読むか」の唯一の正本。  
**要約・MUST:** `yk-skill/rule/40_python/PYTHON_RULES.md` · **手順:** `../SKILL.md`  
**設計パターン（他言語向け）:** `yk-skill/rule/10_meta/PROGRESSIVE_CONTEXT_ROUTING_RULES.md`

**最終更新:** 2026-09-18（5周のサブエージェントレビュー。§2.1「L1 references」を §3 と統合し廃止。§2 強制Standard条件をリテラル一致のみから意味的シグナル（`win32com.client`/`pythoncom`/`.spec` 等）にも拡張し、`c:/yk-application/` 配下でない Excel COM 実装が Light tier をすり抜ける穴を塞いだ。4周目で §4 との整合を取り直し）。旧: 2026-09-09（P14f）

---

## 0. 禁止・原則

- スキル `references/` の **全ファイルを毎回 Read しない**
- `rule/40_python/references/PYTHON_*.md` の **全ファイルを毎回 Read しない**（tag に応じた 1 本のみ · Ref Plan `load`）
- `FASTAPI_*.md`（`40_python/references/`）は **FASTAPI_RULES.md 経路**（本 ROUTER の load 対象にしない）
- `5.Python/0.ルール・操作方法/*rev*.md` を毎回 Read しない（アーカイブ）
- ロード表を `SKILL.md` や `PYTHON_RULES.md` に **複製しない**（リンクのみ）

---

## 1. 手順（毎タスク）

1. `PYTHON_RULES.md` → `SKILL.md` を読む
2. 本 ROUTER で **tier** と **tags** を決める
3. **Ref Plan** をチャットに出力（`SKILL.md` Step 0.1 — **Light は短形式**）
4. Ref Plan の `load` に列挙したファイル **だけ** Read してから実装
5. 完了報告に **読んだ refs** を1行以上書く（Light は §8 簡略）

---

## 2. Tier — floor（最低限読むセット）

| tier | いつ | floor（このセットを必ず Read） |
|------|------|--------------------------------|
| **Light** | 1〜2ファイル・コメント/typo/局所1点 | `ssot-audit.md` |
| **Standard** | 機能追加・改善・3ファイル以上・I/O/バリデーション変更 | `ssot-audit.md` · `Python_1_開発規律.md` · `Python_2_技術ナレッジベース_03_監査・地雷回避.md` |
| **Full** | 新規プロジェクト・リリース・exe配布・仕様書新設 | Standard floor + `exemplar.md` |

**tier が曖昧なとき:** 迷ったら **Standard**（Light の過小評価を避ける）。ユーザーが「1行修正」「typo のみ」と明示したときだけ Light。

**Light でも KB03 を足す条件（いずれか）:**
- 例外処理・バリデーション・入力境界を変更
- 複数モジュールにまたがる
- ユーザーが「品質ゲート厳守」を明示

**強制（Light 禁止 · Standard 以上）:** 対象パスが `c:/yk-application/`、またはシグナルが `GetActiveObject` / `StayOnTop` / `build_exe` / `ToolPlugin` のとき。**このリテラル一致は例であって網羅ではない** — `win32com.client` / `pythoncom` の import・`GetActiveObject`/`Dispatch` 呼び出しなど **Office COM 操作と判断できる兆候があれば、パスが `c:/yk-application/` 配下でなくても同じ扱い**（Light 禁止・`yk_desktop` 必須）にする。**注意:** `customtkinter`/`tkinter` の GUI 単体（COM 操作を伴わない）はこの強制の対象外 — §4 のとおり `gui` タグのみでよい。`c:/yk-application/` 配下の GUI（COM の有無を問わない）は引き続き強制対象。tag に **`yk_desktop` を必ず付ける**（任意にしない）。exe を変えるなら **`exe` も**。（2026-09-18 4周目: §4 のシグナル表と表現を揃え、tkinter 単体を誤って強制対象に含めていた3周目の不整合を是正）

**優先順位（強制 vs 「typo 明示」Light 例外）:** 強制条件（対象パス／シグナル）は「tier が曖昧なとき」の `typo` 明示 Light 例外より**常に優先**する。対象パスが `c:/yk-application/` 配下、またはシグナルに該当する変更は、ユーザーが「typo だけ直して」と明示していても Standard 以上・`yk_desktop` 必須とする（tag 判定と floor Read は必須。実装の手を広げるかは別途ユーザーに確認してよい）。

L1 パターン（openpyxl / yk-application GUI / exe・埋め込みWebView）の tag 別 floor は **§3 に統合済み**（`yk_openpyxl` / `yk_desktop` / `yk_webview` / `exe` / `excel` 行）。

---

## 3. Tag — floor に加算（OR）

**正本パス（`PYTHON_*.md` 系）:** `c:/yk-skill/rule/40_python/references/`（フルパスは §8）。**複数 tag は該当する reference を重複なく Ref Plan `load` に列挙する。**

| tag | 追加で Read |
|-----|-------------|
| `new_project` | `ファイル構成について.md` · `Python_9_設計墓場・廃止規律記録.md` · テンプレ 3〜8（`Python_3`〜`Python_8`）· KB `02` · `04` |
| `excel` | KB `02_共通品質` · `06_Excel連携` · `PYTHON_OPENPYXL_DATA.md` |
| `gui` | KB `02` · `04`（K-003 DPI 等） |
| `streamlit` | KB `07_Streamlit` · （UI/通知なら KB `02` も） |
| `external` | KB `05_外部連携` |
| `exe` | KB `04_環境・配布` · `memo_操作方法.md` · `PYTHON_PYINSTALLER_GUI.md` |
| `deadline` | `deadline-protocol.md` |
| `skill_update` | `yk-skill/rule/10_meta/SKILL_AUTHORING_RULES.md` · `principles.md` · `ssot-audit.md` |
| `yk_openpyxl` | `PYTHON_OPENPYXL_DATA.md` |
| `yk_desktop` | `PYTHON_YK_DESKTOP.md` |
| `yk_webview` | `PYTHON_PYINSTALLER_GUI.md`（Ref Plan にはファイル単位で `load` する。`yk_webview` タグで特に関係が深いのは冒頭目次の tkwebview2 関連3見出しだが、他見出しも同一ファイル内にあるため同時に目に入る） |

**Full tier:** 上記 tag に加え、該当テンプレ・`count_stats.py`（物理計量する場合）を Read。

---

## 4. コードシグナル → tag 推定

対象ファイル・import・ユーザー指示から tag を推定する（複数可）。

| シグナル | tag |
|----------|-----|
| `openpyxl`, `data_only`, `shift_jis`, `cp932` | `yk_openpyxl`（+ `excel`） |
| `xlsx`, `xlwings`, Excel 操作 | `excel` |
| `customtkinter`, `tkinter`, GUI ウィンドウ | `gui`（Excel 併用なら `excel` も） |
| `yk-application` 内の `customtkinter` | `gui` + `yk_desktop` |
| `GetActiveObject`, `StayOnTop`, `ToolPlugin`, `c:/yk-application/`, `win32com.client`, `pythoncom`, `.spec` ファイル | `yk_desktop` |
| `tkwebview2`, `pywebview` 埋め込み | `yk_webview` |
| `streamlit`, `st.`, Plotly in Streamlit | `streamlit` |
| `httpx`, `requests`, スクレイピング, SQLite 外部 | `external` |
| `PyInstaller`, `build_exe`, `.spec`, 配布 | `exe` |
| 新規 `MZ` プロジェクト・仕様書なし | `new_project` |
| 納期・締切・期限の記述 | `deadline` |

---

## 5. K-ID 指定時

本ファイル **§5 の表** または `Python_2_技術ナレッジベース_01_目次.md` でファイルを特定し、**該当 KB 1ファイル** を追加。目次全文の常時 Read は不要。

| ID 帯 | ファイル |
|-------|----------|
| K-001, K-002, K-003, K-015〜K-019, K-050, K-051, K-056-1, K-057, K-058, K-059 | `04_環境・配布` |
| K-020〜K-022, K-030〜K-032, K-040, K-041, K-052, K-055, K-056 | `02_共通品質` |
| K-010, K-011, K-011-1, K-024, K-053, K-054 | `06_Excel連携` |
| K-012, K-018, K-060, K-061, K-062 | `05_外部連携` |
| K-036〜K-044 | `07_Streamlit` |
| T-070, T-071, T-072 | `03_監査・地雷回避` |
| 棄却設計 | `Python_9_設計墓場・廃止規律記録.md` |

---

## 6. パージ（重複除去）

- 同一 KB を tag と K-ID の両方で指定しても **1回だけ** Read
- Light · tag なし · 境界変更なし → **floor = `ssot-audit.md` のみ**
- Ref Plan の `skip` に「読まないファイルと理由」を必ず1行以上（**Light は省略可**）

---

## 7. Ref Plan テンプレート

### Light（短形式）

```markdown
## Ref Plan
- tier: Light（例: 1ファイルの typo 修正）
- load: ssot-audit.md
```

### Standard / Full（フル形式）

```markdown
## Ref Plan
- tier: Standard（Excel 保存のエッジケース追加）
- tags: excel
- load: ssot-audit.md, Python_1_開発規律.md, Python_2_技術ナレッジベース_03_監査・地雷回避.md, Python_2_技術ナレッジベース_02_共通品質.md, Python_2_技術ナレッジベース_06_Excel連携.md
- skip: テンプレ3-8（新規ではない）, KB07（Streamlit未使用）
- ids: K-010, K-011
```

---

## 8. ファイル短名 → パス

| 短名 | パス（`references/` 起点） |
|------|------------------------------|
| ssot-audit | `ssot-audit.md` |
| exemplar | `exemplar.md` |
| deadline | `deadline-protocol.md` |
| Python_1 | `Python_1_開発規律.md` |
| KB02〜07 | `Python_2_技術ナレッジベース_02_共通品質.md` 等 |
| テンプレ3〜8 | `Python_3_テンプレート_プロジェクト仕様書.md` 〜 `Python_8_テンプレート_clean.py.md` |
| 設計墓場 | `Python_9_設計墓場・廃止規律記録.md` |
| ファイル構成 | `ファイル構成について.md` |
| memo | `memo_操作方法.md` |
| PYTHON_OPENPYXL_DATA | `c:/yk-skill/rule/40_python/references/PYTHON_OPENPYXL_DATA.md` |
| PYTHON_PYINSTALLER_GUI | `c:/yk-skill/rule/40_python/references/PYTHON_PYINSTALLER_GUI.md` |
| PYTHON_YK_DESKTOP | `c:/yk-skill/rule/40_python/references/PYTHON_YK_DESKTOP.md` |
