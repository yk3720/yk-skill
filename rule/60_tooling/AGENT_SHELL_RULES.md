# エージェント Shell / RUN 承認（YK 横断）

**目的:** Cursor Agent が **Shell（ターミナル）** を呼ぶたびに出る **RUN 承認**を、安全性を保ちつつ減らす。  
**関連:** `60_tooling/CURSOR_RULES.md`（Windows 実務）· `10_meta/GIT_WORKFLOW_RULES.md` · スキル `committing-with-git-yk` · `handoff-session-work`

**最終更新:** 2026-05-23

---

## 1. 用語

| 用語 | 意味 |
|------|------|
| **RUN** | Agent が Shell コマンドを実行する前のユーザー承認（Skip / Run / Add to allowlist） |
| **Auto-Run** | Settings → Agents → Auto-Run Mode。allowlist 上のコマンドは承認なしで実行されうる |
| **allowlist** | `terminalAllowlist` / `mcpAllowlist` — 正本はリポジトリ、実行時は `~/.cursor/permissions.json`（**IDE UI とマージしない**） |
| **正本（Git）** | `c:/yk-skill/rule/60_tooling/cursor-permissions/permissions.json` |

**公式:** [Terminal](https://cursor.com/docs/agent/tools/terminal) · [permissions.json](https://cursor.com/docs/reference/permissions)

---

## 2. 人間が一度だけ行う設定（エージェントは変更しない）

### UI の名前対応（Cursor 3.5 以降）

ドロップダウンに **「Allowlist」という第4項目は無い**のが正常です。公式の旧名称との対応は次のとおりです。

| 画面に出る名前 | 公式ドキュメント上の呼び方 |
|----------------|---------------------------|
| **Auto-Run in Sandbox** | **Allowlist (with Sandbox)** |
| **Ask Every Time** | Allowlist（allowlist 空＝毎回承認に近い） |
| **Run Everything (Unsandboxed)** | Run Everything |

### 手順

1. **`Ctrl+Shift+J`** → **Cursor Settings → Agents**
2. **Auto-Run Mode** は **`Auto-Run in Sandbox` のままでよい**（いまの選択で OK）。**`Run Everything` は使わない**
3. **同じ Agents 画面を下へスクロール**し、次があるか確認する  
   - **Command Allowlist** / **Terminal Command Allowlist**  
   - **MCP Allowlist**  
   - 表示が **`~/.cursor/permissions.json` で管理（読み取り専用）** なら、下記 JSON が効いている
4. **allowlist はリポジトリ正本 → ローカルへデプロイ**（2 アカウント・複数 PC 向け）  
   - 正本: `c:/yk-skill/rule/60_tooling/cursor-permissions/permissions.json`  
   - 初回: `cursor-permissions/Deploy-CursorPermissions.ps1 -Mode Copy`（管理者不要）。開発者モード ON なら `-Mode Symlink` 可  
   - 詳細: `cursor-permissions/README.md`  
   - Cursor が読むのは常に **`%USERPROFILE%\.cursor\permissions.json`** のみ（リポジトリ直読みは不可）
5. **allowlist を効かせたいのに Sandbox で無視される**とき（既知）  
   → **Agents** → **Legacy Terminal Tool**（Inline Editing & Terminal 付近）を **オン**  
   → [フォーラム #152136](https://forum.cursor.com/t/command-allowlist-is-silently-ignored-when-auto-run-in-sandbox-is-enabled/152136)  
   ※ Sandbox モードでは UI の Command Allowlist が **効かない**報告あり。`permissions.json` も同様のことがある
6. **保護:** File-Deletion Protection 等は **オン**推奨（UI のみ · ファイル化不可）
7. **Auto-Run モード・Network・Git Writes・保護トグル** — **ファイル化不可**。2 アカウントで揃えるときは Settings を手動で同じにするか Settings Sync

### allowlist の内容（正本 = `cursor-permissions/permissions.json`）

| 載せる | 載せない（毎回 RUN = 意図的な確認） |
|--------|-------------------------------------|
| `cd` · `python` · 読取系 git の**完全列挙** | `"git"` 単体（全サブコマンドが通る） |
| | `git add` · `git commit` · `git push` · `git pull` |

- allowlist は **便利機能**であり **セキュリティ境界ではない**（公式）。`git push --force` 等は **branch protection** でも守る。
- PR を頻繁に行う場合のみ **`gh`** を追加検討（prefix 一致に注意）。

---

## 3. エージェントのデフォルト（全タスク）

### 3-1. ツールの優先順位

| 目的 | 使うツール | Shell |
|------|------------|-------|
| ファイル一覧 | **Glob** | 使わない |
| 本文・設定読み | **Read** | 使わない |
| 文字列検索 | **Grep** | 使わない |
| 副作用（commit · test · install） | Shell | 下記例外のみ |

**禁止例:** 確認・俯瞰のための `git status` · `ls` · `Get-ChildItem` · `dir`（Read/Glob で足りる）。

### 3-2. Shell を使ってよいターン

ユーザーが **当ターンで明示**したときのみ:

- `commit` / `push` / PR 作成 / テスト実行
- 引き継ぎ **終了**（触った Git ルートの `git status` のみ）
- clone · `npm install` 等、実行が必須の作業

### 3-3. 1 RUN にまとめる

同一目的のコマンドは **1 本の Shell** に **`;` で連結**（PowerShell 5.1 では **`&&` 不可**）。

```powershell
git -C "c:/yk-memo" status; git -C "c:/yk-skill" status
```

- マルチリポの commit 調査も **並列 3 本より 1 本連結を優先**（RUN 最小）。
- 例外: ユーザーが「並列で」と明示したとき。

### 3-4. 権限（再試行 RUN を避ける）

| 作業 | Shell の `required_permissions` |
|------|----------------------------------|
| `git add` / `commit` / `push`（`.git` 書き込み） | 初回から **`all`** |
| Playwright · clone · `npm install` | 初回から **`all`**（該当スキル参照） |
| 読取のみの git（allowlist 外） | サンドボックス可 → 失敗時のみ `all` |

**非推奨:** サンドボックスで失敗してから `all` で同じコマンドを再実行（RUN が 2 倍になりやすい）。詳細は `committing-with-git-yk/references/commit-shell.md`。

---

## 4. タスク別例外（優先: 発火スキル > 本ファイル）

| ID | タスク | Shell |
|----|--------|-------|
| **D-1** | 引き継ぎ **確認**（`handoff-session-work` 確認モード） | **禁止** — Glob + Read のみ |
| **D-2** | 引き継ぎ **終了** | 触ったルートの `git status` のみ（1 本にまとめてよい） |
| **D-3** | **commit**（`committing-with-git-yk`） | 可 — 調査は §3-3、commit は Write + `-F`、初回 `all` |
| **D-4** | Playwright（`using-playwright`） | 可 — スキルどおり `all` |

---

## 5. ユーザー向け依頼文（コピー用）

```text
引き継ぎを確認して。Shell は使わず Read/Glob のみ。git は不要。
```

```text
yk-memo だけコミット＆プッシュ。git は1本のShell・初回からフル権限で。
```

---

## 6. トラブルシュート

| 症状 | 対処 |
|------|------|
| allowlist を入れたのに RUN が減らない | Auto-Run が **Allowlist** か確認。Sandbox モードで allowlist 無視の報告あり → §2 手順 4 |
| 1 コマンドで RUN が 2 回 | サンドボックス失敗 → Run。§3-4どおり **初回 `all`** |
| 確認なのに `git status` だらけ | 依頼文に **D-1** の文言を付ける |

---

## 7. Cursor User Rules に追記する文案（任意）

Cursor **Settings → Rules** に次を追加すると、グローバルでも RUN が減りやすい。

```markdown
## Shell / RUN（YK）

- 確認・調査・引き継ぎの俯瞰: Shell 禁止。Glob / Read / Grep のみ。
- commit 調査: `git status`/`diff`/`log` は **1 本の Shell に `;` 連結**（並列 3 本は使わない）。初回からフル権限。
- 副作用が要るタスク（commit / push / test）のみ Shell。SSOT: `c:/yk-skill/rule/60_tooling/AGENT_SHELL_RULES.md`
```

`committing-changes-with-git` の「並列」と矛盾しないよう、**並列または 1 本連結**と読む。

---

## 8. メンテナンス

- allowlist 変更: **`cursor-permissions/permissions.json` のみ編集**（Symlink デプロイ時はローカルも即反映）
- 別 PC・Copy デプロイ時: 変更後に `Deploy-CursorPermissions.ps1 -Mode Copy` を再実行
- Cursor の Auto-Run UI 変更時: §2 を見直す
- 反映確認: Settings → Agents の Command Allowlist が読み取り専用 · 1 本の `git status` で RUN 有無
