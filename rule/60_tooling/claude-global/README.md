# Claude Code `CLAUDE.md`（YK 正本）

Claude Code がグローバル設定として読む **`CLAUDE.md`** の正本を Git で管理する。

**並び:** `cursor-permissions/`（`~/.cursor/permissions.json`）と同じ「リポジトリ正本 → ホームへデプロイ」パターン。

## なぜリポジトリに置くか

| 項目 | 説明 |
|------|------|
| Claude Code が読む場所 | **固定:** `%USERPROFILE%\.claude\CLAUDE.md` |
| リポジトリの役割 | **正本（SSOT）**。handoffs 索引 · L1 ルール早見表 · スキル一覧をここで版管理する |
| 編集 | **`claude-global/CLAUDE.md` のみ**編集し、デプロイで反映する |

## 初回セットアップ（Windows）

```powershell
cd c:\yk-skill\rule\60_tooling\claude-global
.\Deploy-ClaudeGlobal.ps1 -Mode Copy      # 標準（管理者不要）
.\Deploy-ClaudeGlobal.ps1 -Mode Symlink   # 開発者モード ON または管理者 PowerShell のときのみ
```

`-Mode Symlink` なら `~\.claude\CLAUDE.md` を直接編集してもリポジトリ正本に書き込まれる。

## 2 PC / clone 後

| 状況 | 手順 |
|------|------|
| **新 PC** | `yk-skill` を clone 後、`Deploy-ClaudeGlobal.ps1 -Mode Copy` |
| **pull 後** | Copy モードなら再デプロイ。Symlink モードなら不要 |
| **手書きで `~\.claude\CLAUDE.md` を編集した** | 内容を正本へ取り込み、再デプロイ |

## 関連

| 種別 | パス |
|------|------|
| プロジェクト憲法（例: flowchart-studio） | 各リポの `AGENTS.md` |
| ui-kit 向け | `workspace-ui-kit/CLAUDE.md` |
| L1 ルール | `yk-skill/rule/` · `RULE_INDEX.md` |
| スキル本体 | `yk-skill/.claude/skills/` |
