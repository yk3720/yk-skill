# Vercel 参照ルール

## このルールが必要な背景

**Vercel** 上に Next.js などをデプロイする・プレビューと環境変数を使う・公式ドキュメントを辿る際、ホスティングと AI 周辺（Gateway / SDK）を混同しないための SSOT。Neon 連携の実務メモは **§0**、手順の実行 SSOT は **`creating-vercel-yk` スキル**。

**ファイルパス:** `c:/yk-skill/rule/30_web_stack/VERCEL_RULES.md`  
**索引:** [`RULE_INDEX.md`](../RULE_INDEX.md) No 34  
**最終更新:** 2026-06-23（§6-1 ダッシュボード 2026〜 UI 追記）

**横断:** [`SECRETS_HYGIENE_RULES.md`](../10_meta/SECRETS_HYGIENE_RULES.md) · [`GIT_WORKFLOW_RULES.md`](../10_meta/GIT_WORKFLOW_RULES.md) · [`NEXTJS_RULES.md`](NEXTJS_RULES.md) §5

---

## 0. Neon 連携・CLI・ローカル env（実務で詰まりやすい点）

AI-Driven School の **commenting-visual-explainers** 等、Vercel Marketplace 経由で Neon を繋ぐときの再現メモ。**手順の正本は本 §0。** ウィジェット埋め込みは `setup-fb-tool` / `creating-visual-explainers-fb`。

**横断:** [`SECRETS_HYGIENE_RULES.md`](../10_meta/SECRETS_HYGIENE_RULES.md) — 機密はチャットに貼らない。

### 0-1. `vercel link`（非対話）

- チームが複数あると **`Provide --scope or --team explicitly`** で止まる。CLI が提示した **`vercel link --yes --project … --scope …`** をそのまま使う。
- link 後、**Development** 向け変数が `.env.local` に入ることがある（**Sensitive は除く** — §6）。

### 0-2. Neon 接続時の Custom Prefix

- デフォルトの **`STORAGE`** のままだと **`STORAGE_URL`** になり、アプリが期待する **`DATABASE_URL`** にならない。
- **Custom Prefix は `DATABASE`** にし、**`DATABASE_URL`** が付くようにする（`setup-fb-tool` と一致）。

### 0-3. `vercel env pull` と Sensitive

- **Sensitive** は **Production / Preview のみ**作成可（Development では Sensitive トグル不可）。
- `vercel env pull`（既定は Development）では **Sensitive な Production 変数はローカルに来ない**（空行になりうる）。
- ローカル DB 用: Development スコープの非 Sensitive 複製 · Dashboard から 1 行追記 · Neon コンソール **Show secret**（`********` のままコピーしない）。

### 0-4. 接続文字列の形

- Neon / Postgres の URI は **`postgresql://` または `postgres://` で始まる**必要がある。

### 0-5. Next.js が「ルートだけ 404」

- **`/` に `page.tsx` がない**プロジェクトでは本番ルート 404 でも正常（FB ツール等）。README どおりの URL で確認。

### 0-6. コマンドの実行ディレクトリ

- **`npm run db:migrate`** 等は **`package.json` があるルート**で実行。

---

## 1. 概要（一言）

**Git 連携デプロイ + CDN/エッジ + Preview/Production 環境**をまとめるホスティング。Next.js は zero-config で載せやすい。**AI Gateway / AI SDK は別レイヤー**（§8）— ホストだけなら AI 章は読まなくてよい。

---

## 2. YK プロジェクト分岐（最優先）

**対象が未確定なら、§2 より先にここで止める。**

| 判定（シグナル / cwd） | 使うもの | Vercel でやること |
|------------------------|----------|-------------------|
| 静的図解 HTML · surge 公開 | 図解スキル系（`creating-visual-explainers` 等） | **Vercel に deploy しない** |
| 「FBツールをセットアップ」· `fb-tool-url.txt` 未設定 | **`setup-fb-tool`**（nested · 初回のみ） | link · Neon · 初回 `vercel --prod`（スキル Step 7） |
| FB 初回完了後の env / 再デプロイ | **`creating-vercel-yk`** + 本 L1 §0 | §6 手順 · Ref Plan |
| `flowchart-studio` · `flowchart-web-mermaid` · `workspace-ui-kit`（将来 deploy） | **`creating-vercel-yk`** + `NEXTJS_RULES` | link · env · Preview 確認 |
| `app/` · RSC のみ（deploy 意図なし） | **`nextjs-dev-entry`** | 本入口は不要 |
| AI Route · Gateway 導入 | **`creating-vercel-yk`** tag `ai-gateway` | §8 公式へ委譲 |

**三分岐（混同防止）**

| 成果物 | ホスト |
|--------|--------|
| 図解 HTML 本体 | **surge** |
| FB Next API（widget 用） | **Vercel** |
| 図解への widget 埋め込み | 図解スキル（Vercel CLI は触らない） |

---

## 3. エージェント向け — いつ何を読むか

| 段階 | 読むもの | タイミング |
|------|----------|------------|
| L1 | **本ファイル** | 毎回・最初（**§2 分岐確定後**）· env 画面の場所は **§6-1** |
| L2 | `creating-vercel-yk/SKILL.md` | link · env · deploy 方針 |
| 併用 | `SECRETS_HYGIENE_RULES.md` | env 追加 · 値の扱い |
| 併用 | `NEXTJS_RULES.md` §5 | `app/` 同時編集時 |
| Neon 初回 | **`setup-fb-tool`** | FB セットアップ依頼時のみ |

**実行スキル:** `creating-vercel-yk` · **禁止:** surge 静的図解の Vercel ホスト · FB 初回を本スキルだけで完結

**L0 入口:** [`vercel-dev-entry.mdc`](../../.cursor/rules/vercel-dev-entry.mdc) · `app/**` のみ → [`nextjs-dev-entry.mdc`](../../.cursor/rules/nextjs-dev-entry.mdc)

**Shell:** `AGENT_SHELL_RULES` — `vercel` CLI は **ユーザーが当ターンで deploy / test / Shell を明示したときのみ**。未明示時は Ref Plan + 手順提示まで。**例外:** ユーザーが FB 初回セットアップを依頼したターンの `setup-fb-tool` Step 7。

---

## 5. デプロイ · Git

| 操作 | 結果 |
|------|------|
| production branch（**Settings → Environments** で確認。既定は `main`）へ push/merge | **Production** deployment |
| それ以外の branch / PR | **Preview**（branch URL · commit URL） |
| CLI `vercel`（`--prod` なし） | Preview |
| CLI `vercel --prod` | Production（**ユーザー明示時のみ** — §3 Shell） |

**注意:** Git の production branch への push は **CLI 不要でも Production が走る**。「CLI 禁止 ≠ 本番反映禁止」。

**ロールバック · 昇格:** [Promoting deployments](https://vercel.com/docs/deployments/promoting-a-deployment) · [Instant Rollback](https://vercel.com/docs/instant-rollback)

---

## 6. 環境変数

| 環境 | 用途 |
|------|------|
| **Production** | 本番ユーザー向け |
| **Preview** | PR/branch レビュー（本番 DB へ書かない値） |
| **Development** | ローカル（`vercel dev` / `next dev` / `vercel env pull`） |

- 変更は **次回デプロイ**にのみ反映（過去デプロイには遡らない）。
- **Sensitive:** 登録後は Dashboard / `vercel env ls` で値非表示。build/runtime では利用可。
- **初回登録:** Sensitive · 本番キーは **Dashboard 推奨**（CLI `vercel env add --value` の空保存報告あり · 2026-05 時点）。

**ローカルへの取り込み**

| ローカルコマンド | 使う CLI |
|------------------|----------|
| `next dev` / `npm run dev` のみ | `vercel env pull [file]`（省略時 `.env` · プロジェクトは `.env.local` も可） |
| `vercel dev` / `vercel build` | **`vercel pull`**（env だけでは不足） |

- Dashboard / `vercel env add` 後は **`vercel env pull` を再実行**（デプロイとは別）。
- **Framework 変数:** deploy 時は `NEXT_PUBLIC_VERCEL_*` 等が注入される。[Framework env vars](https://vercel.com/docs/environment-variables/framework-environment-variables) — **`vercel env pull` ではプレフィックス自動付与されない** → Development スコープで `NEXT_PUBLIC_` 付き定義してから pull。
- **Middleware / Edge:** Project Settings の env を使う（`.env.local` の非 `NEXT_PUBLIC_` だけに頼らない）。

**Neon / DATABASE_URL:** §0-2 · §0-3。詳細手順の再掲は **§0 のみ**（本節では繰り返さない）。

### 6-1. ダッシュボード画面（2026〜 UI）

2026 年 1〜2 月に **ナビゲーション全面刷新**（2026-02-26 全ユーザー既定）と **環境変数 UI 改善**（2026-01-16）が入った。エージェントは旧手順（横タブのみ · Settings 内だけ、等）を前提に案内しない。

#### ナビゲーション（2026-02 既定）

| 変更点 | 内容 |
|--------|------|
| サイドバー | 横タブを **リサイズ可能なサイドバー**に統合（非表示可） |
| チーム / プロジェクト | **Projects as filters** — 同一ページをチーム版・プロジェクト版で切替 |
| モバイル | 下部フローティングバー |
| 設定の入口 | 公式: プロジェクト選択後 **サイドバーの Settings** → 各項目。一部 UI ではプロジェクト画面右上の **設定モーダル**（コミュニティ報告 2026-03） |

**見つからないとき:** サイドバーが折りたたまれていないか確認 → プロジェクトを選択済みか確認 → **Environment Variables** は Settings 配下ではなく **サイドバー直下**の項目として出る場合がある（[Managing env vars](https://vercel.com/docs/environment-variables/managing-environment-variables)）。

#### 環境変数 — 開く場所

| スコープ | 開く場所 |
|----------|----------|
| **プロジェクト** | ダッシュボードでプロジェクト選択 → サイドバー **Environment Variables** |
| **チーム全体** | チームスイッチャーでチーム選択 → **Settings** → **Environment Variables** |

2026-01 UI: 共有（チーム）とプロジェクトの変数を同一画面で管理しやすくなった。一覧は **検索** · **環境（Production / Preview / Development）フィルタ** · 各行の **⋯ メニュー**。

#### 追加 · 編集 · 削除

| 操作 | 手順 |
|------|------|
| **追加** | 画面上部フォーム — Name · Value · 適用環境（複数可）→ **Save** |
| **編集** | 一覧で変数名を検索 → 行右 **⋯** → **Edit** → 新しい Value（Sensitive は現在値非表示）→ 環境を確認 → **Save** |
| **削除** | 一覧 → **⋯** → Delete |

**MUST:** env 変更は **過去のデプロイには反映されない**。Save 後は **必ず Redeploy**（下表）。

#### Sensitive 環境変数

| 項目 | 内容 |
|------|------|
| 作成可能環境 | **Production · Preview のみ**（Development では Sensitive トグル不可 — §0-3 と同じ） |
| 保存後 | Dashboard / `vercel env ls` で **値は読めない**（`********` のままコピー禁止 — `SECRETS_HYGIENE`） |
| 編集 | **⋯ → Edit** で **Value と環境のみ**変更可。**キー名は変更不可** |
| 新規を Sensitive に | 既存を削除して Sensitive 有効で再追加 |

`NEXT_PUBLIC_SUPABASE_*` 等の本番キーは Sensitive 推奨。再貼り付け時は **Supabase 側から再コピー**（[`SUPABASE_RULES.md`](SUPABASE_RULES.md) §4-1）。

#### env 変更後の Redeploy（手順）

| 手順 | 操作 |
|------|------|
| 1 | サイドバー **Deployments** |
| 2 | 対象（通常は **最新の Production**）を選択 |
| 3 | **⋯** → **Redeploy** |
| 4 | デプロイ完了後に動作確認 |

Git push でも新デプロイは走るが、**env だけ変えたときは Redeploy が最短**（[Rotating secrets](https://vercel.com/docs/environment-variables/rotating-secrets)）。

#### 環境（Environment）の意味 — 再掲

| 環境 | いつ使う |
|------|----------|
| **Production** | 本番ブランチ（既定 `main`）へのデプロイ · `vercel --prod` |
| **Preview** | PR / 本番以外の branch · `vercel`（`--prod` なし） |
| **Development** | `vercel dev` · `vercel env pull` · ローカル `next dev` |
| **Custom environments** | 別環境をインポートして切り離す（上級） |

Preview が本番 DB（Supabase 等）を汚さないよう **Production と Preview で値を分ける**（flowchart-studio 等）。

#### 旧 UI との対応（エージェント向け）

| 旧案内（使わない） | 新（2026〜） |
|--------------------|--------------|
| 「Project Settings の Environment Variables セクションだけ」 | サイドバー **Environment Variables** を先に案内 |
| env 変更 = 即反映 | **Redeploy 必須**と明記 |
| Dashboard で Sensitive の値を確認 | **不可** — 外部（Supabase 等）から再取得 |

#### 公式参照

- [Dashboard navigation redesign](https://vercel.com/changelog/dashboard-navigation-redesign-rollout)（2026-02-26 既定）
- [Improved environment variables UI](https://vercel.com/changelog/improved-environment-variables-ui)（2026-01-16）
- [Managing environment variables](https://vercel.com/docs/environment-variables/managing-environment-variables)
- [Sensitive environment variables](https://vercel.com/docs/environment-variables/sensitive-environment-variables)
- [Rotating environment variables](https://vercel.com/docs/environment-variables/rotating-secrets)

---

## 7. `vercel.json` 要点

| キー | 用途 |
|------|------|
| `git.deploymentEnabled` | ブランチごとに自動デプロイ on/off（[Git configuration](https://vercel.com/docs/project-configuration/git-configuration)） |

redirects · headers · crons 等は [Project Configuration](https://vercel.com/docs/project-configuration) へ委譲（L1 に手順を増やさない）。

---

## 8. AI 境界（リンク + 委譲）

| レイヤー | 役割 | YK で読むタイミング |
|----------|------|---------------------|
| **ホスティング** | Next デプロイ · Functions · Preview | 本 L1 §5–§7 |
| **AI Gateway** | 統一 API · 課金 · フォールバック · 200+ models | AI 機能を実装するときのみ |
| **AI SDK** | TS 向け推奨 · model string で Gateway 経由 | 同上 |

- Next を載せるだけ → **§8 はスキップ可**。
- `generateText` / Gateway 導入時 → [AI Gateway](https://vercel.com/docs/ai-gateway) · [AI SDK on Gateway](https://vercel.com/docs/ai-gateway/sdks-and-apis/ai-sdk) · ROUTER tag `ai-gateway`（手順は公式 Getting started へ委譲）。

---

## 9. 公式カタログ（参照）

### 9-1. できることの例

- [Git 連携](https://vercel.com/docs/git) · [Environments](https://vercel.com/docs/deployments/environments) · [Marketplace](https://vercel.com/docs/integrations)
- [Next.js on Vercel](https://vercel.com/docs/frameworks/full-stack/nextjs) · [Functions](https://vercel.com/docs/functions) · ISR · [Image Optimization](https://vercel.com/docs/image-optimization)

### 9-2. AI 関連（製品一覧）

[AI SDK](https://vercel.com/docs/ai-sdk) · [AI Gateway](https://vercel.com/docs/ai-gateway) · [MCP](https://vercel.com/docs/mcp) · [v0](https://v0.app/docs/introduction)

---

## 10. 参照 URL（公式 · クイック）

| 説明 | URL |
|------|-----|
| ドキュメント入口 | https://vercel.com/docs |
| Environment variables | https://vercel.com/docs/environment-variables |
| `vercel env` CLI | https://vercel.com/docs/cli/env |
| Next.js on Vercel | https://vercel.com/docs/frameworks/full-stack/nextjs |
| Git | https://vercel.com/docs/git |

---

## 14. 禁止・境界

| 禁止 | 理由 |
|------|------|
| surge 静的図解 HTML を Vercel にホスト | §2 · 図解スキル |
| FB 初回セットアップを `creating-vercel-yk` のみで完結 | `setup-fb-tool` が正本 |
| 未明示の `vercel --prod` / 本番 redeploy CLI | §3 Shell · handoffs |
| L1 §0 をスキルに再掲 | 二重 SSOT |
| deploy Ref Plan に ui-kit `vercel-react-best-practices` 全文 | 性能 SSOT は ui-kit（RULE_INDEX D 行） |

---

## 15. 品質ゲート（変更時）

- [ ] §2 で YK 分岐（surge / FB 初回 / 汎用 deploy）を確定した
- [ ] 触った §0 / §5 / §6 / §7 の該当項を実施した（または Ref Plan で skip 理由を書いた）
- [ ] Secrets: 値をチャット・commit に載せていない（`SECRETS_HYGIENE`）
- [ ] Shell: CLI 実行はユーザー明示または `setup-fb-tool` 例外のみ

**完了報告:** tier / tags · **読んだ refs**（L1 節 · ROUTER · 公式 URL）· CLI は実行したか提示のみか — 各 1 行。

**React/Next 性能:** `yk-tool/workspace-ui-kit/.claude/skills/vercel-react-best-practices`（ui-kit 正本）。deploy とは別。`creating-react-yk` ROUTER tag `performance` 経由。
