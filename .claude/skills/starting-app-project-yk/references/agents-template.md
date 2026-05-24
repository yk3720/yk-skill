# AGENTS.md テンプレート

企画フォルダ直下に Write。`{...}` をプロジェクト値で置換。**500 行未満。**

---

```markdown
# AGENTS.md — {プロダクト名}

エージェント向け憲法。**境界 · SSOT · 再開手順**（500行未満）。

| 項目 | 値 |
|------|-----|
| **handoffs slug** | `{slug}` |
| **企画フォルダ** | `{企画フォルダ絶対パス}` |
| **更新** | {YYYY-MM-DD} |

---

## プロダクトの一文

{一文}

---

## 再開（毎セッション · この順）

1. [`handoffs/{slug}/HANDOFF.md`](c:/yk-memo/handoffs/{slug}/HANDOFF.md)
2. **最新セッション MD §4 だけ**
3. 本ファイル

```text
@c:/yk-memo/handoffs/{slug}/HANDOFF.md
@c:/yk-memo/handoffs/{slug}/{最新セッション}.md
@{企画フォルダ}/AGENTS.md
続きから。§4 の1件だけ。終わったら止めて報告。
```

**仕様疑問時のみ:** `{主要仕様MD}` · `{ADR.md}`

---

## コード置き場

| 用途 | パス |
|------|------|
| 実装 | `{コードパス}` |

```{shell}
{dev/test コマンド}
```

---

## やる / やらない

| やる | やらない |
|------|----------|
| {やる} | {やらない} |

---

## SSOT マップ

| ドメイン | 正本 |
|----------|------|
| セッション §4 | `handoffs/{slug}/` |
| 概要 | `01_product/プロジェクト概要.md` |
| 完成定義 | `01_product/完成チェックリスト.md` |
| 仕様 | `02_spec/データモデル.md` |
| ADR | `04_decisions/意思決定記録(ADR).md` |

---

## ルール · スキル

- No **17** `APP_PROJECT_RULES.md`
- スタック: `RULE_INDEX` No {列挙}
- 引き継ぎ: `handoff-session-work`

---

## 禁止 · 注意

- commit / push — ユーザー明示まで
- 企画フォルダにセッション進捗 SSOT を置かない
- {プロジェクト固有の禁止}
```

---

## 必須項目チェック

- [ ] slug · 企画パス · 更新日
- [ ] 再開 3 ファイル（HANDOFF · §4 · AGENTS）
- [ ] やる/やらない（10 行以内目安）
- [ ] SSOT マップ（セッションは handoffs のみ）
- [ ] No 17 へのリンク
