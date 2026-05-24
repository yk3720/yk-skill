---
name: creating-pythoncode-yk
description: Pythonのコードを作成・更新・改善するスキル。「ツールを作って」「pythonでコードを書いて」「ツールを検討して」など依頼された際に使用する。Do NOT use for non-Python stacks only (use domain-specific skills instead).
paths: "**/*.py"
---

# Creating Python Code

**品質方針:** 時間より品質。ゲート未通過の完了報告は禁止。

## Step 0: ルールを読む（必須・この順）

1. **`c:/yk-skill/rule/40_python/PYTHON_RULES.md`** — 実務 SSOT（毎回・最初）
2. **本 SKILL.md** — 手順
3. **[references/ROUTER.md](references/ROUTER.md)** — tier / tag / 読むファイルの決定（**ロード規則の SSOT**）
4. **`references/`** — **Ref Plan（Step 0.1）に列挙したファイルのみ** Read（全件禁止）

人間向け rev アーカイブ: `c:/1.cursor/5.Python/0.ルール・操作方法/`（都度・必要時のみ）

---

## Step 0.1: Ref Plan（コード編集前・必須ゲート）

**Write / StrReplace の前に**、チャットへ Ref Plan を出力する。未出力のまま実装しない。  
**質問のみ・Read だけでコードを変えない**ときは不要。

tier の決め方 → [references/ROUTER.md](references/ROUTER.md) §2〜§4。**迷ったら Standard**（過小な Light 禁止）。

### Light（1〜2ファイル・typo/局所1点・境界変更なし）

ROUTER §2 の Light 条件を満たすときだけ。`tags` / `skip` / `ids` は **省略可**。

```markdown
## Ref Plan
- tier: Light（理由1行）
- load: ssot-audit.md
```

Light でも ROUTER §2「KB03 を足す条件」に当てはまるときは tier を **Standard に上げ**、下記フル形式を使う。

### Standard / Full

```markdown
## Ref Plan
- tier: Standard | Full（理由1行）
- tags: （該当なしなら「なし」）
- load: （Read する references を列挙）
- skip: （読まないものと理由・1行以上）
- ids: （K-ID / T-ID があれば）
```

テンプレ例 → ROUTER §7。

---

## references カタログ（Read は Ref Plan 経由）

ルーティングは **ROUTER.md のみ** に書く。ここは存在確認用。

- **ルータ:** [ROUTER.md](references/ROUTER.md)
- **規律:** [Python_1](references/Python_1_開発規律.md) · [Rules_1](references/Rules_1.md) · [Rules_2](references/Rules_2.md)
- **ゲート:** [ssot-audit](references/ssot-audit.md) · [deadline-protocol](references/deadline-protocol.md) · [exemplar](references/exemplar.md)
- **KB:** [01目次](references/Python_2_技術ナレッジベース_01_目次.md) · [02](references/Python_2_技術ナレッジベース_02_共通品質.md) · [03](references/Python_2_技術ナレッジベース_03_監査・地雷回避.md) · [04](references/Python_2_技術ナレッジベース_04_環境・配布.md) · [05](references/Python_2_技術ナレッジベース_05_外部連携.md) · [06](references/Python_2_技術ナレッジベース_06_Excel連携.md) · [07](references/Python_2_技術ナレッジベース_07_Streamlit.md)
- **テンプレ:** [3](references/Python_3_テンプレート_プロジェクト仕様書.md)〜[8](references/Python_8_テンプレート_clean.py.md) · [設計墓場](references/Python_9_設計墓場・廃止規律記録.md) · [ファイル構成](references/ファイル構成について.md) · [memo](references/memo_操作方法.md)

---

## 作業プロセス

### Step 0.25: 三層監査（抽出 → 写経 → 検挙）

`PYTHON_RULES.md` §5 に従う。

### Step 0.5: 開発期日（該当時）

tag `deadline` → `deadline-protocol.md` を Ref Plan に含める。

### Step 1: 指示を固定

目的 · 対象 · 制約 · 成功条件（不明は「不明」と明記）。

### Step 2: 変更方針

変えないものを先に決める。最小差分。`PYTHON_RULES.md` §2 遵守。

### Step 3: 実装

- 新規: 骨格 → 最短経路 → 境界 → 仕上げ
- 修正: 再現 → 原因 → 最小修正 → 回帰防止

### Step 4: 品質ゲート

`PYTHON_RULES.md` §7。Full なら `exemplar.md` も（Ref Plan に含めること）。

### Step 5: SSoT 監査（完了の必須ゲート）

`ssot-audit.md`（Ref Plan の floor に含まれること）。

### Step 6: 完了報告

`PYTHON_RULES.md` §8 の tier。**読んだ refs** を1行以上明記。

---

索引: [references/README.md](references/README.md) · 他言語の同型設計: `yk-skill/rule/10_meta/PROGRESSIVE_CONTEXT_ROUTING_RULES.md`
