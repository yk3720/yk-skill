# YK スキル図（Mermaid）

**正本テキスト:** [SKILLS_INDEX.md](../SKILLS_INDEX.md) · [SKILL_CATALOG.md](../SKILL_CATALOG.md)

## 図一覧

| ファイル | 内容 | 読み順 |
|----------|------|--------|
| [skills-overview.mmd](./skills-overview.mmd) | 9 カテゴリ × 全スキル俯瞰 | 1 |
| [skills-routing-pairs.mmd](./skills-routing-pairs.mmd) | 図解受付・主要ペア関係 | 2 |
| [briefmap-skills-overview.html](../briefmap-skills-overview.html) | 上司向けブリーフ（HTML · 9カテゴリ俯瞰） | 3 |

## プレビュー

1. [Mermaid Live Editor](https://mermaid.live/) に `.mmd` を貼る
2. または（ローカル）:

```bash
npx -p @mermaid-js/mermaid-cli mmdc -i skills-overview.mmd -o _out/skills-overview.svg
```

## 更新タイミング

スキル追加・改名・カテゴリ変更時: `creating-skills` Step 8 または `managing-skills-yk` とあわせて本図を同期する。
