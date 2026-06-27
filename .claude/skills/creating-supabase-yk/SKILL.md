---
name: creating-supabase-yk
description: Supabase Auth · RLS · @supabase/ssr · env の Ref Plan と手順。発火例「Supabase」「RLS」「auth/callback」「profiles テーブル」「AUTH_DISABLED」。Do NOT use for Vercel deploy のみ（creating-vercel-yk）· 汎用 app/ ルート（creating-nextjs-yk）· flowchart payload 単体（creating-reactflow-yk）· surge 図解。
---

# Creating Supabase（YK）

**品質方針:** RLS / Auth / 本番 env を触るタスクでは **Ref Plan 未出力の Write/StrReplace 禁止**。本番チェックは L1 §11。

## Step 0: 入口（必須）

1. **`SUPABASE_RULES.md`** — L1（**§0 読む深さ · 誤ルーティングを先に確定**）
2. **本 SKILL.md**
3. **[ROUTER.md](references/ROUTER.md)** — tier / tag · Ref Plan テンプレ

**同一ターンで `app/` 一般 + Auth:** lead は **`creating-supabase-yk`**（auth 系）。併用時は Ref Plan に **`委譲: creating-nextjs-yk`** を列挙。

## Step 0.1: Shell（`AGENT_SHELL_RULES`）

| 状態 | エージェントの動き |
|------|-------------------|
| ユーザーが test / deploy / Shell を**未明示** | Ref Plan · チェックリスト**提示まで**。`supabase` CLI · seed スクリプトは**実行しない** |
| **明示あり** | ROUTER の CLI 節どおり（cwd 明示 · 値はチャットに貼らない） |
| ダッシュボード操作のみ | 手順提示（`SUPABASE_SETUP.md`）— Shell 不要 |

## Step 0.2: Ref Plan → load（編集前）

1. ROUTER で tier / tags を決定
2. **Ref Plan をチャットに出力**（質問のみ · Read のみは不要）
3. Ref Plan の **`load` に列挙したものだけ** Read

→ テンプレ: [ROUTER.md §7](references/ROUTER.md#7-ref-plan-テンプレート)

**委譲:** Vercel env 画面 → L1 §0 表 · `VERCEL_RULES` §6-1 · `flowDocuments.ts` 実装 → `REACTFLOW_RULES` · OAuth UI → `creating-react-yk`

## 作業プロセス

ROUTER §1 と同型: §0 確定 → tier/tag → Ref Plan → load → 編集 → L1 §11（該当時）→ 完了報告。

## 方式境界

| やりたいこと | 使うもの |
|--------------|----------|
| RLS · migrations · `@supabase/ssr` · env | **本スキル + SUPABASE_RULES** |
| Vercel env 編集 · Redeploy | **`creating-vercel-yk`** + `VERCEL_RULES` §6 |
| `app/` 一般（auth 以外） | `creating-nextjs-yk` |
| LoginForm · Client OAuth ボタン | `creating-react-yk` + L1 §0 委譲表 |
| 表駆動保存 · `flowDocuments` | `creating-reactflow-yk` + 本スキル tag `flowchart-actions` |
| surge 図解 HTML | 図解スキル — **Supabase 不要** |

## L0 入口

| パス | 優先 entry |
|------|------------|
| `lib/supabase/**` · `lib/auth/**` · `app/auth/**` · `database/migrations/**` | **`supabase-dev-entry.mdc`** → 本スキル |
| `app/**`（auth 以外） | **`nextjs-dev-entry.mdc`** |

---

索引: `RULE_INDEX.md` No 37 · 参照実装: `creating-vercel-yk` · `creating-mermaid-yk`
