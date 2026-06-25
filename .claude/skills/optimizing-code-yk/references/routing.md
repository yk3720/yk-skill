# スタック → L1 · 実装スキル

M1 の Web 調査キーワードと M2 の `creating-*-yk` 委譲の索引。**詳細手順は各 L1 / 子スキルが SSOT。**

## 判定手順

1. リポルートの `package.json` · `pyproject.toml` を Read
2. 下表でドメインを特定
3. `c:/yk-skill/rule/RULE_INDEX.md` クイック入口で L1 を Read（コード編集前）

## マッピング

| 触るもの | L1（Read） | M2 委譲スキル |
|----------|------------|---------------|
| `app/` · RSC · Server Actions | `NEXTJS_RULES.md` | `creating-nextjs-yk` |
| `components/` · Hooks · Client UI | `REACT_RULES.md` | `creating-react-yk` |
| `@xyflow/react` · 表駆動フロー | `REACTFLOW_RULES.md` | `creating-reactflow-yk` |
| `**/*.py` | `PYTHON_RULES.md` | `creating-pythoncode-yk` |
| `components/ui` · shadcn | `SHADCN_UI_RULES.md` | `creating-shadcn-yk` |
| Playwright spec | `PLAYWRIGHT_RULES.md` | `using-playwright` |

## M1 Web 調査クエリ例

`researching-web` に渡す際の種（スタック確定後）:

| ドメイン | クエリ例 |
|----------|----------|
| React | `React 19 useEffect best practices` · 公式 react.dev |
| Next.js | `Next.js App Router data fetching` · 公式 nextjs.org |
| React Flow | `@xyflow/react migration` · 公式 xyflow.com |
| Python | `{ライブラリ名} official documentation` |

**性能のみ深掘り:** `creating-react-yk` の ROUTER tag `performance` → ui-kit `vercel-react-best-practices`（deploy タスクと混同しない · `VERCEL_RULES` 参照）。

## 複数ドメインにまたがるとき

- M1: レンズをドメインごとに分ける（例: L-api=Next · L-perf=React）
- M2: ファイルパスごとに子スキルを切り替える（1 ターンで複数 Read 可）
