---
name: managing-git-yk
description: >
  YK ワークスペース向け git commit / push / GitHub PR / 作業ツリーのクリーン。
  ユーザーが「コミットして」「commit して」「push して」「プッシュして」「PRを作って」「プルリクを出して」
  「クリーンにして」「クリーンにする」と明示したとき、または handoff-session-work 終了モード Phase C。
  マルチリポ判定・日本語メッセージ・secrets ゲート。
  Do NOT use for 引き継ぎ確認・整理（handoff-session-work）、新しいアプリ / AGENTS.md（starting-app-project-yk）、
  clone / branch 単独、force push to main/master、tracked の破棄のみ（「破棄して」が別途必要）。
disable-model-invocation: true
---

# Git リポジトリ管理（YK）

**副作用あり** — **`/managing-git-yk`** またはユーザーが **当ターンで commit / push / PR / クリーン を明示**したとき、または `handoff-session-work` **終了モード Phase C** のみ実行する。

旧名 `/committing-with-git-yk` · `/pushing-and-pr-yk` は本スキルへ委譲する。

## 方針 SSOT（転記しない）

| レイヤ | 参照 |
|--------|------|
| 方針 | `c:/yk-skill/rule/10_meta/GIT_WORKFLOW_RULES.md` |
| secrets | `c:/yk-skill/rule/10_meta/SECRETS_HYGIENE_RULES.md` §2 · エージェント必読チェックリスト |
| commit 手順 | Cursor User Rules（`committing-changes-with-git`）— amend 条件。調査 Shell は下記を優先 |
| PR 手順 | Cursor User Rules（`creating-pull-requests`） |
| Shell / RUN | `c:/yk-skill/rule/60_tooling/AGENT_SHELL_RULES.md` — 調査は `;` 1 本 · 初回 `all` |

矛盾時は **GIT_WORKFLOW** > **AGENT_SHELL / commit-shell** > User Rules の実行形式。

## 依存（必要時 Read）

- リポ判定 → [references/repo-routing.md](references/repo-routing.md)
- メッセージ例 → [references/message-examples.md](references/message-examples.md)
- Windows での commit → [references/commit-shell.md](references/commit-shell.md)
- push / PR の Shell → [references/pr-push-shell.md](references/pr-push-shell.md)
- クリーン → [references/clean.md](references/clean.md)
- 引き継ぎ終了の連結 → [../handoff-session-work/references/git-save.md](../handoff-session-work/references/git-save.md)

## モード（1 ターンでユーザー意図を 1 つに絞る）

| モード | 発火例 | やること |
|--------|--------|----------|
| **commit** | コミットして · commit して · 日本語でコミット | `git commit` まで。**push しない** |
| **push** | push して · プッシュして · リモートに上げて | `git push`（必要なら `-u origin HEAD`）。**commit しない** |
| **pr** | PR を作って · プルリク · pull request | User Rules に従い `gh pr create` |
| **push+pr** | push して PR · 上げてプルリク | 先 push → 続けて PR |
| **commit+push** | コミットして push · `handoff-session-work` Phase C | add + commit + push を **1 本/リポ**。**PR は含めない** |
| **clean** | クリーンにして · クリーンにする · git clean | 未追跡と残骸のみ。[clean.md](references/clean.md)。**tracked は破棄しない** |

「レポジトリ管理」だけで操作が無いときは **1 問だけ**（コミットする / push する / PR を作る / **クリーンにする**）。実行は明示があるまでしない。  
曖昧な push/PR も **1 問だけ**（push のみ / PR のみ / 両方）。

## 使わない場面

| 依頼 | 正しい扱い |
|------|------------|
| 引き継ぎ **終了**（引き継ぎして等） | `handoff-session-work` が Phase C で本スキルを **commit+push** で Read して実行 |
| 引き継ぎ **確認** · **整理** · handoffs 俯瞰 | `handoff-session-work`（**commit/push 禁止**） |
| 新しいアプリ · AGENTS.md | `starting-app-project-yk` |
| コードレビューのみ | `reviewing-code-yk` |
| `5.Python` の rev 上書き | `revision-protection` — 既存 `*revNNN*` の内容変更は中止 |
| 変更の破棄 · `reset --hard` | 「破棄して」等の **別途明示**（clean モードには含めない） |

## 開始ゲート（すべて満たすまで実行しない）

1. **Agent モード**（書き込み・シェル実行可）
2. 上表のモードが取れること — ユーザー明示 **または** `handoff-session-work` **終了モード Phase C**（**commit+push** · PR は別途明示）
3. HANDOFF の「次は commit / push」**だけ**では不十分
4. 対象リポが特定できる（不明なら [repo-routing.md](references/repo-routing.md) に従い確認）

**Phase C から呼ばれたとき:** メッセージ草案はセッション MD §1 を材料にする。同ターン内に修正指示がなければ add / commit / push へ進む（[git-save.md](../handoff-session-work/references/git-save.md)）。

## やらないこと

- モードに無い操作（「コミットして」で push しない · 「push して」で commit しない · 「クリーンにして」で tracked を破棄しない）
- `git config` 変更 · `push --force` を `main`/`master` へ · `reset --hard` · `rebase -i` · `git clean -x`
- secrets 疑いファイルの add / commit / push / 削除（ユーザーが要求しても警告して中止）
- 複数リポの変更を **1 コミットに混ぜる**
- clone · ブランチ作成だけの依頼を本スキルの既定操作にしない（ユーザーが PR 手順の一部として明示したときだけ User Rules に従う）

## 手順（リポごとに繰り返す）

### 1. リポを確定

[repo-routing.md](references/repo-routing.md) を Read。**2 ルート以上**ならリポごとに分けて実行する。

### 2. 調査（1 本の Shell · `;` 連結）

初回から `required_permissions: ["all"]`。[commit-shell.md](references/commit-shell.md) · [pr-push-shell.md](references/pr-push-shell.md)。

- **commit** を含む → status · diff --stat · log
- **push / pr** を含む → status · branch -vv · log（PR ならベースとの diff）
- **push / pr** で未コミットあり → **止めて** commit するか確認（`commit+push` 以外では自動 commit しない）
- **clean** → [clean.md](references/clean.md) の調査
- リモート未設定 · 追跡ブランチなし → ユーザーに確認

### 3. commit（モードに commit が含まれるとき）

1. 直近 `git log` の型・言語・括弧に合わせる（`GIT_WORKFLOW` §3）。参考は [message-examples.md](references/message-examples.md)
2. **通常の commit モード**は草案を見せ、OK を得てから add / commit。**commit+push（Phase C）**はゲート通過後に進む
3. secrets · `*revNNN*` 内容変更は中止。ステージ後に `diff --cached` を確認
4. 実行は [commit-shell.md](references/commit-shell.md)（Bash HEREDOC または Write + `git commit -F`）

### 4. push（モードに push が含まれるとき）

[pr-push-shell.md](references/pr-push-shell.md) に従う。`main`/`master` への force はしない。

### 5. PR（モードに pr が含まれるとき）

[pr-push-shell.md](references/pr-push-shell.md) と User Rules。必要なら先に push。`gh pr create` 後に **PR URL** を返す。

### 6. clean（モードが clean のとき）

[clean.md](references/clean.md) に従う。dry-run を見せてから実行する。Phase C では呼ばない。

### 7. 完了報告（リポごと）

```text
リポ: <name> (<ROOT>)
コミット: <hash> — <subject> または 未実施
push: 実施 / 未実施 / スキップ（理由）
PR: <URL> または 未実施
クリーン: 実施 / 未実施 / 対象なし
ブランチ: <name> · ahead/behind 要約
```

## 失敗時

| 事象 | 対応 |
|------|------|
| pre-commit / commit-msg hook 失敗 | **amend しない** — 原因修正後 **新規 commit** |
| コミット対象なし | 報告して終了 |
| `&&` 構文エラー · 日本語パーサエラー · `.git` Permission denied · index.lock · `????` メッセージ · COMMIT_EDITMSG 消失 · pre-commit OS ブロック | [commit-shell.md](references/commit-shell.md) トラブルシュート |
| push rejected（non-fast-forward） | force の提案は **main/master 禁止** · 取り込み方針を確認 |
| `gh` 未認証 · 404 | 認証・リポ名を確認して報告 |
| clean の dry-run に secrets っぽいパス | **消さない** — 報告して確認 |

## スキル改善時

`creating-skills` Step 0〜8 · `c:/yk-skill/rule/10_meta/SKILL_AUTHORING_RULES.md`
