# push / PR 前調査（Windows / PowerShell）

**手順 SSOT:** Cursor User Rules `creating-pull-requests`（PR）· `c:/yk-skill/rule/60_tooling/AGENT_SHELL_RULES.md`（`;` 連結 · 初回 `all`）

## 調査（リポごと · 1 本）

```powershell
git -C "<ROOT>" status; git -C "<ROOT>" branch -vv; git -C "<ROOT>" log -3 --oneline
```

PR モードでベースブランチが分かっているとき（例: `main`）:

```powershell
git -C "<ROOT>" diff main...HEAD --stat
```

## push（初回 upstream）

```powershell
git -C "<ROOT>" push -u origin HEAD
```

既に upstream があるとき:

```powershell
git -C "<ROOT>" push
```

**禁止（エージェント）:** `git push --force` を `main` / `master` へ。ユーザー明示の他ブランチ force も事前に警告。

## 権限

- `.git` 書き込み · ネットワーク · `gh` → Shell は **`required_permissions: ["all"]`** を初回から指定
- 複数 git コマンドは **`;` で 1 本**（`&&` 不可 — YK 既定）

## PR

`gh pr create` の本文・並列調査は **User Rules `creating-pull-requests` に従う**（本ファイルに再掲しない）。
