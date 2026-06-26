# Supabase 参照ルール

## このルールが必要な背景

Supabase（PostgreSQL + Auth + RLS）を Next.js / Server Actions と組み合わせる際、セキュリティポリシーの書き方・初回ログインの落とし穴・ローカル開発フローを揃えておくと手戻りを減らせる。本ファイルは **YK 横断 MUST と Supabase パターンの SSOT**。

**ファイルパス（エージェント・スキル参照用）:** `c:/yk-skill/rule/30_web_stack/SUPABASE_RULES.md`

**ステータス:** `draft`（RULE_INDEX No.37）— RLS・接続方針・env の MUST は適用。L0 entry / L2 スキル未整備のため手順詳細は §5 + `SUPABASE_SETUP.md`。`active` 化条件: `supabase-dev-entry.mdc` 作成 + RULE_INDEX 更新。

**実装スタック:** `flowchart-studio`（ADR-013 DB-1）· [`NEXTJS_RULES.md`](NEXTJS_RULES.md) · [`REACTFLOW_RULES.md`](../35_reactflow/REACTFLOW_RULES.md)

**最終更新:** 2026-06-27（P14d · §2-4 · §6 · §8 を `references/` へ分割）

---

## 0. エージェント向け — いつ何を読むか

### 読む深さ

| モード | 条件 | 読む節 |
|--------|------|--------|
| **Light** | env 確認・AUTH_DISABLED 質問のみ | §0 + §4 索引 + [`SUPABASE_ENV.md`](references/SUPABASE_ENV.md) + §7 |
| **Standard** | RLS / Auth / Server Actions を変更するとき | L1 §0–§1 · §5 · §7 + **該当 `references/`**（§2 索引 · §4 索引 · §6 索引）+ マイグレーション正本 |
| **Deep** | スキーマ変更 · 新テーブル追加 | Standard + `SUPABASE_SCHEMA_RLS.md` 全文 + ADR-013 |

**質問のみ・Read のみ** → §0 + 該当節のみ。全文 Read 不要。

### 本ファイルで扱わない（委譲 SSOT）

| 関心 | SSOT |
|------|------|
| `app/` のルーティング・Server Components・Route Handler | [`NEXTJS_RULES.md`](NEXTJS_RULES.md) |
| payload / `module_id` / 表駆動保存・`lib/flowchart/` | [`REACTFLOW_RULES.md`](../35_reactflow/REACTFLOW_RULES.md) + `flowDocuments` アクション |
| OAuth UI の Client 境界・LoginForm コンポーネント | [`REACT_RULES.md`](REACT_RULES.md) |
| `.env` / トークン漏洩・キーローテーション | `10_meta/SECRETS_HYGIENE_RULES.md` |
| ダッシュボードで URL / API キーの場所（2025〜 UI） | [`references/SUPABASE_ENV.md`](references/SUPABASE_ENV.md) §4-1 |
| Vercel ダッシュボード · env 編集 · Redeploy（2026〜 UI） | `30_web_stack/VERCEL_RULES.md` **§6-1** |
| 初回セットアップ画面操作（プロバイダー · マイグレーション等） | `c:/yk-application/flowchart-studio/docs/runbooks/SUPABASE_SETUP.md` |

### 誤ルーティング禁止

| 触るもの | 使う | 使わない |
|----------|------|----------|
| `app/auth/**` · RLS 変更 | **本ファイル** + `NEXTJS_RULES` | `REACTFLOW_RULES` のみ |
| OAuth プロバイダー設定のみ | §5 + §6 索引 + `SUPABASE_SETUP.md` | L1 全文 + references 全読み |
| `lib/flowchart/actions/flowDocuments.ts` | `REACTFLOW_RULES` + §2 索引（RLS 概要） | 本ファイルに実装手順を書かない |

---

## 1. プロジェクト構成（ADR-013 方針）

| 項目 | 方針 |
|------|------|
| **環境** | 本番 / 開発（プレビュー）で **2 プロジェクト**（Preview が本番 DB を汚さない） |
| **接続** | **Server Actions メイン + RLS 保険**（サービスロールを Client に渡さない） |
| **役割** | `editor` / `viewer`（`profiles` テーブルのメール許可リストで管理） |
| **Auth** | Google · Azure（Microsoft）· 開発時は Email Magic Link / Password も可（§6） |
| **制限回避** | Magic Link の回数制限時はパスワード認証を併用（§6-2） |

**認可の正:** RLS + Server Actions の二重チェック。ページ保護はアプリ層（`getAuthState()`）で明示。新 Route 追加時は必ず未認証テストを行う。

### 実装マップ（flowchart-studio）

| 関心 | 正本パス |
|------|----------|
| Supabase クライアント（server / client / middleware） | `backend/src/lib/supabase/{server,client,middleware,env}.ts`（import: `@/lib/supabase/*`） |
| Auth セッション取得 | `backend/src/lib/auth/session.ts`（`getAuthState` · `getAuthContext`） |
| Cloud 保存・読込 Server Actions | `backend/src/lib/flowchart/actions/documents/flowDocuments.ts` |
| ログイン UI | `frontend/src/components/auth/LoginForm.tsx` |
| コールバック | `app/auth/callback/route.ts` |
| セッションリフレッシュ（proxy） | `middleware.ts` → `backend/src/lib/supabase/middleware.ts` |

---


## 2. テーブル設計 · RLS（索引）

**詳細:** [`references/SUPABASE_SCHEMA_RLS.md`](references/SUPABASE_SCHEMA_RLS.md) — §2 DB-1/DB-2 · §3 RLS 落とし穴

| 節 | 内容 |
|----|------|
| §2 | テーブル · マイグレーション正本 · DB-2 適用手順 |
| §3 | RLS アンチパターン · profiles · flow_documents 共同編集 |

---

## 4. 環境変数（索引）

**詳細:** [`references/SUPABASE_ENV.md`](references/SUPABASE_ENV.md) — §4-1 ダッシュボード 2025〜 UI · 禁止事項

**Light モード:** §0 + 本節索引 + §7（AUTH_DISABLED）

---


## 5. ローカル開発フロー

1. Supabase ダッシュボードで**開発用プロジェクト**を作成（本番と必ず分ける）
2. SQL Editor でマイグレーション実行（`001_db1_schema.sql` → `002_fix_profiles_role_protection.sql`）
3. **Authentication → URL Configuration** で Redirect URLs に追加:
   - `http://localhost:3000/auth/callback`
   - Site URL も `http://localhost:3000` に設定
4. Table Editor → `profiles` に自分のメールを `editor` で追加（role は手動のみ — INSERT ポリシーなし）
5. Authentication → Sign In / Providers でプロバイダーを有効化
6. `.env.local` に URL / Publishable Key を設定
7. `npm run dev` → ログイン確認（`app/auth/callback/route.ts` が `exchangeCodeForSession` でセッション確立）

**セットアップ詳細（画面操作）:** `c:/yk-application/flowchart-studio/docs/runbooks/SUPABASE_SETUP.md`

---

## 6. 開発時ログイン · SSR（索引）

**詳細:** [`references/SUPABASE_AUTH_SSR.md`](references/SUPABASE_AUTH_SSR.md)

| 節 | 内容 |
|----|------|
| §6 | Magic Link · Password · 試用共有アカウント |
| §8 | @supabase/ssr · proxy · Route Handler · RPC `ok: false` |

---


## 7. AUTH_DISABLED モード

```ts
// lib/supabase/env.ts — 認証バイパスは明示オプトインのみ
export function isAuthDisabled(): boolean {
  return process.env.AUTH_DISABLED === "1";
}

/** 本番で Supabase 未設定かつ AUTH_DISABLED でない場合は起動を止める */
export function assertProductionSupabaseEnv(): void {
  if (process.env.NODE_ENV !== "production") return;
  if (isAuthDisabled()) return;
  getSupabaseEnv(); // 未設定なら throw
}
```

`AUTH_DISABLED=1` のときのみ `getAuthState()` が `dev@local / editor` を返し、認証・RLS をバイパスする。**`NEXT_PUBLIC_SUPABASE_URL` 未設定だけではバイパスしない**（本番の設定ミスで全員 editor になる事故を防ぐ）。

### ローカル開発（Supabase なし）

| 条件 | 設定 |
|------|------|
| UI だけ動かす | `.env.local` に **`AUTH_DISABLED=1`**（[LOCAL_DEV.md](../../../yk-application/flowchart-studio/docs/LOCAL_DEV.md)） |
| Playwright E2E | `playwright.config.ts` が `AUTH_DISABLED=1` を注入（`:3001`） |

URL を設定した後は**サーバーを再起動**すること（環境変数は起動時のみ読み込まれる）。

### ⛔ 本番 MUST NOT

| チェック | 内容 |
|----------|------|
| `AUTH_DISABLED=1` が Vercel 本番 env に無いこと | 全 API が editor 扱いになる |
| `NEXT_PUBLIC_SUPABASE_URL` / `ANON_KEY` が本番 / Preview env に設定されていること | `next.config` の `assertProductionSupabaseEnv` が build/start で失敗する |
| Production と Preview で Supabase プロジェクトを分けていること | Preview が本番 DB を汚さない |

---

## 10. Tauri / Desktop 連携

デスクトップアプリ（Tauri）で Supabase Auth を使う場合、ブラウザベースの Web アプリとは異なる考慮が必要。

### Deep Link によるコールバック
OAuth や Magic Link のリダイレクト先としてカスタムプロトコル（例: `my-app://auth/callback`）を使用する。

1.  **Supabase 設定**: `Authentication > URL Configuration` の Redirect URLs にカスタムプロトコルを登録。
2.  **PKCE フロー**: Tauri 等の Public Client では PKCE フローが必須。
3.  **セッション交換**: アプリ側で Deep Link を検知し、URL に含まれる `code` を `exchangeCodeForSession(code)` でセッションに変換する。

### 二重起動の防止 (Single Instance)
リダイレクト時に新しいウィンドウが開かないよう、Tauri の `single-instance` プラグインを併用し、既存のウィンドウでリンクを処理させること。

---

## 11. 本番デプロイ前チェックリスト

| # | チェック |
|---|---------|
| DB | `profiles` · `flow_documents` に RLS が有効（ALTER TABLE ENABLE ROW LEVEL SECURITY） |
| DB | 全テーブルに SELECT / INSERT / UPDATE / DELETE ポリシーがある（または意図的に無し） |
| DB | `USING(true)` に `TO authenticated` が付いている |
| DB | `UPDATE` ポリシーに `WITH CHECK` がある |
| DB | column-level GRANT で `profiles.role` の自己書換えを防いでいる（migration 002） |
| Auth | Email プロバイダーを本番で**無効化**している（Google/Azure のみ） |
| Auth | Redirect URLs に本番・Preview の `/auth/callback` が登録されている |
| Env | `AUTH_DISABLED` が本番 env に無いこと |
| Env | `NEXT_PUBLIC_SUPABASE_URL` / `ANON_KEY` が本番 / Preview env に設定されていること（`assertProductionSupabaseEnv`） |
| Env | service_role キーが `NEXT_PUBLIC_` で始まっていないこと |
| 監査 | Supabase ダッシュボード → **Security Advisor** で定期確認（マイグレーション後・月次） |
