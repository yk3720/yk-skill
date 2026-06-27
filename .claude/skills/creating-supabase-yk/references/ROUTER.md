# Supabase 参照ルーティング（ROUTER）

**SSOT:** 本ファイルが tier · tag · Ref Plan テンプレの唯一の正本。  
**要約・MUST:** `yk-skill/rule/30_web_stack/SUPABASE_RULES.md` · **手順:** `../SKILL.md`  
**設計パターン:** `yk-skill/rule/10_meta/PROGRESSIVE_CONTEXT_ROUTING_RULES.md`

**最終更新:** 2026-06-27

---

## 0. 禁止・原則

- **§0 読む深さ未確定のまま** RLS / Auth / migration を編集しない
- L3 references の全文を **tag 無しで一括 Read しない**（Ref Plan の `load` に列挙）
- tier / tag 表を `SKILL.md` や L1 に **複製しない**
- **service_role** · `.env` 値をチャットに貼らない（`SECRETS_HYGIENE_RULES`）
- **Vercel deploy 手順**を本 ROUTER に再掲しない → `creating-vercel-yk`
- **flowDocuments 実装詳細**を本 ROUTER に再掲しない → `REACTFLOW_RULES`

---

## 1. 手順（毎タスク）

1. `SUPABASE_RULES.md` **§0** で読む深さ · 委譲先を確定
2. `SKILL.md` → 本 ROUTER で **tier** と **tags**
3. **Ref Plan** をチャットに出力
4. Ref Plan の `load` **だけ** Read → 編集 /（明示時のみ）CLI
5. 本番・Preview 触るとき L1 §11 → 完了報告

---

## 2. Tier — floor

| tier | いつ | floor（必ず Read） |
|------|------|----------------------|
| **Light** | env 確認 · `AUTH_DISABLED` 質問 · ダッシュボード URL の場所 | L1 §0 · §4 索引 · [`SUPABASE_ENV.md`](../../../rule/30_web_stack/references/SUPABASE_ENV.md) · §7 |
| **Standard** | RLS / Auth / Server Actions · migration 1 本 · OAuth 設定 | **L1** §0–§1 · §5 · §7 + **該当 references**（§2–§6 索引） |
| **Deep** | 新テーブル · スキーマ設計 · 共同編集ポリシー変更 | Standard + [`SUPABASE_SCHEMA_RLS.md`](../../../rule/30_web_stack/references/SUPABASE_SCHEMA_RLS.md) 全文 + ADR-013 |

**既定:** 迷ったら **Standard**（Light の過小評価を避ける）。

**Light → Standard に上げる条件（いずれか）:**

- RLS ポリシー · migration · `app/auth/**` の Write/StrReplace
- `@supabase/ssr` クライアント構成の変更
- 本番 / Preview env の追加・変更

---

## 3. Tag — floor に加算

| tag | 追加 floor |
|-----|------------|
| `env` | [`SUPABASE_ENV.md`](../../../rule/30_web_stack/references/SUPABASE_ENV.md) · `SECRETS_HYGIENE_RULES` |
| `auth-ssr` | [`SUPABASE_AUTH_SSR.md`](../../../rule/30_web_stack/references/SUPABASE_AUTH_SSR.md) · [Supabase Auth SSR](https://supabase.com/docs/guides/auth/server-side/nextjs)（1 URL） |
| `rls-schema` | [`SUPABASE_SCHEMA_RLS.md`](../../../rule/30_web_stack/references/SUPABASE_SCHEMA_RLS.md) |
| `setup-dashboard` | L1 §5 · `c:/yk-application/flowchart-studio/docs/runbooks/SUPABASE_SETUP.md` |
| `auth-disabled` | L1 §7 のみ（他 tag と併用可） |
| `flowchart-actions` | [`REACTFLOW_RULES.md`](../../../rule/35_reactflow/REACTFLOW_RULES.md) L1 §2 索引 — **RLS 概要のみ** |
| `vercel-env` | [`VERCEL_RULES.md`](../../../rule/30_web_stack/VERCEL_RULES.md) §6-1 · **`creating-vercel-yk`** 委譲 |
| `tauri-auth` | L1 §10 · [Supabase Native Mobile Deep Linking](https://supabase.com/docs/guides/auth/native-mobile-deep-linking) |

**公式 URL:** 1 tag あたり **1 ページまで**。

---

## 4. シグナル → tag

| シグナル | tag | 禁止 |
|----------|-----|------|
| `NEXT_PUBLIC_SUPABASE_*` · Connect ダッシュボード | `env` | 「Settings → API」案内 |
| `AUTH_DISABLED` · ローカル UI のみ | `auth-disabled` | URL 未設定だけでバイパス |
| OAuth · Magic Link · `exchangeCodeForSession` | `auth-ssr` | L1 全文 + 全 references |
| migration · RLS · `profiles` · `flow_documents` | `rls-schema` | REACTFLOW のみ |
| 初回プロジェクト · Redirect URLs | `setup-dashboard` | CLI 自動実行 |
| Vercel Sensitive · Redeploy | `vercel-env` | env 値をチャットに貼る |
| `flowDocuments.ts` · Server Actions 保存 | `flowchart-actions` + `auth-ssr` or `rls-schema` | 本 ROUTER に実装手順 |
| Tauri · Deep Link · PKCE | `tauri-auth` | ブラウザ callback 手順のみ |

---

## 5. リポ内パス · L0 優先

| パス | L0 優先 | tier 目安 |
|------|---------|-----------|
| `lib/supabase/**` · `lib/auth/**` | **`supabase-dev-entry`** | Standard |
| `app/auth/**` | **`supabase-dev-entry`** + `nextjs-dev-entry`（Route Handler） | Standard |
| `database/migrations/**` | **`supabase-dev-entry`** | Deep |
| `lib/flowchart/actions/**` | **`reactflow-dev-entry`** + 本スキル tag `flowchart-actions` | Standard |

正本例: `c:/yk-application/flowchart-studio/backend/src/lib/supabase/`

---

## 6. パージ

- OAuth UI のみ → `creating-react-yk`（RLS 変更なしなら L1 §0 委譲表どおり **本スキル不要**）
- deploy のみ → `creating-vercel-yk`
- 質問のみ → Ref Plan 省略 · Light floor のみ

---

## 7. Ref Plan テンプレート

### Light（短形式）

```markdown
## Ref Plan
- tier: Light（例: AUTH_DISABLED の意味確認のみ）
- load: SUPABASE_RULES L1 §7 · SUPABASE_ENV.md
```

### Standard / Deep（フル形式）

```markdown
## Ref Plan
- tier: Standard（例: profiles RLS 修正）
- tags: rls-schema, auth-ssr
- load: SUPABASE_RULES L1 §0–§1 §5 · SUPABASE_SCHEMA_RLS.md §3 · SUPABASE_AUTH_SSR.md §8
- skip: setup-dashboard（既存プロジェクト）
- 委譲: creating-react-yk（LoginForm ラベルのみ同ターン時）
- Shell: 未実行
```

---

## 8. 完了報告（末尾必須）

- tier / tags
- Shell 実行有無（cwd · コマンド要約）
- **読んだ refs**（L1 節 · L3 · 公式 URL · runbook）
- L1 §11 該当項（本番 · Preview 触ったとき）
