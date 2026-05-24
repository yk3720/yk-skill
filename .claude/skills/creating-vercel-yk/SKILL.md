---
name: creating-vercel-yk
description: Vercel の link/env/deploy 方針と Ref Plan。発火例「vercel link」「vercel env」「Vercel にデプロイ」「vercel.json」。Do NOT use for surge 静的図解ホスト（図解スキル）· FB 初回セットアップ（setup-fb-tool）· app/ のみの RSC 編集（creating-nextjs-yk）· AI 実装の詳細手順（公式 + ROUTER tag ai-gateway）。
---

# Creating Vercel deploy（YK）

**品質方針:** `VERCEL_RULES.md` §15 ゲート未通過の完了報告は禁止。

## Step 0: 入口（必須）

1. **`VERCEL_RULES.md`** — L1（**§2 分岐を先に確定**）
2. **本 SKILL.md**
3. **[ROUTER.md](references/ROUTER.md)** — tier / tag · Ref Plan テンプレ

**同一ターンで `app/` + deploy 方針:** lead は状況に応じ **`creating-nextjs-yk`** または本スキル。併用時は Ref Plan に **`委譲:`** を列挙。

## Step 0.1: Shell（`AGENT_SHELL_RULES`）

| 状態 | エージェントの動き |
|------|-------------------|
| ユーザーが deploy / test / Shell を**未明示** | Ref Plan · cwd · §0/§6 チェックリスト**提示まで**。`vercel` CLI は**実行しない** |
| **明示あり** | ROUTER の CLI 節どおり（cwd 明示） |
| **FB 初回セットアップ**依頼 | **`setup-fb-tool`**（本スキルは使わない） |

## Step 0.2: Ref Plan → load（CLI 前）

1. ROUTER で tier / tags を決定
2. **Ref Plan をチャットに出力**
3. Ref Plan の **`load` に列挙したものだけ** Read

→ テンプレ: [ROUTER.md §7](references/ROUTER.md#7-ref-plan-テンプレート)

**委譲:** Neon 手順の正本 → L1 **§0 のみ**（再掲禁止）· `app/` RSC → `creating-nextjs-yk` · 機密 → `SECRETS_HYGIENE_RULES`

## 作業プロセス

ROUTER §1 と同じ: §2 確定 → tier/tag → Ref Plan → load → §15 ゲート → 完了報告。

## CLI（実行 SSOT · ユーザー明示時のみ）

**cwd を必ず明示。** 値はチャットに貼らない。

### 汎用（リンク済みプロジェクト）

```bash
cd c:/path/to/next-app   # package.json があるルート
vercel link --yes --project … --scope …   # §0-1
vercel env pull .env.local                # next dev のみのとき
# vercel dev / vercel build 前は vercel pull
```

### Preview 確認（明示依頼時）

```bash
vercel          # Preview deployment
# vercel --prod  # Production — ユーザー明示 + §3 確認後のみ
```

## 方式境界

| やりたいこと | 使うもの |
|--------------|----------|
| link · env · deploy 方針 | **本スキル + VERCEL_RULES** |
| FB 初回 · widget 埋め込み | **`setup-fb-tool`** · `creating-visual-explainers-fb` |
| 図解 HTML · surge | 図解スキル — **Vercel 禁止** |
| `app/` · layout/page | `creating-nextjs-yk` |
| AI Gateway / SDK 実装 | ROUTER `ai-gateway` + 公式 docs（L1 §8） |
| React 性能 70 ルール | ui-kit `vercel-react-best-practices`（**deploy Ref Plan に載せない**） |

## L0 入口

| パス | 優先 entry |
|------|------------|
| `vercel.json` · `.vercel/**` | **`vercel-dev-entry.mdc`** → 本スキル |
| `app/**` のみ | **`nextjs-dev-entry.mdc`**（本スキル不要） |

---

索引: `RULE_INDEX.md` No 34 · 「Vercel / デプロイを触るとき」節
