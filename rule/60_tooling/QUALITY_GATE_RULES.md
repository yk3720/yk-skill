# 品質ゲート（YK 横断）

**目的:** 編集時・コミット時・CI/デプロイ時の3層で、人間・AI 双方の変更を機械的に検証する。  
**関連:** `AGENT_SHELL_RULES.md` · `GIT_WORKFLOW_RULES.md` · `PLAYWRIGHT_RULES.md` · `PYTHON_RULES.md` · `REACTFLOW_RULES.md` §6 · `SECRETS_HYGIENE_RULES.md` · `WORKSPACE_SCRIPTS_RULES.md`

**索引:** [`../RULE_INDEX.md`](../RULE_INDEX.md) No **63** · L0: `quality-gates-yk.mdc`

**最終更新:** 2026-06-25（Defender 除外 `\.cache\pre-commit` · pre-commit ブロック対処）

---

## 1. 3層ゲート（混同禁止）

| 層 | 正体 | 例 |
|----|------|-----|
| **編集時** | `.vscode/settings.json`（format on save） | Prettier / ESLint fix / Ruff |
| **コミット時** | Git hooks（husky + lint-staged / pre-commit） | ステージファイルの lint・format・秘密検出 |
| **CI / デプロイ** | GitHub Actions · Vercel build | typecheck · test · build |
| **リモート（人間設定）** | GitHub Push Protection | push 前の秘密ブロック（`--no-verify` 回避策） |

**任意の第4層:** Cursor Agent Hooks（`.cursor/hooks.json`）— format on save とは別物。未導入時は §8 参照。

---

## 2. 対象リポジトリ

| パス | フック |
|------|--------|
| `yk-application/flowchart-studio` | **要**（Web + Python 混在） |
| `yk-memo` | **任意** — staged `.md` ローカルリンク（`yk-tool/scripts/check-markdown-links-staged.ps1` · `.githooks/pre-commit`）· Cursor `afterFileEdit`（同上 staged 版の姉妹） |
| `yk-skill` | 不要（MD/ルール中心） |
| その他 `yk-tool/*` | `package.json` / `pyproject.toml` の有無で個別判断 |

---

## 3. Web（flowchart-studio）

### ツール

- ESLint 9 flat config + `eslint-config-prettier`
- Prettier
- husky v9 + lint-staged
- pre-commit（汎用セキュリティ + Python Ruff）

### scripts（SSOT）

| script | 用途 |
|--------|------|
| `npm run lint` | ESLint 全体 |
| `npm run format:check` | Prettier チェック |
| `npm run typecheck` | `tsc --noEmit` |
| `npm run test` | Vitest |
| `npm run test:e2e` | Playwright（CI では PR 時のみ拡張可） |
| `npm run excel:mypy` | excel_normalize の mypy |

### Git hooks

| hook | 内容 |
|------|------|
| **pre-commit** | ① lint-staged（eslint --fix + prettier）· ② pre-commit 全フック（下表） |
| **pre-push** | typecheck + vitest + excel:test |

#### pre-commit 内の pre-commit フック（`.pre-commit-config.yaml`）

| hook | 目的 | 対象 |
|------|------|------|
| `check-merge-conflict` | `<<<<<<<` 等の未解決マーカーを commit 拒否 | ステージされた `flowchart-studio/**` 全般 |
| `detect-private-key` | SSH / PEM 秘密鍵の誤 commit 拒否 | 同上 |
| `ruff-check` + `ruff-format` | Python lint / format | `python/**` のみ |

**pre-commit に入れない:** `tsc`（遅い）· E2E（遅い）· `mypy`（CI 向け）— `PLAYWRIGHT_RULES` §12 どおり E2E はターン内で実行。

**意図的に入れない:** `commitlint`（`GIT_WORKFLOW_RULES` の日本語・log 準拠と衝突）· SQLFluff（マイグレーション少数のため手動レビュー）· 毎ターン Cursor `stop` hook（遅い）。

### 見え方・エラーと非エラーの区別

| 出力 | 意味 | 対処 |
|------|------|------|
| `LF will be replaced by CRLF`（git add 時） | Windows の改行警告。**エラーではない** | 無視してよい |
| ESLint **warning**（未使用変数等） | commit は通る。**error のみ拒否** | 余裕があれば修正 |
| pre-push で typecheck + test が走る | **正常**（10 秒前後かかる） | 待つ |
| `check for merge conflicts ... Passed` | セキュリティ hook が効いている | — |
| `(no files to check) Skipped`（commit 時） | **異常** — pre-commit がファイルを認識できていない | `.husky/pre-commit` が git ルートから `--config` 付きで実行されているか確認（2026-06-09 修正済） |
| hook 失敗（exit 1）で **上記以外** | commit / push 拒否 | 出力を読み自己修正 · `--no-verify` 禁止 |
| **WinError 4551** または **Windows セキュリティ「pre-commit.exe をブロック」** | `pre-commit` フックランナーが OS により実行不可（Cursor エージェント **および** ローカル端末の両方で起こりうる · コード不備ではない） | 下記 **Windows で pre-commit がブロックされたとき** · 詳細は `committing-with-git-yk/references/commit-shell.md` |

#### Windows で pre-commit がブロックされたとき

| 段階 | 人間（推奨順） | エージェント |
|------|----------------|--------------|
| **1. 恒久対処（Defender 除外）** | **Windows セキュリティ** → ウイルスと脅威の防止 → **設定の管理** → **除外** → **+ 除外の追加** → **フォルダ** → `%USERPROFILE%\.cache\pre-commit`（例: `C:\Users\<user>\.cache\pre-commit` · 隠しフォルダのためアドレス欄に貼り付け可）。追加後 `python -m pre_commit run detect-private-key --all-files` が **Passed** になること | — |
| **2. 恒久対処（未署名 exe）** | ダイアログで **詳細情報** → **実行を許可**（`pre-commit.exe`）。パスは `where.exe pre-commit` で確認（Microsoft Store 版 Python では `...\Python313\Scripts\pre-commit.exe` 等） | — |
| **3. 代替起動** | `python -m pre_commit run --all-files` で個別 hook を確認（`.exe` のみブロックのとき有効 · **Defender 除外が先**） | 同上 |
| **4. 一時回避** | 下表の手動確認後、**当該 hook のみ** `SKIP`（`--no-verify` とは別） | 手動確認 → `SKIP` → `commit -F` |
| **5. 最後** | ユーザー明示時のみ `--no-verify` | 原則禁止 |

**症状の切り分け**

| 症状 | よくある原因 | 先に試す対処 |
|------|--------------|--------------|
| `detect-private-key` のみ WinError 4551 · `check-merge-conflict` は Passed | Defender が hook キャッシュをブロック | **段階 1**（`\.cache\pre-commit` 除外） |
| 「`pre-commit.exe` の発行元を確認できない」ダイアログ | 未署名の pip スクリプト | **段階 2** |
| Cursor エージェントの Shell のみ失敗 | App Control / サンドボックス | ユーザー端末で commit · または **段階 4** `SKIP` |

**SKIP 前の手動確認（hook 別）**

| hook | 手動確認 |
|------|----------|
| `check-merge-conflict` | Grep で `<<<<<<<` / `=======` / `>>>>>>>` がステージに無いこと |
| `detect-private-key` | Grep で `BEGIN OPENSSH PRIVATE KEY` / `BEGIN RSA PRIVATE KEY` 等が無いこと |
| `ruff-check` / `ruff-format` | `ruff check` / `ruff format` を手動実行 |

**PowerShell 例（複数 hook）:**

```powershell
$env:SKIP = 'check-merge-conflict,detect-private-key'
git commit -F .git/COMMIT_EDITMSG_YK.txt
Remove-Item Env:SKIP
```

**記録:** handoff 終了時はセッション MD §2 に「OS が pre-commit をブロック · ローカル commit 要」等を 1 行。


**モノレポ注意（yk-tool 配下の旧配置のみ）:** 過去に `yk-tool/flowchart-studio` だった頃は git ルート相対の pre-commit だった。**現行**は `c:/yk-application/flowchart-studio` が**独立 Git** — ルートで `npm install` · husky · pre-commit を実行する。

### 初期化（新規クローン後）

```powershell
cd c:/yk-application/flowchart-studio
npm install
pip install -e "python[dev]"
```

`pip install` は **Python ファイルだけでなく** `check-merge-conflict` / `detect-private-key` にも必要（flowchart 配下のあらゆる commit で pre-commit が走る）。

---

## 4. Python（python/）

- **Ruff** + **pre-commit**（`ruff-check --fix` → `ruff-format`）
- 設定: `python/pyproject.toml` · `.pre-commit-config.yaml`
- `PYTHON_RULES` 準拠（mypy は hook ではなく CI 拡張候補 · uv 移行は別タスク）

---

## 5. エージェント行動

1. **hook 失敗時:** ターミナル出力を読み、**即座に自己修正して再 commit**。`--no-verify` 禁止。amend は `GIT_WORKFLOW_RULES` / commit スキルどおり。
2. **hook が直せる範囲:** format / lint の auto-fix のみ。型エラー・テスト失敗はコード修正ターンが必要。
3. **commit 時 Shell:** 初回から `required_permissions: ["all"]`（`AGENT_SHELL_RULES`）。
4. **hook 自動修正後:** `git status` で差分確認 · 必要なら再 stage。
5. **UI 変更 + E2E spec 追加:** 同一ターンで `npm run test:e2e`（`PLAYWRIGHT_RULES` §12）。
6. **秘密検出で止まった場合:** 該当行を削除または `.env` 等へ移し、**値をチャットに貼らない**（`SECRETS_HYGIENE_RULES`）。
7. **pre-commit が WinError 4551 / Windows セキュリティでブロック:** §3「Windows で pre-commit がブロックされたとき」· `commit-shell.md` — 手動確認後 `SKIP`（`--no-verify` 不可）。

---

## 6. CI

- **SSOT:** `c:/yk-application/flowchart-studio/.github/workflows/ci.yml`
- **`HUSKY=0`:** CI では Git hook をスキップし、同じ検査をコマンドで直接実行（二重実行防止）
- push/PR で **flowchart-studio リポ**変更時に **2 ジョブ**（`quality` · `Playwright E2E` · 並列）:
  - **quality:** lint · format · typecheck · vitest · ruff · **mypy** · pre-commit（セキュリティ + ruff）· pytest · **`npm run build`**（`AUTH_DISABLED=1`）
  - **e2e:** `npm run build` → **`npm run test:e2e`**（`AUTH_DISABLED=1` · `IMPORT_E2E_STUB=1` · `PLAYWRIGHT_E2E=1`）
- pre-commit は **リポジトリルート**（`flowchart-studio/`）の `.pre-commit-config.yaml`
- Vercel build はデプロイ最終ゲート（CI build は早期検出）

---

## 7. GitHub Push Protection（人間が一度設定）

ローカル hook は `--no-verify` で回避可能なため、**リモート側の防衛線**として Push Protection を有効化する。

1. GitHub リポジトリ → **Settings** → **Code security**
2. **Secret scanning** · **Push protection** を有効化（プラン・組織設定による）
3. 詳細: [Push protection（GitHub Docs）](https://docs.github.com/en/code-security/concepts/secret-security/push-protection)

エージェントは UI 設定を変更しない。未設定の場合はユーザーに有効化を促す。

---

## 8. 将来の拡張（任意・未導入）

| 候補 | 用途 | 導入条件 |
|------|------|----------|
| Cursor `beforeShellExecution` | `git commit --no-verify` 拒否 | AI が hook 回避を試みる場合 |
| `detect-secrets` / Gitleaks | より精度の高い秘密検出 | 誤検知 baseline の運用が必要になったとき |
| CI Playwright 追加 spec | 新機能の UI 回帰 | `designing-playwright-tests-yk` で載せる/載せないを決めたあと |
| Dependabot / Renovate | hook 依存の自動更新 | 複数人開発・長期運用時 |

