# yk-skill/rule — ルール索引

エージェント・人間が **どのファイルをいつ読むか** の入口。詳細は各ファイルが SSOT。

**最終更新:** 2026-05-24（flowchart-web-mermaid · Mermaid 3分岐）

**改善プロジェクトの続き:** [RULE_IMPROVEMENT_HANDOFF.md](RULE_IMPROVEMENT_HANDOFF.md)（未着手バックログ・再開手順）

---

## ルール配置の規約（v1 — 固定）

| 項目 | 規約 |
|------|------|
| **入口** | 本ファイル `rule/RULE_INDEX.md` のみルート直下（移動しない） |
| **帯フォルダ** | `10_meta/` · `20_web_workspace/` · `30_web_stack/` · **`35_reactflow/`** · `40_python/` · **`45_mermaid/`** · `50_gas_html_test/` · `60_tooling/` — **並び・分類用**（10刻みで空きを残す。中間ドメインは **No と一致**させる例: No 35 → `35_reactflow` · No 45 → `45_mermaid`） |
| **ファイル名** | `{TOPIC}_RULES.md`（番号はファイル名に付けない） |
| **カタログ No** | 下表の **No 列**が論理順の SSOT。帯番号と優先順位（Governance）は別 |
| **新規追加** | 該当帯にファイル作成 → **本表に1行追加**（No は空き番号。既存ファイルのリネームは避ける） |
| **ルート直下** | `RULE_INDEX.md` と `RULE_IMPROVEMENT_HANDOFF.md` のみ（2026-05-23 移行スタブ削除済み） |

**Phase 2（予約）:** ルールが ~25 本を超えたら `rule/load-manifest.yaml` を検討（本表から生成可能な列: `path` · `band` · `tags` · `read_when` · `status`）。

---

## Governance & Precedence（優先順位）

複数ルールが矛盾したときは、**上ほど優先**する。同順位で指示が食い違うときは、**推測で片方を捨てず**チャットでユーザーに確認する。

| 順 | レイヤ | 例 |
|----|--------|-----|
| **1** | **ユーザー明示指示** | 当該チャットで今回と指定されたこと |
| **2** | **ワークスペース alwaysApply ルール** | `.cursor/rules/*.mdc`（`alwaysApply: true`）。`5.Python` では **rev 積層保護**（`revision-protection.mdc`）— 既存 `*revNNN*` ファイルの上書き禁止・新 rev のみ積層 |
| **3** | **glob 付き .mdc** | 編集中ファイルに一致する entry（例: `python-dev-entry.mdc`） |
| **4** | **狭いドメイン rule → 広い rule** | 例: `DIAGRAM_MANAGER_WORKSPACE_RULES` > `WORKSPACE_RULES` > `NEXTJS` / `SHADCN` / `TAILWIND` |
| **5** | **yk-skill L1 + 発火スキル** | 例: `40_python/PYTHON_RULES.md` + `creating-pythoncode-yk/SKILL.md` |
| **6** | **Ref Plan で列挙した references のみ** | ロード規則の SSOT は各スキルの `ROUTER.md` |
| **7** | **企画・メモ（人間向け）** | `yk-memo` 等 — スコープ・背景の参考。**実装の正解ではない** |

**企画メモ vs 実装 rule:** 実装・AI 指示の SSOT は **`yk-skill/rule` の該当 `*_WORKSPACE_RULES.md`（およびコード内の型・定数）** が勝つ。`yk-memo` と食い違う場合は **rule または ADR を更新してから**実装に反映する。

Web ドメイン内の「狭い > 広い」の詳細 → `20_web_workspace/WORKSPACE_RULES.md` §1。

---

## リポジトリマップ（横断パス SSOT）

**目的:** 複数 Git ルートにまたがるパスの正本。詳細・移行手順は `c:/yk-memo/handoffs/workspace-layout/HANDOFF.md`。

**注意（2026-05-23）:** 図解 HTML の `yk-tool/publish/` · 主要ツールの `yk-tool/` 移行は **完了**。`surge-published-list.md` は移行後表記に更新済み。古いメモ・スキル断片に旧パスが残る場合は本表を正とする。

### リポジトリの役割

| ルート | 役割 | Git |
|--------|------|-----|
| `c:/yk-memo` | テキスト・企画（MD · 講座 · 議事） | あり |
| `c:/yk-skill` | スキル · `rule/` · 公開台帳 `metadata/` | あり |
| `c:/yk-tool` | 成果物・アプリ（`publish/` · `apps/` · ui-kit 等） | あり（新規） |
| `c:/yk-document` | 業務データ（Excel 原本 Git 外 · `exports/` · `_index/`） | あり（新規） |
| `c:/1.cursor/5.Python` | Python 実装（**別リポ・実験混在・一括整理しない**） | あり |
| `c:/yk-local`（任意） | `.env` · トークン · フル PII — 各リポから参照のみ | なし |

### 横断パス一覧（目標）

| 用途 | 目標パス | 備考 |
|------|----------|------|
| AI 指示・実装 rule の SSOT | `c:/yk-skill/rule/` | 本ファイル所在 |
| surge 公開図解台帳 | `c:/yk-skill/metadata/surge-published-list.md` | 図解スキルがデプロイ後に更新 |
| スキル台帳（インベントリ） | `c:/yk-skill/metadata/SKILL_CATALOG.md` | `creating-skills` 完了時に再生成 · 整理依頼時は `managing-skills-yk` · `yk-tool/catalog.yaml` と混同しない |
| 図解 HTML 正本（ローカル） | `c:/yk-tool/publish/` | スキル内 `output/` は作業用 · デプロイ後に publish へコピー |
| 図解以外の Web/ツールアプリ | `c:/yk-tool/apps/` · ルート直下 Next アプリ | 例: `apps/commit-report-tool/` · `workspace-ui-kit/` |
| 図解管理 UI（Next） | `c:/yk-tool/workspace-ui-kit/` | 移行元: `yk-skill/workspace-ui-kit/` |
| フローチャート Web（React Flow） | `c:/yk-tool/flowchart-web-reactflow/` | ADR-010 · 表 → React Flow |
| フローチャート Web（Mermaid 比較） | `c:/yk-tool/flowchart-web-mermaid/` | ADR-010 · 表 → Mermaid プレビュー |
| Playwright E2E | `c:/yk-tool/playwright-test/` | 移行元: `yk-skill/playwright-test/`（2026-05-23） |
| Python デスクトップツール | `c:/1.cursor/5.Python/` | 新規本番は必要分のみ **新フォルダへ移出** · `revision-protection` 適用 |
| 企画・背景（参考のみ） | `c:/yk-memo/` | Governance 段階 7 — 実装の正解ではない |
| Excel 原本 | `c:/yk-document/**/originals/` | Git ignore · 変換は `5.Python` + `exports/` |
| セッション引き継ぎ MD | `c:/yk-memo/handoffs/{project}/` | スキル `handoff-session-work`（終了·再開·確認·整理）· `references/template.md` · `folder-audit.md` |
| Git commit（ユーザー明示時） | 各リポの Git ルート | スキル `committing-with-git-yk` · 方針は `GIT_WORKFLOW_RULES.md` |
| Agent Shell / RUN 承認 | `60_tooling/cursor-permissions/permissions.json` → `~/.cursor/` にデプロイ | `60_tooling/AGENT_SHELL_RULES.md` · `cursor-permissions/README.md` |

### Cursor マルチルート（目安）

| タスク | 載せるルート |
|--------|-------------|
| 図解生成・デプロイ | `yk-skill` + `yk-tool` |
| ui-kit / flowchart-web-reactflow | `yk-tool` + `yk-skill` |
| Excel 読取・変換 | `yk-document` + `5.Python` |
| 企画確認のみ | `yk-memo` のみ可 |

**パス方針:** シンボリックリンクは使わない。`5.Python` · 各実装リポの `.mdc` から `yk-skill/rule` へは **絶対パス**で参照（現行パターン維持）。

---

## Status 列（エージェント向け定義）

本表 **Status** 列は、各 `*_RULES.md` の **整備度**（索引メタデータ）を示す。Git ブランチ名や本文中の「下書き」とは別概念。

| Status | 意味 | エージェントの扱い |
|--------|------|-------------------|
| **active** | L1 整備済。**当該ドメインで PROGRESSIVE 完遂**（L0 `*-dev-entry.mdc` · L2 スキル · `ROUTER.md` — meta 横断など L0 不要の帯は例外） | 該当作業時に **L1 を Read**。手順・Ref Plan はスキルと entry に従う |
| **draft** | L1 はあるが **PROGRESSIVE 完遂前**（スキル未作成 · ROUTER が L1 暫定 · entry 未作成 等） | **L1 先頭の注記どおり、構文・安全など MUST は適用**。手順は L1 暫定節 + 既存スキル。`active` への昇格は人間が索引を更新するまで行わない |
| **deprecated** | 置換先あり。**参照禁止** | 読まない。本表の置換ルールまたは移行スタブを確認 |

**SSOT:** Status の定義は **本節のみ**。各ルールファイル先頭の「ステータス」行は本表と **同期** する（食い違い時は本表を正として L1 を直す）。

**`draft` → `active` 昇格の目安（ドメイン rule）**

1. `10_meta/PROGRESSIVE_CONTEXT_ROUTING_RULES.md` §10 の新ドメイン手順が完了している  
2. 本表の当該行を `active` に更新した  
3. L1 先頭のステータス表記を `active` に合わせる  

例: No 45 `MERMAID_RULES` — 2026-05-23 に P10 完了後 `active`。

---

## 番号付きカタログ（SSOT）

| No | 帯 | パス | いつ読む | Status |
|----|-----|------|----------|--------|
| 00 | — | `RULE_INDEX.md` | **常に最初**（本ファイル） | active |
| 11 | 10_meta | `10_meta/PROGRESSIVE_CONTEXT_ROUTING_RULES.md` | 新ドメインスキル・ルーティング設計 | active |
| 12 | 10_meta | `10_meta/SKILL_AUTHORING_RULES.md` | スキル作成・更新 | active |
| 13 | 10_meta | `10_meta/AI_DRIVEN_RULES.md` | 講座・行動指針（人間向け原則） | active |
| 14 | 10_meta | `10_meta/GIT_WORKFLOW_RULES.md` | **Git 操作**（commit / push / メッセージ / 禁止事項） | active |
| 15 | 10_meta | `10_meta/SECRETS_HYGIENE_RULES.md` | **Secrets**（コミット禁止・チャット貼付禁止・保管場所） | active |
| 16 | 10_meta | `10_meta/COMMUNICATION_RULES.md` | **チャット応答**（平易さ・作業後3点サマリ） | active |
| 21 | 20_web_workspace | `20_web_workspace/WORKSPACE_RULES.md` | workspace-ui-kit 横断 | active |
| 22 | 20_web_workspace | `20_web_workspace/DIAGRAM_MANAGER_WORKSPACE_RULES.md` | `/diagram-manager` 作業 | active |
| 31 | 30_web_stack | `30_web_stack/NEXTJS_RULES.md` | Next.js 作業 | active |
| 32 | 30_web_stack | `30_web_stack/SHADCN_UI_RULES.md` | shadcn / Base UI 作業 | active |
| 33 | 30_web_stack | `30_web_stack/TAILWINDCSS_RULES.md` | Tailwind 作業 | active |
| 34 | 30_web_stack | `30_web_stack/VERCEL_RULES.md` | Vercel / Neon デプロイ | active |
| 35 | 35_reactflow | `35_reactflow/REACTFLOW_RULES.md` | 表駆動フロー · `@xyflow/react` · `flowchart-web-reactflow` | active |
| 41 | 40_python | `40_python/PYTHON_RULES.md` | Python ツール（毎回・L1） | active |
| 45 | 45_mermaid | `45_mermaid/MERMAID_RULES.md` | Mermaid DSL（`.mmd` / 図解 MD）・diagram-as-code | active |
| 51 | 50_gas_html_test | `50_gas_html_test/GAS_RULES.md` | GAS Web アプリ | active |
| 52 | 50_gas_html_test | `50_gas_html_test/GAS_REPORT_DESIGN_RULES.md` | **GAS 進捗レポート HTML**・surge 図解 HTML の chip デザイン | active |
| 53 | 50_gas_html_test | `50_gas_html_test/PLAYWRIGHT_RULES.md` | Playwright / E2E | active |
| 54 | 50_gas_html_test | `50_gas_html_test/POWERSHELL_HTML_RULES.md` | 大容量 HTML + PowerShell | active |
| 61 | 60_tooling | `60_tooling/CURSOR_RULES.md` | Cursor / Windows 実務 | active |
| 62 | 60_tooling | `60_tooling/AGENT_SHELL_RULES.md` | **Agent Shell / RUN 削減** · Read 優先 · allowlist | active |

**帯の意味（要約）**

| 帯 | 含むもの | 含まないもの |
|----|----------|--------------|
| 10_meta | 横断設計・Git · Secrets · スキル執筆・講座原則 | ドメイン実装詳細 |
| 20_web_workspace | ui-kit 横断・図解管理等ドメイン | スタック個別 API |
| 30_web_stack | Next / shadcn / Tailwind / Vercel | workspace-ui-kit の画面仕様 · flowchart の表→RF パイプライン（→ No 35） |
| 35_reactflow | 表駆動 · React Flow · flowchart-web-* | Mermaid DSL（→ 45）· surge 図解 HTML |
| 40_python | Python L1・SDD 要約 | KB 全文（スキル references） |
| 45_mermaid | Mermaid DSL・図の SDD・検証（mmdc） | `creating-mermaid-yk` · ROUTER |
| 50_gas_html_test | GAS・レポート HTML デザイン・E2E・PS HTML | Next.js UI（→ 30） |
| 60_tooling | エディタ・OS 操作 | アプリ仕様 |

**パス:** 上表の `帯/{NAME}_RULES.md` が SSOT。旧 `rule/{NAME}_RULES.md` フラットパスは廃止（2026-05-23）。

---

## 読む順序（Python ツールを触るとき）

1. **`40_python/PYTHON_RULES.md`** — 要約 SSOT（毎回）
2. **スキル `SKILL.md`** — 手順
3. **`references/ROUTER.md`** — tier / tag
4. **Ref Plan 出力後** — `references/` の列挙ファイルのみ Read  
   - **Light**（局所修正）: `tier` + `load` の短形式 · **Standard 以上**: フル形式（SKILL Step 0.1）

`5.Python` で `.py` を触るときは `python-dev-entry.mdc` が自動適用される。

**他言語スキル新設時:** `10_meta/PROGRESSIVE_CONTEXT_ROUTING_RULES.md`

---

## 読む順序（Mermaid 図を書くとき）

1. **`45_mermaid/MERMAID_RULES.md`** — L1 SSOT（毎回）
2. **スキル `creating-mermaid-yk/SKILL.md`** — 手順
3. **`creating-mermaid-yk/references/ROUTER.md`** — tier / tag
4. **Ref Plan** — `.mmd` 編集前（ROUTER §7）
5. **表駆動フローが必要なら** → 下記「flowchart-web-reactflow」節（Mermaid 比較版は ADR-010 · 併用 · 代替ではない）

`yk-skill` · `yk-memo` で `.mmd` を触るときは `mermaid-dev-entry.mdc` が自動適用される。

---

## 読む順序（flowchart-web-reactflow / React Flow を触るとき）

1. **`35_reactflow/REACTFLOW_RULES.md`** — L1 SSOT（毎回）
2. **スキル `creating-reactflow-yk/SKILL.md`** — 手順
3. **`creating-reactflow-yk/references/ROUTER.md`** — tier / tag · Ref Plan
4. **Ref Plan** — コード編集前（ROUTER §7）
5. **Next.js シェル** — `30_web_stack/NEXTJS_RULES.md` §5 · `creating-nextjs-yk`
6. **shadcn 表 UI** — `SHADCN_UI_RULES.md` §6 · `creating-shadcn-yk`（未導入時はスキップ）
7. **参照実装** — `c:/yk-tool/flowchart-web-reactflow/`
8. **方式境界** — `45_mermaid/MERMAID_RULES.md` §1.5

**誤ルーティング禁止:** No 35 は `creating-mermaid-yk` · surge 図解スキルで代替しない。

---

## 読む順序（flowchart-web-mermaid / 表 → Mermaid プレビュー）

1. **`35_reactflow/REACTFLOW_RULES.md`** — L1 SSOT（§3-6 `toMermaid` · §4-1 Mermaid プレビュー）
2. **スキル `creating-reactflow-yk/SKILL.md`** — 手順（**`creating-mermaid-yk` 非使用**）
3. **`creating-reactflow-yk/references/ROUTER.md`** — tag `mermaid-preview` 等
4. **Next.js シェル** — `NEXTJS_RULES.md` §5 · `creating-nextjs-yk`
5. **参照実装** — `c:/yk-tool/flowchart-web-mermaid/`（`toMermaid.ts` · `MermaidPreview.tsx`）
6. **方式境界** — `45_mermaid/MERMAID_RULES.md` §1.5-1（`.mmd` 執筆は No 45 へ）

**開発ポート:** **3001**（reactflow 版 3000 と並行）。

---

## 読む順序（workspace-ui-kit を触るとき）

1. **`20_web_workspace/WORKSPACE_RULES.md`** — キット横断
2. **ドメイン固有** — 上表 No 22 等
3. **スタック** — `NEXTJS` · `SHADCN` · `TAILWIND`（**`GAS_REPORT_DESIGN` は含めない** — ui-kit は shadcn トークンが SSOT）
4. **企画（人間向け・参考）** — `yk-memo`（Governance 段階 7）

`workspace-ui-kit` で `app/` · `components/` · `lib/` 内の `.ts` / `.tsx` を触るときは `workspace-ui-kit/.cursor/rules/workspace-dev-entry.mdc` が自動適用される。

**デザイン判断のルーティング**

| 状況 | 読むルール |
|------|------------|
| workspace-ui-kit（Next / shadcn） | `SHADCN_UI` · `TAILWIND` · ドメイン rule |
| GAS 進捗レポート HTML・surge 図解 HTML（chip・8px グリッド） | `50_gas_html_test/GAS_REPORT_DESIGN_RULES.md` |
| 迷ったら | 本表 No 00 → 上表 |

---

## 読む順序（Agent が Shell を使うとき）

1. **`60_tooling/AGENT_SHELL_RULES.md`** — RUN 削減 · Read/Glob 優先 · タスク別例外 D-1〜D-4
2. **`60_tooling/CURSOR_RULES.md`** — Windows · 権限 · 人間向け Auto-Run 手順（§5 からリンク）

---

## 読む順序（Git 操作をするとき）

1. **`10_meta/GIT_WORKFLOW_RULES.md`** — 横断方針（commit / push / メッセージ / 禁止）
2. **`10_meta/SECRETS_HYGIENE_RULES.md`** — コミットしてはいけないファイル・チャット貼付禁止
3. **ドメイン補足** — 例: Python rev 積層 → `40_python/PYTHON_RULES.md` §9 · Playwright セッション → No 53 §5
4. **実行手順** — Cursor User Rules（`git status` / `git diff` / HEREDOC 等）
5. **（任意）** スキル `committing-with-git-yk` — マルチリポ判定 · 日本語メッセージ草案 · `/committing-with-git-yk` 明示起動

---

## 読む順序（資格情報・トークンを扱うとき）

1. **`10_meta/SECRETS_HYGIENE_RULES.md`** — チェックリスト · 禁止パターン
2. **ドメイン** — Python `.env` → No 41 · GAS → No 51 §4 · Vercel → No 34 §0 · Playwright → No 53 §5
3. **Git に載せる前** — `GIT_WORKFLOW_RULES.md` §2

---

## 読む順序（GAS / Playwright / 大容量 HTML）

1. 本表で該当 No を特定
2. **GAS** → No 51 · **E2E** → No 53（GAS は `networkidle`、Sheets は `load` — PLAYWRIGHT 参照）
3. **大容量 HTML 編集** → No 54（Python 文字列処理が安定する場合は `40_python` も可）

---

## リポジトリ内（workspace-ui-kit）

| 用途 | ファイル |
|------|----------|
| 採用管理雛形・ADR・スキル | `workspace-ui-kit/CLAUDE.md` |
| 図解管理の実装 | `app/diagram-manager/` · `components/diagram-manager/` |

---

## 新規ルールの追加手順

1. **帯を選ぶ**（上表「帯の意味」）。該当なしなら **70_** など空き帯を `RULE_INDEX` に定義してから作成
2. `rule/{帯}/{TOPIC}_RULES.md` を作成（500 行目安。超えたら references へ）
3. **本表に行を追加**（No · path · いつ読む · status）
4. 既存 rule / スキルから **絶対パス `c:/yk-skill/rule/{帯}/{FILE}`** でリンク（`SKILL_AUTHORING` §12 準拠）
5. 旧来のフラット名が必要なら **スタブのみ**（本文コピー禁止）
