# Next.js 参照ルーティング（ROUTER）

**SSOT:** 本ファイルが tier · tag · Ref Plan テンプレの唯一の正本。  
**要約・MUST:** `yk-skill/rule/30_web_stack/NEXTJS_RULES.md` · **手順:** `../SKILL.md`  
**設計パターン:** `yk-skill/rule/10_meta/PROGRESSIVE_CONTEXT_ROUTING_RULES.md`

**最終更新:** 2026-06-24

---

## 0. 禁止・原則

- `NEXTJS_RULES.md` を毎ターン全文 Read する必要はないが、**`app/` を Write/StrReplace するターンでは L1 を Read 済み**であること
- 公式 nextjs.org ページは **tag に該当するときだけ** Read（Ref Plan の `load` に列挙）
- tier / tag 表を `SKILL.md` や L1 に **複製しない**
- **Hooks · Rules of React** → `REACT_RULES` · `creating-react-yk`（本 ROUTER では扱わない）

---

## 1. 手順（毎タスク）

1. `NEXTJS_RULES.md` → `SKILL.md` を読む
2. 本 ROUTER で **tier** と **tags** を決める
3. flowchart-web → L1 §6 を floor に追加
4. **Ref Plan** をチャットに出力
5. Ref Plan の `load` に列挙したもの **だけ** Read してから編集
6. L1 §8 ゲート → §9 完了報告

---

## 2. Tier — floor

| tier | いつ | floor（必ず Read） |
|------|------|----------------------|
| **Light** | メタデータ文言 · 静的 JSX · RSC 境界不変 | L1 §5 または該当 1 ファイル |
| **Standard** | `page`/`layout` 変更 · import 追加 · 動的ルート | **L1 全体** + §3 Tag floor |
| **Full** | 新 Route Handler · キャッシュ方針変更 · 認証横断 | L1 + 該当 tag 公式 1 ページ + プロジェクト bundled docs 1 ページ |

**既定:** 迷ったら **Standard**。

---

## 3. Tag — floor に加算

| tag | 追加 floor |
|-----|------------|
| `rsc-boundary` | L1 §5〜5-2 · [Server and Client Components](https://nextjs.org/docs/app/getting-started/server-and-client-components) |
| `routing-files` | [Project Structure](https://nextjs.org/docs/app/getting-started/project-structure) · 触る `app/**` |
| `data-fetch` | [Fetching Data](https://nextjs.org/docs/app/getting-started/fetching-data) |
| `mutate-actions` | [Mutating Data](https://nextjs.org/docs/app/getting-started/mutating-data) · [Data Security](https://nextjs.org/docs/app/guides/data-security) |
| `cache-revalidate` | [Caching](https://nextjs.org/docs/app/getting-started/caching) · [Revalidating](https://nextjs.org/docs/app/getting-started/revalidating) |
| `metadata` | [Metadata and OG images](https://nextjs.org/docs/app/getting-started/metadata-and-og-images) |
| `route-handler` | [Route Handlers](https://nextjs.org/docs/app/getting-started/route-handlers) |
| `request-apis` | [Upgrade v15 · Async Request APIs](https://nextjs.org/docs/app/guides/upgrading/version-15) |
| `flowchart-web` | L1 §6 · 触る `app/**`（**RF スキルは `components/flowchart` 作業時のみ**） |
| `ui-kit-shell` | L1 §5-3 · `WORKSPACE_RULES` §3 |

**公式 URL:** 1 tag あたり **1 ページまで**（Getting Started 系を優先）。

**Bundled docs（本節が手順 SSOT）:** プロジェクトに `next` があり、かつ `AGENTS.md` がある／ユーザーがバンドル doc 明示時 — 実装前に `node_modules/next/dist/docs/`（v16.1 以前の codemod なら `.next-docs/`）の該当 1 ページを `load` に含める。公式 URL と **どちらか 1 本**。

---

## 4. シグナル → tag

| シグナル | tag |
|----------|-----|
| `"use client"` · Server→Client props · children 合成 | `rsc-boundary` |
| 新 segment · `layout` · `loading` · `error` | `routing-files` |
| `fetch` in Server Component · streaming | `data-fetch` |
| `"use server"` · form action | `mutate-actions` |
| `revalidatePath` · `cacheTag` · `use cache` | `cache-revalidate` |
| `generateMetadata` · OG | `metadata` |
| `app/**/route.ts` | `route-handler` |
| `await cookies()` · `headers()` | `request-apis` |
| `flowchart-studio` の `app/` のみ | `flowchart-web`（RF 本体は `creating-reactflow-yk`） |
| `workspace-ui-kit/app/` | `ui-kit-shell` |

---

## 5. リポ内パス

| パス | いつ load |
|------|-----------|
| `c:/yk-application/flowchart-studio/app/**` | flowchart Next シェル（§6 floor） |
| `c:/yk-tool/workspace-ui-kit/app/**` | ui-kit Server シェル |
| その他 Next プロジェクト `app/**` | 作業対象リポの該当ファイル |

---

## 6. パージ

- Light + tag なし → L1 §5 のみで足りるなら公式 Read しない
- Pages Router プロジェクトで App Router 公式 tag を付けない（Pages 公式に差し替え）

---

## 7. Ref Plan テンプレート

```markdown
## Ref Plan
- tier: Standard（理由を1行）
- tags: rsc-boundary
- load: NEXTJS_RULES L1 · app/page.tsx · （ROUTER §3 の公式 1 本、または bundled docs 1 本）
- skip: REACT_RULES（components 不変のため）
- 委譲: なし
- ids: （任意 · PROGRESSIVE 準拠）
```

---

## 8. 完了報告（末尾必須）

- 触ったファイル一覧
- tier / tags
- **読んだ refs**（L1 · ROUTER · ファイル · 公式 URL · bundled docs）
