# M3: スキル健康診断・改善提案

**修正の実行は `creating-skills` に委譲する。** 本モードは提案まで。

## 手順

1. 対象を確定（全スキル / 1 スキル / M2 の要アクションリスト）
2. 各 `SKILL.md` について `c:/yk-skill/rule/10_meta/SKILL_AUTHORING_RULES.md` の要点でチェック:

| 観点 | 確認 |
|------|------|
| description | 発火例 · Do NOT · 三人称 · 1024 字以内 |
| name | フォルダ名一致 |
| 簡潔さ | SKILL.md 500 行以内 · 詳細は references |
| SSoT | ハードコードされた古いパス · 二重管理 |
| 境界 | 類似スキルとの Do NOT が効いているか |

3. `SKILL_CATALOG` ペア表と矛盾する description がないか
4. `skill-categories.yaml` に name があるか（新規漏れ）
5. `SKILLS_INDEX.md` と description のズレ

## 出力

```markdown
## スキル健康診断

### 優先度高
- `name` — 問題 — 提案修正

### 優先度中
…

### 次アクション
- 修正する場合: 「`creating-skills` で ○○ を改善」とユーザーに確認
- 台帳のみ: `managing-skills-yk` で SKILL_CATALOG 再生成
```

## 委譲

| ユーザー依頼 | 先 |
|-------------|-----|
| 提案どおり直して | `creating-skills`（Step 0〜8） |
| 台帳だけ更新 | `managing-skills-yk` |
| 1 スキルだけ description 修正 | `creating-skills` |

## Shell

不要（Read のみ）。
