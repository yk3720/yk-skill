# Git 追跡対象規則
## 横断 Git SSOT — 何を追跡するか（いつ commit するかは別 rule）

**用途:** 全 YK リポジトリ共通の **追跡対象**（track / not track）· `.gitignore` · 誤コミット解除。  
**関連:** [`GIT_WORKFLOW_RULES.md`](GIT_WORKFLOW_RULES.md)（**いつ** commit / push するか）· [`SECRETS_HYGIENE_RULES.md`](SECRETS_HYGIENE_RULES.md)（**秘密**の扱い）· [`QUALITY_GATE_RULES.md`](../60_tooling/QUALITY_GATE_RULES.md)（`detect-private-key` は補助）  
**詳細:** リポ種別 · gitignore 雛形 → [`references/GIT_TRACKING_PATTERNS.md`](references/GIT_TRACKING_PATTERNS.md)

**最終更新:** 2026-08-18

---

## 原則

Git に載せるのは **「第三者が clone したあと、README の手順どおりに依存を入れ・ビルド/起動・テストまで到達できる最小セット」** に限る。

| 区分 | 方針 |
|------|------|
| **track** | ソース · ロックファイル · 非秘密の設定テンプレ · 再現手順（docs/scripts）· 開発用フィクスチャ |
| **not track** | 実行時に再生成されるもの（`__pycache__` · ログ · `node_modules` · ビルド成果物 · 作者 xlsx · 秘密） |
| **`.gitignore`** | リポジトリごとに **commit** する。横断 denylist の雛形は `yk-tool/.gitignore` |
| **既追跡の生成物** | `.gitignore` 追加だけでは止まらない → §4 の `--cached` 解除 |

**役割分担:** 秘密 → `SECRETS_HYGIENE` · commit タイミング → `GIT_WORKFLOW` · **本ファイル = 再現性の補完**。

---

## ⚡ エージェント必読チェックリスト

新規ファイル追加 · `.gitignore` 変更 · コミット前。

- [ ] ステージに **生成物**（`__pycache__` · `*.log` · `.next/` · `dist/`）が混ざっていない
- [ ] **秘密**（`.env` · session · トークン）は `SECRETS_HYGIENE` チェックリスト済み
- [ ] **作者 xlsx** を flowchart 系に載せていない（共有は `import.json`）
- [ ] 空 dir だけ必要なら **`.gitkeep`** を置き、中身は ignore
- [ ] `.gitignore` を追加したが **既に index 済み** のファイルがないか `git status` で確認

---

## 1. 追跡必須（MUST track）

| 種別 | 例 |
|------|-----|
| **ソース** | `app/` · `lib/` · `python/src/` · `main.py` · `route.ts` |
| **依存の固定** | `package-lock.json` · `requirements.txt` · `pyproject.toml` |
| **再現手順** | `README.md` · `AGENTS.md` · `docs/` · 起動 bat / `setup_venv.py` |
| **設定テンプレ（秘密なし）** | `.env.example` · migration / seed SQL |
| **開発フィクスチャ** | `frontend/src/samples/` · `data/**/import.json` · pytest fixture |
| **品質ゲート定義** | `package.json` scripts · Vitest/Playwright spec · `.pre-commit-config.yaml` |
| **`.gitignore` 自体** | チーム共有の除外ルール |

---

## 2. 追跡禁止（MUST NOT track）

| 種別 | 例 | 備考 |
|------|-----|------|
| **Python 実行生成物** | `__pycache__/` · `*.pyc` · `.pytest_cache/` · `.venv/` | MZ0000 事故の典型 |
| **ランタイムログ** | `logs/` · `*.log` | `logs/.gitkeep` のみ可 |
| **依存ツリー・ビルド** | `node_modules/` · `.next/` · `dist/` · `build/` · PyInstaller exe |
| **秘密・セッション** | `.env*` · `credentials.json` · `auth/session.json` | → `SECRETS_HYGIENE` |
| **作者 Excel 正本** | `data/**/*.xlsx` · `~$*` | 共有は `import.json` |
| **E2E 成果物** | `test-results/` · `playwright-report/` · `coverage/` |
| **作業用 AI 生成物** | 各スキル `output/` · Mermaid `_out/` | 正本は `yk-tool/publish/` 等 |

**denylist は全 yk-application リポで同一に近づける。** リポごとの差が漏洩経路になる。

---

## 3. グレー域（推奨）

| 項目 | 推奨 |
|------|------|
| **Lock ファイル** | **commit** — `package-lock.json` · 将来 `uv.lock` も |
| **作者 xlsx vs import.json** | xlsx = Git 外 · **import.json + 再生成スクリプト = commit** |
| **配布 exe** | GitHub Release 等。**リポにはビルド手順のみ** |
| **Mermaid 生成 SVG** | **not track** — 正本は `.mmd` |
| **`.vscode/`** | チーム合意があるものだけ（`yk-tool` は `extensions.json` / `settings.json` を明示許可） |
| **`yk-tool/publish/**`** | **現状 track**。件数増加時に LFS / 部分 ignore を再判断 |

---

## 4. `.gitignore` と既追跡ファイルの解除

| 操作 | 方針 |
|------|------|
| **新規 ignore** | リポ root の `.gitignore` に追記し **commit** |
| **既に index 済み** | `git rm --cached -r -- path` → `.gitignore` 追記 → commit（ユーザー明示時） |
| **履歴に秘密・パスが残った** | `--cached` だけでは不十分 → `git filter-repo` 等 + キーローテーション（`SECRETS_HYGIENE`） |

**PowerShell 例（1 行）:**

```powershell
git rm --cached -r -- path/to/file_or_dir; Add-Content .gitignore 'path/to/file_or_dir'
```

**`.gitkeep` パターン:** 実行時にファイルが増える dir → `dir/*` + `!dir/.gitkeep`。詳細は [`references/GIT_TRACKING_PATTERNS.md`](references/GIT_TRACKING_PATTERNS.md) §3。

---

## 5. リポジトリ別（概要）

| リポ | track の要点 | not track の要点 |
|------|--------------|------------------|
| **yk-memo** | `handoffs/` · **`04.文章/`**（確定稿 + `特徴.md`）· テンプレ | `output/*` · `.claude/` |
| **yk-skill** | `rule/` · スキル本体 · `metadata/` | スキル `output/` · `_out/` · FB の `.env` |
| **yk-tool** | `publish/` · `catalog.yaml` · `scripts/` | `node_modules/` · `.env*` · `*.log` |
| **flowchart-studio** | ソース · `docs/` · **`import.json`** | 作者 xlsx · `.next/` · `.env*` |
| **Python デスクトップ** | ソース · `logs/.gitkeep` | `logs/*` · `output/` · `dist/` · `__pycache__/` |

**Git 外（第5の枠）:** `yk-local` — フル PII · Excel 原本 · トークン。

詳細表 · gitignore 雛形 → [`references/GIT_TRACKING_PATTERNS.md`](references/GIT_TRACKING_PATTERNS.md)。

---

## 6. 機械チェックとの関係

| 手段 | カバー範囲 |
|------|------------|
| **`detect-private-key`（pre-commit）** | PEM/SSH 鍊形式のみ。**`.env` · ログ · session は止まらない** |
| **`.gitignore`** | 生成物・秘密ファイルの **主防御** |
| **Push Protection** | 既知 secret パターン（GitHub） |

`SECRETS_HYGIENE` チェックリスト ≠ pre-commit カバレッジ。両方必要。

---

## 7. 関連 rule（ドメイン補足）

| 領域 | SSOT |
|------|------|
| Python `.env` · venv | `40_python/PYTHON_RULES.md` §2 |
| 作者 xlsx · import.json | `35_reactflow/REACTFLOW_RULES.md` · `Excel取込.md`（flowchart-studio） |
| Playwright session | `50_gas_html_test/PLAYWRIGHT_RULES.md` §5 |
| 新規 yk-application | `15_project_mgmt/YK_APPLICATION_RULES.md` §5-2（`.env.example` 必置） |

矛盾時は `RULE_INDEX.md` Governance に従う。
