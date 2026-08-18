# 作業ツリーのクリーン（YK）

**方針 SSOT:** `c:/yk-skill/rule/10_meta/GIT_WORKFLOW_RULES.md` §1 · §4（`reset --hard` は本モードに含めない）  
**secrets:** `c:/yk-skill/rule/10_meta/SECRETS_HYGIENE_RULES.md` §2

## 範囲

| やる（ユーザー OK 後） | やらない |
|------------------------|----------|
| `git clean -nd` の dry-run を見せてから `git clean -fd`（未追跡のみ） | `-x` / `-xf`（ignored の `.env` · `node_modules` 等） |
| 残骸: `COMMIT_EDITMSG_YK.txt`（当該リポで commit 待ちでなければ）· 他プロセス無しの `index.lock` | tracked の破棄（`restore` · `reset --hard`）— 「破棄して」「リセットして」が別途あるときだけ `GIT_WORKFLOW` §4 |
| secrets っぽい未追跡は **消さず報告** | 一覧を出さずに実行 |

## 調査（1 本 · `;` 連結 · 初回 `all`）

```powershell
git -C "<ROOT>" status --short; git -C "<ROOT>" clean -nd
```

dry-run が空で status もクリーンなら、残骸ファイルの有無だけ確認して終了する。

## 実行

1. 消すパスの一覧をユーザーに出す（dry-run + 残骸）
2. OK を得てから `git clean -fd`（必要なときだけ残骸を削除）
3. 再 `status --short` で残件を報告する

## 完了報告

```text
リポ: <name> (<ROOT>)
クリーン: 実施 / 対象なし / スキップ（理由）
消したもの: <パス要約> または なし
残件: クリーン / tracked 変更あり（破棄していない）
```
