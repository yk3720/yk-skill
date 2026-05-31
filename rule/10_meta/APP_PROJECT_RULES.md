# 個人アプリ開発プロジェクト規則
## App Project Lifecycle — YK 共通 v1

**用途:** 個人開発 × AI 支援で **新規アプリを始める · 企画フォルダを整える · 再開する** ときの横断 SSOT。  
**ステータス:** active（L1 · スキル `starting-app-project-yk` v1 — 実例 1 件）  
**関連:** `10_meta/AI_DRIVEN_RULES.md`（行動指針）· スキル `handoff-session-work` · `RULE_INDEX.md` No 17  
**実例:** [flowchart-web 企画 + AGENTS.md](c:/yk-memo/00.ai-driven-school/個人テーマ_フローチャートアプリ/AGENTS.md)

**最終更新:** 2026-05-31

---

## 13. 企画ドキュメント種別（経緯 · 合意 · 2026-05-31）

**実例:** [flowchart-web decision-log](c:/yk-memo/00.ai-driven-school/個人テーマ_フローチャートアプリ/04_decisions/decision-log.md)

| 種別 | パターン | 正本 | 載せる内容 |
|------|----------|------|------------|
| **経緯索引** | `04_decisions/decision-log.md` | 企画 | タイムライン · リンク · 1 行要約のみ（本文コピー禁止） |
| **ADR** | `04_decisions/意思決定記録(ADR).md` または `ADR-NNN-*.md` | 企画 | Accepted 技術・プロダクト決定 |
| **grill-me** | `01_product/grill-me_{YYYY-MM-DD}_{論題}.md` | 企画 | 対話 Q&A · 未決 · 優先順位（`相談_*` は同義 · 新規は `grill-me_` 推奨） |
| **調査** | `01_product/調査_{テーマ}.md` | 企画 | 調査結果 · 比較（決定前） |
| **計画** | `01_product/計画_{YYYY-MM-DD}_{論題}.md` | 企画 | 相談→実装の分解 · §4 候補 |
| **セッション** | `handoffs/{slug}/*.md` | handoffs | §4 = 次の 1 件 · 作業記録 |

**昇格ルール（MUST）**

1. grill-me で **Accepted** → ADR + decision-log 1 行  
2. grill-me で **未決** → grill-me §4 のみ（ADR に書かない）  
3. セッション終了 → decision-log 1 行 · handoff §1 要約（ADR 全文コピー禁止）  
4. **戦略 vs 戦術** — 方針合意（grill-me）と §4 実行タスクがズレても正常。decision-log で両方リンクする  

**報告用:** 最終報告は `00_theme/報告書_*`（将来）← decision-log から要約転記。詳細は ADR · grill-me · handoffs へ委譲。

---

## 1. 解く問題

| 症状 | 原因 |
|------|------|
| 再開のたびに AI が迷う | 企画フォルダと handoffs の **二重 SSOT** |
| スコープ爆発 | PRD 全文を 1 プロンプトに渡す · 完成チェックリスト一括依頼 |
| 進捗が信頼できない | `再開メモ` · 手動確認 · handoffs の **日付・定義の不一致** |
| ルールが散在 | スタック rule（No 31–35）と **プロジェクトの置き方** が未分離 |

**目標:** 企画（安定）· セッション（毎回）· 憲法（境界）を分離し、**再開は handoffs §4 の 1 件だけ**。

---

## 2. 三層モデル（MUST）

| 層 | 置き場 | 更新頻度 | 載せる内容 |
|----|--------|----------|------------|
| **Product Spec** | `yk-memo/.../{企画フォルダ}/` | 低 | 概要 · MVP · データモデル · ADR · 完成定義 |
| **Session Handoff** | `yk-memo/handoffs/{slug}/` | 毎セッション | HANDOFF + セッション MD（**§4 = 次の 1 件**） |
| **Agent Constitution** | 企画フォルダ **`AGENTS.md`** | 低 | 境界 · SSOT マップ · 再開 3 ファイル · やる/やらない |

```text
Product Spec（何を作るか）
    ↓ 参照
Session Handoff（今回 1 件）
    ↓ 境界確認
AGENTS.md → コード（yk-tool 等）
```

**MUST NOT:** 企画フォルダに **セッション進捗 SSOT**（次の 1 件 · git 状態 · 完了記録）を置く。  
**MUST NOT:** handoffs に **恒久仕様全文**（データモデル · 列定義）をコピーする — パスリンクのみ。

---

## 3. リポジトリ役割

| ルート | 役割 |
|--------|------|
| `c:/yk-memo` | 企画フォルダ · **`handoffs/`** |
| `c:/yk-tool` | Web/ツール **実装**（別アプリ = 別ディレクトリ） |
| `c:/yk-skill` | **本 rule** · スタック rule · スキル |
| `c:/1.cursor/5.Python` | Python デスクトップ（rev 積層保護） |

横断パス SSOT → `RULE_INDEX.md` §リポジトリマップ

---

## 4. 新規アプリ開始チェックリスト

ユーザーが「新しいアプリを始める」とき、エージェントは次を **順に** 提案・実施する（ユーザー OK 後）。

| # | 成果物 | MUST |
|---|--------|------|
| 1 | **handoffs slug** 決定（小文字 · ハイフン） | ユーザー確認。推測で新 slug を作らない |
| 2 | `handoffs/{slug}/HANDOFF.md` 初版 | 企画パス · コードパス · §6 ロードマップ |
| 3 | 企画フォルダ（`yk-memo/.../`） | README · プロジェクト概要 · MVP または完成定義 |
| 4 | 企画フォルダ **`AGENTS.md`** | §5 テンプレ準拠 · 500 行未満 |
| 5 | slug ↔ 企画フォルダ **対応 1 行** | HANDOFF 表 · AGENTS 表 |
| 6 | `handoffs/README.md` プロジェクト一覧に 1 行 | routing.md §既知プロジェクト例 と同期 |
| 7 | スタック rule | `RULE_INDEX` クイック入口（No 31–35 等） |

**任意（規模が大きいとき）:** `99_archive/research/` · 浅い `01_product/` `02_spec/` 階層 — §6。

---

## 5. AGENTS.md 必須項目

各アプリの `AGENTS.md` に **次を含める**（プロジェクト固有値で埋める）。

| 節 | 内容 |
|----|------|
| メタ | handoffs slug · 企画フォルダパス · 更新日 |
| 再開 | HANDOFF → 最新セッション §4 → 本ファイル（3 ファイル） |
| コード置き場 | リポ · パス · dev コマンド |
| やる / やらない | スコープ境界（10 行以内が目安） |
| SSOT マップ | ドメイン別正本 1 表 |
| スタック rule | `RULE_INDEX` から該当 No のみ |
| 禁止 | commit 方針 · 企画への進捗書き戻し禁止 |

**コピペ用ラッパ:** 企画フォルダ `新チャット依頼.md` は **handoffs + AGENTS** の短い依頼文のみ（長文 PRD 禁止）。

---

## 6. 企画フォルダ推奨構成（個人 · 浅い階層）

**標準（2026-05-24〜）:** 企画が増える前提で **番号付きサブフォルダ**を使う。索引はルート `README.md` のみ。

```text
{企画フォルダ}/
├── README.md              # 唯一の索引
├── AGENTS.md              # 憲法（ルート固定）
├── 新チャット依頼.md       # 薄いラッパ（ルート固定）
├── 再開メモ.md             # 廃止 stub 可（handoffs へ）
├── 01_product/            # 概要 · MVP · 完成定義 · アクティブ UX 調査
├── 02_spec/               # データモデル · 画面 · 技術方針 · 列の意味
├── 03_plan/               # フェーズ計画
├── 04_decisions/          # ADR · decision-log（経緯索引）
└── 99_archive/
    ├── research/          # 立ち上げ期調査（再開時は読まない）
    └── evidence/          # 手動確認スナップショット
```

**複数プロジェクト:** `yk-memo/00.ai-driven-school/README.md` にプロジェクト一覧 · slug 対応表。

**移行:** フラット 18 ファイル → 上記へ。実例: [flowchart-web 企画](c:/yk-memo/00.ai-driven-school/個人テーマ_フローチャートアプリ/)。

**読む順序（再開時 · 3 ファイル）:** handoffs HANDOFF → 最新 §4 → `AGENTS.md`（ルート）。  
**読む順序（仕様疑問時）:** `02_spec/データモデル.md` · `04_decisions/ADR` · `04_decisions/decision-log.md`（経緯） · `01_product/完成チェックリスト.md`。

---

## 7. セッション引き継ぎ（handoffs）

**SSOT:** スキル `handoff-session-work` · `references/routing.md` — 本節は要約のみ。

| 操作 | 正本 | 鉄則 |
|------|------|------|
| **再開** | 最新セッション MD **§4 の 1 件** | ロードマップ全体に広げない |
| **終了** | 新規セッション MD Write | **整理→archive 先**（Phase A 必須） |
| **確認** | Glob + Read のみ | Shell 禁止 |

セッション MD §4 の最小形（task packet）:

```markdown
### 完了の定義
- [ ] 測定可能な条件

### やる / やらない
| やる | やらない |

### 依頼文（コピペ用）
@handoffs/.../最新セッション.md
続きから。§4 の1件だけ。
```

**人間専用タスク**（目視 · 実機操作）は §4 に載せず、HANDOFF §6 に「担当: ユーザー」と書く。

---

## 8. 完成定義の分離（MUST）

| 記号 | 意味 | 置き場 |
|------|------|--------|
| **MVP / M2** | AC · 技術ゲート完了 | `MVP定義.md` · チェックリスト §A |
| **M3** | 実務フロー §C **すべて** ✅ | `完成チェックリスト.md` |
| **完成** | チェックリスト A〜D **すべて** ✅ | 同上 |
| **§4** | **今セッションの 1 件**（エージェント実行可） | handoffs セッション MD |

**MUST:** M3 ✅ と C-2 ☐ を同時に書かない。C-2 未了なら `M3 ☐（C-2 のみ）`。

---

## 9. 実装セッションの読む順序

1. **`10_meta/APP_PROJECT_RULES.md`**（本ファイル）— 初回 or 企画整理時
2. **handoffs** — 毎セッション §4
3. **`AGENTS.md`** — 境界
4. **スタック L1** — `RULE_INDEX` クイック入口（触るドメインのみ）
5. **Product Spec** — 仕様疑問時のみ

詳細手順 → [RULE_ROUTING_PLAYBOOK.md](../RULE_ROUTING_PLAYBOOK.md#読む順序個人アプリ新規企画フォルダ再開)

---

## 10. 禁止事項

| 禁止 | 理由 |
|------|------|
| 企画フォルダ `再開メモ.md` を進捗 SSOT として更新 | handoffs と二重管理 |
| 122KB 級 HANDOFF の毎回上書き | セッション MD を新規 Write |
| PRD · README 全文を実装プロンプトに貼る | task packet（§4）に分解 |
| 完成チェックリスト全項目の一括実装依頼 | 1 セッション = 1 テーマ |
| handoffs 本文に rule / ADR 全文コピー | パスリンクのみ |
| `git commit` / `push` の独断実行 | `GIT_WORKFLOW_RULES.md` |

---

## 11. 実例（flowchart-web · 2026-05-24）

| 項目 | 値 |
|------|-----|
| slug | `flowchart-web` |
| 企画 | `c:/yk-memo/00.ai-driven-school/個人テーマ_フローチャートアプリ/` |
| handoffs | `c:/yk-memo/handoffs/flowchart-web/HANDOFF.md` |
| コード | `c:/yk-tool/flowchart-web-reactflow/` · `flowchart-web-mermaid/` |
| 経緯索引 | `04_decisions/decision-log.md` |
| §4（2026-05-31 時点） | DB-2 dev 003+004 適用済 · 次: アプリ uuid 化 |
| スタック | No 35 REACTFLOW · No 31 NEXTJS · No 37 SUPABASE |

Phase 1 整理（handoffs 一本化 · AGENTS 新設）完了後に本 rule を起草。

---

## 12. スキル連携

| 段階 | 成果物 |
|------|--------|
| **L1 rule（SSOT）** | 本ファイル No 17 |
| **手順スキル（v1）** | `starting-app-project-yk` — 新規 · 整理 · AGENTS のみ |
| **セッション運用** | `handoff-session-work`（再開 · 終了 · 整理 archive） |
| **2 アプリ目以降** | checklist 実例追記 · スキル references 更新 |

スキルは rule 全文をコピーしない。執筆 → `SKILL_AUTHORING_RULES.md` · `creating-skills`。
