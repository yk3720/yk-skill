# Vercel 参照ルーティング（ROUTER）

**SSOT:** 本ファイルが tier · tag · Ref Plan テンプレの唯一の正本。  
**要約・MUST:** `yk-skill/rule/30_web_stack/VERCEL_RULES.md` · **手順:** `../SKILL.md`  
**設計パターン:** `yk-skill/rule/10_meta/PROGRESSIVE_CONTEXT_ROUTING_RULES.md`

**最終更新:** 2026-05-24

---

## 0. 禁止・原則

- **§2 分岐未確定のまま** link/env/deploy 手順を出さない
- **§0 Neon 手順を SKILL に再掲しない** — Ref Plan の `load` は `VERCEL_RULES §0` へリンク
- tier / tag 表を `SKILL.md` や L1 に **複製しない**
- **surge 静的図解** → 本 ROUTER 不使用（L1 §14）
- **FB 初回** → `setup-fb-tool`（本スキル拒否）
- **deploy Ref Plan に** `vercel-react-best-practices` **を載せない**（tag `perf-only` は ui-kit 参照のみ）

---

## 1. 手順（毎タスク）

1. `VERCEL_RULES.md` **§2** で対象確定（未確定なら停止）
2. `SKILL.md` → 本 ROUTER で **tier** と **tags**
3. **Ref Plan** をチャットに出力
4. Ref Plan の `load` **だけ** Read → 編集 /（明示時のみ）CLI
5. L1 §15 ゲート → 完了報告

---

## 2. Tier — floor

| tier | いつ | floor（必ず Read） |
|------|------|----------------------|
| **Light** | 説明 · ドキュメント整理 · deploy 意図なし | L1 §2 · §1 |
| **Standard** | `vercel env pull` 方針 · Preview 手順 · env 表の更新 | **L1** §2–§3 · §6 · 触る §0 項 |
| **Full** | 初回 link · Neon 連携 · `vercel.json` 新規 · 本番方針 | L1 全体 · 本 ROUTER §3 tag floor · 公式 1 URL |

**既定:** 迷ったら **Standard**。

---

## 3. Tag — floor に加算

| tag | 追加 floor |
|-----|------------|
| `link-env` | L1 §0-1 · §6 · [Environment variables](https://vercel.com/docs/environment-variables) · [vercel env CLI](https://vercel.com/docs/cli/env) |
| `neon-fb` | L1 **§0 全体** · `setup-fb-tool`（初回のみ · 再デプロイは本スキル） |
| `next-on-vercel` | L1 §5 · [Next.js on Vercel](https://vercel.com/docs/frameworks/full-stack/nextjs) · `NEXTJS_RULES` §5（`app/` 同時時） |
| `git-deploy` | L1 §5 · [Git](https://vercel.com/docs/git) · §7 `git.deploymentEnabled` |
| `ai-gateway` | L1 §8 · [AI Gateway](https://vercel.com/docs/ai-gateway) — **手順は公式へ委譲** |
| `surge-forbidden` | L1 §2 · §14 — **作業中止** |
| `perf-only` | ui-kit `.claude/skills/vercel-react-best-practices` — **deploy タスクでは load しない** |

**公式 URL:** 1 tag あたり **1 ページまで**。

---

## 4. シグナル → tag

| シグナル | tag | 禁止 |
|----------|-----|------|
| `vercel link` · scope エラー | `link-env` | — |
| `vercel env pull` · Sensitive 空 | `link-env` + §0 | 値をチャットに貼る |
| Neon · `DATABASE_URL` · Marketplace | `neon-fb` | 初回を本スキルのみ |
| production branch · Preview · `vercel --prod` | `git-deploy` | 未明示の `--prod` |
| flowchart / ui-kit を Vercel に載せる | `next-on-vercel` | surge 図解 |
| AI SDK · Gateway · `generateText` | `ai-gateway` | L1 に手順全文を書く |
| surge · 図解デプロイ | `surge-forbidden` | 本スキル |
| パフォーマンス · Core Web Vitals | `perf-only` | deploy Ref Plan に混ぜる |

---

## 5. リポ内パス · L0 優先

| パス | L0 優先 | vercel lead |
|------|---------|-------------|
| `vercel.json` · `.vercel/**` | **`vercel-dev-entry`** → 本スキル | Standard / Full |
| `app/**` のみ | **`nextjs-dev-entry`** | 委譲のみ |
| `commenting-visual-explainers/**` FB 初回 | **`setup-fb-tool`** | 本スキル拒否 |

---

## 6. パージ

- surge 図解 → 図解スキル（L1 §14）
- `components/ui` → `creating-shadcn-yk`
- Python `.env` · `5.Python` → `PYTHON_RULES`（No 34 ではない）

---

## 7. Ref Plan テンプレート

```markdown
## Ref Plan
- §2 対象: surge中止 | fb-初回→setup-fb-tool | flowchart-deploy | env-only | …
- tier: Standard（理由 1 行）
- tags: link-env, git-deploy
- load: VERCEL_RULES L1 §2 §6 · §0-3（該当時）
- skip: AI §8（ホストのみのため）
- 委譲: creating-nextjs-yk（app/ 同時時）
- Shell: 未実行 | ユーザー明示で vercel …（cwd）
```

---

## 8. 完了報告（末尾必須）

- §2 対象
- tier / tags
- Shell 実行有無（cwd · コマンド要約）
- **読んだ refs**（L1 節 · ROUTER · 公式 URL）
- L1 §15 該当項
