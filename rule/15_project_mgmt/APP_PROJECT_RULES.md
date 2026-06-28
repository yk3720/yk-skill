# 個人アプリ開発プロジェクト規則
## App Project Lifecycle — YK 共通 v1

**用途:** 個人開発 × AI 支援で **新規アプリを始める · 企画フォルダを整える · 再開する** ときの横断 SSOT。  
**ステータス:** active（L1 · スキル `starting-app-project-yk` v1 — 実例 1 件）  
**関連:** `10_meta/AI_DRIVEN_RULES.md`（行動指針）· `15_project_mgmt/PROJECT_DOCUMENT_RULES.md`（企画フォルダ 6 種 · No 25）· スキル `handoff-session-work` · `RULE_INDEX.md` No 17  
**実例:** [flowchart-studio AGENTS.md](c:/yk-application/flowchart-studio/AGENTS.md) · [docs/](c:/yk-application/flowchart-studio/docs/)

**最終更新:** 2026-06-26（§2 docs/ 統合 · 検証駆動例外 footnote）

---

## 13. 企画ドキュメント種別（経緯 · 合意 · 2026-05-31）

**実例:** [flowchart-studio decision-log](c:/yk-application/flowchart-studio/docs/05_開発ガイドライン/decision-log.md)

| 種別 | パターン | 正本 | 載せる内容 |
|------|----------|------|------------|
| **経緯索引** | `05_開発ガイドライン/decision-log.md` | 企画 | タイムライン · リンク · 1 行要約のみ（本文コピー禁止） |
| **ADR** | `03_技術仕様/意思決定記録(ADR).md` または `ADR-NNN-*.md` | 企画 | Accepted 技術・プロダクト決定（**Draft** = grill 合意済 · 実装前 — 追随 MD は `PROJECT_DOCUMENT_RULES` §9.2） |
| **grill-me** | `01_要求定義/grill-me_{YYYY-MM-DD}_{論題}.md` | 企画 | 対話 Q&A · 未決 · 優先順位（`相談_*` は同義 · 新規は `grill-me_` 推奨） |
| **調査** | `01_要求定義/調査_{テーマ}.md` | 企画 | 調査結果 · 比較（決定前） |
| **計画** | `01_要求定義/計画_{YYYY-MM-DD}_{論題}.md` | 企画 | 相談→実装の分解 · §4 候補 |
| **セッション** | `handoffs/{slug}/*.md` | handoffs | §4 = 次の 1 件 · 作業記録 |

**昇格ルール（MUST）**

1. grill-me で **Accepted** → ADR（**Draft 可** · 実装前）+ decision-log 1 行 · 追随 MD は **§9.2**（`PROJECT_DOCUMENT_RULES`）  
2. grill-me で **未決** → grill-me §4 のみ（ADR に書かない）  
3. セッション終了 → decision-log 1 行 · handoff §1 要約（ADR 全文コピー禁止）  
4. **戦略 vs 戦術** — 方針合意（grill-me）と §4 実行タスクがズレても正常。decision-log で両方リンクする  
5. ADR **Accepted** + 実装完了 → 機能設計 SSOT の二層注記を外し一層に統合（§9.2）  
6. **UI 同一** 等の曖昧語 — grill / ADR で **骨格** と **差分許容**（例: 認証無効時メニュー）を分けて書く

**報告用:** 最終報告は `00_theme/報告書_*`（将来）← decision-log から要約転記。詳細は ADR · grill-me · handoffs へ委譲。

---

## 1. 解く問題

| 症状 | 原因 |
|------|------|
| 再開のたびに AI が迷う | 企画フォルダと handoffs の **二重 SSOT** |
| スコープ爆発 | PRD 全文を 1 プロンプトに渡す · 完成チェックリスト一括依頼 |
| 進捗が信頼できない | `再開メモ` · 手動確認 · handoffs の **日付・定義の不一致** |
| ルールが散在 | スタック rule（No 31–35）と **プロジェクトの置き方** が未分離 |

**目標:** 企画（安定）· セッション（毎回）· 憲法（境界）を分離し、**再開は handoffs §4 の 1 件だけ**（**検証駆動フェーズ**は HANDOFF §6 が実行正本 — §11 実例参照）。

---

## 2. 三層モデル（MUST）

| 層 | 置き場 | 更新頻度 | 載せる内容 |
|----|--------|----------|------------|
| **Product Spec** | **`yk-application/{app}/docs/`**（独立リポ · 推奨）または `yk-memo/.../{企画フォルダ}/`（講座のみ等） | 低 | 概要 · MVP · データモデル · ADR · 完成定義 |
| **Session Handoff** | `yk-memo/handoffs/{slug}/` | 毎セッション | HANDOFF + セッション MD（**§4 = 次の 1 件**） |
| **Agent Constitution** | 独立リポ **`AGENTS.md`**（推奨）または企画 `05_開発ガイドライン/エージェント憲法.md` | 低 | 境界 · SSOT マップ · 再開 3 ファイル · やる/やらない |

```text
Product Spec（何を作るか）— docs/ とコードが同一 Git
    ↓ 参照
Session Handoff（今回 1 件）— yk-memo/handoffs/
    ↓ 境界確認
AGENTS.md（憲法）→ コード
```

**MUST NOT:** 企画フォルダに **セッション進捗 SSOT**（次の 1 件 · git 状態 · 完了記録）を置く。  
**MUST NOT:** handoffs に **恒久仕様全文**（データモデル · 列定義）をコピーする — パスリンクのみ。

---

## 3. リポジトリ役割

| ルート | 役割 |
|--------|------|
| `c:/yk-memo` | **`handoffs/`** · 講座テーマ（`00_テーマ/`）· 企画 stub（独立リポ移行後） |
| `c:/yk-tool` | 汎用ツール · 実験アプリ（モノレポ） |
| `c:/yk-application` | **独立 Git** の本線アプリ — **`docs/` + `AGENTS.md` が Product Spec 正本**（例: `flowchart-studio`）· 構成テンプレ: [`templates/independent-app-repo/STRUCTURE.md`](templates/independent-app-repo/STRUCTURE.md) |
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
| 3 | 企画フォルダ **最小 3 種** | `01_要求定義/` · `04_リポジトリ構造/` · `05_開発ガイドライン/` — `PROJECT_DOCUMENT_RULES` §7 |
| 4 | `05_開発ガイドライン/エージェント憲法.md` | §5 テンプレ準拠 · 500 行未満 |
| 5 | slug ↔ 企画フォルダ **対応 1 行** | HANDOFF 表 · 憲法メタ表 |
| 6 | `handoffs/README.md` プロジェクト一覧に 1 行 | routing.md §既知プロジェクト例 と同期 |
| 7 | スタック rule | `RULE_INDEX` クイック入口（No 31–35 等） |

**任意（規模が大きいとき）:** `02_機能設計/` · `03_技術仕様/` · `99_アーカイブ/` — 追加トリガーは `PROJECT_DOCUMENT_RULES` §12。

---

## 5. エージェント憲法 必須項目

各アプリの **`05_開発ガイドライン/エージェント憲法.md`** に **次を含める**（プロジェクト固有値で埋める）。テンプレ → スキル `starting-app-project-yk` · `references/agents-template.md`。

**移行中:** ルート `AGENTS.md` が残るプロジェクトは完了まで参照可。新規はルート `AGENTS.md` を作らない。

| 節 | 内容 |
|----|------|
| メタ | handoffs slug · 企画フォルダパス · 更新日 |
| 再開 | HANDOFF → 最新セッション §4 → 本ファイル（3 ファイル） |
| コード置き場 | リポ · パス · dev コマンド |
| やる / やらない | スコープ境界（10 行以内が目安） |
| SSOT マップ | ドメイン別正本 1 表 |
| スタック rule | `RULE_INDEX` から該当 No のみ |
| 禁止 | commit 方針 · 企画への進捗書き戻し禁止 |

**コピペ用ラッパ:** 企画フォルダ `新チャット依頼.md` は **handoffs + エージェント憲法** の短い依頼文のみ（長文 PRD 禁止）。

---

## 6. 企画フォルダ推奨構成（個人 · 6 種体系）

**SSOT:** フォルダ名 · 種別定義 · 吸収ルール · 移行手順は **`15_project_mgmt/PROJECT_DOCUMENT_RULES.md`（No 25）** を Read。本節はライフサイクル上の要約のみ。

**標準（2026-06-23〜）:** 6 種（`01_要求定義/` 〜 `06_ユビキタス言語/`）+ 別枠（`00_テーマ/` · `99_アーカイブ/` · handoffs）。憲法は `05_開発ガイドライン/エージェント憲法.md`。新規は最小 3 種（`01` · `04` · `05/エージェント憲法`）。命名 · 追加トリガー → `PROJECT_DOCUMENT_RULES` §11 · §12。

**移行中:** 旧 slug `flowchart-web` 等は `flowchart-studio`（`yk-application`）へ移行済 — 物理移行は rule 確定後（`PROJECT_DOCUMENT_RULES` §8）。

**読む順序（再開時 · 3 ファイル）:** handoffs HANDOFF → 最新 §4 → エージェント憲法（移行完了後は `05_開発ガイドライン/`、未完了はルート `AGENTS.md`）。

---

## 7. セッション引き継ぎ（handoffs）

**SSOT:** スキル `handoff-session-work` · `references/routing.md` — 本節は要約のみ。

| 操作 | 正本 | 鉄則 |
|------|------|------|
| **再開** | 最新セッション MD **§4 の 1 件** | ロードマップ全体に広げない |
| **再開（検証駆動）** | HANDOFF **§6** | §4 機械消化しない · 検証メモまたは明示依頼まで待機（例: `flowchart-studio`） |
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
| **完成** | チェックリスト A〜D **すべて** ✅ | `完成チェックリスト.md` |
| **M3** | 実務フロー §C **すべて** ✅ | `完成チェックリスト.md` |
| **MVP / M2** | マイルストーン **AC** 完了 | `MVP定義.md` · チェックリスト §A |
| **技術ゲート** | `G-N`（任意） | `03_技術仕様/` または ADR |
| **§4** | **今セッションの 1 件**（エージェント実行可） | handoffs セッション MD — **チェックボックスのみ**（`AC-N` 禁止） |
| **検証** | 実装後の確認 | §4 内 1 行 · `PLAYWRIGHT_RULES` |

**MUST:** M3 ✅ と C-2 ☐ を同時に書かない。C-2 未了なら `M3 ☐（C-2 のみ）`。  
**MUST:** §4 にマイルストーン AC（`AC-N`）を書かない — 具体的な作業完了条件に分解する。  
**MUST NOT:** 完成 · MVP/M2/M3 のゲートを §4 に書く（リンクのみ可）。

SDD マッピング · AC 3 層 · §4 task packet → `PROJECT_DOCUMENT_RULES` §10。

---

## 9. 実装セッションの読む順序

1. **`15_project_mgmt/APP_PROJECT_RULES.md`**（本ファイル）— 初回 or 企画整理時
2. **`15_project_mgmt/PROJECT_DOCUMENT_RULES.md`** — 企画フォルダ構成 · 6 種 · 移行時
3. **handoffs** — 毎セッション §4
4. **エージェント憲法**（`05_開発ガイドライン/` または移行中はルート `AGENTS.md`）— 境界
5. **スタック L1** — `RULE_INDEX` クイック入口（触るドメインのみ）
6. **Product Spec** — 仕様疑問時のみ

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

## 11. 実例（flowchart-studio · 2026-06-24）

| 項目 | 値 |
|------|-----|
| slug | `flowchart-studio` |
| Product Spec | `c:/yk-application/flowchart-studio/docs/` |
| 憲法 | `c:/yk-application/flowchart-studio/AGENTS.md` |
| handoffs | `c:/yk-memo/handoffs/flowchart-studio/HANDOFF.md` |
| 講座・提出 | `c:/yk-memo/00.ai-driven-school/個人テーマ_フローチャートアプリ/00_テーマ/` |
| 経緯索引 | `docs/05_開発ガイドライン/decision-log.md` |
| 実装三層 | `frontend/` · `backend/` · `database/`（`docs/04_リポジトリ構造/`） |
| スタック | No 35 REACTFLOW · No 31 NEXTJS · No 37 SUPABASE |
| 検証駆動例外 | HANDOFF §6 が実行正本（§4 機械消化しない · 2026-06-26〜） |

---

## 12. スキル連携

| 段階 | 成果物 |
|------|--------|
| **L1 rule（SSOT）** | 本ファイル No 17 |
| **手順スキル（v1）** | `starting-app-project-yk` — 新規 · 整理 · AGENTS のみ |
| **セッション運用** | `handoff-session-work`（再開 · 終了 · 整理 archive） |
| **2 アプリ目以降** | checklist 実例追記 · スキル references 更新 |

スキルは rule 全文をコピーしない。執筆 → `SKILL_AUTHORING_RULES.md` · `creating-skills`。
