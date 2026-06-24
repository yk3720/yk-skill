# 独立アプリリポ — フォルダ構成テンプレ（YK）

**用途:** `yk-application/{app}/` の新規作成 · 既存整理の正本。  
**実例:** [flowchart-studio/docs/04_リポジトリ構造/リポジトリ構造.md](c:/yk-application/flowchart-studio/docs/04_リポジトリ構造/リポジトリ構造.md)

**最終更新:** 2026-06-24（repo-layout v3.2 · python/ 層）

---

## 三層（リポをまたぐ）

| 層 | 置き場 | 載せるもの |
|----|--------|------------|
| **ドキュメント + 実装** | `yk-application/{app}/` | `docs/` · `app/` · `AGENTS.md` |
| **セッション** | `yk-memo/handoffs/{slug}/` | §4 = 次の 1 件 |
| **講座・提出**（任意） | `yk-memo/.../00_テーマ/` | テーマ文案のみ |

詳細: [`APP_PROJECT_RULES.md`](../rule/10_meta/APP_PROJECT_RULES.md)

---

## 実装四層（リポ内）

| 層 | フォルダ | 載せるもの |
|----|----------|------------|
| **フロントエンド** | `app/` · `frontend/src/` | ページ · UI · デモ JSON |
| **バックエンド** | `backend/src/` · `app/**/route.ts` | Server Actions · 認証 · DB 接続 |
| **データベース** | `database/` | migrations · seed · SQL |
| **Python** | `python/src/` · `python/testdata/` | Excel 正規化等 |
| **共有** | `lib/` | 純粋関数（フレームワーク非依存） |

> Next.js では `app/` をルートに置く（`frontend/app/` は不可）。`backend/` は別プロセスの API サーバーではなく、同一 Next.js 内のサーバー側コード。

---

## リポ内ツリー（テンプレ）

```text
{app-name}/
├── AGENTS.md
├── README.md
├── package.json
├── middleware.ts                 # Next.js · ルート固定
├── {起動.bat}                    # 任意 · → scripts/dev/open.bat
│
├── docs/                         # 仕様 + 運用
│   ├── README.md
│   ├── 01_要求定義/
│   ├── 02_機能設計/
│   ├── 03_技術仕様/              # ADR 正本
│   ├── 04_リポジトリ構造/
│   ├── 05_開発ガイドライン/
│   ├── 06_ユビキタス言語/        # 任意
│   ├── LOCAL_DEV.md
│   └── runbooks/
│
├── app/                          # フロント入口（Next.js 制約）
├── frontend/
│   └── src/
│       ├── components/
│       └── samples/
├── backend/
│   └── src/
│       └── lib/                      # auth · actions · supabase
├── lib/                          # 共有ドメイン
├── database/
│   ├── migrations/
│   ├── sql/
│   └── src/
│       └── seed/
├── scripts/dev/
├── python/                       # 任意 · Excel 取込等
│   ├── pyproject.toml
│   ├── src/
│   │   └── {package}/
│   ├── scripts/
│   ├── tests/
│   └── testdata/
└── e2e/
```

---

## import エイリアス（Next.js 推奨）

物理フォルダと既存 import を両立する。

| import | 実パス |
|--------|--------|
| `@/components/*` | `frontend/src/components/*` |
| `@/samples/*` | `frontend/src/samples/*` |
| `@/lib/auth/*` | `backend/src/lib/auth/*` |
| `@/lib/supabase/*` | `backend/src/lib/supabase/*` |
| `@/lib/flowchart/actions/*` | `backend/src/lib/flowchart/actions/*` |
| `@/lib/*` | `lib/*` |

---

## 命名ルール

| やる | やらない |
|------|----------|
| `docs/` に仕様 + 運用を集約 | `specs/` と `docs/` の二重正本 |
| `frontend/` · `backend/` · `database/` | `client/` · `server/`（Vite+Express 向け） |
| `frontend/src/samples/` = アプリ用デモ JSON | `fixtures/` を複数系統で使う |
| ADR は `docs/03_技術仕様/` のみ | リダイレクト stub を増やす |

---

## 新規作成チェックリスト（最小）

1. `yk-application/{app}/` を Git 初期化
2. 上記ツリー + `AGENTS.md` · `docs/README.md` · `docs/LOCAL_DEV.md`
3. `yk-memo/handoffs/{slug}/HANDOFF.md`
4. `docs/04_リポジトリ構造/リポジトリ構造.md` にパス表を埋める
5. `tsconfig.json` に import エイリアスを設定

スキル: `starting-app-project-yk`

---

## Next.js 以外の場合

| スタック | 実装フォルダ | frontend/backend 分離 |
|----------|--------------|-------------------------|
| Next.js（推奨 · 本線） | `app/` · `lib/` | `frontend/` + `backend/lib/`（ハイブリッド） |
| Vite SPA + API | `frontend/` · `backend/` | API を別デプロイする理由が出たとき |
| CLI のみ | `src/` | — |
