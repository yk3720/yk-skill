# 品質ゲート（YK 横断）

**目的:** 編集時・コミット時・CI/デプロイ時の3層で、人間・AI 双方の変更を機械的に検証する。  
**関連:** `AGENT_SHELL_RULES.md` · `GIT_WORKFLOW_RULES.md` · `PLAYWRIGHT_RULES.md` · `PYTHON_RULES.md` · `REACTFLOW_RULES.md` §6 · `SECRETS_HYGIENE_RULES.md`

**索引:** [`../RULE_INDEX.md`](../RULE_INDEX.md) No **63** · L0: `quality-gates-yk.mdc`

**最終更新:** 2026-06-09

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
| `yk-tool/flowchart-web-reactflow` | **要**（Web + Python 混在） |
| `yk-memo` · `yk-skill` | 不要（MD/ルール中心） |
| その他 `yk-tool/*` | `package.json` / `pyproject.toml` の有無で個別判断 |

---

## 3. Web（flowchart-web-reactflow）

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

### Git hooks

| hook | 内容 |
|------|------|
| **pre-commit** | ① lint-staged（eslint --fix + prettier）· ② pre-commit 全フック（下表） |
| **pre-push** | typecheck + vitest + excel:test |

#### pre-commit 内の pre-commit フック（`.pre-commit-config.yaml`）

| hook | 目的 | 対象 |
|------|------|------|
| `check-merge-conflict` | `<<<<<<<` 等の未解決マーカーを commit 拒否 | ステージされた `flowchart-web-reactflow/**` 全般 |
| `detect-private-key` | SSH / PEM 秘密鍵の誤 commit 拒否 | 同上 |
| `ruff-check` + `ruff-format` | Python lint / format | `tools/excel_normalize/**` のみ |

**pre-commit に入れない:** `tsc`（遅い）· E2E（遅い）· `mypy`（CI 向け）— `PLAYWRIGHT_RULES` §12 どおり E2E はターン内で実行。

**意図的に入れない:** `commitlint`（`GIT_WORKFLOW_RULES` の日本語・log 準拠と衝突）· SQLFluff（マイグレーション少数のため手動レビュー）· 毎ターン Cursor `stop` hook（遅い）。

### 初期化（新規クローン後）

```powershell
cd flowchart-web-reactflow
npm install
pip install -e "tools/excel_normalize[dev]"
```

`pip install` は **Python ファイルだけでなく** `check-merge-conflict` / `detect-private-key` にも必要（flowchart 配下のあらゆる commit で pre-commit が走る）。

---

## 4. Python（tools/excel_normalize）

- **Ruff** + **pre-commit**（`ruff-check --fix` → `ruff-format`）
- 設定: `tools/excel_normalize/pyproject.toml` · `.pre-commit-config.yaml`
- `PYTHON_RULES` 準拠（mypy は hook ではなく CI 拡張候補 · uv 移行は別タスク）

---

## 5. エージェント行動

1. **hook 失敗時:** ターミナル出力を読み、**即座に自己修正して再 commit**。`--no-verify` 禁止。amend は `GIT_WORKFLOW_RULES` / commit スキルどおり。
2. **hook が直せる範囲:** format / lint の auto-fix のみ。型エラー・テスト失敗はコード修正ターンが必要。
3. **commit 時 Shell:** 初回から `required_permissions: ["all"]`（`AGENT_SHELL_RULES`）。
4. **hook 自動修正後:** `git status` で差分確認 · 必要なら再 stage。
5. **UI 変更 + E2E spec 追加:** 同一ターンで `npm run test:e2e`（`PLAYWRIGHT_RULES` §12）。
6. **秘密検出で止まった場合:** 該当行を削除または `.env` 等へ移し、**値をチャットに貼らない**（`SECRETS_HYGIENE_RULES`）。

---

## 6. CI

- **SSOT:** `yk-tool/.github/workflows/flowchart-web-reactflow-ci.yml`
- **`HUSKY=0`:** CI では Git hook をスキップし、同じ検査をコマンドで直接実行（二重実行防止）
- push/PR で `flowchart-web-reactflow/**` 変更時に lint · format · typecheck · vitest · pre-commit（セキュリティ + ruff）· pytest を実行
- Vercel build はデプロイ最終ゲート

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
| CI `npm run build` | Next ビルドの早期検出 | CI 時間とのトレードオフを許容するとき |
| CI `mypy` | Python 型チェック | `PYTHON_RULES` 完全準拠を CI で担保するとき |
| Dependabot / Renovate | hook 依存の自動更新 | 複数人開発・長期運用時 |
