# M2: 未使用・低使用スキルの分析

**前提:** Cursor にスキル利用回数の公式 API はない。回数は補助シグナルとして扱う。

## 手順

### 1. 候補の洗い出し

次を組み合わせて「要確認リスト」を作る:

| シグナル | 見方 |
|----------|------|
| `skill-usage.yaml` | `count_estimate` 低 · `last_used` 古い |
| `explicit_only: yes` | **意図的低頻度**（未使用≠不要） |
| `tier: nested` · `sample` | バンドル専用 · 本番外 |
| `SKILL_CATALOG` ペア表 | 代替スキルに統合済みの可能性 |
| `SKILLS_INDEX` | 発火が極端に狭い（例: 「私の文体で」のみ） |

任意（ユーザーが深掘りを望むとき）:

- `c:/yk-desk` 等の `agent-transcripts` を Grep（スキル名 · `Read` された SKILL パス）
- `yk-memo/handoffs` でスキル言及の有無

### 2. 理由分類（必ず 1 つ付ける）

| コード | 意味 | 典型対応 |
|--------|------|----------|
| **L** | 意図的低頻度（explicit_only · 季節 · 破壊的操作） | そのまま |
| **T** | 発火条件が狭い/悪い | `description` 見直し → creating-skills |
| **D** | 重複・代替あり | ペア統合を検討 |
| **N** | 不要の可能性 | ユーザー確認後に archive |
| **U** | 知らないだけ（索引不足） | SKILLS_INDEX · 本スキル M1 で足りる |

### 3. レポート形式

```markdown
## 未使用・低使用スキル分析（YYYY-MM-DD）

### 要アクション（T / D / N）
- `skill-name` — 分類: T — 理由: … — 提案: …

### 監視のみ（L / U）
- `skill-name` — 分類: L — 理由: …

### データ不足
- （transcript 未調査等）
```

### 4. usage 台帳の更新（任意）

ユーザーが「記録して」と言ったとき、または M2 完了時に `skill-usage.yaml` の `entries` を更新する。  
**自動カウントはしない**（誤差が大きいため）。

## Shell

transcript Grep はユーザーが「ログまで見て」と明示したときのみ。通常は Read / Grep（ワークスペース内）のみ。
