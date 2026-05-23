# commit 実行（Windows / PowerShell）

**手順 SSOT:** Cursor User Rules `committing-changes-with-git`（並列調査 · amend 条件）

## 推奨: メッセージファイル + `-F`

PowerShell では bash HEREDOC が使えないため、**UTF-8 一時ファイル**を使う。

```powershell
$root = "c:/yk-tool"   # 対象ルートに置換
$msgFile = Join-Path $env:TEMP "yk-commit-msg.txt"
@(
  "feat(publish): 図解 HTML 正本を yk-tool に移行"
  ""
  "yk-memo から publish へ物理移行するため。"
) | Set-Content -Path $msgFile -Encoding utf8

git -C $root add <paths...>
git -C $root commit -F $msgFile
Remove-Item $msgFile -ErrorAction SilentlyContinue
git -C $root status
```

- 1 行のみのときは配列 1 要素でよい
- 本文なしのときは空行・2 行目以降を省略

## 代替: 2 つの `-m`

短いメッセージのみのとき:

```powershell
git -C $root commit -m "feat(scope): 日本語の要約" -m "なぜこの変更か（日本語）"
```

## 禁止・注意

- `git commit --amend` — User Rules の条件をすべて満たすときのみ
- `--no-verify` — ユーザー明示時のみ
- コミットメッセージに `.env` の値 · API キーを書かない
