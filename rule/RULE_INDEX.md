# yk-skill/rule — ルール索引

エージェント・人間が **どのファイルをいつ読むか** の入口。詳細は各ファイルが SSOT。

**最終更新:** 2026-05-17

---

## 読む順序（workspace-ui-kit を触るとき）

1. **`WORKSPACE_RULES.md`** — キット横断（dev・A′・turbopack 禁止）
2. **ドメイン固有** — 下表の「ワークスペース固有」列
3. **スタック** — `NEXTJS` · `SHADCN` · `TAILWIND` · `DESIGN`
4. **企画（人間向け）** — `yk-memo` 内の課題・案ドキュメント（スコープ・提出物）

---

## 一覧

| 用途 | ファイル |
|------|----------|
| **ワークスペース共通** | `WORKSPACE_RULES.md` |
| 図解管理 | `DIAGRAM_MANAGER_WORKSPACE_RULES.md` |
| Next.js | `NEXTJS_RULES.md` |
| shadcn/ui | `SHADCN_UI_RULES.md` |
| Tailwind | `TAILWINDCSS_RULES.md` |
| 画面・タイポ | `DESIGN_RULES.md` |
| 講座・AI の向き合い方 | `AI_DRIVEN_RULES.md` |
| Cursor | `CURSOR_RULES.md` |
| Vercel 公開 | `VERCEL_RULES.md` |
| スキル執筆 | `SKILL_AUTHORING_RULES.md` |
| GAS / Playwright / PowerShell HTML | 各 `*_RULES.md`（用途が合うときのみ） |

---

## リポジトリ内（workspace-ui-kit）

| 用途 | ファイル |
|------|----------|
| 採用管理雛形・ADR・スキル | `workspace-ui-kit/CLAUDE.md` |
| 図解管理の実装 | `app/diagram-manager/` · `components/diagram-manager/` |
