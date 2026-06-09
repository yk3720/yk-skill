# Git ワークフロー規則
## 横断 Git SSOT — 方針のみ（実行手順は Cursor User Rules）

**用途:** 全リポジトリ共通の **Git 方針**（いつ・何を・どう履歴に残すか）。  
**関連:** `40_python/PYTHON_RULES.md` §9（Python / rev 積層）· `60_tooling/QUALITY_GATE_RULES.md`（Git hook / CI）· 各ドメイン rule のセキュリティ節  
**実行手順:** Cursor **User Rules**（`git status` / `git diff` / HEREDOC 等）— 本ファイルは **方針 SSOT** のみ

**最終更新:** 2026-05-23

---

## 1. いつ Git 操作するか

| 操作 | 方針 |
|------|------|
| **`git commit`** | **ユーザーが明示したときのみ**。曖昧な場合はコミット前に確認する |
| **`git push`** | **ユーザーが明示したときのみ**。「コミットして」だけでは push 可と解釈しない |
| **引き継ぎ終了** | 「引き継ぎして」「セッション終了」「作業を保存」「引き継ぎ終了」は **当ターンで commit + push まで**（スキル `handoff-session-work` Phase C → `committing-with-git-yk` · `pushing-and-pr-yk`） |
| **`git pull` / fetch** | 作業に必要なとき。破壊的マージの恐れがある場合はユーザーに確認 |
| **PR 作成** | ユーザー依頼時。push が未実施なら先に push 可否を確認 |

**エージェントが独断で行わないこと:** コミット・push・force push・hard reset・大規模削除。

---

## 2. コミットしてはいけないもの

**一覧・チェックリスト（SSOT）:** [`SECRETS_HYGIENE_RULES.md`](SECRETS_HYGIENE_RULES.md) §2 · §「エージェント必読チェックリスト」

**コミット前:** ステージにシークレットが混ざっていないか確認する。含まれていたらステージから外し、ユーザーに報告する。

---

## 3. コミットメッセージ

| 項目 | 方針 |
|------|------|
| **言語・文体** | **対象リポジトリの直近 `git log` に合わせる**（不明なら日本語） |
| **内容** | **why** を 1〜2 文。what の羅列だけにしない |
| **粒度** | **1 コミット = 1 つの意図**。無関係な変更を混ぜない |
| **禁止** | 空コミット · 意味のない `update` のみ · secrets を含むメッセージ |

実行時は User Rules に従い、コミット前に `git log` でスタイルを確認する。

---

## 4. ブランチ・リモートの安全規則

| 項目 | 方針 |
|------|------|
| **既定ブランチ** | リポジトリごと（`main` / `master` 等）。`git branch -vv` で確認 |
| **feature ブランチ** | PR 作成時は User Rules の手順に従う。命名はリポジトリ慣習に合わせる |
| **`git push --force`** | **`main` / `master` へは禁止**。他ブランチもユーザー明示時のみ。実行前に警告 |
| **`git reset --hard`** | ユーザー明示時のみ |
| **`git commit --amend`** | User Rules の条件をすべて満たすときのみ（**hook 失敗時は amend せず新規コミット** → [`QUALITY_GATE_RULES.md`](../60_tooling/QUALITY_GATE_RULES.md) §5） |
| **`git commit --no-verify`** | **禁止**（品質ゲート回避）→ 同上 §5 |
| **`git rebase -i` 等** | 対話必須のためエージェントは使わない |
| **`git config` 変更** | **禁止**（ユーザーが直接変更する） |

**履歴の監査可能性:** 既存コミットの改変（rebase の乱用等）で追跡不能にしない。

---

## 5. リポジトリ別の補足（ドメイン rule が詳細 SSOT）

**Secrets（保管・チャット）:** [`SECRETS_HYGIENE_RULES.md`](SECRETS_HYGIENE_RULES.md)

| リポジトリ / 領域 | 補足 |
|-------------------|------|
| **yk-skill（`rule/` · スキル）** | 通常ファイル名で更新。履歴は Git が SSOT（rev 番号ファイルは使わない） |
| **`5.Python/0.ルール・操作方法`** | **rev 積層** — 既存 `*revNNN*` の上書き禁止 · 新 rev のみ積層（`revision-protection.mdc`）→ `40_python/PYTHON_RULES.md` §9 |
| **Playwright テスト** | `auth/session.json` 等 → `50_gas_html_test/PLAYWRIGHT_RULES.md` §5 |
| **GAS** | Script Properties にトークン → `50_gas_html_test/GAS_RULES.md` |
| **Vercel / Neon** | `.env.local` の Sensitive 変数 → `30_web_stack/VERCEL_RULES.md` |
| **`yk-tool/flowchart-web-reactflow`** | husky / lint-staged / pre-commit（commit）· typecheck + test（push）→ [`QUALITY_GATE_RULES.md`](../60_tooling/QUALITY_GATE_RULES.md) |

---

## 6. User Rules との分担

| レイヤ | 役割 |
|--------|------|
| **本ファイル（yk-skill）** | 方針 SSOT — Governance 段階 5 の横断 rule |
| **Cursor User Rules** | 実行手順（HEREDOC · PR 用 `gh` 等）— **YK マルチルートでは commit 前調査は `AGENT_SHELL_RULES` §3-3（1 本 `;` 連結）を優先**（User Rules の並列 3 本 Shell は未適用） |
| **スキル `committing-with-git-yk`** | ユーザー明示時、または引き継ぎ終了 Phase C の commit — `/committing-with-git-yk` |
| **スキル `pushing-and-pr-yk`** | ユーザー明示時、または引き継ぎ終了 Phase C の push / 依頼時の PR — `/pushing-and-pr-yk` |
| **スキル `handoff-session-work`** | 終了モードで Phase A→B→C（C で上記 2 スキルを Read して実行） |

矛盾したときは **Governance**（`RULE_INDEX.md`）の優先順位に従う。同順位ならユーザーに確認する。
