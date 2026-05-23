# yk-skill/rule 改善プロジェクト — 続き用引き継ぎ

> **AI 向け:** 新チャットで本ファイルを **最初に Read** し、§「再開手順」に従う。ユーザーは「`RULE_IMPROVEMENT_HANDOFF` の続きから」と言えばよい。

| 項目 | 値 |
|------|-----|
| **状態** | Phase 2 進行中（2026-05-23 — P1〜P7 完了） |
| **リポジトリ** | `c:/yk-skill`（主）· 参照更新済み: `5.Python` · `yk-memo` 一部 · `workspace-ui-kit` |
| **入口 SSOT** | `c:/yk-skill/rule/RULE_INDEX.md` |
| **対話の経緯** | ルール矛盾チェック → Web調査 → 多視点レビュー → 対話で1件ずつ決定 → 実装 |
| **会話 transcript** | `C:\Users\ykoba\.cursor\projects\c-yk-memo\agent-transcripts\46267dcc-f9ea-4ac1-824c-3bb349c0882a\46267dcc-f9ea-4ac1-824c-3bb349c0882a.jsonl`（詳細な議論・却下案はここを検索） |

---

## 再開手順（エージェント用）

1. **Read** `c:/yk-skill/rule/RULE_INDEX.md`（Governance・カタログ・読む順序）
2. **Read** 本ファイル（未着手バックログ）
3. ユーザーに **次の1件** を確認するか、下表 **推奨順の先頭** から着手する
4. 各項目は **対話で1件ずつ** 方針確定 → 実装 → 本ファイルの該当行を `done` に更新
5. **リビジョン保護:** `5.Python` の `*revNNN*` ファイルは上書き禁止（`revision-protection.mdc`）。ルール本文の rev 番号付き KB は同様の精神で新 rev のみ積層
6. **コミット / push:** [`10_meta/GIT_WORKFLOW_RULES.md`](10_meta/GIT_WORKFLOW_RULES.md) — ユーザー明示時のみ

**依頼文の例（ユーザー）**

```text
@c:/yk-skill/rule/RULE_IMPROVEMENT_HANDOFF.md の続きから。
次はバックログ P1（横断 Git SSOT）を進めてください。
```

---

## 完了済み（再実装不要）

| ID | 内容 | 主な成果物 |
|----|------|------------|
| **G1** | Governance（7段優先順位） | `RULE_INDEX.md` 先頭 § Governance |
| **G2** | 帯フォルダ + カタログ No（v1） | `10_meta/` … `60_tooling/` · 直下スタブ（移行期） |
| **G3** | `DESIGN` → `GAS_REPORT_DESIGN` 整理 | `50_gas_html_test/GAS_REPORT_DESIGN_RULES.md` · ui-kit 読み順から除外 |
| **G4** | PYTHON §6 ↔ ROUTER の SSOT 一本化 | `40_python/PYTHON_RULES.md` §6 · `references/ROUTER.md` §5・§11 |
| **G5** | Light tier の Ref Plan 簡略化 | `SKILL.md` Step 0.1 · `ROUTER.md` · `PYTHON_RULES` §0/§6/§8 · `PROGRESSIVE` §4 · `python-dev-entry.mdc` |
| **G6** | 参照パス一括更新（Phase 1） | Python スキル · 図解3スキル · `5.Python/入口.md` · `workspace-ui-kit/CLAUDE.md` · yk-memo 図解関連メモ |
| **P1** | 横断 Git SSOT | `10_meta/GIT_WORKFLOW_RULES.md`（No 14）· `RULE_INDEX` · `PYTHON_RULES` §9 リンク化 · PLAYWRIGHT / using-playwright / Rules_2 重複削減 |
| **P2** | 横断 Secrets Hygiene | `10_meta/SECRETS_HYGIENE_RULES.md`（No 15）· GIT_WORKFLOW §2 リンク化 · GAS / Vercel / PYTHON / PLAYWRIGHT · 図解3スキル · FB README |
| **P3** | `GAS_RULES` ALLOWALL 正例修正 | デフォルト正例は `setXFrameOptionsMode` 省略 · 埋め込み時のみ ALLOWALL 分岐 · 悪い例を明示 |
| **P4** | `PLAYWRIGHT_RULES` waitForTimeout 整理 | §2-2 を anti-pattern 化 · §4-1 `getContentFrame` を `expect` + `toPass` に置換 |
| **P5** | `workspace-dev-entry.mdc` | `workspace-ui-kit/.cursor/rules/` · glob `app`/`components`/`lib` · `RULE_INDEX` · `CLAUDE.md` |
| **P6** | 移行スタブ削除 | 再スキャン後 17 スタブ削除 · `RULE_INDEX` 更新 |
| **P7** | `Rules_1.md` Superseded バナー | 目立つボックス · `入口.md` 導線強化 |

### 採用済みアーキテクチャ決定（再議論しない）

- **入口:** `rule/` 直下は `RULE_INDEX.md` · `RULE_IMPROVEMENT_HANDOFF.md` のみ（**移行スタブは 2026-05-23 削除済み**）。SSOT は帯フォルダ内
- **命名:** ファイル名 `{TOPIC}_RULES.md`（番号なし）。論理順は `RULE_INDEX` の **No 列**
- **帯:** 10刻み（`10_meta` … `60_tooling`）。Phase 2 予約: ~25本超で `load-manifest.yaml`
- **企画 vs 実装:** 実装 SSOT は `yk-skill/rule`（Governance 段階7で yk-memo は参考のみ）
- **Light Ref Plan:** `tier` + `load` のみ。迷ったら **Standard**
- **ROUTER:** tier/tag/K-ID 表の SSOT は `references/ROUTER.md` のみ
- **Git SSOT:** `10_meta/GIT_WORKFLOW_RULES.md` — 方針のみ。push / commit はユーザー明示時。メッセージは直近 `git log` に合わせる。実行手順は User Rules
- **Secrets SSOT:** `10_meta/SECRETS_HYGIENE_RULES.md` — チェックリスト + 禁止パターン。チャットへの値貼付は **原則禁止（例外なし）**。実装手順は各ドメイン rule
- **Web L0 入口:** `workspace-ui-kit/.cursor/rules/workspace-dev-entry.mdc` — glob `app` · `components` · `lib` の `*.{ts,tsx}`

### 帯フォルダ一覧（SSOT パス）

| 帯 | パス |
|----|------|
| 入口 | `rule/RULE_INDEX.md` |
| 10_meta | `10_meta/PROGRESSIVE` · `SKILL_AUTHORING` · `AI_DRIVEN` · `GIT_WORKFLOW` · `SECRETS_HYGIENE` |
| 20_web_workspace | `20_web_workspace/WORKSPACE_RULES.md` · `DIAGRAM_MANAGER_WORKSPACE_RULES.md` |
| 30_web_stack | `30_web_stack/NEXTJS` · `SHADCN_UI` · `TAILWINDCSS` · `VERCEL` |
| 40_python | `40_python/PYTHON_RULES.md` |
| 50_gas_html_test | `GAS` · `GAS_REPORT_DESIGN` · `PLAYWRIGHT` · `POWERSHELL_HTML` |
| 60_tooling | `60_tooling/CURSOR_RULES.md` |

### P6 スタブ削除（2026-05-23 実施）

`yk-skill` · `yk-memo` · `5.Python` · `Users\ykoba\src` で旧フラットパス `yk-skill/rule/{NAME}_RULES.md` を再スキャン → **参照 0件**（HANDOFF 内の rg 例示のみ）→ 直下スタブ **17 件削除**。

---

## 未着手バックログ

**優先:** P8。着手前にユーザー確認を推奨（対話形式の継続）。

| ID | 優先 | タイトル | 概要・受け入れ基準 | 主に触るファイル |
|----|------|----------|-------------------|------------------|
| **P8** | 低 | yk-memo 残参照の棚卸し | 図解関連は新パス済み。**他フォルダ**に `rule/PYTHON_RULES.md` 等の旧パスが残っていないか `rg` で確認・更新。 | `c:/yk-memo/**` |
| **P9** | 予約 | `load-manifest.yaml`（Phase 2） | ルール ~25 本超えたら `RULE_INDEX` 表から機械可読マニフェスト生成を検討。 | `RULE_INDEX.md` Phase 2 節 |

### 当初レビューで言及・未タスク化した周辺

- ルール全文の **再矛盾チェック**（帯移行後の横断読み）
- **サブエージェント多視点レビュー**の再実施（大きな変更後）
- `flowchart-web/` 等、今回スコープ外リポジトリのルールリンク

---

## Python 作業時のクイック参照（変更なし）

1. `40_python/PYTHON_RULES.md`
2. `creating-Pythoncode-yk/SKILL.md`
3. `references/ROUTER.md`
4. Ref Plan → 列挙 refs のみ Read（Light / Standard は G5 参照）
5. `5.Python` では `python-dev-entry.mdc`（glob `**/*.py`）

スキルパス: `c:/yk-skill/.claude/skills/creating-Pythoncode/.claude/skills/creating-Pythoncode-yk/`

---

## Web（workspace-ui-kit）作業時

1. `20_web_workspace/WORKSPACE_RULES.md`
2. ドメイン（例: `DIAGRAM_MANAGER_WORKSPACE_RULES.md`）
3. `30_web_stack/`（SHADCN · TAILWIND · NEXTJS）— **GAS_REPORT_DESIGN は読まない**
4. 企画は `yk-memo`（参考のみ）

---

## 関連プロジェクト（別トラック）

| 項目 | パス |
|------|------|
| **4リポ分割（yk-tool / yk-document）** | `c:/yk-memo/handoffs/workspace-layout/HANDOFF.md` — 3 アプリ yk-tool へ移動済み（2026-05-23）· commit 未 |

---

## 本ファイルのメンテナンス

- タスク完了時: 該当行を **完了済み表へ移動**し、バックログから削除
- 新規決定時: §「採用済みアーキテクチャ決定」に1行追加
- `RULE_INDEX.md` の最終更新日は構造変更時のみ更新（本ファイルの日付と揃える）

**最終更新:** 2026-05-23（P7 完了）
