# Supabase — Auth · Next.js SSR（L3 参照）

**SSOT:** 本ファイル · **索引:** [`SUPABASE_RULES.md`](../SUPABASE_RULES.md) §6 · §8
**最終更新:** 2026-06-27（P14d · L1 から分割）

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
