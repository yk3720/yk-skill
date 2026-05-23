---
name: committing-with-git-yk
description: >
  YK ワークスペース向け git commit。ユーザーが「コミットして」「commit して」
  「日本語でコミット」と明示したときのみ。マルチリポ判定・日本語メッセージ草案・
  secrets ゲート。push は別依頼。引き継ぎ保存・セッション終了では使わない。
disable-model-invocation: true
---

# Git Commit（YK）

**副作用あり** — 本スキルは **`/committing-with-git-yk`** またはユーザーが **当ターンで commit を明示**したときのみ実行する。

## 方針 SSOT（転記しない）

| レイヤ | 参照 |
|--------|------|
| 方針 | `c:/yk-skill/rule/10_meta/GIT_WORKFLOW_RULES.md` |
| secrets | `c:/yk-skill/rule/10_meta/SECRETS_HYGIENE_RULES.md` §2 · エージェント必読チェックリスト |
| 手順 | **Cursor User Rules**（`committing-changes-with-git`）— 調査 · amend 条件 |
| Shell / RUN | `c:/yk-skill/rule/60_tooling/AGENT_SHELL_RULES.md` — 調査は `;` 1 本 · 初回 `all` |

矛盾時は **GIT_WORKFLOW** と User Rules を優先する。

## 依存（必要時 Read）

- リポ判定 → [references/repo-routing.md](references/repo-routing.md)
- メッセージ例 → [references/message-examples.md](references/message-examples.md)
- Windows での commit 実行 → [references/commit-shell.md](references/commit-shell.md)

## 使わない場面

| 依頼 | 正しい扱い |
|------|------------|
| 引き継ぎ · セッション終了 · 作業を保存 · 引き継ぎ内容を確認 · 整理して | `handoff-session-work`（**commit 禁止**） |
| push · PR 作成のみ | User Rules の `creating-pull-requests` / ユーザー明示まで push しない |
| `5.Python` の rev 上書き | `revision-protection` — 既存 `*revNNN*` の内容変更は中止 |

## 開始ゲート（すべて満たすまで実行しない）

1. **Agent モード**（書き込み・シェル実行可）
2. ユーザー発話に **commit 意図**がある（例: コミットして / commit して / 日本語でコミット）
3. HANDOFF の「次は commit」**だけ**では不十分 — 当ターンの明示が必要
4. 対象リポが特定できる（不明なら [repo-routing.md](references/repo-routing.md) に従い確認）

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
| index.lock（単独） | 他プロセス確認後、削除して [commit-shell.md](references/commit-shell.md) の再試行手順 |

## スキル改善時

`creating-skills` Step 0〜7 · `c:/yk-skill/rule/10_meta/SKILL_AUTHORING_RULES.md`
