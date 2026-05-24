# React Flow 参照ルーティング（ROUTER）

**SSOT:** 本ファイルが tier · tag · Ref Plan テンプレの唯一の正本。  
**要約・MUST:** `yk-skill/rule/35_reactflow/REACTFLOW_RULES.md` · **手順:** `../SKILL.md`  
**設計パターン:** `yk-skill/rule/10_meta/PROGRESSIVE_CONTEXT_ROUTING_RULES.md`

**最終更新:** 2026-05-24

---

## 0. 禁止・原則

- `REACTFLOW_RULES.md` を毎ターン全文 Read する必要はないが、**flowchart コードを Write/StrReplace するターンでは L1 を Read 済み**であること
- 公式 React Flow ページは **tag に該当するときだけ** Read（Ref Plan の `load` に列挙）
- tier / tag 表を `SKILL.md` や L1 に **複製しない**（リンクのみ）

---

## 1. 手順（毎タスク）

1. `REACTFLOW_RULES.md` → `SKILL.md` を読む
2. 本 ROUTER で **tier** と **tags** を決める
3. **Ref Plan** をチャットに出力
4. Ref Plan の `load` に列挙したもの **だけ** Read してから編集
5. `REACTFLOW_RULES.md` §6 ゲート → §7 完了報告

---

## 2. Tier — floor

| tier | いつ | floor（必ず Read） |
|------|------|----------------------|
| **Light** | コメント · ラベル文言 · テーマ色のみ · パイプライン不変 | L1 §4 または該当 1 ファイル |
| **Standard** | レイアウト · エッジ · Canvas · 表 UI · 複数ファイル | **L1 全体** + 参照実装 floor（§4 tag） |
| **Full** | 新形状種別 · 永続化キー変更 · `toMermaid` 契約変更 · 両アプリ `lib/flowchart` 同期 | L1 + 企画 ADR + `lib/flowchart/types.ts` |

**既定:** 迷ったら **Standard**。

---

## 3. Tag — floor に加算

| tag | 追加 floor |
|-----|------------|
| `layout` | `layoutGrid.ts` · `measureHeights.ts` · `layoutPresets.ts` |
| `edges` | `buildEdges.ts` · `types.ts` |
| `canvas` | `FlowCanvas.tsx` · `flowTypes.ts` · `nodes/FlowShapeNode.tsx` · `edges/LabeledEdge.tsx` |
| `export` | `exportPng.ts` · `exportSvg.ts` · [Download Image 公式例](https://reactflow.dev/examples/misc/download-image)（1 ページまで） |
| `table-ui` | `FlowTableEditor.tsx` · `FlowchartEditor.tsx` · `parseTable.ts` |
| `next-shell` | `app/page.tsx` · `NEXTJS_RULES.md` §5 |
| `persist` | `document.ts` · `draftStorage.ts` |
| `mermaid-preview` | `toMermaid.ts` · `MermaidPreview.tsx` · L1 §3-6 · §4-1 · `flowchart-web-mermaid/` |

**複数 tag:** Ref Plan にすべて列挙。

---

## 4. シグナル → tag

| シグナル | tag |
|----------|-----|
| 分岐 · 合流 · Level ずれ | `layout` · `edges` |
| エッジが消える · fitView | `canvas` |
| PNG/SVG | `export` |
| CSV · 列 · バリデーション | `table-ui` |
| `app/` · `"use client"` | `next-shell` |
| 下書き · localStorage | `persist` |
| `toMermaid` · Mermaid プレビュー · `flowchart-web-mermaid` | `mermaid-preview` |

---

## 5. リポ内パス

| パス | いつ load |
|------|-----------|
| `c:/yk-tool/flowchart-web-reactflow/lib/flowchart/` | domain / layout / edges 変更（**mermaid 版と同期 MUST**） |
| `c:/yk-tool/flowchart-web-reactflow/components/flowchart/` | UI / canvas（reactflow 版） |
| `c:/yk-tool/flowchart-web-mermaid/lib/flowchart/` | domain / `toMermaid`（**reactflow 版と同期 MUST**） |
| `c:/yk-tool/flowchart-web-mermaid/components/flowchart/` | UI / Mermaid プレビュー |
| `c:/yk-memo/00.ai-driven-school/個人テーマ_フローチャートアプリ/意思決定記録(ADR).md` | Full · 方式変更 |

---

## 6. パージ

- 同一公式 URL を複数 tag で二重指定しない
- Ref Plan の `skip` に読まない理由を 1 行（Light は省略可）

---

## 7. Ref Plan テンプレート

### Light（短形式）

```markdown
## Ref Plan
- tier: Light（例: themes.ts の色のみ）
- load: c:/yk-skill/rule/35_reactflow/REACTFLOW_RULES.md §4, c:/yk-tool/flowchart-web-reactflow/lib/flowchart/themes.ts
```

### Standard / Full

```markdown
## Ref Plan
- tier: Standard（例: 分岐ずれ修正）
- tags: layout, edges
- load: c:/yk-skill/rule/35_reactflow/REACTFLOW_RULES.md, c:/yk-tool/flowchart-web-reactflow/lib/flowchart/layoutGrid.ts, buildEdges.ts
- skip: 公式（参照実装で足りる）
```

---

## 8. 完了報告

`REACTFLOW_RULES.md` §7。末尾に **読んだ refs**（L1 · ROUTER · 実装ファイル · 公式 URL）を列挙。
