# commit 実行（Windows / PowerShell）

**手順 SSOT:** Cursor User Rules `committing-changes-with-git`（並列調査 · amend 条件）

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
# 成功後、COMMIT_EDITMSG_YK.txt は削除してよい（コミット履歴には残らない）
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

## 並列調査コマンド（status / diff / log）

User Rules どおり **1 コマンドずつ**、または **同一 Shell 内では `;` で連結**する。

```powershell
git -C "c:/yk-memo" status; git -C "c:/yk-memo" diff --stat; git -C "c:/yk-memo" log -5 --oneline
```

- **`&&` は使わない** — Windows PowerShell 5.1（Cursor 既定になりがち）では構文エラー。詳細は `rule/50_gas_html_test/PLAYWRIGHT_RULES.md` §10-1。

## push

ユーザーが **当ターンで push を明示**したときのみ。ネットワークが必要なため、commit と同様 **サンドボックスで失敗したら `all` で再試行**（下表）。

## トラブルシュート（Cursor エージェント · Windows）

2026-05-23 の実運用で発生した事象と対処。**詳細手順は本ファイルが SSOT**（`GIT_WORKFLOW` / User Rules は方針のみ）。

| 症状 | 原因 | 対処 |
|------|------|------|
| `トークン '&&' は...有効なステートメント区切りではありません` | PS 5.1 で `&&` 非対応 | `;` で連結するか、コマンドを分ける |
| Shell 実行直後に PowerShell の **パーサエラー**（日本語が文字化け・`UnexpectedToken`） | エージェントが **1 行の Shell 引数に日本語 commit 文を埋め込んだ**（`@(...)` · `-m "日本語"` 等） | **A. Write → `git commit -F`**。短い英語のみなら **2 つの `-m`** も可 |
| `Permission denied`（`.git/objects/...`）· `failed to insert into database` | Cursor **サンドボックス**が `.git` 書き込みを拒否 | Shell を **`required_permissions: ["all"]`** で再実行（`git_write` のみでは不足することがある） |
| `Unable to create '.git/index.lock': File exists` | 上記失敗の直後に **壊れた lock** が残った | 他の git プロセスが無いことを確認し、`index.lock` を削除してから **all** で add/commit をやり直す |

**再試行の順序（推奨）**

1. メッセージを **Write** で `<ROOT>/.git/COMMIT_EDITMSG_YK.txt` に出す  
2. `index.lock` があれば削除  
3. `git add` → `git commit -F` を **`all` 権限**で実行  
4. push も同様に **`all`**

## 禁止・注意

- `git commit --amend` — User Rules の条件をすべて満たすときのみ
- `--no-verify` — ユーザー明示時のみ
- コミットメッセージに `.env` の値 · API キーを書かない
- エージェントの Shell に **日本語の長い here-string を渡さない**（B は手動端末向け）
