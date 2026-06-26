# Supabase — スキーマ · RLS（L3 参照）

**SSOT:** 本ファイル · **索引:** [`SUPABASE_RULES.md`](../SUPABASE_RULES.md) §2 · §3
**最終更新:** 2026-06-27（P14d · L1 から分割）

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
