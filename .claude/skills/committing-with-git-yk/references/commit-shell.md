# commit 実行（Windows / PowerShell）

**手順 SSOT:** Cursor User Rules `committing-changes-with-git`（調査 · amend 条件）· `c:/yk-skill/rule/60_tooling/AGENT_SHELL_RULES.md`（RUN 最小 · 初回 `all`）

## 引き継ぎ終了 Phase C — RUN 最小（最優先）

| やる | やらない |
| ---- | -------- |
| **Bash 1 本/リポ:** `add && commit && push` | Phase B 単独 `git status` Shell |
| 2 リポ → **2 Run**（並列送信可） | Post-C 専用 commit（hash 同期の 2 回目 push） |
| hash は **完了報告**に載せる（方式 A） | PowerShell の `$(cat <<'EOF'...)` |

詳細: [handoff-session-work/references/git-save.md](../handoff-session-work/references/git-save.md)

---

## 最優先: Bash ツール + HEREDOC（add→commit→push を 1 コール）

**PowerShell ツールで HEREDOC は使わない** — 構文エラーで Run が倍化する。PowerShell では **`-m` 1 行** または **Write + `git commit -F`**。

```bash
cd "c:/yk-application/flowchart-studio" && git add file1 file2 && git commit -m "$(cat <<'EOF'
feat(scope): 日本語の要約

なぜこの変更か（日本語 1〜2 文）。
EOF
)" && git push origin main
```

**マルチリポ:** メッセージが異なるため、リポごとに別の Bash コール（並列実行可）。3 リポ = 3 コールで完了。

**許可設定:** `cursor-permissions/permissions.json`（Tier B）を `Deploy-CursorPermissions.ps1` で `~/.cursor/` にデプロイ済みなら、Agents の Command Allowlist 経由で RUN 省略可。Claude Code は別途 `settings.json` allow。

---

## 代替: メッセージファイル + `-F`（Bash ツールが使えない場合）

PowerShell では bash HEREDOC が使えない。**PowerShell ツールで commit するとき**は、下記 **A（Write ツール）** を使う。

### A. エージェント向け（PowerShell 用）— Write で UTF-8 ファイルを作る

日本語本文を **Shell コマンド文字列に直接書かない**（後述「トラブルシュート」）。エディタの **Write** で次を作成し、`git commit -F` する。

```text
<ROOT>/.git/COMMIT_EDITMSG_YK.txt   # 例: c:/yk-memo/.git/COMMIT_EDITMSG_YK.txt
```

```text
feat(scope): 日本語の要約

なぜこの変更か（日本語 1〜2 文）。
```

```powershell
git -C "c:/yk-memo" add <paths...>
git -C "c:/yk-memo" commit -F "c:/yk-memo/.git/COMMIT_EDITMSG_YK.txt"
git -C "c:/yk-memo" status
# 成功後のみ COMMIT_EDITMSG_YK.txt を削除（commit 前に消すと失敗 — 下記「履歴」）
```

### B. 手動 PowerShell — ローカル端末のみ

ユーザーが **自分の PowerShell ウィンドウ**で実行する場合のみ、UTF-8 一時ファイルでも可。

```powershell
$root = "c:/yk-tool"
$msgFile = Join-Path $env:TEMP "yk-commit-msg.txt"
@(
  "feat(publish): 図解 HTML 正本を yk-tool に移行"
  ""
  "yk-memo から publish へ物理移行するため。"
) | Set-Content -Path $msgFile -Encoding utf8
git -C $root commit -F $msgFile
```

- 1 行のみのときは配列 1 要素でよい
- 本文なしのときは空行・2 行目以降を省略

## 代替: 2 つの `-m`

短いメッセージのみのとき:

```powershell
git -C $root commit -m "feat(scope): 日本語の要約" -m "なぜこの変更か（日本語）"
```

## マルチリポ 1 ターン完結パターン（Bash ツール）

リポごとに Bash コールを並列送信すれば 1 ターンで複数リポを commit+push できる。

```bash
# yk-application/flowchart-studio
cd "c:/yk-application/flowchart-studio" && git add FILE && git commit -m "$(cat <<'EOF'
feat: 変更A
EOF
)" && git push origin main
```

```bash
# yk-skill（並列で送信）
cd "c:/yk-skill" && git add FILE && git commit -m "$(cat <<'EOF'
rule: 変更B
EOF
)" && git push origin main
```

---

## 調査コマンド（status / diff / log）— RUN 最小

**YK 既定:** 対象リポごとに **1 本の Shell** に `;` で連結（**並列 3 本は使わない**）。**初回から `required_permissions: ["all"]`**。

```powershell
git -C "c:/yk-memo" status; git -C "c:/yk-memo" diff --stat; git -C "c:/yk-memo" log -5 --oneline
```

マルチリポ（例: yk-memo + yk-skill）も **1 本にまとめる**:

```powershell
git -C "c:/yk-memo" status; git -C "c:/yk-skill" status
```

- **`&&` は使わない** — Windows PowerShell 5.1（Cursor 既定になりがち）では構文エラー。詳細は `rule/50_gas_html_test/PLAYWRIGHT_RULES.md` §10-1。
- User Rules の「並列調査」と両立: **並列 Shell 3 本または 1 本連結のどちらか** — YK では **1 本連結を優先**。

## add / commit / push

**初回 Shell から `required_permissions: ["all"]`**（サンドボックス → 失敗 → 再 RUN を避ける）。

push はユーザーが **当ターンで push を明示**したときのみ。commit と **同じターン**なら add → commit → push を **1 本の `;` 連結**してよい。

**マルチリポ:** リポ **ごとに** Write → add → commit →（push）→ **そのリポのメッセージファイル削除** の順。別リポの `COMMIT_EDITMSG_YK.txt` を commit 前に消さない。

## トラブルシュート（Cursor エージェント · Windows）

実運用で発生した事象と対処（2026-05-23 初版 · 2026-06-11 追記）。**詳細手順は本ファイルが SSOT**（`GIT_WORKFLOW` / User Rules は方針のみ）。

| 症状 | 原因 | 対処 |
|------|------|------|
| `トークン '&&' は...有効なステートメント区切りではありません` | PS 5.1 で `&&` 非対応 | `;` で連結するか、コマンドを分ける |
| Shell 実行直後に PowerShell の **パーサエラー**（日本語が文字化け・`UnexpectedToken`） | エージェントが **1 行の Shell 引数に日本語 commit 文を埋め込んだ**（`@(...)` · `-m "日本語"` 等） | **A. Write → `git commit -F`**。短い英語のみなら **2 つの `-m`** も可 |
| commit は成功するがメッセージが **`????`** になる | Shell の **here-string / パイプ**で `git commit -F -` に渡した（`@"..."@ \| git commit -F -` 等） | **A. Write → `git commit -F <path>`** に切り替え。文字化け済みなら User Rules の amend 条件を満たすとき **`git commit --amend -F <path>`** |
| `check for merge conflicts` / `detect private key` 等が **`[WinError 4551] アプリケーション制御ポリシーによってこのファイルがブロックされました`** で失敗 | **pre-commit フックランナー**（`pre-commit.exe`）が Cursor エージェントまたは OS ポリシーにより実行不可（コード不備ではない） | [§ pre-commit OS ブロック](#pre-commit-os-ブロック) |
| **Windows セキュリティ**「`pre-commit.exe` の発行元を確認できないためブロック」 | 同上（ローカル端末で pip 由来の未署名 `pre-commit.exe` が Smart App Control 等に拒否される） | ユーザー: **詳細情報** → 実行を許可 · または `python -m pre_commit` で代替確認 · ダメなら [§ pre-commit OS ブロック](#pre-commit-os-ブロック) |
| `Permission denied`（`.git/objects/...`）· `failed to insert into database` | Cursor **サンドボックス**が `.git` 書き込みを拒否 | Shell を **`required_permissions: ["all"]`** で再実行（`git_write` のみでは不足することがある） |
| `Unable to create '.git/index.lock': File exists` | 上記失敗の直後に **壊れた lock** が残った | 他の git プロセスが無いことを確認し、`index.lock` を削除してから **all** で add/commit をやり直す |
| `fatal: could not read log file '.../COMMIT_EDITMSG_YK.txt': No such file or directory` | **`git commit -F` より前に** メッセージファイルを削除した（マルチリポで先に片方だけ消した等） | メッセージを **Write で再作成** → `git commit -F` のみ再実行（**add はステージ済みなら不要**）→ 成功後に削除 |

### pre-commit OS ブロック

`QUALITY_GATE_RULES` §3「Windows で pre-commit がブロックされたとき」と同一。**`--no-verify` とは別** — ブロックされた **hook-id のみ** `SKIP` する。

**恒久対処（人間 · 先に実施）:** Windows セキュリティ → ウイルスと脅威の防止 → 設定の管理 → **除外** → フォルダ `%USERPROFILE%\.cache\pre-commit`。確認: `python -m pre_commit run detect-private-key --all-files` が Passed。

| hook | SKIP 前の手動確認 |
|------|-------------------|
| `check-merge-conflict` | Grep: `<<<<<<<` / `=======` / `>>>>>>>` がステージに無い |
| `detect-private-key` | Grep: `BEGIN OPENSSH PRIVATE KEY` / `BEGIN RSA PRIVATE KEY` 等が無い |
| `ruff-check` / `ruff-format` | `ruff check` / `ruff format` を手動実行 |

```powershell
$env:SKIP = 'check-merge-conflict,detect-private-key'
git -C "c:/yk-application/flowchart-studio" commit -F "c:/yk-application/flowchart-studio/.git/COMMIT_EDITMSG_YK.txt"
Remove-Item Env:SKIP
```

### 履歴（失敗事例）

| 日付 | リポ | 症状 | 原因 | 結果 |
|------|------|------|------|------|
| 2026-05-23 | yk-memo | `could not read log file 'c:/yk-memo/.git/COMMIT_EDITMSG_YK.txt'` | yk-skill の commit/push **成功直後**に、エージェントが **yk-memo 用ファイルも含めて** `COMMIT_EDITMSG_YK.txt` を一括 Delete。yk-memo は **add 済み・commit 未実行**のままメッセージだけ消えた | メッセージ再 Write → `git commit -F` → push で **`788652b`** として成功。ステージは残っていたため add 不要 |
| 2026-06-11 | yk-tool | メッセージが `????` · `check-merge-conflict` が WinError 4551 | `@"..."@ \| git commit -F -` を使用 · エージェント環境で pre-commit フックが OS によりブロック | Grep で競合マーカー確認後 `SKIP=check-merge-conflict` で commit → Write + `amend -F` でメッセージ修正 → push 成功（**`3b8fb2e`**） |
| 2026-06-25 | flowchart-studio | `detect-private-key` が WinError 4551 · ローカルで Windows セキュリティが `pre-commit.exe` をブロック | pip 由来の未署名 `pre-commit.exe` · Defender が `\.cache\pre-commit` をブロックするケースあり | **Defender 除外** `%USERPROFILE%\.cache\pre-commit` で `detect-private-key` Passed · 一時は `SKIP` · CI は `quality` ジョブで pre-commit 相当を実行 |

**教訓:** `COMMIT_EDITMSG_YK.txt` の削除は **当該リポで `git commit` が成功したあと**のみ。並列 Delete や「片方成功したら両方消す」は禁止。

**commit 1 リポの Shell 例（RUN 1 回 + Write）**

1. **Write** で `<ROOT>/.git/COMMIT_EDITMSG_YK.txt`  
2. **Shell（`all`）1 本:**

```powershell
git -C "c:/yk-memo" add <paths...>
git -C "c:/yk-memo" commit -F "c:/yk-memo/.git/COMMIT_EDITMSG_YK.txt"
git -C "c:/yk-memo" status
```

3. push 依頼があれば **続けて 1 本**（または上記に `; git -C ... push` を足す）  
4. **commit 成功後**にのみ `COMMIT_EDITMSG_YK.txt` を Delete  
5. `index.lock` が残っていれば削除してから再実行

**マルチリポの正しい順（例: yk-skill → yk-memo）**

1. Write `yk-skill/.git/COMMIT_EDITMSG_YK.txt` → add → commit → push → Delete **yk-skill のみ**  
2. Write `yk-memo/.git/COMMIT_EDITMSG_YK.txt` → add → commit → push → Delete **yk-memo のみ**

## 禁止・注意

- `git commit --amend` — User Rules の条件をすべて満たすときのみ
- `--no-verify` — ユーザー明示時のみ（**全体の hook 回避**）
- `SKIP=<hook-id>` — **WinError 4551 または Windows セキュリティで pre-commit がブロックされたときのみ**（上記 [§ pre-commit OS ブロック](#pre-commit-os-ブロック) の手動確認後 · ブロックされた hook-id ごと · カンマ区切り可）
- コミットメッセージに `.env` の値 · API キーを書かない
- エージェントの Shell に **日本語の長い here-string を渡さない**（`git commit -F -` へのパイプ含む · B は手動端末向け）
- **`COMMIT_EDITMSG_YK.txt` を commit 前に Delete しない**（マルチリポで他リポ分を先に消さない）
