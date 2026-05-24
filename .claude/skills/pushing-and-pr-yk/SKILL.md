---
name: pushing-and-pr-yk
description: >
  YK 向け git push と GitHub PR 作成。ユーザーが「push して」「プッシュして」「PRを作って」「プルリクを出して」と当ターンで明示したときのみ。
  commit は別スキル（committing-with-git-yk）。引き継ぎ終了では使わない。
  Do NOT use for コミットしてのみ、force push to main/master（警告して中止）、git config 変更、未コミットのまま push 提案のみ。
disable-model-invocation: true
---

# Git Push / PR（YK）

**副作用あり** — **`/pushing-and-pr-yk`** またはユーザーが **当ターンで push / PR を明示**したときのみ実行する。

## 方針 SSOT（転記しない）

| レイヤ | 参照 |
|--------|------|
| 方針 | `c:/yk-skill/rule/10_meta/GIT_WORKFLOW_RULES.md` |
| commit | `committing-with-git-yk`（push/PR の前に未コミットなら先に依頼を促す） |
| PR 実行手順 | [pr-push-shell.md](references/pr-push-shell.md) + User Rules（amend/force 禁止等の方針のみ） |
| Shell / RUN | `c:/yk-skill/rule/60_tooling/AGENT_SHELL_RULES.md` — `;` 1 本 · 初回 `all` |
| push 実行 | [references/pr-push-shell.md](references/pr-push-shell.md) |

## モード（1 ターンでユーザー意図を 1 つに絞る）

| モード | 発火例 | やること |
|--------|--------|----------|
| **push** | push して · プッシュして · リモートに上げて | `git push`（必要なら `-u origin HEAD`） |
| **pr** | PR を作って · プルリク · pull request | User Rules に従い `gh pr create` |
| **push+pr** | push して PR · 上げてプルリク | 先 push → 続けて PR |

曖昧なときは **1 問だけ**（push のみ / PR のみ / 両方）。

## 使わない場面

| 依頼 | 正しい扱い |
|------|------------|
| コミットして · commit して | `committing-with-git-yk` |
| 引き継ぎ · セッション終了 · handoffs 確認 | `handoff-session-work`（**push/PR 禁止**） |
| コードレビューのみ | `reviewing-code-yk` |

## 開始ゲート（すべて満たすまで実行しない）

1. **Agent モード**
2. ユーザー発話に **push または PR 意図**がある
3. HANDOFF の「次は push」**だけ**では不十分 — 当ターンの明示が必要
4. 対象リポが特定できる → [../committing-with-git-yk/references/repo-routing.md](../committing-with-git-yk/references/repo-routing.md)

## やらないこと

- `git commit`（未コミットがあれば `committing-with-git-yk` を提案）
- `git config` 変更 · `git push --force` on **`main`/`master`**（他ブランチも明示時のみ · 事前警告）
- `reset --hard` · `rebase -i`
- secrets 疑いの変更を push

## 手順（リポごとに繰り返す）

### 1. リポを確定

[repo-routing.md](../committing-with-git-yk/references/repo-routing.md) を Read。複数ルートなら **リポごとに** push/PR する。

### 2. 事前調査（1 本の Shell · `;` 連結）

[pr-push-shell.md](references/pr-push-shell.md) の調査コマンド（`AGENT_SHELL_RULES` §3-3）。初回 **`required_permissions: ["all"]`**。

- 未コミット変更あり → **push/PR を止め**、commit するか確認（`committing-with-git-yk`）
- リモート未設定 · 追跡ブランチなし → ユーザーに確認

### 3. push（モードに push が含まれるとき）

[pr-push-shell.md](references/pr-push-shell.md) に従う。

- 既定: `git -C "<ROOT>" push -u origin HEAD`（初回 upstream が必要なとき）
- **force push** — `main`/`master` へは **実行しない**（警告して中止）。他ブランチはユーザーが force を明示したときのみ

### 4. PR（モードに pr が含まれるとき）

**[pr-push-shell.md](references/pr-push-shell.md)** と User Rules（PR 本文・`gh` 形式）に従う。事前調査の Shell は §2 と同様 **1 本連結**:

1. 並列調査（status · diff · tracking · log · `git diff base...HEAD`）
2. 必要ならブランチ作成 · `git push -u origin HEAD`
3. `gh pr create`（HEREDOC 本文 · `required_permissions: ["all"]`）
4. **PR URL** をユーザーに返す

### 5. 完了報告（リポごと）

```text
リポ: <name> (<ROOT>)
push: 実施 / 未実施 / スキップ（理由）
PR: <URL> または 未実施
ブランチ: <name> · ahead/behind 要約
```

## 失敗時

| 事象 | 対応 |
|------|------|
| push rejected（non-fast-forward） | force の提案は **main/master 禁止** · 取り込み方針をユーザーに確認 |
| `gh` 未認証 · 404 | 認証・リポ名を確認して報告 |
| Permission denied · `.git` | [pr-push-shell.md](references/pr-push-shell.md) — `all` で再試行 |

## スキル改善時

`creating-skills` Step 0〜8 · `SKILL_AUTHORING_RULES.md`
