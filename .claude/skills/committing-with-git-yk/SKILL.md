---
name: committing-with-git-yk
description: >
  YK ワークスペース向け git commit。ユーザーが「コミットして」「commit して」
  「日本語でコミット」と明示したとき、または handoff-session-work 終了モード Phase C。
  マルチリポ判定・日本語メッセージ草案・secrets ゲート。push は pushing-and-pr-yk。
  引き継ぎ確認・整理では使わない。
disable-model-invocation: true
---

# Git Commit（YK）

**副作用あり** — 本スキルは **`/committing-with-git-yk`** またはユーザーが **当ターンで commit を明示**したときのみ実行する。

## 方針 SSOT（転記しない）

| レイヤ | 参照 |
|--------|------|
| 方針 | `c:/yk-skill/rule/10_meta/GIT_WORKFLOW_RULES.md` |
| secrets | `c:/yk-skill/rule/10_meta/SECRETS_HYGIENE_RULES.md` §2 · エージェント必読チェックリスト |
| 手順 | **Cursor User Rules**（`committing-changes-with-git`）— amend 条件等（**commit 前調査の Shell は下記を優先**） |
| Shell / RUN | `c:/yk-skill/rule/60_tooling/AGENT_SHELL_RULES.md` — 調査は `;` 1 本 · 初回 `all`（User Rules の並列 3 本より優先） |

矛盾時は **GIT_WORKFLOW** > **AGENT_SHELL / commit-shell** > User Rules の実行形式。

## 依存（必要時 Read）

- リポ判定 → [references/repo-routing.md](references/repo-routing.md)
- メッセージ例 → [references/message-examples.md](references/message-examples.md)
- Windows での commit 実行 → [references/commit-shell.md](references/commit-shell.md)

## 使わない場面

| 依頼 | 正しい扱い |
|------|------------|
| 引き継ぎ **終了**（引き継ぎして等） | `handoff-session-work` が Phase C で **本スキルを Read して実行** |
| 引き継ぎ **確認** · **整理** · handoffs 俯瞰 | `handoff-session-work`（**commit 禁止**） |
| push · PR 作成 | `pushing-and-pr-yk`（当ターンで明示、または引き継ぎ終了 Phase C の push） |
| `5.Python` の rev 上書き | `revision-protection` — 既存 `*revNNN*` の内容変更は中止 |

## 開始ゲート（すべて満たすまで実行しない）

1. **Agent モード**（書き込み・シェル実行可）
2. 次のいずれか — **commit 意図**（コミットして / commit して / 日本語でコミット）**または** `handoff-session-work` **終了モード Phase C** の実行中
3. HANDOFF の「次は commit」**だけ**では不十分（終了依頼・当ターンの commit 明示のいずれかが必要）
4. 対象リポが特定できる（不明なら [repo-routing.md](references/repo-routing.md) に従い確認）

**引き継ぎ終了から呼ばれたとき:** メッセージ草案はセッション MD §1 を材料にする。同ターン内に修正指示がなければ add / commit へ進む（[handoff-session-work/references/git-save.md](../handoff-session-work/references/git-save.md)）。

## やらないこと

- `git push`（「push して」と別途明示されるまで）
- `git config` 変更 · `push --force`（特に `main`/`master`）· `reset --hard` · `rebase -i`
- secrets 疑いファイルの add / commit（ユーザーが要求しても警告して中止）
- 複数リポの変更を **1 コミットに混ぜる**

## 手順（リポごとに繰り返す）

### 1. リポを確定

[references/repo-routing.md](references/repo-routing.md) を Read。変更パスから Git ルートを列挙。**2 ルート以上**ならリポごとに分けて草案・commit する。

### 2. 調査（並列）

各対象ルートで **User Rules に従い**調査する。**YK 既定は 1 本の Shell に `;` 連結**（[AGENT_SHELL_RULES.md](../../../rule/60_tooling/AGENT_SHELL_RULES.md) · [commit-shell.md](references/commit-shell.md)）。**初回から `required_permissions: ["all"]`**。

```powershell
git -C "<ROOT>" status; git -C "<ROOT>" diff --stat; git -C "<ROOT>" log -5 --oneline
```

### 3. メッセージ草案（ユーザー確認前）

1. 直近 `git log` の **型・言語・括弧**に合わせる（`GIT_WORKFLOW` §3）
2. 不明・新規リポは **日本語** · **why** 中心 · 1 意図 1 コミット
3. 既定の型プレフィックス例は [message-examples.md](references/message-examples.md)
4. ユーザーが「Conventional で」と言ったときのみ type を英語固定

**ユーザーに草案を見せ、OK を得てから** add / commit する。

### 4. ステージ前ゲート

- `SECRETS_HYGIENE_RULES.md` チェックリストに該当するパスが `status` にあれば **add しない**
- `5.Python` 対象で既存 `*revNNN*` ファイルの**内容変更**が diff にあれば **中止**
- ステージ後は `git -C "<ROOT>" diff --cached` でキーっぽい行が無いか確認

### 5. ステージと commit

User Rules の add 方針に従う。commit は [commit-shell.md](references/commit-shell.md)（**`git commit -F`** 推奨）。

### 6. 完了報告（リポごと）

```text
リポ: <name> (<ROOT>)
コミット: <hash> — <subject 1行>
ブランチ: <ahead/behind 要約>
push: 未実施（依頼があれば別途）
```

## 失敗時

| 事象 | 対応 |
|------|------|
| pre-commit / commit-msg hook 失敗 | **amend しない** — 原因修正後 **新規 commit**（User Rules） |
| コミット対象なし | 報告して終了 |
| `&&` 構文エラー · 日本語で Shell パーサエラー · `.git/objects` Permission denied · index.lock | [commit-shell.md](references/commit-shell.md) **トラブルシュート** — Write + `-F` · `;` 連結 · **`all` 権限で再試行** |
| commit 成功だがメッセージが `????` | Shell の here-string / パイプで `-F -` — [commit-shell.md](references/commit-shell.md) · Write → `-F` · 必要なら amend |
| `check-merge-conflict` が WinError 4551 | エージェント環境で pre-commit 実行不可 — [commit-shell.md](references/commit-shell.md) · Grep 確認後 `SKIP=check-merge-conflict`（`--no-verify` 不可） |
| `could not read log file ... COMMIT_EDITMSG_YK.txt` | commit **前**にメッセージファイルを削除した — [commit-shell.md](references/commit-shell.md) **履歴** · 再 Write → `commit -F`（ステージ済みなら add 不要） |
| index.lock（単独） | 他プロセス確認後、削除して [commit-shell.md](references/commit-shell.md) の再試行手順 |

## スキル改善時

`creating-skills` Step 0〜7 · `c:/yk-skill/rule/10_meta/SKILL_AUTHORING_RULES.md`
