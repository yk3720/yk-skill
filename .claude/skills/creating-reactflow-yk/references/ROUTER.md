# React Flow 参照ルーティング（ROUTER）

**SSOT:** 本ファイルが tier · tag · Ref Plan テンプレの唯一の正本。  
**要約・MUST:** `yk-skill/rule/35_reactflow/REACTFLOW_RULES.md` · **手順:** `../SKILL.md`  
**設計パターン:** `yk-skill/rule/10_meta/PROGRESSIVE_CONTEXT_ROUTING_RULES.md`

**最終更新:** 2026-06-19（`chrome-ui` tag · design-system 索引）

---

## 0. 禁止・原則

- `REACTFLOW_RULES.md` を毎ターン全文 Read する必要はないが、**flowchart コードを Write/StrReplace するターンでは L1 を Read 済み**であること
- 公式 React Flow ページは **tag に該当するときだけ** Read（Ref Plan の `load` に列挙）
- tier / tag 表を `SKILL.md` や L1 に **複製しない**（リンクのみ）
- **L1 §3-5 は要約。ファイル floor の正本は本 §3**
- **Canvas 変更の default:** 公式 Examples ではなく `FlowCanvas.tsx` · `flowTypes.ts` · `toReactFlow.ts`

---

## 1. 手順（毎タスク）

1. `REACTFLOW_RULES.md` → `SKILL.md` を読む
2. 本 ROUTER で **tier** と **tags** を決める（**ROUTER §4 → L1 §3-5 で層確認**）
3. **Ref Plan** をチャットに出力
4. Ref Plan の `load` に列挙したもの **だけ** Read してから編集
5. `REACTFLOW_RULES.md` §6 ゲート → §7 完了報告

---

## 2. Tier — floor

| tier | いつ | floor（必ず Read） |
|------|------|----------------------|
| **Light** | コメント · ラベル文言 · **操作 chrome の色/class のみ** · パイプライン不変 | L1 §5.6-2a + `design-system.md` §4、または該当 1 ファイル |
| **Standard** | レイアウト · エッジ · Canvas · 表 UI · 複数ファイル | **L1 全体** + 参照実装 floor（**§3 Tag — floor に加算**） |
| **Full** | 新形状種別 · 永続化キー変更 · `toMermaid` 契約変更 · 両アプリ `lib/flowchart` 同期 | L1 + 企画 ADR + `lib/flowchart/types.ts` |

**既定:** 迷ったら **Standard**。

**Light → Standard 昇格（いずれかで Standard）:** Canvas / layout / 両アプリ `lib/flowchart` 同期 / 新 RF API / 永続化キー変更。

---

## 3. Tag — floor に加算

| tag | 追加 floor |
|-----|------------|
| `layout` | `layoutGrid.ts` · `measureHeights.ts` · `layoutPresets.ts` |
| `edges` | `buildEdges.ts` · `types.ts` |
| `canvas` | `FlowCanvas.tsx` · `FlowchartEditor.tsx`（ラッパー行）· `flowTypes.ts` · `nodes/FlowShapeNode.tsx` · `edges/LabeledEdge.tsx` · 新規 RF API / 表示異常時のみ [Common Errors](https://reactflow.dev/learn/troubleshooting/common-errors)（Ref Plan `load` 必須） |
| `export` | `exportPng.ts` · `exportSvg.ts` · [Download Image 公式例](https://reactflow.dev/examples/misc/download-image)（1 ページまで） |
| `table-ui` | `FlowTableEditor.tsx` · `FlowchartEditor.tsx` · `parseTable.ts` · 表の**見た目**は `chrome-ui` と併用 |
| `chrome-ui` | `docs/design-system.md` §3–4 · `flowchartUiClasses.ts` · `app/globals.css`（`--flow-*`）· 確認は `app/dev/style/`（dev のみ） |
| `next-shell` | `app/page.tsx` · `NEXTJS_RULES.md` §6 |
| `persist` | `document.ts` · `draftStorage.ts` |
| `mermaid-preview` | `toMermaid.ts` · `MermaidPreview.tsx` · L1 §3-6 · §4-3 · `flowchart-web-mermaid/` |

**複数 tag:** Ref Plan にすべて列挙。

**公式 URL:** 1 tag あたり **Learn / Troubleshooting 1 ページまで**（§6 パージ · L1 §4-0）。

---

## 4. シグナル → tag

| シグナル | tag |
|----------|-----|
| 分岐 · 合流 · Level ずれ | `layout` · `edges` |
| エッジが消える · fitView · 真っ白 · 高さ 0 | `canvas` |
| PNG/SVG | `export` |
| CSV · 列 · バリデーション | `table-ui` |
| ボタン · バナー · 表の見た目 · `fcBtn*` / `fcTable*` | `chrome-ui` |
| `app/` · `"use client"` | `next-shell` |
| 下書き · localStorage | `persist` |
| `toMermaid` · Mermaid プレビュー · `flowchart-web-mermaid` | `mermaid-preview` |

---

## 5. リポ内パス

| パス | いつ load |
|------|-----------|
| `c:/yk-application/flowchart-studio/lib/flowchart/` | domain / layout / edges 変更（**mermaid 版と同期 MUST**） |
| `c:/yk-application/flowchart-studio/frontend/src/components/flowchart/` | UI / canvas（reactflow 版） |
| `c:/yk-tool/flowchart-web-mermaid/lib/flowchart/` | domain / `toMermaid`（**reactflow 版と同期 MUST**） |
| `c:/yk-tool/flowchart-web-mermaid/components/flowchart/` | UI / Mermaid プレビュー |
| `c:/yk-application/flowchart-studio/docs/design-system.md` | 操作 UI / スタイル変更（**chrome-ui**） |
| `c:/yk-application/flowchart-studio/docs/03_技術仕様/意思決定記録(ADR).md` | Full · 方式変更 |

---

## 6. パージ

- 同一公式 URL を複数 tag で二重指定しない
- Ref Plan の `skip` に読まない理由を 1 行（Light は省略可）

---

## 7. Ref Plan テンプレート

### Light（短形式）

**Write/StrReplace 時は tier に関わらず Ref Plan 必須**（短形式可）。

```markdown
## Ref Plan
- tier: Light（例: themes.ts の色のみ）
- load: c:/yk-skill/rule/35_reactflow/REACTFLOW_RULES.md §4, c:/yk-application/flowchart-studio/lib/flowchart/themes.ts
```

### Standard / Full

```markdown
## Ref Plan
- tier: Standard（例: 分岐ずれ修正）
- tags: layout, edges
- load: c:/yk-skill/rule/35_reactflow/REACTFLOW_RULES.md, c:/yk-application/flowchart-studio/lib/flowchart/layoutGrid.ts, c:/yk-application/flowchart-studio/lib/flowchart/buildEdges.ts
- skip: 公式（参照実装で足りる）
```

---

## 8. 完了報告

`REACTFLOW_RULES.md` §7。末尾に **読んだ refs**（L1 · ROUTER · 実装ファイル · 公式 URL）を列挙。
