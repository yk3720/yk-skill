# diagrams — 45_mermaid

| ファイル | 主題 | 読み順 |
|----------|------|--------|
| [`overview.mmd`](overview.mmd) | Mermaid ルール適用時の SDD フロー概要 | 1 |

## エージェント入口

`.mmd` 編集時: `c:/yk-skill/.cursor/rules/mermaid-dev-entry.mdc` → `MERMAID_RULES.md` · `creating-mermaid-yk`

## プレビュー

1. [Mermaid Live Editor](https://mermaid.live/) に `overview.mmd` を貼り付け
2. または（`test` 明示時）リポルートから:

```bash
npx -p @mermaid-js/mermaid-cli mmdc -i rule/45_mermaid/diagrams/overview.mmd -o rule/45_mermaid/diagrams/_out/overview.svg
```

正本は `.mmd`。生成 SVG は `_out/`（任意・Git 追跡はプロジェクト方針に従う）。
