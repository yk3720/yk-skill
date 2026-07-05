# M1: 一覧・説明

## 手順

1. `SKILLS_INDEX.md` を Read（カテゴリ全体の回答）
2. 質問が特定スキル名・用途に絞られるとき:
   - `SKILL_CATALOG.md` で tier · `explicit_only` · ペアを確認
   - 必要なら `.claude/skills/<name>/SKILL.md` の `description` を Read
3. ユーザーに返す内容:
   - **該当スキル名**（バッククォート）
   - **発火キーワード**（description から · 要約でよい）
   - **`explicit_only`** なら「ユーザーが明示したときのみ」と明記
   - **似たスキル**があればペア表から 1 行で区別
   - **おすすめ**があれば理由付きで 1 つ

## 質問パターン

| ユーザー意図 | 返し方 |
|-------------|--------|
| 全部知りたい | カテゴリごとに件数 + 代表スキル 2〜3 件 · 詳細は `SKILLS_INDEX` 参照を案内 |
| 図解 / メール / テスト 等 | `skill-categories.yaml` の該当カテゴリを列挙 |
| A と B の違い | `SKILL_CATALOG` のペア表 + 各 `description` の Do NOT |
| いつ起動するか | `description` の発火例をそのまま要約（捏造しない） |

## やらないこと

- `SKILL_CATALOG.md` を書き換えない
- description にない発火条件を invent しない
- 37 件すべてを毎回ダンプしない（質問に応じて絞る）

## Shell

不要。Glob / Read / Grep のみ。
