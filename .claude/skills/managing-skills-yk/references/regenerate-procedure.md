# 台帳再生成手順

[catalog-schema.md](catalog-schema.md) の列定義に従い `SKILL_CATALOG.md` を上書きする。

## 1. 収集

`c:/yk-skill` で `SKILL.md` を列挙（除外: `node_modules` · `.git`）。

PowerShell 例:

```powershell
Get-ChildItem -Path "c:\yk-skill\.claude\skills","c:\yk-skill\sample" -Filter "SKILL.md" -Recurse -File |
  Where-Object { $_.FullName -notmatch '\\node_modules\\|\\\.git\\' } |
  Sort-Object FullName
```

## 2. 各行の機械抽出

各 `SKILL.md` について:

1. 先頭 YAML（`---` 〜 `---`）を Read
2. `name:` · `disable-model-invocation:` を取得
3. `skill_path` = フルパスから `c:/yk-skill/` を除いた相対（`\` → `/`）
4. `tier` · `canonical` は [catalog-schema.md](catalog-schema.md) の規則で判定
5. `notes` は重複・親子・要整理があるときだけ 1 行

## 3. 並べ替え

- 本番表: `tier`（L1 → nested）→ `name` 昇順
- sample 表: `name` 昇順

## 4. 書き込み

`c:/yk-skill/metadata/SKILL_CATALOG.md` を **全文置換**。

ヘッダに **最終更新**（作業日）· **件数**（L1 / nested / sample）を記載。

## 5. 完了報告（ユーザー向け）

- 件数サマリ
- `canonical=no` の一覧（重複）
- sample 件数
- `yk-tool/catalog.yaml` とは別物である旨 1 行
