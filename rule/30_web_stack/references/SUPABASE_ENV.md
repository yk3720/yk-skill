# Supabase — 環境変数 · ダッシュボード（L3 参照）

**SSOT:** 本ファイル · **索引:** [`SUPABASE_RULES.md`](../SUPABASE_RULES.md) §4
**最終更新:** 2026-06-27（P14d · L1 から分割）

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
