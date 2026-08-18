# Git 追跡 — リポ別パターン · gitignore 雛形

**SSOT（方針）:** [`../GIT_TRACKING_RULES.md`](../GIT_TRACKING_RULES.md)  
**横断 denylist 雛形:** `c:/yk-tool/.gitignore`（新規リポはここをベースにコピー）  
**外部参照:** [Git 公式 — gitignore](https://git-scm.com/docs/gitignore) · [github/gitignore](https://github.com/github/gitignore)

**最終更新:** 2026-08-18

---

## 1. リポ種別ごとの表

| リポ種別 | Track | Don't track | Notes |
|----------|-------|-------------|-------|
| **yk-memo** | `handoffs/**` · 企画/講座 MD · **`04.文章/**`** · `99.テンプレート/` | `output/*` · `.claude/` | 確定稿は **常時 track**（`writing-in-my-voice-yk` の Read SSOT）。AI 下書きは置かない |
| **yk-skill** | `rule/` · `.claude/skills/**` · `metadata/surge-published-list.md` | 各スキル `output/` · `_out/` · FB `.env*` / トークン / `node_modules` | 公開 HTML 正本は `yk-tool/publish/` |
| **yk-tool** | `catalog.yaml` · `scripts/` · **`publish/**`** · 各ツール `package.json` | `node_modules/` · `.env*` · `*.log` · `tmp/` | publish 大量 HTML は将来 LFS 検討 |
| **flowchart-studio** | ソース · `docs/` · **`data/**/import.json`** · テスト fixture xlsx | **`data/**/*.xlsx`** · `.env*` · `.next/` · Python `build/` `dist/` | 作者 Excel = ローカル。共有 = import.json |
| **flowchart-excel** | ソース · README/spec | `logs/` · `output/` · `temp/` · `dist/` · `.venv/` | `.gitkeep` 推奨（§3） |
| **MZ0000_FlowchartTool** | ソース · **`logs/.gitkeep`** | **`logs/*.log`** · `__pycache__/` · `.env` | `logs/app.log` が Modified = 既追跡残存の信号 |

**Git リポ外:** `yk-local` — フル PII · Excel 原本 · トークン（各 `_index` から参照のみ）。

---

## 2. `.env.example` パターン

```gitignore
.env
.env.*
!.env.example
```

| 項目 | 方針 |
|------|------|
| **中身** | 変数名 + 説明 + **ダミー値のみ**（`change-me` 等） |
| **禁止** | 本番キー形状 · 接続 URI 全文 · 実メール |
| **レイヤ** | Next（`.env.local`）と Python（`python/.env`）は example を分ける |
| **運用** | 新規 secret 追加時は **example を同 PR で更新** |

参照実装: `flowchart-studio/python/.env.example` · `yk-tool/.gitignore` § env。

---

## 3. `.gitkeep` パターン

**推奨（Python デスクトップ — logs / output）**

```gitignore
logs/*
!logs/.gitkeep
output/*
!output/.gitkeep
```

| パターン | 用途 |
|----------|------|
| **`dir/*` + `!dir/.gitkeep`** | 実行時にファイルが増える dir（flowchart-excel 型） |
| **`dir/*.log` + `dir/.gitkeep`** | 拡張子固定の生成物（MZ0000 型） |
| **dir 内 `.gitignore` で `*` + `!.gitignore`** | 人間の一時退避のみ（yk-memo `output/` 型） |

---

## 4. 新規 Python デスクトップの最小 `.gitignore`

`yk-tool/.gitignore` から最低限コピー:

```gitignore
__pycache__/
*.py[cod]
.venv/
venv/
.env
.env.*
!.env.example
logs/*
!logs/.gitkeep
output/*
!output/.gitkeep
dist/
build/
*.log
~$*
```

---

## 5. 監査コマンド（調査時 · Shell 禁止ルールの例外はユーザー明示 test/commit 時）

既追跡の生成物を洗い出す:

```powershell
git ls-files logs/ output/ temp/ dist/ __pycache__ .env
```

1 件でもヒットしたら [`GIT_TRACKING_RULES.md`](../GIT_TRACKING_RULES.md) §4 で `--cached` 解除を検討。

---

## 6. 既知の差分メモ（2026-08-18）

| リポ | 状態 | 推奨アクション |
|------|------|----------------|
| **MZ0000_FlowchartTool** | `logs/*.log` ignore 済み · **`__pycache__/*.pyc` が index 残存** | `git rm --cached -r __pycache__` + `.gitignore` に Python 節追加 |
| **flowchart-excel** | `logs/` · `output/` ignore 済み · `.gitkeep` 未配置 | `logs/.gitkeep` · `output/.gitkeep` 追加 |
| **yk-tool/publish/** | 現状 track | 件数増加時に LFS / 部分 ignore を HANDOFF で再判断 |
