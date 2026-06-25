# 資料整理 — 読む範囲 Tier

## Tier 一覧

| Tier | いつ | Read 範囲 |
|------|------|-----------|
| **P**（デフォルト） | 「資料整合して」等 · プロジェクト指定 | 依頼リポの `docs/`（6 種）· ルート `AGENTS.md` · `docs/05_開発ガイドライン/decision-log.md`（または同等経緯索引） |
| **P+H** | 「handoffs も含めて」 | Tier P + `c:/yk-memo/handoffs/{slug}/`（HANDOFF 先頭表 · 最新セッション §4 · README 最新行） |
| **C** | **明示のみ** — 「四リポ横断」「横断 doc-sync」 | Tier P+H + 触れた `yk-skill/rule/` 該当 L1 · 四リポ間リンク · `handoffs/README.md` 横断行 |

**デフォルトは Tier P。** Tier を上げるのはユーザー明示または依頼文のキーワードのみ。

## 正本優先（矛盾時）

`PROJECT_DOCUMENT_RULES.md` に従い、次の順で優先する（下ほど狭い・具体的）:

1. **コード・コミット**（実装の真実）
2. **機能設計 SSOT**（例: ボタン一覧 · 方針 MD）
3. **AGENTS.md**（憲法・境界）
4. **decision-log**（経緯索引 — 1 行要約）
5. **handoffs 最新 §4**（次の 1 手 — 恒久方針は HANDOFF §6）

意味的矛盾で上記だけでは決められないときは **報告のみ**（独断で古い方を削除しない）。

## flowchart-studio の Tier P 目安

| パス | 役割 |
|------|------|
| `c:/yk-application/flowchart-studio/docs/02_機能設計/` | UI · ボタン · 方針 |
| `c:/yk-application/flowchart-studio/docs/05_開発ガイドライン/decision-log.md` | 経緯 |
| `c:/yk-application/flowchart-studio/AGENTS.md` | 憲法 |

## Read のしかた

- チェック項目ごとに **Grep**（`未着手` · `次:` · `実装` · 機能名）→ 該当ファイルだけ Read
- `AGENT_SHELL_RULES` — 確認・調査ターンでは Shell 禁止（Glob / Read / Grep のみ）
