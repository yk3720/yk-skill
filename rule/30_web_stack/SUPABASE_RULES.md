# Supabase 参照ルール

## このルールが必要な背景

Supabase（PostgreSQL + Auth + RLS）を Next.js / Server Actions と組み合わせる際、セキュリティポリシーの書き方・初回ログインの落とし穴・ローカル開発フローを揃えておくと手戻りを減らせる。本ファイルは **YK 横断 MUST と Supabase パターンの SSOT**。

**ファイルパス（エージェント・スキル参照用）:** `c:/yk-skill/rule/30_web_stack/SUPABASE_RULES.md`

**ステータス:** `draft`（RULE_INDEX No.37）— RLS・接続方針・env の MUST は適用。L0 entry / L2 スキル未整備のため手順詳細は §5 + `SUPABASE_SETUP.md`。`active` 化条件: `supabase-dev-entry.mdc` 作成 + RULE_INDEX 更新。

**実装スタック:** `flowchart-studio`（ADR-013 DB-1）· [`NEXTJS_RULES.md`](NEXTJS_RULES.md) · [`REACTFLOW_RULES.md`](../35_reactflow/REACTFLOW_RULES.md)

**最終更新:** 2026-06-24（§6-1 Magic Link `/auth/confirm` · §8 ルート分離）（§4-1 ダッシュボード 2025〜 UI 追記）

---

## 0. エージェント向け — いつ何を読むか

### 読む深さ

| モード | 条件 | 読む節 |
|--------|------|--------|
| **Light** | env 確認・AUTH_DISABLED 質問のみ | §0 + §4（§4-1 含む）+ §7 |
| **Standard** | RLS / Auth / Server Actions を変更するとき | 本ファイル全文 + マイグレーション正本 |
| **Deep** | スキーマ変更・新テーブル追加 | Standard + ADR-013（§1 が要約 SSOT · 決定理由のみ ADR 参照）|

**質問のみ・Read のみ** → §0 + 該当節のみ。全文 Read 不要。

### 本ファイルで扱わない（委譲 SSOT）

| 関心 | SSOT |
|------|------|
| `app/` のルーティング・Server Components・Route Handler | [`NEXTJS_RULES.md`](NEXTJS_RULES.md) |
| payload / `module_id` / 表駆動保存・`lib/flowchart/` | [`REACTFLOW_RULES.md`](../35_reactflow/REACTFLOW_RULES.md) + `flowDocuments` アクション |
| OAuth UI の Client 境界・LoginForm コンポーネント | [`REACT_RULES.md`](REACT_RULES.md) |
| `.env` / トークン漏洩・キーローテーション | `10_meta/SECRETS_HYGIENE_RULES.md` |
| ダッシュボードで URL / API キーの場所（2025〜 UI） | **本ファイル §4-1** |
| Vercel ダッシュボード · env 編集 · Redeploy（2026〜 UI） | `30_web_stack/VERCEL_RULES.md` **§6-1** |
| 初回セットアップ画面操作（プロバイダー · マイグレーション等） | `c:/yk-application/flowchart-studio/docs/runbooks/SUPABASE_SETUP.md` |

### 誤ルーティング禁止

| 触るもの | 使う | 使わない |
|----------|------|----------|
| `app/auth/**` · RLS 変更 | **本ファイル** + `NEXTJS_RULES` | `REACTFLOW_RULES` のみ |
| OAuth プロバイダー設定のみ | §5–§6 + `SUPABASE_SETUP.md` | 本ファイル全文 |
| `lib/flowchart/actions/flowDocuments.ts` | `REACTFLOW_RULES` + §3 概要 | 本ファイルに実装手順を書かない |

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

## 2. テーブル設計（DB-1）

```sql
-- 許可リスト（email = primary key · 管理者が事前投入・authenticated INSERT ポリシーは意図的に無し）
public.profiles (
  email      text        primary key,
  role       text        not null check (role in ('editor', 'viewer')),
  user_id    uuid        unique references auth.users(id) on delete set null,
  created_at timestamptz not null default now()
)

-- フローチャート保存
public.flow_documents (
  module_id  text        primary key,
  title      text,
  payload    jsonb       not null,
  updated_at timestamptz not null default now(),
  updated_by uuid        references auth.users(id) on delete set null
)
```

**マイグレーション正本:** `c:/yk-application/flowchart-studio/database/migrations/`  
**DB-2 適用手順（Dashboard）:** `c:/yk-application/flowchart-studio/docs/runbooks/DB2_MIGRATION_RUNBOOK.md`

| ファイル | 内容 |
|----------|------|
| `001_db1_schema.sql` | テーブル · RLS 初期 |
| `002_fix_profiles_role_protection.sql` | profiles の role 自己昇格防止（column-level GRANT） |
| `003_db2_schema.sql` | 装置 4 表 + RLS（DELETE ポリシーなし） |
| `004_flow_documents_module_fk.sql` | デモ seed · `module_id` text→uuid · `admin_delete_equipment()` |
| `verify_db2.sql` | 適用後検証（読取のみ） |

**DB-2 適用（MUST）**

- **順序:** 003 → 004（dev のみ · 本番は別途）
- **手段:** Supabase Dashboard SQL Editor（全文貼付 · Run）。004 は破壊的警告あり
- **004 前:** `flow_documents` の text `module_id` を確認 — `spike%` 削除 · `supply-feed` と `press-01:supply-feed` の重複解消（Runbook §2.3–2.4）
- **004 後:** `flow_documents.module_id` が **uuid** であること。アプリ uuid 化は **別タスク**
- **失敗時:** トランザクション全体がロールバックされることが多い — 列確認してから再 Run。004 を部分実行した状態では **004 全文の再 Run 禁止**（Runbook 参照）

**DB-1 スキーマ（004 適用前 · 参考）**

```sql
-- フローチャート保存（DB-1）
public.flow_documents (
  module_id  text        primary key,
  ...
)
```

**DB-2 スキーマ（004 適用後 · 参考）**

```sql
public.flow_documents (
  module_id  uuid        primary key references public.modules(id),
  ...
)
-- 装置: equipment_codes → devices → units → modules
```

## 3. RLS ポリシー — 落とし穴と正しいパターン

**このセクションのスコープ:** `profiles` テーブルの MUST パターンと共通アンチパターン · `flow_documents` の運用方針（§3 共同編集表）。RLS SQL 全文はマイグレーション正本（`001` · `016` 等）を参照。

### RLS アンチパターン（禁止）

| アンチパターン | 問題 | 修正 |
|----------------|------|------|
| `USING (true)` に `TO` 句なし | `anon` 含む全員に公開 | 必ず `TO authenticated` を付ける |
| `UPDATE` ポリシーに `WITH CHECK` なし | `role='editor'` 等に自己書換え可能 | `WITH CHECK` で変更後の値を制約する |
| `auth.uid()` を直接 using/check に書く | 行ごとに再評価・低速 | 必ず `(select auth.uid())` でラップ |
| `auth.jwt() ->> 'user_metadata'` で認可 | ユーザー自己書換え可能なフィールド | `auth.jwt() ->> 'email'` または `auth.users.email` を使う |
| SELECT のみテストして INSERT/UPDATE/DELETE を省略 | 書き込み側の穴が見えない | 全 CRUD を別ユーザー JWT で検証する |

### ⚠ 落とし穴: profiles SELECT を user_id 一致のみにしない

```sql
-- ❌ 悪い例: 初回ログイン時に user_id = NULL のため自分の行が取れない
create policy "profiles_select_own" on public.profiles for select
  to authenticated
  using ((select auth.uid()) = user_id);
```

**現象:** 初回ログイン → `profiles` が見つからない → `{ kind: "pending" }` → 「アクセス権がありません」

```sql
-- ✅ 正しい例: email OR user_id の両方で照合
create policy "profiles_select_own" on public.profiles for select
  to authenticated
  using (
    lower(email) = lower(auth.jwt() ->> 'email')
    OR (select auth.uid()) = user_id
  );
```

**理由:** `user_id` は初回ログイン時に NULL。`auth.jwt() ->> 'email'` はトークンから取れるためこちらで先に照合できる。

### profiles UPDATE（user_id の自動紐づけ）と role 保護

```sql
-- user_id の自動紐づけ（メール一致のみ許可）
create policy "profiles_update_link_self"
  on public.profiles for update
  to authenticated
  using (lower(email) = lower(auth.jwt() ->> 'email'))
  with check (user_id = (select auth.uid()));

-- ⚠ 上記ポリシーは role 列の自己書換えを防げない
-- → migration 002 の column-level GRANT で user_id 列のみに更新を制限する
-- REVOKE UPDATE ON public.profiles FROM authenticated;
-- GRANT UPDATE (user_id) ON public.profiles TO authenticated;
```

### flow_documents と初回ログイン順序

`flow_documents` の RLS は `profiles.user_id = (select auth.uid())` の EXISTS に依存。**初回ログインで `user_id` が紐づく前は flow_documents へのアクセスが全て拒否される**。実装 `lib/auth/session.ts` の `getAuthState()` は profiles SELECT（email 照合）→ user_id UPDATE → `allowed` 返却の順序を保証しているため、Server Actions 経由では自動解決する。直接 PostgREST を呼ぶ場合はこの順序を意識すること。

### flow_documents — 共同編集と削除の分離（016 · 2026-06-15）

**方針:** フロー**中身の編集**（クラウド保存 · import 再取込）は **全 editor/admin**。**削除系**（動作削除 · 雛形リセット · 装置/ユニット削除）は従来どおり **所有者チェーン + admin** のみ。

| 操作 | 誰ができる | マイグレーション |
|------|------------|------------------|
| フロー中身の保存 · import 上書き | 全 `editor` / `admin` | `016_flow_documents_collaborative_edit.sql` |
| フロー雛形リセット | `admin` · flow 作成者 | `011` |
| モジュール（動作）削除 | `admin` · 装置/ユニット登録者チェーン | `013` |
| 装置 · ユニット削除 | `admin` · 各 `created_by` | `010` · `008` |

- **`015` は `016` で上書き** — 015 未適用なら 016 のみ Run でよい（Runbook §12-2b）。
- SQL 全文 · 本番確認手順: [`DB2_MIGRATION_RUNBOOK.md`](../../../yk-application/flowchart-studio/docs/runbooks/DB2_MIGRATION_RUNBOOK.md) §12-2c · handoffs [`HANDOFF.md`](../../../yk-memo/handoffs/flowchart-studio/HANDOFF.md) §6 権限表。

---

## 4. 環境変数

```env
# .env.local（git に含めない）
NEXT_PUBLIC_SUPABASE_URL=https://xxxx.supabase.co

# 新規プロジェクト（推奨）
NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY=sb_publishable_...
# または legacy（2026 年末まで動作）
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJ...

# ローカルで Supabase なしで UI だけ動かす（本番では絶対に設定しない → §7）
# AUTH_DISABLED=1
```

**取得場所:** **§4-1**（旧「Settings → API」は廃止 · Project URL は API Keys 画面に無い）

### 4-1. ダッシュボード画面（2025〜 UI）

Supabase は 2025 年以降、**Project URL と API キーの表示場所を分離**した。エージェントは **「Settings → API」** を案内しない（存在しない · 404 相当）。

#### 旧 UI との対応

| 旧（〜2025 前半） | 新（2025〜） |
|-------------------|--------------|
| Settings → **API** — Project URL と anon が同一画面 | **Connect** ダイアログ、または下表の複数箇所に分散 |
| anon / service_role のみ | **Publishable** / **Secret** キー（`sb_publishable_` · `sb_secret_`）+ Legacy タブで JWT キー併存 |

#### 欲しい値 → 開く場所

| 欲しい値 | 開く場所 | 備考 |
|----------|----------|------|
| **Project URL** | **Connect** ダイアログ（プロジェクト画面上部） | [公式第一推奨](https://supabase.com/docs/guides/getting-started/api-keys) · API Keys タブで URL + キーをまとめて表示 |
| **Project URL**（代替） | Settings → **General** → Reference ID | `https://{reference-id}.supabase.co` で組み立て可 |
| **Publishable key**（`sb_publishable_...`） | Connect ダイアログ、または Settings → **API Keys**（Publishable 表） | 新キー · フロント向け · anon の後継 |
| **anon key**（`eyJ...` · legacy JWT） | Connect ダイアログ、または Settings → **API Keys** → **Legacy API Keys** タブ | `flowchart-studio` は `NEXT_PUBLIC_SUPABASE_ANON_KEY` 名のまま利用可 |
| **Secret key**（`sb_secret_...`） | Settings → **API Keys**（Secret keys 表） | **ブラウザ・`NEXT_PUBLIC_` 禁止**（§4 禁止事項） |
| **service_role**（legacy JWT） | Settings → **API Keys** → **Legacy API Keys** タブ | サーバー・スクリプトのみ |

**注意:** Settings → **API Keys** のメイン画面（Publishable / Secret の表）には **Project URL は表示されない**。ユーザーが「API Keys を開いたが URL がない」と言ったら §4-1 の Connect または General を案内する。

#### キー種別（どれを env に入れるか）

| 種別 | 形式 | env 例（flowchart-studio） | 用途 |
|------|------|---------------------------|------|
| Publishable | `sb_publishable_...` | `NEXT_PUBLIC_SUPABASE_ANON_KEY` に代入可（[移行ガイド](https://supabase.com/docs/guides/getting-started/migrating-to-new-api-keys)） | ブラウザ · Server Actions（anon 相当） |
| anon（legacy） | JWT `eyJ...` | `NEXT_PUBLIC_SUPABASE_ANON_KEY` | 同上 · 2026 末まで併存 |
| Secret | `sb_secret_...` | **使わない**（service_role 相当 · RLS バイパス） | バッチ · 管理スクリプトのみ |
| service_role（legacy） | JWT `eyJ...` | `SUPABASE_SERVICE_ROLE_KEY`（git 外 · サーバーのみ） | seed スクリプト等 |

新規プロジェクトで Legacy タブが無い場合は **Connect** または Publishable 表から `sb_publishable_...` を取得する。「Create new API keys」ボタンがある既存プロジェクトは、押しても legacy キーは残る（[Changelog](https://supabase.com/changelog/29260-upcoming-changes-to-supabase-api-keys)）。

#### Vercel へ貼るとき（再取得）

Vercel の Sensitive env は作成後に値を読めない。**必ず Supabase 側（Connect または §4-1 の表）から再コピー**して Edit で上書き → Redeploy。Vercel 画面の開き方・Redeploy 手順は [`VERCEL_RULES.md`](VERCEL_RULES.md) **§6-1**。

#### 公式参照

- [Understanding API keys](https://supabase.com/docs/guides/getting-started/api-keys)
- [Migrating to publishable and secret API keys](https://supabase.com/docs/guides/getting-started/migrating-to-new-api-keys)
- [Upcoming changes to Supabase API Keys](https://supabase.com/changelog/29260-upcoming-changes-to-supabase-api-keys)

### ⛔ 禁止事項

| 禁止 | 理由 |
|------|------|
| `SUPABASE_SERVICE_ROLE_KEY` を `NEXT_PUBLIC_` で始める | RLS を全バイパスするキーがブラウザに露出 |
| service_role クライアントを Client Components / `use client` で使う | 同上 |
| service_role は Server Actions の通常フローに使う | RLS 無効化 → 権限チェックがすべて素通り |
| `.env.local` を git commit する | キー漏洩 |

service_role は**マイグレーション・バッチ・管理スクリプトのみ**に限定する。

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

## 6. 開発時ログイン（Magic Link / Password）

Google / Microsoft OAuth の設定が済む前に動作確認したい場合、**Email Magic Link** または **パスワード認証** を開発用フォールバックとして使用できる。

### 6-1. Magic Link（OTP · token_hash）

**Redirect URLs** に `/auth/confirm` を登録（クエリなし · パスのみ）。OAuth は `/auth/callback` と分ける。

**メールテンプレ**は `{{ .ConfirmationURL }}`（PKCE）ではなく token_hash リンク（`flowchart-studio/docs/runbooks/SUPABASE_SETUP.md` §1-1 参照）。

```tsx
// Supabase Email OTP（Magic Link）— emailRedirectTo は path のみ（?next= 不可）
const { error } = await supabase.auth.signInWithOtp({
  email,
  options: { emailRedirectTo: `${origin}/auth/confirm` },
});
```

**受信側:** `app/auth/confirm/route.ts` で `verifyOtp({ type, token_hash })`。

### 6-2. パスワード認証（Magic Link 制限回避用）
Supabase の無料枠では Magic Link の送信頻度に制限（1時間2通程度）がある。開発を止めないためにパスワード認証を併用する。

1.  **Dashboard 設定**: `Authentication > Sign In / Providers > Email` で **Confirm email** を **オフ** にする（メール確認なしで即ログイン可能にするため）。
2.  **新規登録**: アプリから `signUp({ email, password })` でユーザー作成。
3.  **既存ユーザーへの設定**: 既に Magic Link で作成済みのユーザーにパスワードを設定する場合、Dashboard の `Users` から一度削除して登録し直すのが最短。

### 6-3. 試用期の共有アカウント（開発 Supabase のみ）

複数人に Vercel dev URL で触ってもらうとき、**許可リスト + 共有パスワード**が手早い（自己登録 UI は未実装）。

1. **Authentication → Users → Add user** — `@` 付きダミーメール · Auto Confirm ON
2. **Table Editor → `profiles`** — 同じメール · `editor` または `admin`
3. 試用者には **パスワードでログイン** を案内（Magic Link は送信制限あり）

| 禁止 | 理由 |
|------|------|
| 専用本番 Supabase に共有 admin を置く | 本番データ汚染 · OAuth 一本化方針と矛盾 |
| `AUTH_DISABLED=1` を Vercel に設定 | 全員無認証 editor · クラウド保存も不整合 |

手順詳細: [`SUPABASE_SETUP.md`](../../../yk-application/flowchart-studio/docs/runbooks/SUPABASE_SETUP.md) §3-1

### ⚠ セキュリティ注意

| 環境 | 対応 |
|------|------|
| **開発プロジェクト**（`flowchart-dev` · 現行 Vercel `-dun` も接続中） | Email 有効 + Magic Link / Password UI 表示 → OK |
| **専用本番 Supabase**（分離後） | Email プロバイダーを**ダッシュボードで無効化**する（Google/Azure のみ） |

**理由:** Email が有効なまま UI を隠しても、API を直接呼べば任意メールに OTP が送れる。`profiles` に登録済みのメールを持つ攻撃者が `user_id` を紐づけ、全 `flow_documents` を閲覧できる。本番は Google / Azure（許可された組織アカウントのみ）に絞ること。

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

## 8. Next.js SSR 連携（@supabase/ssr）

Supabase Auth を Next.js App Router で使う場合、`@supabase/ssr` の 3 クライアントが必須。

| クライアント | パス | 用途 |
|--------------|------|------|
| browser | `lib/supabase/client.ts` | `"use client"` コンポーネント内（OAuth ボタン等） |
| server | `lib/supabase/server.ts` | Server Components · Server Actions · Route Handler |
| middleware | `lib/supabase/middleware.ts` | proxy.ts（Next.js 16）でセッションリフレッシュ |

### セッションリフレッシュ（proxy.ts / middleware.ts）

Server Components はクッキーを書けないため、**セッションリフレッシュは必ず proxy.ts（または middleware.ts）で行う**。proxy.ts を経由しないルートではトークン期限切れが起きる。

```ts
// middleware.ts（実装: lib/supabase/middleware.ts の updateSession を呼ぶ）
export async function middleware(request: NextRequest) {
  return await updateSession(request);
}
export const config = { matcher: ["/((?!_next/static|_next/image|favicon.ico).*)"] };
```

### サーバー側 Auth 検証

| API | 用途 | 注意 |
|-----|------|------|
| `getUser()` | Server Actions / Route Handler での本人確認 | Auth サーバーに問い合わせ → 失効・停止ユーザーも検知 |
| `getClaims()` | proxy.ts でのセッションリフレッシュ確認 | JWT をローカル検証（高速）· ユーザー停止は検知しない |
| `getSession()` | **使わない** | キャッシュ読み・サーバー検証なし → 信頼できない |

**MUST:** Server Actions で認証が必要な処理は必ず `getUser()` を先に呼ぶ（middleware は直接呼び出しでバイパスされうる）。

### 8-2. RPC / Server Action の `{ ok: false }` 戻り値

`supabase.rpc()` や DB 関数が **JSON 内の `ok: false`** を返すパターンでは、**PostgREST の `error` が null でも失敗**になりうる。

| MUST | 例 |
|------|-----|
| `data` の **`ok === false` を成功扱いしない** | `import_equipment_bundle` → `{ ok: false, error: "..." }` |
| 失敗時は `{ ok: false, error }` をクライアントへ返す | `mapRpcError(row.error)` で文言を統一してよい |
| E2E スタブは **`requireEditor()` 等の認可の後**に評価する | スタブを認可前に置くと本番誤設定時にバイパスされる（→ [`PLAYWRIGHT_RULES.md`](../50_gas_html_test/PLAYWRIGHT_RULES.md) §12-7） |

```ts
const row = data as { ok?: boolean; error?: string; /* ... */ };
if (row.ok === false) {
  return { ok: false, error: mapRpcError(row.error ?? "RPC エラー") };
}
```

### auth/callback · auth/confirm Route Handler

| ルート | 用途 | 処理 |
|--------|------|------|
| `/auth/callback` | OAuth（Google / Azure） | `exchangeCodeForSession(code)` |
| `/auth/confirm` | Magic Link · サインアップ確認メール | `verifyOtp({ type, token_hash })` |

```ts
// app/auth/callback/route.ts — OAuth
const code = searchParams.get("code");
const next = searchParams.get("next") ?? "/";
// next は同一オリジンのパスのみ許可（"//" で始まるプロトコル相対 URL を防ぐ）
const safePath = next.startsWith("/") && !next.startsWith("//") ? next : "/";
if (code) {
  await supabase.auth.exchangeCodeForSession(code);
  return NextResponse.redirect(`${origin}${safePath}`);
}
```

```ts
// app/auth/confirm/route.ts — Magic Link（token_hash テンプレ）
const tokenHash = searchParams.get("token_hash");
const type = searchParams.get("type"); // EmailOtpType
if (tokenHash && type) {
  const { error } = await supabase.auth.verifyOtp({ type, token_hash: tokenHash });
  if (!error) return NextResponse.redirect(`${origin}${safePath}`);
}
```

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
