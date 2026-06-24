# 独立アプリリポ — フォルダ構成テンプレ（YK）

**用途:** `yk-application/{app}/` の新規作成 · 既存整理の正本。  
**実例:** [flowchart-studio/specs/04_リポジトリ構造/リポジトリ構造.md](c:/yk-application/flowchart-studio/specs/04_リポジトリ構造/リポジトリ構造.md)

**最終更新:** 2026-06-24

---

## 三層（リポをまたぐ）

| 層 | 置き場 | 載せるもの |
|----|--------|------------|
| **Product Spec + 実装** | `yk-application/{app}/` | `specs/` · `app/` · `AGENTS.md` |
| **セッション** | `yk-memo/handoffs/{slug}/` | §4 = 次の 1 件 |
| **講座・提出**（任意） | `yk-memo/.../00_テーマ/` | テーマ文案のみ |

詳細: [`APP_PROJECT_RULES.md`](../rule/10_meta/APP_PROJECT_RULES.md)

---

## リポ内ツリー（テンプレ）

```text
{app-name}/
├── AGENTS.md                 # 憲法（唯一の AI 入口 · stub 禁止）
├── README.md                 # 人間向け概要 · 起動 · ディレクトリ索引
├── CHANGELOG.md
├── package.json              # フレームワーク設定はルート慣習で残す
├── {起動.bat}                # 任意 · → scripts/dev/open.bat へ委譲推奨
│
├── specs/                    # 何を作るか（Product Spec）
│   ├── README.md
│   ├── 01_要求定義/
│   ├── 02_機能設計/          # 規模に応じて追加
│   ├── 03_技術仕様/          # ADR 正本
│   ├── 04_リポジトリ構造/    # 本テンプレのプロジェクト写し
│   ├── 05_開発ガイドライン/  # decision-log（憲法は AGENTS.md）
│   └── 06_ユビキタス言語/    # 任意
│
├── docs/                     # どう動かすか（運用のみ）
│   ├── README.md
│   ├── LOCAL_DEV.md
│   └── runbooks/             # Supabase · DB · デプロイ手順
│
├── samples/                  # アプリ用サンプルデータ（JSON 等）
├── scripts/
│   ├── dev/                  # open.bat 等
│   ├── seed/                 # DB seed（TS 等）
│   └── supabase/             # SQL 関数 · 生成 Run 用
├── tools/                    # 補助パッケージ（任意 · 各 tool は testdata/ を持つ）
├── supabase/migrations/      # マイグレーションのみ（SQL スクリプトは scripts/supabase）
├── app/                      # Next.js App Router（スタックに応じて）
├── components/
├── lib/
└── e2e/                      # Playwright
```

---

## 命名ルール

| やる | やらない |
|------|----------|
| `samples/` = アプリが読むデモ JSON | `fixtures/` を複数系統で使う |
| `tools/{name}/testdata/` = ツール専用入出力 | 仕様 stub を `docs/` に置く |
| `scripts/{seed,supabase,dev}/` で自動化を分類 | `CLAUDE.md` + `AGENTS.md` + specs 憲法の三重 |
| ADR は `specs/03_技術仕様/` のみ | `docs/adr/` に索引だけ残す |

---

## 新規作成チェックリスト（最小）

1. `yk-application/{app}/` を Git 初期化
2. 上記ツリーの空フォルダ + `AGENTS.md` · `specs/README.md` · `docs/LOCAL_DEV.md`
3. `yk-memo/handoffs/{slug}/HANDOFF.md`（slug はユーザー確認）
4. `specs/04_リポジトリ構造/リポジトリ構造.md` にパス表を埋める
5. スタック rule を `AGENTS.md` に列挙（`RULE_INDEX` No 31–35 等）

スキル: `starting-app-project-yk`（handoffs · 企画 stub）

---

## Next.js 以外の場合

| スタック | 実装フォルダ | client/server 分離 |
|----------|--------------|-------------------|
| Next.js（推奨 · 本線） | `app/` · `lib/` | 不要（単一リポ） |
| Vite SPA + API | `client/` · `server/` | API を別デプロイする理由が出たとき |
| CLI のみ | `src/` | — |

**原則:** 分離はデプロイ要件が見えてから。テンプレは常に単一リポから始める。
