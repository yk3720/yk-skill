# Vercel 参照ルール

## このルールが必要な背景

**Vercel** 上に Next.js などをデプロイする・プレビューを使う・ドキュメントを辿る際、公式が提供する機能区分（ホスティング、Functions、AI 周辺など）を混同しないためのメモ。本ファイルは **公式要点とリンクの SSOT** とする。

**ファイルパス（エージェント・スキル参照用）:** `c:\yk-skill\rule\VERCEL_RULES.md`

**最終更新:** 2026-05-10

---

## 1. 概要（一言）

公式ドキュメントでは **「The AI Cloud」** と位置づけられ、**ビルド・デプロイ・スケール**をまとめて扱うクラウドプラットフォーム。**Git と連携した自動デプロイ**やプレビュー環境が強みとして説明されている。

---

## 2. 公式ドキュメントで押さえること

### 2-1. できることの例（公式の整理）

- 静的サイト、各種 **フレームワーク**、[マルチテナント SaaS](https://vercel.com/docs/multi-tenant)、[マイクロフロントエンド](https://vercel.com/docs/microfrontends)、AI エージェント連携アプリなど。
- [Git リポジトリ連携](https://vercel.com/docs/git)でプッシュごとにデプロイ、[プレビュー環境](https://vercel.com/docs/deployments/environments#preview-environment-pre-production)で本番前に検証。
- [Marketplace](https://vercel.com/docs/integrations) で AI・DB・CMS・分析・ストレージなどの連携。

### 2-2. アプリ構築まわり

[Next.js](https://vercel.com/docs/frameworks/nextjs)、他 [対応フレームワーク](https://vercel.com/docs/frameworks/more-frameworks)、[Functions](https://vercel.com/docs/functions)、[Routing Middleware](https://vercel.com/docs/routing-middleware)、ISR、[画像最適化](https://vercel.com/docs/image-optimization)、[環境（preview / production 等）](https://vercel.com/docs/deployments/environments)、[Feature flags](https://vercel.com/docs/feature-flags) など。

### 2-3. AI 関連（公式が強調している領域）

[AI SDK](https://vercel.com/docs/ai-sdk)、[AI Gateway](https://vercel.com/docs/ai-gateway)、[MCP Servers](https://vercel.com/docs/mcp)、[v0](https://v0.app/docs/introduction) など。

### 2-4. その他（公式カテゴリ）

- **チーム:** Toolbar、Comments、Draft mode など。
- **セキュリティ:** Deployment Protection、RBAC、WAF、Bot 対策など。
- **デプロイ・スケール:** CDN、[Rolling Releases](https://vercel.com/docs/rolling-releases)、[Instant Rollback](https://vercel.com/docs/instant-rollback)、Observability など。

### 2-5. Next.js との関係

Next.js は Vercel が主導する OSS で、**Vercel 上で Next.js をホストする**のはよくある組み合わせ（公式ドキュメントでも Next.js が前面に出る）。Next を Vercel に載せる場合は **Getting started** と **Next.js 向けページ**が有用。

---

## 3. 参照 URL（公式）

| 説明 | URL |
|------|-----|
| ドキュメント入口 | https://vercel.com/docs |
| はじめての Vercel | https://vercel.com/docs/getting-started-with-vercel |
| Next.js on Vercel | https://vercel.com/docs/frameworks/nextjs |
| Knowledge Base（ガイド集） | https://vercel.com/kb |

---

## 4. エージェント向けメモ

- 「何をしているサービスか」を説明するときは、**Git 連携デプロイ + エッジ/CDN + プレビュー**を一言に含めると伝わりやすい。必要に応じて AI 周辺機能も説明に含める。
