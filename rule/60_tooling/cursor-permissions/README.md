# Cursor `permissions.json`（YK 正本）

Cursor が Auto-Run 時に読む **Command Allowlist / MCP Allowlist** の正本を Git で管理する。

**公式:** [permissions.json](https://cursor.com/docs/reference/permissions) · 手順・エージェント規約: `../AGENT_SHELL_RULES.md`

## なぜリポジトリに置くか

| 項目 | 説明 |
|------|------|
| Cursor が読む場所 | **固定:** `%USERPROFILE%\.cursor\permissions.json`（プロジェクト直下ではない） |
| リポジトリの役割 | **正本（SSOT）**。編集はここで行い、各 PC・各 Cursor アカウント用に **コピーまたはシンボリックリンク** で反映する |
| UI との関係 | `terminalAllowlist` を定義すると **IDE の Command Allowlist は上書き**（マージしない）。設定画面は読み取り専用になる |

**ファイル化できないもの**（Auto-Run モード・保護トグル・Network Access 等）は引き続き Settings → Agents で手動を揃える。

## 初回セットアップ（Windows）

```powershell
cd c:\yk-skill\rule\60_tooling\cursor-permissions
.\Deploy-CursorPermissions.ps1 -Mode Copy      # 標準（管理者不要）
.\Deploy-CursorPermissions.ps1 -Mode Symlink   # 開発者モード ON または管理者 PowerShell のときのみ
```

反映確認: **Cursor Settings → Agents → Command Allowlist** が `permissions.json` 由来の読み取り専用表示になる。

## 2 アカウント / 複数 PC

| 状況 | 手順 |
|------|------|
| **同じ Windows ユーザー**で Cursor アカウントだけ切替 | `~\.cursor\permissions.json` は **1 つ** — デプロイ 1 回で両アカウントに同じファイルが効く（allowlist 部分） |
| **別 PC** | リポジトリを clone 後、各 PC で `Deploy-CursorPermissions.ps1 -Mode Copy` |
| **`--user-data-dir` でプロファイル分離** | 各プロファイルの Windows ユーザーが同じなら `~\.cursor\` は共有。別ユーザーならユーザーごとにデプロイ |
| **UI の Auto-Run モード等** | アカウントごとに Settings で同じにする（または Settings Sync） |

## 編集ルール

### Tier A — 読取（既定 · 全環境）

- **`terminalAllowlist` に載せる:** `cd` · `python` · 読取系 git（`git status` · `git diff` · `git log` · `git -C` · `git rev-parse`）

### Tier B — 書込（個人 dev · RUN 削減 · 2026-06-25 以降の正本）

- **追加で載せる:** `git add` · `git commit` · `git push` · `git mv`
- **載せない:** `"git"` 単体 · `git push --force` 等 — branch protection と併用
- **リスク:** allowlist は便利機能でありセキュリティ境界ではない（公式）。社内共有 PC では Tier A のみを検討

- **`mcpAllowlist`:** 使うときだけ JSON にキーを追加。空配列 `[]` だけ書くと MCP が全部ブロックされるので **キーごと省略**

変更後は Cursor 再起動不要（ファイル監視）。Agent で `git status` が RUN なしになるか確認する。

## トラブル

- UI がまだ `cd` / `python` だけで編集可能 → デプロイ先が `%USERPROFILE%\.cursor\permissions.json` か確認。`-Mode Symlink` 失敗時は `-Mode Copy`
- Sandbox で allowlist が効かない → Agents の **Legacy Terminal Tool** を ON（`AGENT_SHELL_RULES.md` §2）
