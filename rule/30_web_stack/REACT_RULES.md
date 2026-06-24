# React 開発ルール（ひな形 v0）
## YK React コンポーネント — Design & Development Rules

**ステータス:** `active`（[`RULE_INDEX.md`](../RULE_INDEX.md) No 36 · PROGRESSIVE L0/L1/L2 整備済）

**SSOT（本ファイル）:** `yk-skill/rule/30_web_stack/REACT_RULES.md`  
**実行手順・ゲート:** `.claude/skills/creating-react-yk/SKILL.md`  
**ロード規則 SSOT:** `.../creating-react-yk/references/ROUTER.md`

**横断:** [`NEXTJS_RULES.md`](NEXTJS_RULES.md) §5（RSC · `"use client"` — **本ファイルでは再掲しない**） · [`35_reactflow/REACTFLOW_RULES.md`](../35_reactflow/REACTFLOW_RULES.md)（表駆動 · `@xyflow/react`） · [`20_web_workspace/WORKSPACE_RULES.md`](../20_web_workspace/WORKSPACE_RULES.md) §3（`lib/` 純関数）

**最終更新:** 2026-05-24  
**索引:** [`../RULE_INDEX.md`](../RULE_INDEX.md) No 36

**L0 入口:** 広 glob の単独 entry は置かない。`workspace-ui-kit` → `workspace-dev-entry.mdc` · `flowchart-studio` の Client 一般 → `reactflow-dev-entry.mdc` から本ファイルへリンク。

---

## 0. エージェント向け — いつ何を読むか

| 段階 | 読むもの | タイミング |
|------|----------|------------|
| L1 | **本ファイル** | Client Component · Hooks · 合成ロジックを触るたび・最初 |
| L2 | `creating-react-yk/SKILL.md` | 手順・ゲート |
| L2.5 | **Ref Plan** | **Write/StrReplace 前**（ROUTER §7） |
| L3 | ROUTER の `load` のみ | Ref Plan 後 |

**Ref Plan 不要:** 質問のみ · Read のみ。

**本ファイルで扱わない（委譲 SSOT）**

| 関心 | SSOT |
|------|------|
| `"use client"` · Server/Client 境界 · serializable props | [`NEXTJS_RULES.md`](NEXTJS_RULES.md) **§5** |
| `app/` · ルーティング · dev ポート | `NEXTJS_RULES` · `creating-nextjs-yk` |
| `@xyflow/react` · 表駆動 · `lib/flowchart/` | [`REACTFLOW_RULES.md`](../35_reactflow/REACTFLOW_RULES.md) · `creating-reactflow-yk` |
| shadcn init/add | `SHADCN_UI_RULES` · `creating-shadcn-yk` |

**誤ルーティング禁止**

| 触るもの | 使う入口 | **使わない** |
|----------|----------|--------------|
| **`components/**`（flowchart 以外）** · Hooks · 合成 | **本帯** · `creating-react-yk` | `creating-reactflow-yk` |
| **`components/flowchart/**`（表 UI · プレビュー）** | 本帯 + `REACTFLOW_RULES` §3 | RF API のみで React 一般を省略しない |
| **`lib/flowchart/**` | `creating-reactflow-yk`（React 禁止） | 本スキル |
| **`app/**`** | `creating-nextjs-yk` | 本スキル単独 |
| surge 図解 HTML | 図解スキル系 | 本帯 |

---

## 1. YK レイヤ原則（横断 MUST）

| レイヤ | 規則 |
|--------|------|
| **`lib/**`** | **React / DOM import 禁止**（純 TS · Zod 等）。UI は `components/**` |
| **`components/**`** | Client Component（Next プロジェクトでは `"use client"` — 境界詳細は NEXTJS §5） |
| **アダプタ** | 例: `toReactFlow.ts` — ドメイン → React ライブラリ型（[`REACTFLOW_RULES`](../35_reactflow/REACTFLOW_RULES.md) §3） |

flowchart のドメイン詳細は **REACTFLOW §3** が SSOT。ui-kit の `lib/<domain>/` は **WORKSPACE §3**。

---

## 2. Rules of React — MUST（要約）

**公式 SSOT:** [Rules of React](https://react.dev/reference/rules) · 詳細ページは ROUTER tag 時のみ Ref Plan `load`。

### 2-1. 純粋性（Components and Hooks must be pure）

| MUST | 規則 |
|------|------|
| 冪等性 | 同一 props/state/context なら同一 JSX 出力 |
| render 内副作用禁止 | 副作用は **イベントハンドラ** または **`useEffect`**（最後の手段） |
| 不変性 | props / state / Hook 引数を **直接ミューテーションしない** — setter で更新 |
| JSX 後の変更禁止 | JSX に渡した値をその後 mutate しない |

### 2-2. React がコンポーネントを呼ぶ

| MUST | 規則 |
|------|------|
| JSX のみ | `<Component />` — **関数として直接呼ばない** |
| Hook は値にしない | Hook を props や変数として渡さない · 動的 DI 禁止 |

### 2-3. Rules of Hooks

| MUST | 規則 |
|------|------|
| トップレベルのみ | ループ · 条件 · ネスト関数 · early return 後 · try/catch 内で Hook を呼ばない |
| React 関数内のみ | コンポーネントまたはカスタム Hook 内のみ（通常 JS 関数から禁止） |
| **`use` 例外** | [Rules of Hooks](https://react.dev/reference/rules/rules-of-hooks) — 条件付き可。try/catch 不可 |

**推奨:** `eslint-plugin-react-hooks` · [Strict Mode](https://react.dev/reference/react/StrictMode)

---

### 2-4. YK 推奨スタック（第一候補）

**新規開発（Web / デスクトップ）において、以下の組み合わせを第一候補（Default Stack）とする。**

| レイヤ | 技術選定 | 理由 |
|--------|----------|------|
| **UI フレームワーク** | **React** | コンポーネントの再利用性とエコシステムの広さ |
| **UI コンポーネント** | **shadcn/ui** | デザインの洗練度と、ソースコードを直接制御できる柔軟性 |
| **スタイリング** | **Tailwind CSS** | ユーティリティファーストによる高速な開発と保守性 |

**例外:**
- パフォーマンス、制約、または特定の要件により上記より優れた方法がある場合は、他の方法を検討する。
- 既存プロジェクトの制約がある場合はそれに従う。

---

## 3. YK Client パターン — MUST

| 項目 | 規則 |
|------|------|
| 派生 state | **render で計算** — props から Effect + setState で複製しない |
| リセット | 子の state リセットは **`key` リマウント** を優先 |
| イベント起因 | ユーザー操作の副作用は **イベントハンドラ** に置く（Effect 経由を避ける） |
| 参照安定 | 子が `memo` · RF `nodeTypes` 等で参照 equality する場合 — **`useMemo` / `useCallback` またはモジュールスコープ**（根拠: REACTFLOW §4-1 · Common Errors パターン） |
| 状態更新 | **イミュータブル**（スプレッド等）— 配列/オブジェクトの in-place 変更禁止 |

**ui-kit 固有の見た目規約** — `workspace-ui-kit` の `coding-rules.md` · `designing-workspace-ui`（yk-skill には全文コピーしない）。

---

## 4. 公式参照 — エージェント索引

| 区分 | 扱い |
|------|------|
| **L1（毎回 Read 不要）** | §2 MUST 表 · §3 YK パターン |
| **Ref Plan `load` で Read 可** | [Rules of React](https://react.dev/reference/rules) · [Rules of Hooks](https://react.dev/reference/rules/rules-of-hooks) · [Components and Hooks must be pure](https://react.dev/reference/rules/components-and-hooks-must-be-pure) · tag 固有は ROUTER §3 |
| **React 19（採用時のみ）** | [useActionState](https://react.dev/reference/react/useActionState) · [useOptimistic](https://react.dev/reference/react/useOptimistic) · [useFormStatus](https://react.dev/reference/react-dom/hooks/useFormStatus) — YK コードベース未使用時は tag `forms-actions` |
| **RSC** | **読まない** → NEXTJS §5 |
| **禁止** | react.dev 全文の L1 転記 · Examples から UI シェル丸ごとコピー |

**LLM 索引:** [react.dev/llms.txt](https://react.dev/llms.txt)

---

## 5. 責務分割（Next · React · React Flow）

| 層 | 担当 rule / スキル |
|----|-------------------|
| React 一般（Hooks · 純粋性 · 合成） | **本ファイル** · `creating-react-yk` |
| App Router · RSC · `"use client"` | `NEXTJS_RULES` §5 · `creating-nextjs-yk` |
| flowchart パス表 · dev ポート | `NEXTJS_RULES` §6 |
| 表駆動 · `@xyflow/react` | `REACTFLOW_RULES` · `creating-reactflow-yk` |

---

## 6. 品質ゲート

| ゲート | 手段 |
|--------|------|
| Lint | プロジェクトの `npm run lint`（`eslint-plugin-react-hooks` 想定） |
| 型 | `npm run build` または `tsc` |

**Shell:** `AGENT_SHELL_RULES` — ユーザーが当ターンで `test` / `build` / `lint` を明示したときのみ実行。

---

## 7. 完了報告

`creating-react-yk` SKILL · ROUTER §8 に従う。末尾に **読んだ refs**（L1 · ROUTER · 触ったファイル · 公式 URL）を列挙。
