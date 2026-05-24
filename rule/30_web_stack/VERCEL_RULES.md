# Vercel 参照ルール

## このルールが必要な背景

**Vercel** 上に Next.js などをデプロイする・プレビューと環境変数を使う・公式ドキュメントを辿る際、ホスティングと AI 周辺（Gateway / SDK）を混同しないための SSOT。Neon 連携の実務メモは **§0**、手順の実行 SSOT は **`creating-vercel-yk` スキル**。

**ファイルパス:** `c:/yk-skill/rule/30_web_stack/VERCEL_RULES.md`  
**索引:** [`RULE_INDEX.md`](../RULE_INDEX.md) No 34  
**最終更新:** 2026-05-24（Web 調査 + 3視点レビュー · `creating-vercel-yk` · `vercel-dev-entry`）

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
| `flowchart-web-*` · `workspace-ui-kit`（将来 deploy） | **`creating-vercel-yk`** + `NEXTJS_RULES` | link · env · Preview 確認 |
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
| L1 | **本ファイル** | 毎回・最初（**§2 分岐確定後**） |
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
