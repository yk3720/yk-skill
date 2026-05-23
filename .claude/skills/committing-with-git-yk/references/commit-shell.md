# commit 実行（Windows / PowerShell）

**手順 SSOT:** Cursor User Rules `committing-changes-with-git`（調査 · amend 条件）· `c:/yk-skill/rule/60_tooling/AGENT_SHELL_RULES.md`（RUN 最小 · 初回 `all`）

## 推奨: メッセージファイル + `-F`

PowerShell では bash HEREDOC が使えない。**Cursor エージェントが Shell ツールで commit するとき**は、下記 **A（Write ツール）** を優先する。

### A. エージェント向け（推奨）— Write で UTF-8 ファイルを作る

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

2026-05-23 の実運用で発生した事象と対処。**詳細手順は本ファイルが SSOT**（`GIT_WORKFLOW` / User Rules は方針のみ）。

| 症状 | 原因 | 対処 |
|------|------|------|
| `トークン '&&' は...有効なステートメント区切りではありません` | PS 5.1 で `&&` 非対応 | `;` で連結するか、コマンドを分ける |
| Shell 実行直後に PowerShell の **パーサエラー**（日本語が文字化け・`UnexpectedToken`） | エージェントが **1 行の Shell 引数に日本語 commit 文を埋め込んだ**（`@(...)` · `-m "日本語"` 等） | **A. Write → `git commit -F`**。短い英語のみなら **2 つの `-m`** も可 |
| `Permission denied`（`.git/objects/...`）· `failed to insert into database` | Cursor **サンドボックス**が `.git` 書き込みを拒否 | Shell を **`required_permissions: ["all"]`** で再実行（`git_write` のみでは不足することがある） |
| `Unable to create '.git/index.lock': File exists` | 上記失敗の直後に **壊れた lock** が残った | 他の git プロセスが無いことを確認し、`index.lock` を削除してから **all** で add/commit をやり直す |
| `fatal: could not read log file '.../COMMIT_EDITMSG_YK.txt': No such file or directory` | **`git commit -F` より前に** メッセージファイルを削除した（マルチリポで先に片方だけ消した等） | メッセージを **Write で再作成** → `git commit -F` のみ再実行（**add はステージ済みなら不要**）→ 成功後に削除 |

### 履歴（失敗事例）

| 日付 | リポ | 症状 | 原因 | 結果 |
|------|------|------|------|------|
| 2026-05-23 | yk-memo | `could not read log file 'c:/yk-memo/.git/COMMIT_EDITMSG_YK.txt'` | yk-skill の commit/push **成功直後**に、エージェントが **yk-memo 用ファイルも含めて** `COMMIT_EDITMSG_YK.txt` を一括 Delete。yk-memo は **add 済み・commit 未実行**のままメッセージだけ消えた | メッセージ再 Write → `git commit -F` → push で **`788652b`** として成功。ステージは残っていたため add 不要 |

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
- `--no-verify` — ユーザー明示時のみ
- コミットメッセージに `.env` の値 · API キーを書かない
- エージェントの Shell に **日本語の長い here-string を渡さない**（B は手動端末向け）
- **`COMMIT_EDITMSG_YK.txt` を commit 前に Delete しない**（マルチリポで他リポ分を先に消さない）
